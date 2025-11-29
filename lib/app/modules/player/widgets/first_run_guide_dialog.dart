import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class FirstRunGuideDialog extends StatelessWidget {
  const FirstRunGuideDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration Placeholder (Using Icon for now)
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.warmPeach.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.volunteer_activism, // Hand holding heart
                color: AppColors.pointCoral,
                size: 40.w,
              ),
            ),
            SizedBox(height: 24.h),
            
            // Title
            Text(
              "당신의 온기를 더해주세요",
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textDarkNavy,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            
            // Content
            Text(
              "PetBeats의 진동은 보호자님의 손을 거칠 때\n가장 부드러운 치유의 파동으로 변합니다.\n\n폰을 직접 몸에 대기보다,\n손에 쥐고 아이를 부드럽게 마사지해주세요.\n기계의 진동이 엄마의 심장박동처럼 따뜻해집니다.",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "네, 이해했어요",
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
