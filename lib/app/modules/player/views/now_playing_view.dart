import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/player_controller.dart';
import '../widgets/bio_pulse_widget.dart';
import '../widgets/therapy_control_panel.dart';

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
            isHapticActive: controller.hapticIntensity.value != HapticIntensity.off,
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
    return Obx(() => TherapyControlPanel(
      hapticIntensity: controller.hapticIntensity.value,
      onHapticChange: controller.setHapticIntensity,
      isWeatherActive: controller.isWeatherActive.value,
      onWeatherToggle: controller.toggleWeather,
    ));
  }

  Widget _buildPlaybackControlZone() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
      child: Column(
        children: [
          // Progress Bar with Time Display
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Text(
                  "1:30",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SliderTheme(
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
                        value: 0.5,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),
                Text(
                  "3:00",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
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
}
