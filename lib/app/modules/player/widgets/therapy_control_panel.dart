import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'dart:ui';

enum HapticIntensity { off, soft, deep }

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
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Haptic Control (좌측 - 슬라이더 기반)
              Expanded(child: _buildHapticSlider()),
              
              // Divider
              Container(
                width: 1,
                height: 40.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
              
              // Weather Control (우측 - 아이콘 토글)
              _buildWeatherToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHapticSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.favorite, color: Colors.pinkAccent.withOpacity(0.9), size: 18.w),
            SizedBox(width: 6.w),
            Icon(Icons.vibration, color: Colors.white.withOpacity(0.9), size: 18.w),
            SizedBox(width: 8.w),
            Text(
              'Haptic Therapy',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              'OFF',
              style: TextStyle(
                color: hapticIntensity == HapticIntensity.off 
                    ? Colors.white 
                    : Colors.white.withOpacity(0.4),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
                  activeTrackColor: AppColors.primaryBlue,
                  inactiveTrackColor: Colors.white.withOpacity(0.2),
                  thumbColor: Colors.white,
                  overlayColor: AppColors.primaryBlue.withOpacity(0.2),
                ),
                child: Slider(
                  value: hapticIntensity == HapticIntensity.off
                      ? 0
                      : (hapticIntensity == HapticIntensity.soft ? 1 : 2),
                  min: 0,
                  max: 2,
                  divisions: 2,
                  onChanged: (value) {
                    HapticIntensity newIntensity;
                    if (value == 0) {
                      newIntensity = HapticIntensity.off;
                    } else if (value == 1) {
                      newIntensity = HapticIntensity.soft;
                    } else {
                      newIntensity = HapticIntensity.deep;
                    }
                    
                    // 즉시 햅틱 피드백 제공
                    _provideHapticFeedback(newIntensity);
                    
                    // 상태 변경
                    onHapticChange(newIntensity);
                  },
                ),
              ),
            ),
            Text(
              'DEEP',
              style: TextStyle(
                color: hapticIntensity == HapticIntensity.deep 
                    ? Colors.white 
                    : Colors.white.withOpacity(0.4),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _provideHapticFeedback(HapticIntensity intensity) {
    // Flutter 햅틱 서비스 사용
    if (intensity == HapticIntensity.off) {
      // No feedback
    } else if (intensity == HapticIntensity.soft) {
      HapticFeedback.selectionClick();
    } else if (intensity == HapticIntensity.deep) {
      HapticFeedback.mediumImpact();
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

