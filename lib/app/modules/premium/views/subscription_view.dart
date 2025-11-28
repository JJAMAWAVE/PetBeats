import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/premium_controller.dart';

class SubscriptionView extends GetView<PremiumController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/MainBanner/MainBanner.png', // Reusing banner image for bg
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      TextButton(
                        onPressed: controller.restorePurchase,
                        child: Text(
                          '구매 복원',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Text(
                        'PetBeats Premium',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        '반려동물을 위한\n모든 프리미엄 사운드를 경험하세요',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18.sp,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 48.h),

                      // Benefits List
                      _buildBenefitItem('모든 상황별 모드 무제한 이용'),
                      _buildBenefitItem('광고 없는 쾌적한 환경'),
                      _buildBenefitItem('오프라인 재생 지원'),
                      _buildBenefitItem('백그라운드 재생'),
                      
                      SizedBox(height: 48.h),

                      // Subscribe Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: controller.subscribe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.primaryBlue.withOpacity(0.5),
                          ),
                          child: Text(
                            '월 4,900원으로 시작하기',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        '첫 1개월 무료 체험, 언제든지 해지 가능',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.primaryBlue, size: 24.w),
          SizedBox(width: 12.w),
          Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
