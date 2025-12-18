import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/services/timer_service.dart';

class SleepTimerBottomSheet extends StatelessWidget {
  const SleepTimerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = Get.find<TimerService>();
    
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundDarkNavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bedtime, color: Colors.amber, size: 28.w),
              SizedBox(width: 12.w),
              Text(
                'sleep_timer'.tr,
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          
          Text(
            'sleep_timer_desc'.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 32.h),
          
          // Timer presets
          Obx(() {
            final isActive = timerService.isActive.value;
            
            if (isActive) {
              // Show active timer state
              return _buildActiveTimerUI(timerService);
            } else {
              // Show preset options
              return _buildPresetOptions(timerService);
            }
          }),
          
          SizedBox(height: 24.h),
          
          // Cancel button (only show when timer is active)
          Obx(() {
            if (!timerService.isActive.value) return const SizedBox.shrink();
            
            return TextButton(
              onPressed: () {
                timerService.cancelTimer();
                Get.back();
              },
              child: Text(
                'sleep_timer_cancel'.tr,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
          
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
  
  Widget _buildPresetOptions(TimerService timerService) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      alignment: WrapAlignment.center,
      children: TimerService.presets.map((minutes) {
        return _buildTimerOption(
          minutes: minutes,
          onTap: () {
            timerService.startTimer(minutes);
            Get.back();
          },
        );
      }).toList(),
    );
  }
  
  Widget _buildTimerOption({
    required int minutes,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue.withOpacity(0.3),
              AppColors.primaryBlue.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'minute'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActiveTimerUI(TimerService timerService) {
    return Column(
      children: [
        // Large countdown display
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.indigo.withOpacity(0.4),
                Colors.purple.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.indigo.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.timer,
                color: Colors.amber,
                size: 48.w,
              ),
              SizedBox(height: 16.h),
              Obx(() => Text(
                timerService.formattedTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 4,
                ),
              )),
              SizedBox(height: 8.h),
              Obx(() => Text(
                timerService.remainingText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
              )),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        
        // Quick add time buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAddTimeButton('+5${'minute'.tr}', () => timerService.addTime(5)),
            SizedBox(width: 16.w),
            _buildAddTimeButton('+10${'minute'.tr}', () => timerService.addTime(10)),
            SizedBox(width: 16.w),
            _buildAddTimeButton('+15${'minute'.tr}', () => timerService.addTime(15)),
          ],
        ),
      ],
    );
  }
  
  Widget _buildAddTimeButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
