import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card_slider.dart';
import '../widgets/mini_player.dart';
import '../../premium/controllers/subscription_controller.dart';
import '../../../routes/app_routes.dart';

class SitterSpecialView extends StatelessWidget {
  const SitterSpecialView({super.key});

  List<GlassCardData> get _slides => [
    GlassCardData(
      imagePath: 'assets/images/sitter/intro_empathy.png',
      title: 'sitter_slide1_title'.tr,
      subtitle: 'sitter_slide1_desc'.tr,
    ),
    GlassCardData(
      imagePath: 'assets/images/sitter/intro_solution.png',
      title: 'sitter_slide2_title'.tr,
      subtitle: 'sitter_slide2_desc'.tr,
    ),
    GlassCardData(
      imagePath: 'assets/images/sitter/intro_active_care.png',
      title: 'sitter_slide3_title'.tr,
      subtitle: 'sitter_slide3_desc'.tr,
    ),
    GlassCardData(
      imagePath: 'assets/images/sitter/intro_reassurance.png',
      title: 'sitter_slide4_title'.tr,
      subtitle: 'sitter_slide4_desc'.tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GlassCardSlider(
            slides: _slides,
            headerTitle: 'sitter_title'.tr,
            isDarkMode: false,
            ctaButtonBuilder: (currentPage, totalPages) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: GetBuilder<SubscriptionController>(
                      init: Get.isRegistered<SubscriptionController>()
                          ? Get.find<SubscriptionController>()
                          : Get.put(SubscriptionController()),
                      builder: (controller) {
                        final isPremium = controller.isPremium.value;
                        return ElevatedButton(
                          onPressed: () {
                            if (isPremium) {
                              Get.toNamed(Routes.SITTER_SETUP);
                            } else {
                              Get.toNamed(Routes.SUBSCRIPTION);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 4,
                            shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isPremium ? Icons.shield_outlined : Icons.lock,
                                size: 22.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                isPremium
                                    ? 'sitter_start_btn'.tr
                                    : 'sitter_pro_btn'.tr,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 80.h), // MiniPlayer 공간
                ],
              );
            },
          ),
          // MiniPlayer
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
