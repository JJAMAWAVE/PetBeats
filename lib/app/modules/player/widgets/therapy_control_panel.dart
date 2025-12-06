import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'dart:ui';

enum HapticIntensity { off, light, medium, strong, deep }

class TherapyControlPanel extends StatelessWidget {
  final HapticIntensity hapticIntensity;
  final Function(HapticIntensity) onHapticChange;
  final bool isWeatherActive;
  final VoidCallback onWeatherToggle;

  const TherapyControlPanel({
    super.key,
    required this.hapticIntensity,
    required this.onHapticChange,
    required this.isWeatherActive,
    required this.onWeatherToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          padding: EdgeInsets.all(20.w),
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
              color: hapticIntensity != HapticIntensity.off 
                  ? AppColors.primaryBlue.withOpacity(0.5)
                  : Colors.white.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: hapticIntensity != HapticIntensity.off
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
                    'Premium Haptic Therapy',
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
              // Haptic 슬라이더
              _buildHapticSlider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHapticSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.pinkAccent, size: 20.w),
            SizedBox(width: 8.w),
            Icon(Icons.vibration, color: Colors.amber, size: 20.w),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Text(
              'OFF',
              style: TextStyle(
                color: hapticIntensity == HapticIntensity.off 
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.3),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 18.r),
                  activeTrackColor: AppColors.primaryBlue,
                  inactiveTrackColor: Colors.white.withOpacity(0.15),
                  thumbColor: Colors.white,
                  overlayColor: AppColors.primaryBlue.withOpacity(0.3),
                ),
                child: Slider(
                  value: _getSliderValue(hapticIntensity),
                  min: 0,
                  max: 4,
                  divisions: 4,
                  onChanged: (value) {
                    HapticIntensity newIntensity = _getIntensityFromValue(value);
                    _provideHapticFeedback(newIntensity);
                    onHapticChange(newIntensity);
                  },
                ),
              ),
            ),
            Text(
              'MAX',
              style: TextStyle(
                color: hapticIntensity == HapticIntensity.deep 
                    ? Colors.amber
                    : Colors.white.withOpacity(0.3),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // 현재 강도 표시
        Text(
          _getIntensityLabel(hapticIntensity),
          style: TextStyle(
            color: hapticIntensity == HapticIntensity.off
                ? Colors.white.withOpacity(0.4)
                : AppColors.primaryBlue,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ],
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
      onTap: onWeatherToggle,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isWeatherActive 
              ? AppColors.primaryBlue.withOpacity(0.3) 
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isWeatherActive 
                ? AppColors.primaryBlue.withOpacity(0.5) 
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Icon(
          isWeatherActive ? Icons.cloud : Icons.cloud_off_outlined,
          color: isWeatherActive ? AppColors.primaryBlue : Colors.white.withOpacity(0.5),
          size: 24.w,
        ),
      ),
    );
  }
}

