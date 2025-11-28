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
          'Smart Sync (스마트 싱크)',
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
              'Weather',
              '날씨',
              'assets/icons/icon_special_weather.png',
              Colors.blue.shade400,
              () => Get.toNamed(Routes.WEATHER_SPECIAL),
            ),
            SizedBox(width: 12.w),
            _buildModeButton(
              context,
              'Rhythm',
              '리듬',
              'assets/icons/icon_special_time.png',
              Colors.orange.shade400,
              () => Get.toNamed(Routes.RHYTHM_SPECIAL),
            ),
            SizedBox(width: 12.w),
            _buildModeButton(
              context,
              'Sitter',
              '시터',
              'assets/icons/icon_special_reaction.png',
              Colors.purple.shade400,
              () => Get.toNamed(Routes.SITTER_SPECIAL),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String title,
    String subtitle,
    String imagePath,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
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
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  imagePath,
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDarkNavy,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
