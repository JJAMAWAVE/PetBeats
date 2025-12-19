import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/services/weather_service.dart';
import '../controllers/player_controller.dart';
import '../widgets/bio_pulse_widget.dart';
import '../widgets/audio_reactive_visualizer.dart';
import '../widgets/aurora_curtain_visualizer.dart';
import '../widgets/midi_flash_overlay.dart';
import '../widgets/therapy_control_panel.dart';
import '../widgets/rolling_tip_widget.dart';
import '../widgets/sleep_timer_bottom_sheet.dart';
import '../widgets/mix_panel_bottom_sheet.dart';
import '../widgets/haptic_safety_guide_dialog.dart';

class NowPlayingView extends GetView<PlayerController> {
  const NowPlayingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildVisualizerZone()),
            _buildTherapyControlZone(),
            _buildRollingTipZone(),
            _buildPlaybackControlZone(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textDarkNavy, size: 32),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Center(
              child: Obx(() => Text(
                controller.currentTrackTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textDarkNavy,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              )),
            ),
          ),
          // Info button for Haptic Safety Guide
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: AppColors.textDarkNavy.withOpacity(0.8),
              size: 24.w,
            ),
            onPressed: () {
              Get.dialog(
                const HapticSafetyGuideDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
  
  void _showTimerBottomSheet() {
    Get.bottomSheet(
      const SleepTimerBottomSheet(),
      isScrollControlled: true,
    );
  }

  Widget _buildVisualizerZone() {
    return Obx(() => 
      // 오로라 커튼 비주얼라이저
      AuroraCurtainVisualizer(
        bpm: controller.currentTrackBpm,
        isPlaying: controller.isPlaying,
        mode: controller.homeController.currentMode.value?.id ?? 'sleep',
      ),
    );
  }


  Widget _buildTherapyControlZone() {
    return Obx(() {
      // 햅틱 슬라이더는 특정 모드에서만 표시
      final mode = controller.homeController.currentMode.value;
      final showHapticSlider = mode != null && 
                        (mode.id == 'sleep' || mode.id == 'anxiety' || mode.id == 'senior');
      
      // WeatherService에서 날씨 상태 가져오기
      bool isWeatherActive = false;
      VoidCallback onWeatherToggle = () {};
      try {
        final weatherService = Get.find<WeatherService>();
        isWeatherActive = weatherService.isEnabled.value;
        onWeatherToggle = () {
          if (weatherService.isEnabled.value) {
            weatherService.disableWeatherSync();
          } else {
            weatherService.enableWeatherSync();
          }
        };
      } catch (_) {}
      
      return TherapyControlPanel(
        hapticIntensity: controller.hapticIntensity.value,
        onHapticChange: controller.setHapticIntensity,
        isWeatherActive: isWeatherActive,
        onWeatherToggle: onWeatherToggle,
        hapticMode: controller.hapticMode.value,
        onHapticModeChange: controller.setHapticMode,
        showHapticSlider: showHapticSlider,
      );
    });
  }


  Widget _buildRollingTipZone() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: RollingTipWidget(),
    );
  }

  Widget _buildPlaybackControlZone() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 2.h),  // Minimized to fix overflow
      child: Column(
        children: [
          // Progress Bar with Time Display
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Obx(() => Text(
                  _formatDuration(controller.currentPosition.value),
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Obx(() {
                      // Use temp position during drag, actual position otherwise
                      final position = controller.isDraggingSeekBar.value 
                          ? Duration(milliseconds: (controller.tempSeekPosition.value * controller.currentDuration.value.inMilliseconds).round())
                          : controller.currentPosition.value;
                      final duration = controller.currentDuration.value;
                      final progress = duration.inMilliseconds > 0 
                          ? position.inMilliseconds / duration.inMilliseconds 
                          : 0.0;
                      
                      return SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3.h,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                          activeTrackColor: AppColors.primaryBlue,
                          inactiveTrackColor: AppColors.textGrey.withOpacity(0.2),
                          thumbColor: AppColors.primaryBlue,
                          overlayColor: AppColors.primaryBlue.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: progress.clamp(0.0, 1.0),
                          onChangeStart: (value) {
                            controller.isDraggingSeekBar.value = true;
                            controller.tempSeekPosition.value = value;
                          },
                          onChanged: (value) {
                            // Update temp position during drag
                            controller.tempSeekPosition.value = value;
                          },
                          onChangeEnd: (value) {
                            controller.isDraggingSeekBar.value = false;
                            // Prevent seek when duration is not yet loaded
                            if (duration.inMilliseconds <= 0) {
                              print('⚠️ [SeekBar] Duration not loaded yet, ignoring seek');
                              return;
                            }
                            
                            // Calculate new position
                            final newPosition = Duration(
                              milliseconds: (value * duration.inMilliseconds).round(),
                            );
                            
                            // Prevent accidental seek to very beginning (< 1 second) unless intentional
                            if (newPosition.inSeconds < 1 && value > 0.02) {
                              print('⚠️ [SeekBar] Preventing accidental seek to start');
                              return;
                            }
                            
                            print('🎵 [SeekBar] Seeking to $newPosition (value: $value)');
                            controller.homeController.seekTo(newPosition);
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Obx(() => Text(
                  _formatDuration(controller.currentDuration.value),
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 반복 모드 (왼쪽으로 이동)
              Obx(() => IconButton(
                icon: Icon(
                  controller.repeatModeIcon,
                  color: controller.isRepeatActive 
                      ? AppColors.primaryBlue 
                      : AppColors.textGrey.withOpacity(0.5),
                ),
                iconSize: 24.w,
                onPressed: () => controller.toggleRepeatMode(),
              )),
              IconButton(
                icon: Icon(Icons.skip_previous, color: AppColors.textDarkNavy),
                iconSize: 32.w,
                onPressed: () => controller.homeController.skipPrevious(),
              ),
              Obx(() => GestureDetector(
                onTap: controller.togglePlay,
                child: Container(
                  width: 58.w,
                  height: 58.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    controller.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primaryBlue,
                    size: 30.w,
                  ),
                ),
              )),
              IconButton(
                icon: Icon(Icons.skip_next, color: AppColors.textDarkNavy),
                iconSize: 32.w,
                onPressed: () => controller.homeController.skipNext(),
              ),
              // 셔플 버튼 제거됨 - 미구현 기능
              SizedBox(width: 24.w), // 균형 유지
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildMixButton() {
    return GestureDetector(
      onTap: () => _showMixPanel(),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withOpacity(0.4),
              Colors.blue.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.purple.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.tune,
              color: Colors.white,
              size: 22.w,
            ),
            // Premium indicator dot
            Positioned(
              top: 6.h,
              right: 6.w,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMixPanel() {
    Get.bottomSheet(
      const MixPanelBottomSheet(),
      isScrollControlled: true,
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
