import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../home/widgets/mini_player.dart';
import '../services/sitter_report_storage_service.dart';
import '../../../../app/data/services/auth_service.dart';

class SitterReportView extends StatelessWidget {
  const SitterReportView({super.key});

  @override
  Widget build(BuildContext context) {
    // 모니터링에서 전달받은 데이터
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final Duration elapsedTime = args['elapsedTime'] ?? Duration.zero;
    final int soundCount = args['soundCount'] ?? 0;
    final int motionCount = args['motionCount'] ?? 0;
    final int careCount = args['careCount'] ?? 0;
    
    // Google 연동 상태 확인
    bool isGoogleLinked = false;
    try {
      final storageService = Get.find<SitterReportStorageService>();
      isGoogleLinked = storageService.isLinkedToGoogle;
    } catch (e) {
      debugPrint('[SitterReportView] SitterReportStorageService not found');
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('sitter_report_title'.tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textDarkNavy),
            onPressed: () => Get.offAllNamed('/home'),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Google 연동 안내 배너 (비연동 상태일 때만 표시)
                if (!isGoogleLinked) _buildGoogleLinkBanner(),
                
                // 요약 카드
                _buildSummaryCard(elapsedTime, soundCount, motionCount, careCount),
                
                SizedBox(height: 24.h),
                
                // 타임라인 섹션
                _buildSectionTitle('sitter_timeline_chart'.tr),
                SizedBox(height: 12.h),
                _buildTimelineChart(elapsedTime, soundCount, motionCount, careCount),
                
                SizedBox(height: 24.h),
                
                // 이벤트 로그
                _buildSectionTitle('sitter_event_log'.tr),
                SizedBox(height: 12.h),
                _buildEventLog(soundCount, motionCount, careCount),
                
                SizedBox(height: 24.h),
                
                // 버튼들
                _buildActionButtons(elapsedTime, soundCount, motionCount, careCount),
                
                SizedBox(height: 100.h),
              ],
            ),
          ),
          
          // 미니플레이어
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const MiniPlayer(),
          ),
        ],
      ),
    );
  }
  
  /// Google 계정 연동 안내 배너
  Widget _buildGoogleLinkBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'sitter_device_warning'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'sitter_google_sync_desc'.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.amber.shade700,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  final authService = Get.find<AuthService>();
                  await authService.signInWithGoogle();
                  Get.snackbar(
                    'sitter_sync_complete_title'.tr,
                    'sitter_sync_complete_desc'.tr,
                    backgroundColor: Colors.green.shade100,
                    colorText: Colors.green.shade800,
                  );
                } catch (e) {
                  Get.snackbar(
                    'sitter_sync_failed_title'.tr,
                    'sitter_sync_failed_desc'.tr,
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade800,
                  );
                }
              },
              icon: Image.asset(
                'assets/icons/icon_google.png',
                width: 20.w,
                height: 20.w,
                errorBuilder: (_, __, ___) => Icon(Icons.account_circle, size: 20.w),
              ),
              label: Text('sitter_google_connect'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textDarkNavy,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Duration elapsedTime, int sound, int motion, int care) {
    String formatDuration(Duration d) {
      if (d.inHours > 0) {
        return 'time_format_hm'.trParams({
          'hour': d.inHours.toString(),
          'min': d.inMinutes.remainder(60).toString()
        });
      }
      return 'time_format_ms'.trParams({
        'min': d.inMinutes.toString(),
        'sec': d.inSeconds.remainder(60).toString()
      });
    }
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24.w),
              SizedBox(width: 8.w),
              Text(
                'sitter_monitoring_complete'.tr,
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'sitter_watched_for'.trParams({'duration': formatDuration(elapsedTime)}),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat(Icons.volume_up, 'sitter_stat_sound'.tr, sound),
              _buildDivider(),
              _buildStat(Icons.videocam_outlined, 'sitter_stat_motion'.tr, motion),
              _buildDivider(),
              _buildStat(Icons.music_note, 'sitter_stat_care'.tr, care),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, int count) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28.w),
        SizedBox(height: 4.h),
        Text(
          '$count${'times'.tr}',
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 50.h,
      color: Colors.white24,
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

  Widget _buildTimelineChart(Duration elapsedTime, int sound, int motion, int care) {
    // 간단한 막대 차트로 감지 통계 시각화
    final maxValue = [sound, motion, care].reduce((a, b) => a > b ? a : b);
    final normalizedMax = maxValue > 0 ? maxValue.toDouble() : 1.0;
    
    return Container(
      height: 180.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sitter_detection_stats'.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar('sitter_chart_sound'.tr, sound, normalizedMax, Colors.orange),
                _buildChartBar('sitter_chart_motion'.tr, motion, normalizedMax, Colors.green),
                _buildChartBar('sitter_chart_care'.tr, care, normalizedMax, AppColors.primaryBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, int value, double maxValue, Color color) {
    final height = maxValue > 0 ? (value / maxValue) * 80.h : 0.0;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$value${'times'.tr}',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDarkNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 50.w,
          height: height.clamp(4.0, 80.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildEventLog(int sound, int motion, int care) {
    // 샘플 이벤트 로그 (실제로는 서비스에서 수집)
    final List<Map<String, dynamic>> events = [];
    
    if (sound == 0 && motion == 0 && care == 0) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(Icons.pets, color: Colors.green.shade700, size: 32.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'sitter_no_events'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          if (sound > 0)
            _buildEventItem('🔊', '12:34', 'sitter_event_sound'.tr),
          if (motion > 0)
            _buildEventItem('📹', '12:35', 'sitter_event_motion'.tr),
          if (care > 0)
            _buildEventItem('🎵', '12:35', 'sitter_event_care'.tr),
        ],
      ),
    );
  }

  Widget _buildEventItem(String emoji, String time, String description) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 12.w),
          Text(
            time,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDarkNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Duration elapsedTime, int sound, int motion, int care) {
    String formatDuration(Duration d) {
      if (d.inHours > 0) {
        return 'time_format_hm'.trParams({
          'hour': d.inHours.toString(),
          'min': d.inMinutes.remainder(60).toString()
        });
      }
      return 'time_format_ms'.trParams({
        'min': d.inMinutes.toString(),
        'sec': d.inSeconds.remainder(60).toString()
      });
    }
    
    void shareReport() {
      final text = '''
 🐾 ${'sitter_report_title'.tr}
 
 ⏱️ ${'sitter_elapsed'.trParams({'time': formatDuration(elapsedTime)})}
 🔊 ${'sitter_stat_sound'.tr}: ${sound}
 📹 ${'sitter_stat_motion'.tr}: ${motion}  
 🎵 ${'sitter_stat_care'.tr}: ${care}
 
 ${sound == 0 && motion == 0 ? 'sitter_peaceful_day'.tr : 'sitter_watched_well'.tr}
 
 -PetBeats
''';
      Share.share(text, subject: 'sitter_report_email_subject'.tr);
    }
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: shareReport,
            icon: const Icon(Icons.share),
            label: Text('sitter_share_report'.tr),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Get.offAllNamed('/home'),
            icon: const Icon(Icons.home, color: Colors.white),
            label: Text('sitter_go_home'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
