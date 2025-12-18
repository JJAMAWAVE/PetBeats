import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        title: 'logout'.tr,
        middleText: 'logout_confirm'.tr,
        textConfirm: 'confirm'.tr,
        textCancel: 'cancel'.tr,
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          await _authService.signOut();
          Get.snackbar('logout'.tr, 'logout_success'.tr);
        },
      );
    } else {
      // Try Google Sign In
      try {
        final credential = await _authService.signInWithGoogle();
        if (credential != null) {
          Get.snackbar('login_success'.tr, 'login_welcome'.trParams({'name': credential.user?.displayName ?? ''}));
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
    _showPermissionSnackbar('settings_location'.tr, value);
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    _showPermissionSnackbar('settings_notification'.tr, value);
  }

  void _showPermissionSnackbar(String permission, bool isEnabled) {
    Get.snackbar(
      'permission_changed'.tr,
      'permission_status'.trParams({'permission': permission, 'status': isEnabled ? 'enabled'.tr : 'disabled'.tr}),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('iot_scanning'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Obx(() => Text('iot_found'.trParams({'count': _iotService.scanResults.length.toString()}))),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Obx(() => ListView.builder(
                  itemCount: _iotService.scanResults.length,
                  itemBuilder: (context, index) {
                    final result = _iotService.scanResults[index];
                    final name = result.device.name.isNotEmpty ? result.device.name : 'iot_unknown'.tr;
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(result.device.id.toString()),
                      trailing: ElevatedButton(
                        child: Text('iot_connect'.tr),
                        onPressed: () {
                          Get.back(); // Close dialog
                          _iotService.connectToDevice(result.device);
                          Get.snackbar('iot_connecting'.tr, 'iot_try_connect'.trParams({'name': name}));
                        },
                      ),
                    );
                  },
                )),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('close'.tr),
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
      Get.snackbar('iot_test_mode'.tr, 'iot_no_device'.tr);
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
        'petcam'.tr,
        'petcam_connected'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryBlue,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }
}
