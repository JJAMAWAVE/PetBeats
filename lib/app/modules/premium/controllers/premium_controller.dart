import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PremiumController extends GetxController {
  final RxBool isPremium = false.obs;

  void subscribe() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close loading dialog
      isPremium.value = true;
      
      Get.snackbar(
        '구독 완료',
        'PetBeats 프리미엄 회원이 되신 것을 환영합니다!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryBlue,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    });
  }

  void restorePurchase() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      Get.snackbar(
        '구매 복원',
        '구매 내역이 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.textDarkNavy,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }
}
