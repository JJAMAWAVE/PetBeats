import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ReactionSpecialView extends StatelessWidget {
  const ReactionSpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('반응형 케어 (IoT)'),
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
            _buildDeviceStatusCard(),
            SizedBox(height: 32.h),
            Text('최근 감지 이벤트', style: AppTextStyles.titleMedium),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView(
                children: [
                  _buildEventItem('짖음 감지', '5분 전', '진정 사운드 재생됨', Icons.mic),
                  _buildEventItem('움직임 감지', '1시간 전', '모니터링 녹화됨', Icons.videocam),
                  _buildEventItem('온도 상승 (28°C)', '3시간 전', '에어컨 가동 알림', Icons.thermostat),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceStatusCard() {
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
      child: Column(
        children: [
          _buildDeviceRow('펫캠 (Pet Cam)', '연결됨', true),
          Divider(height: 24.h),
          _buildDeviceRow('스마트 조명', '연결됨', true),
          Divider(height: 24.h),
          _buildDeviceRow('자동 급식기', '연결 끊김', false),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(String name, String status, bool isOnline) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 12.w, color: isOnline ? Colors.green : Colors.grey),
            SizedBox(width: 12.w),
            Text(name, style: AppTextStyles.bodyLarge),
          ],
        ),
        Text(
          status,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isOnline ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(String title, String time, String action, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.textGrey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
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
                Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                Text(action, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
              ],
            ),
          ),
          Text(time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textGrey)),
        ],
      ),
    );
  }
}
