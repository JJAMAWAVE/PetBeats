import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TimeSpecialView extends StatelessWidget {
  const TimeSpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('시간 케어'),
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
            _buildAutoScheduleToggle(),
            SizedBox(height: 32.h),
            Text('시간대별 스케줄', style: AppTextStyles.titleMedium),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView(
                children: [
                  _buildScheduleItem('07:00 AM', '기상 및 활력', Icons.wb_sunny, true),
                  _buildScheduleItem('02:00 PM', '낮잠 시간', Icons.bed, true),
                  _buildScheduleItem('06:00 PM', '산책 후 휴식', Icons.pets, false),
                  _buildScheduleItem('10:00 PM', '수면 유도', Icons.nightlight_round, true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoScheduleToggle() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('자동 스케줄링', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
              SizedBox(height: 4.h),
              Text('시간에 맞춰 자동으로 모드를 변경합니다.', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8))),
            ],
          ),
          Switch(
            value: true,
            onChanged: (v) {},
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String action, IconData icon, bool isActive) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isActive ? AppColors.primaryBlue : AppColors.textGrey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? AppColors.primaryBlue : AppColors.textGrey),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textGrey)),
                Text(action, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (isActive)
            Icon(Icons.check_circle, color: AppColors.primaryBlue, size: 20.w),
        ],
      ),
    );
  }
}
