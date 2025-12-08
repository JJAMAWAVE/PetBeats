import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/player_controller.dart';
import '../widgets/bio_pulse_widget.dart';
import '../widgets/audio_reactive_visualizer.dart';
import '../widgets/midi_flash_overlay.dart';
import '../widgets/therapy_control_panel.dart';
import '../widgets/rolling_tip_widget.dart';
import '../widgets/sleep_timer_bottom_sheet.dart';
import '../widgets/mix_panel_bottom_sheet.dart';

class NowPlayingView extends GetView<PlayerController> {
  const NowPlayingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDarkNavy,
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
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Center(
              child: Obx(() => Text(
                controller.currentTrackTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              )),
            ),
          ),
          // Timer button
          Obx(() {
            final isActive = controller.timerService.isActive.value;
            return GestureDetector(
              onTap: () => _showTimerBottomSheet(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isActive 
                      ? Colors.amber.withOpacity(0.2) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: isActive 
                      ? Border.all(color: Colors.amber.withOpacity(0.5)) 
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? Icons.timer : Icons.timer_outlined,
                      color: isActive ? Colors.amber : Colors.white70,
                      size: 22.w,
                    ),
                    if (isActive) ...[
                      SizedBox(width: 4.w),
                      Obx(() => Text(
                        controller.timerService.formattedTime,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
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
    return Obx(() => Stack(
      children: [
        // 비주얼라이저
        AudioReactiveVisualizer(
          bpm: controller.currentTrackBpm,
          isPlaying: controller.isPlaying,
          color: controller.currentTrackColor,
          mode: controller.homeController.currentMode.value?.id ?? 'sleep',
        ),
        // MIDI 비트 섬광 오버레이
        const MidiFlashOverlay(),
      ],
    ));
  }


  Widget _buildTherapyControlZone() {
    return Obx(() {
      // Only show haptic for modes where heart rate sync is beneficial
      final mode = controller.homeController.currentMode.value;
      final showHaptic = mode != null && 
                        (mode.id == 'sleep' || mode.id == 'anxiety' || mode.id == 'senior');
      
      if (!showHaptic) {
        return const SizedBox.shrink(); // Hide therapy panel for noise/energy modes
      }
      
      return TherapyControlPanel(
        hapticIntensity: controller.hapticIntensity.value,
        onHapticChange: controller.setHapticIntensity,
        isWeatherActive: controller.isWeatherActive.value,
        onWeatherToggle: controller.toggleWeather,
        hapticMode: controller.hapticMode.value,
        onHapticModeChange: controller.setHapticMode,
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
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Obx(() {
                      final position = controller.currentPosition.value;
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
                          inactiveTrackColor: Colors.white.withOpacity(0.2),
                          thumbColor: Colors.white,
                          overlayColor: AppColors.primaryBlue.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: progress.clamp(0.0, 1.0),
                          onChanged: (value) {
                            // Required parameter - no action during drag for smooth performance
                          },
                          onChangeEnd: (value) {
                            // Prevent seek when duration is not yet loaded
                            if (duration.inMilliseconds <= 0) {
                              print('⚠️ [SeekBar] Duration not loaded yet, ignoring seek');
                              return;
                            }
                            // Seek when user finishes dragging
                            final newPosition = Duration(
                              milliseconds: (value * duration.inMilliseconds).round(),
                            );
                            print('🎵 [SeekBar] Seeking to $newPosition');
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
                    color: Colors.white.withOpacity(0.7),
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
              // Mix button (Premium)
              _buildMixButton(),
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
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
                    color: AppColors.backgroundDarkNavy,
                    size: 30.w,
                  ),
                ),
              )),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                iconSize: 32.w,
                onPressed: () => controller.homeController.skipNext(),
              ),
              // Repeat mode toggle (Off → Single → All)
              Obx(() => IconButton(
                icon: Icon(
                  controller.repeatModeIcon,
                  color: controller.isRepeatActive 
                      ? AppColors.primaryBlue 
                      : Colors.white.withOpacity(0.5),
                ),
                iconSize: 24.w,
                onPressed: () => controller.toggleRepeatMode(),
              )),
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
