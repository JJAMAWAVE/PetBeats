import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class AISpecialModeWidget extends StatelessWidget {
  const AISpecialModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI 특별 모드',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textDarkNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            _buildModeButton(
              context,
              '날씨',
              Icons.cloud,
              Colors.blue.shade400,
              () => Get.toNamed(Routes.WEATHER_SPECIAL),
            ),
            SizedBox(width: 12.w),
            _buildModeButton(
              context,
              '시간',
              Icons.access_time_filled,
              Colors.orange.shade400,
              () => Get.toNamed(Routes.TIME_SPECIAL),
            ),
            SizedBox(width: 12.w),
            _buildModeButton(
              context,
              '반응',
              Icons.sensors,
              Colors.purple.shade400,
              () => Get.toNamed(Routes.REACTION_SPECIAL),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28.w),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDarkNavy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
