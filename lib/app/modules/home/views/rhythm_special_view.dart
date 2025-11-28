import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RhythmSpecialView extends StatelessWidget {
  const RhythmSpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('Rhythm (리듬)'),
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
            _buildHeader(),
            SizedBox(height: 24.h),
            Text(
              "시간대에 맞춰 활력, 휴식, 수면 모드를\n자동으로 변경합니다.",
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: ListView(
                children: [
                  _buildTimeSlotCard('Morning (07~11시)', 'Happy Play (활력)', Icons.wb_sunny_outlined, Colors.orange, false),
                  _buildTimeSlotCard('Daytime (11~17시)', 'Calm Shelter (안정)', Icons.wb_cloudy_outlined, Colors.blue, true), // Current
                  _buildTimeSlotCard('Evening (17~22시)', 'Relax (휴식)', Icons.coffee, Colors.brown, false),
                  _buildTimeSlotCard('Night (22~07시)', 'Deep Sleep (수면)', Icons.bedtime, Colors.indigo, false),
                ],
              ),
            ),
            _buildControlSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 시간', style: AppTextStyles.bodyMedium),
            Text('14:30 PM', style: AppTextStyles.titleLarge),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text('Daytime Mode', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTimeSlotCard(String time, String mode, IconData icon, Color color, bool isCurrent) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCurrent ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCurrent ? color : AppColors.textGrey.withOpacity(0.1),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isCurrent ? color.withOpacity(0.2) : AppColors.textGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isCurrent ? color : AppColors.textGrey, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isCurrent ? color : AppColors.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  mode,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: AppColors.textDarkNavy,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            Text('Running', style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildControlSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Rhythm Care (리듬 케어)', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
          Switch(
            value: true,
            onChanged: (val) {},
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
