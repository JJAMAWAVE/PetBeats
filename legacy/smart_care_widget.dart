import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/smart_care_controller.dart';

class SmartCareWidget extends GetView<SmartCareController> {
  const SmartCareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          _buildWeatherCard(),
          SizedBox(width: 16.w),
          _buildIoTCard(),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Obx(() => Container(
      width: 280.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.9),
            const Color(0xFF6C63FF).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showDebugDialog(context),
                    child: Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 24.w),
                  ), // Placeholder icon
                  SizedBox(width: 8.w),
                  Text(
                    '${controller.temperature.value}°C ${controller.weatherCondition.value}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Switch(
                value: controller.isAutoPlayEnabled.value,
                onChanged: controller.toggleAutoPlay,
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
          const Spacer(),
          Text(
            controller.getRecommendationText(),
            style: AppTextStyles.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: controller.playRecommendation,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16.w),
                  SizedBox(width: 4.w),
                  Text(
                    '지금 재생하기',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildIoTCard() {
    return Container(
      width: 280.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.textGrey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.videocam_rounded, color: AppColors.primaryBlue, size: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    'Pet Cam',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textDarkNavy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Online',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.green,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '최근 감지: 짖음 (5분 전)',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildIoTActionButton('Live View', Icons.remove_red_eye_rounded),
              SizedBox(width: 8.w),
              _buildIoTActionButton('진정 사운드', Icons.music_note_rounded, isPrimary: true),
            ],
          ),
        ],
      ),
    );
  }

  void _showDebugDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Debug: AI Smart Care'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('날씨 변경'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _debugButton('맑음'),
                _debugButton('비'),
                _debugButton('눈'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('시간 변경'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _debugButton('아침', isTime: true),
                _debugButton('오후', isTime: true),
                _debugButton('밤', isTime: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _debugButton(String value, {bool isTime = false}) {
    return TextButton(
      onPressed: () {
        if (isTime) {
          controller.setDebugTime(value);
        } else {
          controller.setDebugWeather(value);
        }
        Get.back();
      },
      child: Text(value),
    );
  }

  Widget _buildIoTActionButton(String label, IconData icon, {bool isPrimary = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Mock action
          Get.snackbar(
            label,
            '$label 기능을 실행합니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: isPrimary ? AppColors.primaryBlue : AppColors.textDarkNavy,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 1),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primaryBlue.withOpacity(0.1) : AppColors.textGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isPrimary ? AppColors.primaryBlue : AppColors.textGrey,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
