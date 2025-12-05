import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/player_controller.dart';
import '../widgets/bio_pulse_widget.dart';
import '../widgets/therapy_control_panel.dart';
import '../widgets/rolling_tip_widget.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
            onPressed: () => Get.back(),
          ),
          Obx(() => Text(
            controller.currentTrackTitle,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          )),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizerZone() {
    return Obx(() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BioPulseWidget(
            bpm: controller.currentTrackBpm,
            isPlaying: controller.isPlaying,  // Added this critical parameter
            color: controller.currentTrackColor,
          ),
          SizedBox(height: 48.h),
          // Title - 큰 폰트
          Text(
            controller.currentTrackTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          // Subtitle - 과학적 근거 강조
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              "${controller.currentTrackBpm} BPM • Heartbeat Sync",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
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
      );
    });
  }


  Widget _buildRollingTipZone() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: RollingTipWidget(),
    );
  }

  Widget _buildPlaybackControlZone() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),  // Reduced from 16h to 8h
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
                          onChangeEnd: (value) {
                            // Seek when user finishes dragging
                            final newPosition = Duration(
                              milliseconds: (value * duration.inMilliseconds).round(),
                            );
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                iconSize: 32.w,
                onPressed: () {},
              ),
              SizedBox(width: 32.w),
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
              SizedBox(width: 32.w),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                iconSize: 32.w,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
