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

/// 통일된 PRO 버튼 위젯
/// 
/// 레인보우 그라데이션 효과가 적용된 프리미엄 구독 버튼
class ProButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;

  const ProButton({
    super.key,
    this.text = 'dialog_start_pro',
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
          child: Center(
            child: Text(
              text.tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
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
          text: buttonText,
          onPressed: onPressed,
        ),
        SizedBox(height: 8.h),
        TextButton(
          onPressed: () => Get.back(),
          child: Text('dialog_later'.tr, style: TextStyle(color: AppColors.textGrey)),
        ),
      ],
    );
  }
}

