import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../home/widgets/mini_player.dart';

class SitterSetupView extends StatefulWidget {
  const SitterSetupView({super.key});

  @override
  State<SitterSetupView> createState() => _SitterSetupViewState();
}

class _SitterSetupViewState extends State<SitterSetupView> {
  // 감지 설정
  bool _soundDetectionEnabled = true;
  bool _motionDetectionEnabled = false;
  int _soundSensitivity = 1; // 0: 민감, 1: 보통, 2: 둔감
  int _motionSensitivity = 1;
  
  // 반응 설정
  int _soundMode = 0; // 0: 기본 안정 사운드, 1: 스마트 싱크
  int _playDuration = 1; // 0: 5분, 1: 15분, 2: 30분, 3: 계속

  final List<String> _sensitivityLabels = ['민감', '보통', '둔감'];
  final List<String> _durationLabels = ['5분', '15분', '30분', '계속'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('AI 시터 설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGuideCard(),
                  SizedBox(height: 24.h),
                  _buildSectionTitle('🎛️ 감지 설정'),
                  SizedBox(height: 12.h),
                  _buildDetectionCard(
                    icon: Icons.mic,
                    title: '소리 감지',
                    subtitle: '짖음, 하울링 감지',
                    enabled: _soundDetectionEnabled,
                    sensitivity: _soundSensitivity,
                    onToggle: (val) => setState(() => _soundDetectionEnabled = val),
                    onSensitivityChanged: (val) => setState(() => _soundSensitivity = val),
                  ),
                  SizedBox(height: 12.h),
                  _buildDetectionCard(
                    icon: Icons.videocam,
                    title: '움직임 감지',
                    subtitle: '카메라로 움직임 감지',
                    enabled: _motionDetectionEnabled,
                    sensitivity: _motionSensitivity,
                    onToggle: (val) => setState(() => _motionDetectionEnabled = val),
                    onSensitivityChanged: (val) => setState(() => _motionSensitivity = val),
                  ),
                  SizedBox(height: 24.h),
                  _buildSectionTitle('🎵 반응 행동 설정'),
                  SizedBox(height: 12.h),
                  _buildSoundModeCard(),
                  SizedBox(height: 12.h),
                  _buildDurationCard(),
                  SizedBox(height: 16.h),
                  _buildRetentionNotice(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
          
          // 하단 고정 버튼
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: _buildStartButton(),
            ),
          ),
          
          // 미니플레이어
          const MiniPlayer(),
        ],
      ),
    );
  }

  Widget _buildGuideCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.phone_android, color: AppColors.primaryBlue, size: 32.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '아이의 주 활동 공간이 잘 보이도록\n기기를 거치하고 전원을 연결해주세요.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDarkNavy,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textDarkNavy,
      ),
    );
  }

  Widget _buildDetectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required int sensitivity,
    required Function(bool) onToggle,
    required Function(int) onSensitivityChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: enabled ? AppColors.primaryBlue.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: enabled ? AppColors.primaryBlue.withOpacity(0.3) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: enabled ? AppColors.primaryBlue.withOpacity(0.15) : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: enabled ? AppColors.primaryBlue : Colors.grey, size: 20.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                onChanged: onToggle,
                activeColor: AppColors.primaryBlue,
              ),
            ],
          ),
          if (enabled) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Text('감도: ', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      final isSelected = sensitivity == index;
                      return GestureDetector(
                        onTap: () => onSensitivityChanged(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            _sensitivityLabels[index],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isSelected ? Colors.white : AppColors.textGrey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSoundModeCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감지 시 재생할 사운드?', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          _buildRadioOption(
            title: '기본 안정 사운드',
            subtitle: '분리불안에 효과적인 사운드',
            value: 0,
            groupValue: _soundMode,
            onChanged: (val) => setState(() => _soundMode = val!),
          ),
          SizedBox(height: 8.h),
          _buildRadioOption(
            title: '스마트 싱크 적용',
            subtitle: '날씨/리듬에 맞는 사운드',
            value: 1,
            groupValue: _soundMode,
            onChanged: (val) => setState(() => _soundMode = val!),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String subtitle,
    required int value,
    required int groupValue,
    required Function(int?) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('재생 시간', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              final isSelected = _playDuration == index;
              return GestureDetector(
                onTap: () => setState(() => _playDuration = index),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    _durationLabels[index],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textGrey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRetentionNotice() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 18.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '리포트는 30일 후 자동 삭제됩니다.',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    final canStart = _soundDetectionEnabled || _motionDetectionEnabled;
    
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: canStart ? () {
          Get.toNamed('/sitter-monitoring', arguments: {
            'soundEnabled': _soundDetectionEnabled,
            'motionEnabled': _motionDetectionEnabled,
            'soundSensitivity': _soundSensitivity,
            'motionSensitivity': _motionSensitivity,
            'soundMode': _soundMode,
            'durationIndex': _playDuration,
          });
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: canStart ? 4 : 0,
          shadowColor: AppColors.primaryBlue.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              '모니터링 시작하기',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: canStart ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
