import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RhythmSpecialView extends StatefulWidget {
  const RhythmSpecialView({super.key});

  @override
  State<RhythmSpecialView> createState() => _RhythmSpecialViewState();
}

class _RhythmSpecialViewState extends State<RhythmSpecialView> {
  bool _rhythmCareEnabled = true;
  
  // 각 시간대별 모드 활성화 상태
  Map<String, bool> _modeEnabled = {
    '오전 (07~11시)': true,
    '주간 (11~17시)': true,
    '저녁 (17~22시)': true,
    '야간 (22~07시)': true,
  };

  final List<Map<String, dynamic>> _timeSlots = [
    {'time': '오전 (07~11시)', 'mode': '활력', 'icon': Icons.wb_sunny_outlined, 'color': Colors.orange},
    {'time': '주간 (11~17시)', 'mode': '안정', 'icon': Icons.wb_cloudy_outlined, 'color': Colors.blue},
    {'time': '저녁 (17~22시)', 'mode': '휴식', 'icon': Icons.coffee, 'color': Colors.brown},
    {'time': '야간 (22~07시)', 'mode': '수면', 'icon': Icons.bedtime, 'color': Colors.indigo},
  ];

  int _getCurrentTimeSlot() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 7 && hour < 11) return 0;  // 오전
    if (hour >= 11 && hour < 17) return 1; // 주간
    if (hour >= 17 && hour < 22) return 2; // 저녁
    return 3; // 야간
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('리듬'),
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
              child: ListView.builder(
                itemCount: _timeSlots.length,
                itemBuilder: (context, index) => _buildTimeSlotCard(index),
              ),
            ),
            _buildControlSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final currentSlot = _getCurrentTimeSlot();
    final currentMode = _timeSlots[currentSlot];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 시간', style: AppTextStyles.bodyMedium),
            Text(
              '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.titleLarge,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: currentMode['color'],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '${currentMode['mode']} 모드',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }



  Widget _buildTimeSlotCard(int index) {
    final slot = _timeSlots[index];
    final isCurrent = _rhythmCareEnabled && _getCurrentTimeSlot() == index;
    final isEnabled = _modeEnabled[slot['time']]!;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCurrent ? slot['color'].withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCurrent ? slot['color'] : AppColors.textGrey.withOpacity(0.1),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isCurrent ? slot['color'].withOpacity(0.2) : AppColors.textGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(slot['icon'], color: isCurrent ? slot['color'] : AppColors.textGrey, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot['time'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isCurrent ? slot['color'] : AppColors.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  slot['mode'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: AppColors.textDarkNavy,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (isCurrent)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: slot['color'],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '진행 중',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                  ),
                ),
              SizedBox(height: 8.h),
              Switch(
                value: isEnabled,
                onChanged: (val) {
                  setState(() {
                    _modeEnabled[slot['time']] = val;
                  });
                },
                activeColor: slot['color'],
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlSection() {
    return
      Container(
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
          Text('리듬 케어', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
          Switch(
            value: _rhythmCareEnabled,
            onChanged: (val) {
              setState(() {
                _rhythmCareEnabled = val;
              });
            },
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
