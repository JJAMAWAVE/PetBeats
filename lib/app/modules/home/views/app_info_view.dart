import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card_slider.dart';

class AppInfoView extends StatelessWidget {
  const AppInfoView({super.key});

  List<GlassCardData> get _slides => [
    GlassCardData(
      imagePath: 'assets/images/AppInfo/page_2.png',
      title: 'app_info_p1_title'.tr,
      subtitle: 'app_info_p1_subtitle'.tr,
      badges: [
        {'icon': '🐶', 'text': 'app_info_p1_badge1'.tr},
        {'icon': '🐱', 'text': 'app_info_p1_badge2'.tr},
      ],
    ),
    GlassCardData(
      imagePath: 'assets/images/AppInfo/page_3.png',
      title: 'app_info_p2_title'.tr,
      subtitle: 'app_info_p2_subtitle'.tr,
    ),
    GlassCardData(
      imagePath: 'assets/images/AppInfo/page_4.png',
      title: 'app_info_p3_title'.tr,
      subtitle: 'app_info_p3_subtitle'.tr,
      footer: 'Source: Louisiana State University',
    ),
    GlassCardData(
      imagePath: 'assets/images/AppInfo/page_5.png',
      title: 'app_info_p4_title'.tr,
      subtitle: 'app_info_p4_subtitle'.tr,
      footer: 'Source: Bioacoustics Research / JASA',
    ),
    GlassCardData(
      imagePath: 'assets/images/AppInfo/page_6.png',
      title: 'app_info_p5_title'.tr,
      subtitle: 'app_info_p5_subtitle'.tr,
      footer: 'Source: Salonen et al. (2020, 2021)',
    ),
    GlassCardData(
      imagePath: 'assets/images/AppInfo/page_1.png',
      title: 'app_info_p6_title'.tr,
      subtitle: 'app_info_p6_subtitle'.tr,
    ),
  ];

  void _handleLogin() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      Get.back();
      Get.snackbar(
        'notice'.tr,
        'account_linked'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.textDarkNavy,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassCardSlider(
        slides: _slides,
        isDarkMode: false,
        ctaButtonBuilder: (currentPage, totalPages) {
          // 마지막 페이지에서만 로그인 버튼 표시
          if (currentPage == totalPages - 1) {
            return SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textDarkNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'app_info_continue_action'.tr,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
