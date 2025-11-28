import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SitterSpecialView extends StatefulWidget {
  const SitterSpecialView({super.key});

  @override
  State<SitterSpecialView> createState() => _SitterSpecialViewState();
}

class _SitterSpecialViewState extends State<SitterSpecialView> {
  bool _sitterModeEnabled = true;
  
  // 각 감지 모드 활성화 상태
  Map<String, bool> _detectionEnabled = {
    '짖음 감지': true,
    '움직임 감지': false,
  };

  final List<Map<String, dynamic>> _detectionModes = [
    {'title': '짖음 감지', 'action': '분리불안 모드로 전환', 'icon': Icons.mic, 'color': Colors.redAccent},
    {'title': '움직임 감지', 'action': '실내 놀이 모드로 전환', 'icon': Icons.directions_run, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('시터'),
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
            Expanded(
              child: ListView.builder(
                itemCount: _detectionModes.length,
                itemBuilder: (context, index) => _buildDetectionCard(index),
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
            Text('펫 시터 AI', style: AppTextStyles.titleMedium),
            Text(
              _sitterModeEnabled ? '모니터링 동작 중' : '모니터링 중지됨',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _sitterModeEnabled ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildDetectionCard(int index) {
    final mode = _detectionModes[index];
    final isActive = _detectionEnabled[mode['title']]! && _sitterModeEnabled;
    final isEnabled = _detectionEnabled[mode['title']]!;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isActive ? mode['color'].withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive ? mode['color'] : AppColors.textGrey.withOpacity(0.1),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isActive ? mode['color'].withOpacity(0.2) : AppColors.textGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(mode['icon'], color: isActive ? mode['color'] : AppColors.textGrey, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode['title'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDarkNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  mode['action'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive ? mode['color'] : AppColors.textGrey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (isActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: mode['color'],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text('활성', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                ),
              SizedBox(height: 8.h),
              Switch(
                value: isEnabled,
                onChanged: (val) {
                  setState(() {
                    _detectionEnabled[mode['title']] = val;
                  });
                },
                activeColor: mode['color'],
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
          Text('시터 모드', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
          Switch(
            value: _sitterModeEnabled,
            onChanged: (val) {
              setState(() {
                _sitterModeEnabled = val;
              });
            },
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
