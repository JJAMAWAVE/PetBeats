import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class WeatherSpecialView extends StatelessWidget {
  const WeatherSpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('날씨 케어'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherHeader(),
            SizedBox(height: 32.h),
            Text('사운드 레이어링', style: AppTextStyles.titleMedium),
            SizedBox(height: 16.h),
            _buildSoundControl('기본 배경음', 0.8),
            SizedBox(height: 16.h),
            _buildSoundControl('날씨 효과음 (빗소리)', 0.5),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                   Get.snackbar('적용 완료', '날씨 케어 설정이 저장되었습니다.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
                child: Text('설정 저장', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud, size: 48.w, color: Colors.white),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('현재 날씨: 흐림', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
              Text('강수확률 60%', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundControl(String label, double initialValue) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.textGrey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodyLarge),
          Row(
            children: [
              Icon(Icons.volume_mute, color: AppColors.textGrey),
              Expanded(
                child: Slider(
                  value: initialValue,
                  onChanged: (v) {},
                  activeColor: AppColors.primaryBlue,
                ),
              ),
              Icon(Icons.volume_up, color: AppColors.textGrey),
            ],
          ),
        ],
      ),
    );
  }
}
