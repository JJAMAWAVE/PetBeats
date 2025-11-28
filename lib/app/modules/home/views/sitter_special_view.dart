import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SitterSpecialView extends StatelessWidget {
  const SitterSpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('Sitter (시터)'),
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
              "짖거나 움직임을 감지하면,\n상황에 맞는 음악으로 즉시 전환합니다.",
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
            ),
            SizedBox(height: 32.h),
            _buildDetectionCard(
              'Barking Detected (짖음 감지)',
              'Calm Shelter (분리불안) 모드로 전환',
              Icons.mic,
              Colors.redAccent,
              true,
            ),
            SizedBox(height: 16.h),
            _buildDetectionCard(
              'Motion Detected (움직임 감지)',
              'Happy Play (실내 놀이) 모드로 전환',
              Icons.directions_run,
              Colors.green,
              false,
            ),
            
            Spacer(),
            _buildControlSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.pets, size: 32.w, color: Colors.purple),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pet Sitter AI', style: AppTextStyles.titleMedium),
            Text('Monitoring Active', style: AppTextStyles.bodyMedium.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetectionCard(String title, String action, IconData icon, Color color, bool isActive) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive ? color : AppColors.textGrey.withOpacity(0.1),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isActive ? color.withOpacity(0.2) : AppColors.textGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isActive ? color : AppColors.textGrey, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDarkNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  action,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive ? color : AppColors.textGrey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
             Container(
               padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
               decoration: BoxDecoration(
                 color: color,
                 borderRadius: BorderRadius.circular(12.r),
               ),
               child: Text('Active', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
             ),
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
          Text('Sitter Mode (시터 모드)', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
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
