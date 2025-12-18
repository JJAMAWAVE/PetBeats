import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petbeats/app/routes/app_routes.dart';
import 'package:petbeats/core/widgets/rainbow_gradient.dart';
import 'package:petbeats/core/theme/app_colors.dart';
import 'package:petbeats/core/theme/app_text_styles.dart';

/// 통일된 PRO 기능 카드 위젯
/// 
/// 연한 파란색 배경의 PRO 기능 안내 카드
class ProFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ProFeatureCard({
    super.key,
    this.title = 'dialog_pro_feature',
    this.description = 'dialog_pro_desc',
    this.icon = Icons.diamond,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 32.w),
          SizedBox(height: 8.h),
          Text(
            title.tr,
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            description.tr,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 통일된 PRO 버튼 위젯 (배너 형태)
/// 
/// 레인보우 그라데이션 + 아이콘 + 제목 + 설명 + 화살표
class ProButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onPressed;
  final double? width;

  const ProButton({
    super.key,
    this.title = 'dialog_start_pro',
    this.subtitle = 'dialog_pro_desc',
    this.icon = Icons.diamond,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Get.toNamed(Routes.SUBSCRIPTION),
      child: AnimatedRainbowGradient(
        duration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: width ?? double.infinity,
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // 아이콘
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: Colors.white, size: 24.w),
              ),
              SizedBox(width: 14.w),
              // 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle.tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // 화살표
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 16.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// PRO 기능 카드 + PRO 버튼 조합 위젯
/// 
/// 무료 사용자에게 PRO 기능을 안내하는 전체 섹션
class ProFeatureSection extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final IconData icon;
  final VoidCallback? onPressed;

  const ProFeatureSection({
    super.key,
    this.title = 'dialog_pro_feature',
    this.description = 'dialog_pro_desc',
    this.buttonText = 'dialog_start_pro',
    this.icon = Icons.diamond,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProFeatureCard(
          title: title,
          description: description,
          icon: icon,
        ),
        SizedBox(height: 16.h),
        ProButton(
          title: buttonText,
          subtitle: description,
          icon: icon,
          onPressed: onPressed,
        ),
        SizedBox(height: 12.h),
        // "나중에 할게요" 버튼 - 더 명확한 스타일
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                'dialog_later'.tr,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

