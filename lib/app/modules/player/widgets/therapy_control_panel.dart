import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:petbeats/core/widgets/rainbow_gradient.dart';
import '../../../data/models/haptic_settings_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/services/weather_service.dart';
import '../../../data/services/rhythm_care_service.dart';  // ✨ Rhythm Care
import 'sleep_timer_bottom_sheet.dart';
import 'weather_settings_bottom_sheet.dart';
import 'weather_control_sheet.dart';
import 'premium_feature_popup.dart';
import 'dart:ui';
import '../../../../core/widgets/circle_pulse_spinner.dart';

class TherapyControlPanel extends StatefulWidget {
  final HapticIntensity hapticIntensity;
  final Function(HapticIntensity) onHapticChange;
  final bool isWeatherActive;
  final VoidCallback onWeatherToggle;
  final HapticMode? hapticMode;
  final Function(HapticMode)? onHapticModeChange;
  final bool showHapticSlider;  // 햅틱 슬라이더 표시 여부

  const TherapyControlPanel({
    super.key,
    required this.hapticIntensity,
    required this.onHapticChange,
    required this.isWeatherActive,
    required this.onWeatherToggle,
    this.hapticMode,
    this.onHapticModeChange,
    this.showHapticSlider = true,  // 기본값 true
  });
  
  @override
  State<TherapyControlPanel> createState() => _TherapyControlPanelState();
}

class _TherapyControlPanelState extends State<TherapyControlPanel> {
  HapticMode _selectedMode = HapticMode.soundAdaptive;  // 기본값: 사운드
  
  @override
  void initState() {
    super.initState();
    _selectedMode = widget.hapticMode ?? HapticMode.soundAdaptive;  // 기본값: 사운드
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: widget.hapticIntensity != HapticIntensity.off 
                  ? AppColors.primaryBlue.withOpacity(0.5)
                  : Colors.white.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.hapticIntensity != HapticIntensity.off
                    ? AppColors.primaryBlue.withOpacity(0.3)
                    : Colors.black.withOpacity(0.15),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Premium 타이틀
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '✨ ',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Text(
                    'haptic_premium_title'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Haptic Mode Selector (햅틱 모드일 때만 표시)
              if (widget.showHapticSlider) ...[
                _buildModeSelector(),
                SizedBox(height: 16.h),
                // Haptic 슬라이더
                _buildHapticSlider(),
              ] else ...[
                // 햅틱 없는 모드에서는 퀵 액세스만 표시
                _buildQuickAccessRow(),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildModeSelector() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildModeButton(
          mode: HapticMode.soundAdaptive, 
          icon: Icons.music_note, 
          label: 'haptic_mode_sound'.tr,
          color: Colors.purpleAccent,
        ),
        _buildModeButton(
          mode: HapticMode.heartbeat, 
          icon: Icons.favorite, 
          label: 'haptic_mode_heartbeat'.tr,
          color: Colors.pinkAccent,
        ),
        _buildModeButton(
          mode: HapticMode.rampdown, 
          icon: Icons.trending_down, 
          label: 'haptic_mode_calm'.tr,
          color: Colors.tealAccent,
        ),
        _buildModeButton(
          mode: HapticMode.purr, 
          icon: Icons.pets, 
          label: 'haptic_mode_purr'.tr,
          color: Colors.amber,
        ),
      ],
    );
  }
  
  Widget _buildModeButton({
    required HapticMode mode,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isSelected = _selectedMode == mode;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedMode = mode);
        widget.onHapticModeChange?.call(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60.w,  // Reduced size for compact appearance
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.white.withOpacity(0.5),
              size: 18.w,  // Reduced icon size
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? color : Colors.white.withOpacity(0.5),
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHapticSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 슬라이더 Row - 아이콘을 OFF 옆에 배치하여 공간 절약
        Row(
          children: [
            // OFF + 아이콘들
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, color: Colors.pinkAccent, size: 14.w),
                SizedBox(width: 4.w),
                Icon(Icons.vibration, color: Colors.amber, size: 14.w),
              ],
            ),
            SizedBox(width: 6.w),
            Text(
              _getIntensityLabel(widget.hapticIntensity),
              style: TextStyle(
                color: widget.hapticIntensity == HapticIntensity.off 
                    ? Colors.white.withOpacity(0.5)
                    : AppColors.primaryBlue,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 5.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                  activeTrackColor: AppColors.primaryBlue,
                  inactiveTrackColor: Colors.white.withOpacity(0.15),
                  thumbColor: Colors.white,
                  overlayColor: AppColors.primaryBlue.withOpacity(0.3),
                ),
                child: Slider(
                  value: _getSliderValue(widget.hapticIntensity),
                  min: 0,
                  max: 4,
                  divisions: 4,
                  onChanged: (value) {
                    HapticIntensity newIntensity = _getIntensityFromValue(value);
                    _provideHapticFeedback(newIntensity);
                    widget.onHapticChange(newIntensity);
                  },
                ),
              ),
            ),
            Text(
              'MAX',
              style: TextStyle(
                color: widget.hapticIntensity == HapticIntensity.deep 
                    ? Colors.amber
                    : Colors.white.withOpacity(0.3),
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // 날씨, 알람 아이콘 Row 추가
        _buildQuickAccessRow(),
      ],
    );
  }
  
  /// 날씨 믹스, 리듬, 수면 타이머 퀵 액세스 아이콘 Row (모두 PRO 기능)
  Widget _buildQuickAccessRow() {
    // Get premium status
    final homeController = Get.find<HomeController>();
    final weatherService = Get.find<WeatherService>();
    final rhythmService = Get.isRegistered<RhythmCareService>() 
        ? Get.find<RhythmCareService>() 
        : null;
    
    return Obx(() {
      final isPremium = homeController.isPremiumUser.value;
      final isWeatherActive = weatherService.isEnabled.value;
      final isRhythmActive = rhythmService?.isEnabled.value ?? false;
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 날씨 버튼
          Expanded(
            child: _buildPremiumQuickAccessButton(
              icon: Icons.wb_cloudy,
              label: 'special_weather'.tr,
              color: Colors.lightBlueAccent,
              isActive: isWeatherActive,
              isPremium: isPremium,
              description: 'quick_weather_desc'.tr,
              onPremiumTap: () {
                Get.bottomSheet(
                  const WeatherControlSheet(),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                );
                HapticFeedback.selectionClick();
              },
            ),
          ),
          SizedBox(width: 8.w),
          // 리듬 버튼
          Expanded(
            child: _buildPremiumQuickAccessButton(
              icon: Icons.schedule_outlined,
              label: 'special_rhythm'.tr,
              color: Colors.greenAccent,
              isActive: isRhythmActive,
              isPremium: isPremium,
              description: 'quick_rhythm_desc'.tr,
              onPremiumTap: () {
                // ✨ Toggle Rhythm Care
                if (rhythmService != null) {
                  rhythmService.toggle();
                  final status = rhythmService.isEnabled.value ? 'rhythm_active'.tr : 'rhythm_inactive'.tr;
                  final currentMode = rhythmService.currentTimeZoneName.value;
                  Get.snackbar(
                    '🕐 ${'rhythm_care_status'.tr} $status',
                    isRhythmActive ? 'rhythm_switch_manual'.tr : '${'rhythm_current_zone'.tr} $currentMode',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                }
                HapticFeedback.selectionClick();
              },
            ),
          ),
          SizedBox(width: 8.w),
          // 타이머 버튼
          Expanded(
            child: _buildPremiumQuickAccessButton(
              icon: Icons.timer_outlined,
              label: 'quick_timer'.tr,
              color: Colors.amberAccent,
              isActive: false,
              isPremium: isPremium,
              description: 'quick_timer_desc'.tr,
              onPremiumTap: () {
                Get.bottomSheet(
                  const SleepTimerBottomSheet(),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                );
                HapticFeedback.selectionClick();
              },
            ),
          ),
        ],
      );
    });
  }
  
  /// Premium Quick Access Button with PRO badge
  Widget _buildPremiumQuickAccessButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    required bool isPremium,
    required String description,
    required VoidCallback onPremiumTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (isPremium) {
          onPremiumTap();
        } else {
          // Show premium popup for non-premium users
          PremiumFeaturePopup.show(
            featureName: label,
            description: description,
            icon: icon,
            iconColor: color,
          );
          HapticFeedback.selectionClick();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isActive ? color.withOpacity(0.25) : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isActive ? color : Colors.white.withOpacity(0.2),
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ] : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated icon for active state
                isActive 
                  ? _buildPulsingIcon(icon, color)
                  : Icon(icon, color: Colors.white.withOpacity(0.6), size: 14.w),
                SizedBox(width: 3.w),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isActive ? color : Colors.white.withOpacity(0.6),
                      fontSize: 10.sp,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // PRO Badge (always visible)
          Positioned(
            top: -8.h,
            right: -6.w,
            child: const RainbowProBadge(),
          ),
        ],
      ),
    );
  }
  
  /// Pulsing icon animation for active weather button
  Widget _buildPulsingIcon(IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(icon, color: color, size: 14.w),
        );
      },
      onEnd: () {
        // Restart animation
      },
    );
  }
  
  String _getIntensityLabel(HapticIntensity intensity) {
    switch (intensity) {
      case HapticIntensity.off:
        return 'HAPTIC OFF';
      case HapticIntensity.light:
        return 'LIGHT';
      case HapticIntensity.medium:
        return 'MEDIUM';
      case HapticIntensity.strong:
        return 'STRONG';
      case HapticIntensity.deep:
        return 'DEEP';
    }
  }

  double _getSliderValue(HapticIntensity intensity) {
    switch (intensity) {
      case HapticIntensity.off:
        return 0;
      case HapticIntensity.light:
        return 1;
      case HapticIntensity.medium:
        return 2;
      case HapticIntensity.strong:
        return 3;
      case HapticIntensity.deep:
        return 4;
    }
  }

  HapticIntensity _getIntensityFromValue(double value) {
    if (value == 0) return HapticIntensity.off;
    if (value == 1) return HapticIntensity.light;
    if (value == 2) return HapticIntensity.medium;
    if (value == 3) return HapticIntensity.strong;
    return HapticIntensity.deep;
  }

  void _provideHapticFeedback(HapticIntensity intensity) {
    // Flutter 햅틱 서비스 사용
    switch (intensity) {
      case HapticIntensity.off:
        // No feedback
        break;
      case HapticIntensity.light:
        HapticFeedback.selectionClick();
        break;
      case HapticIntensity.medium:
        HapticFeedback.lightImpact();
        break;
      case HapticIntensity.strong:
        HapticFeedback.mediumImpact();
        break;
      case HapticIntensity.deep:
        HapticFeedback.heavyImpact();
        break;
    }
  }

  Widget _buildWeatherToggle() {
    return GestureDetector(
      onTap: widget.onWeatherToggle,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: widget.isWeatherActive 
              ? AppColors.primaryBlue.withOpacity(0.3) 
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isWeatherActive 
                ? AppColors.primaryBlue.withOpacity(0.5) 
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Icon(
          widget.isWeatherActive ? Icons.cloud : Icons.cloud_off_outlined,
          color: widget.isWeatherActive ? AppColors.primaryBlue : Colors.white.withOpacity(0.5),
          size: 24.w,
        ),
      ),
    );
  }
}

