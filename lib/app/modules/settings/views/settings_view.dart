import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textDarkNavy, size: 20.w),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '설정 및 데이터',
          style: AppTextStyles.titleLarge.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('계정'),
            SizedBox(height: 12.h),
            _buildAccountCard(),
            SizedBox(height: 32.h),
            
            _buildSectionTitle('데이터 접근 권한'),
            SizedBox(height: 8.h),
            Text(
              'PetBeats는 다음 데이터를 사용하여 실시간으로 사운드를 최적화합니다.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Obx(() => _buildPermissionTile(
              icon: Icons.location_on_outlined,
              title: '위치 정보',
              subtitle: '날씨 및 일조량 데이터 수집',
              value: controller.isLocationEnabled.value,
              onChanged: controller.toggleLocation,
            )),
            SizedBox(height: 12.h),
            Obx(() => _buildPermissionTile(
              icon: Icons.notifications_none_outlined,
              title: '알림',
              subtitle: '주간 리포트 및 추천 알림',
              value: controller.isNotificationEnabled.value,
              onChanged: controller.toggleNotification,
            )),
            SizedBox(height: 32.h),

            _buildSectionTitle('기기 연동'),
            SizedBox(height: 16.h),
            _buildDeviceButton(
              icon: Icons.cloud_circle_outlined, // Replace with appropriate icon
              label: 'Smart Home (IoT)',
              onPressed: controller.connectIoT,
            ),
            SizedBox(height: 12.h),
            _buildDeviceButton(
              icon: Icons.videocam_outlined,
              label: 'Pet Cam',
              onPressed: controller.connectPetCam,
            ),
            
            SizedBox(height: 48.h),
            Center(
              child: Text(
                '버전 1.0.0',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey.withOpacity(0.5),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(
        fontSize: 16.sp,
        color: AppColors.textDarkNavy,
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.white, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PetBeats 회원',
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  '로그인하여 데이터를 동기화하세요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.textGrey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF222222), // Dark button color
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20.w),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.titleLarge.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
