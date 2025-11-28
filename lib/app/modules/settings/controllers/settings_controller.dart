import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsController extends GetxController {
  // Data Permissions
  final RxBool isLocationEnabled = true.obs;
  final RxBool isNotificationEnabled = true.obs;

  // Mock Login
  void handleLogin() {
    Get.snackbar(
      '알림',
      '이미 로그인되어 있습니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.textDarkNavy,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  // Toggle Permissions
  void toggleLocation(bool value) {
    isLocationEnabled.value = value;
    _showPermissionSnackbar('위치 정보', value);
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    _showPermissionSnackbar('알림', value);
  }

  void _showPermissionSnackbar(String permission, bool isEnabled) {
    Get.snackbar(
      '권한 설정 변경',
      '$permission 권한이 ${isEnabled ? '허용' : '해제'}되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.textDarkNavy,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 1),
    );
  }

  // Device Connection (Mock)
  void connectIoT() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      Get.snackbar(
        'Smart Home (IoT)',
        '기기가 성공적으로 연동되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryBlue,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  void connectPetCam() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      Get.snackbar(
        'Pet Cam',
        '펫 캠 연결에 성공했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryBlue,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }
}
