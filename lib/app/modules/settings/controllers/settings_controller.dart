import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/iot_service.dart';

class SettingsController extends GetxController {
  // Data Permissions
  final RxBool isLocationEnabled = true.obs;
  final RxBool isNotificationEnabled = true.obs;

  final AuthService _authService = Get.find<AuthService>();
  final IotService _iotService = Get.find<IotService>();

  // Login Logic
  Future<void> handleLogin() async {
    if (_authService.currentUser.value != null) {
      Get.defaultDialog(
        title: '로그아웃',
        middleText: '로그아웃 하시겠습니까?',
        textConfirm: '확인',
        textCancel: '취소',
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          await _authService.signOut();
          Get.snackbar('로그아웃', '성공적으로 로그아웃되었습니다.');
        },
      );
    } else {
      // Try Google Sign In
      try {
        final credential = await _authService.signInWithGoogle();
        if (credential != null) {
          Get.snackbar('로그인 성공', '${credential.user?.displayName}님 환영합니다!');
        } else {
          // If real login fails or is canceled, try simulation for demo
          // await _authService.simulateLogin(); 
        }
      } catch (e) {
        // Fallback to simulation if config is missing
        await _authService.simulateLogin();
      }
    }
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

  // Device Connection (Real BLE)
  void connectIoT() async {
    // Show Scanning Dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('기기 검색 중...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Obx(() => Text('${_iotService.scanResults.length}개의 기기 발견')),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Obx(() => ListView.builder(
                  itemCount: _iotService.scanResults.length,
                  itemBuilder: (context, index) {
                    final result = _iotService.scanResults[index];
                    final name = result.device.name.isNotEmpty ? result.device.name : 'Unknown Device';
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(result.device.id.toString()),
                      trailing: ElevatedButton(
                        child: const Text('연결'),
                        onPressed: () {
                          Get.back(); // Close dialog
                          _iotService.connectToDevice(result.device);
                          Get.snackbar('연결 시도', '$name에 연결을 시도합니다.');
                        },
                      ),
                    );
                  },
                )),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('닫기'),
              ),
            ],
          ),
        ),
      ),
    );

    await _iotService.startScan();
    
    // If no devices found after scan (simulation fallback)
    // If no devices found after scan (simulation fallback)
    if (_iotService.scanResults.isEmpty) {
      Get.snackbar('테스트 모드', '기기를 찾을 수 없어 가상 심박수 모드를 실행합니다.');
      _iotService.simulateHeartRate(); 
    }
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
