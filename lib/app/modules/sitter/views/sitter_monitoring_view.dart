import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../services/sound_detection_service.dart';
import '../services/motion_detection_service.dart';
import '../services/sitter_care_service.dart';
import '../services/sitter_report_storage_service.dart';

class SitterMonitoringView extends StatefulWidget {
  const SitterMonitoringView({super.key});

  @override
  State<SitterMonitoringView> createState() => _SitterMonitoringViewState();
}

class _SitterMonitoringViewState extends State<SitterMonitoringView> with TickerProviderStateMixin {
  // 경과 시간
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  
  // 서비스
  late SoundDetectionService _soundService;
  late MotionDetectionService _motionService;
  late SitterCareService _careService;
  
  // 밀어서 종료
  double _slideProgress = 0.0;
  late AnimationController _pulseController;
  String _currentStatus = '감지 대기 중';
  
  @override
  void initState() {
    super.initState();
    _initServices();
    _startMonitoring();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }
  
  void _initServices() {
    // 서비스 초기화 또는 찾기
    if (!Get.isRegistered<SoundDetectionService>()) {
      Get.put(SoundDetectionService());
    }
    if (!Get.isRegistered<MotionDetectionService>()) {
      Get.put(MotionDetectionService());
    }
    if (!Get.isRegistered<SitterCareService>()) {
      Get.put(SitterCareService());
    }
    
    _soundService = Get.find<SoundDetectionService>();
    _motionService = Get.find<MotionDetectionService>();
    _careService = Get.find<SitterCareService>();
    
    // 설정값 가져오기 (arguments에서)
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _soundService.setSensitivity(args['soundSensitivity'] ?? 1);
    _motionService.setSensitivity(args['motionSensitivity'] ?? 1);
    _careService.configure(
      soundMode: args['soundMode'] ?? 0,
      durationIndex: args['durationIndex'] ?? 1,
    );
    
    // 콜백 설정
    _soundService.onSoundDetected = (db) {
      setState(() => _currentStatus = '소리 감지됨 (${db.toStringAsFixed(1)}dB)');
      _careService.triggerCare(reason: 'sound');
    };
    
    _motionService.onMotionDetected = (level) {
      setState(() => _currentStatus = '움직임 감지됨 (${level.toStringAsFixed(1)}%)');
      _careService.triggerCare(reason: 'motion');
    };
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
        if (_elapsedTime.inSeconds % 5 == 0) {
          _currentStatus = '감지 대기 중';
        }
      });
    });
    
    // 서비스 시작
    _soundService.startListening();
    _motionService.startDetecting();
    _careService.activate();
  }

  void _stopMonitoring() async {
    _timer?.cancel();
    _soundService.stopListening();
    _motionService.stopDetecting();
    _careService.deactivate();
    
    // Firestore에 리포트 저장
    try {
      if (!Get.isRegistered<SitterReportStorageService>()) {
        Get.put(SitterReportStorageService());
      }
      final storageService = Get.find<SitterReportStorageService>();
      await storageService.saveReport(
        elapsedTime: _elapsedTime,
        soundCount: _soundService.detectionCount.value,
        motionCount: _motionService.detectionCount.value,
        careCount: _careService.careCount.value,
      );
    } catch (e) {
      debugPrint('[SitterMonitoring] Error saving report: $e');
    }
    
    Get.offNamed('/sitter-report', arguments: {
      'elapsedTime': _elapsedTime,
      'soundCount': _soundService.detectionCount.value,
      'motionCount': _motionService.detectionCount.value,
      'careCount': _careService.careCount.value,
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // 어두운 테마로 상태바 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Stack(
          children: [
            // 중앙 상태 표시
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 상태 아이콘 (펄스 애니메이션)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = 1.0 + _pulseController.value * 0.15;
                      final opacity = 0.5 + _pulseController.value * 0.5;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(opacity * 0.3),
                            border: Border.all(
                              color: Colors.red.withOpacity(opacity),
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 32.w,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // AI 시터 작동 중 텍스트
                  Text(
                    '🔴 AI 시터 작동 중...',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // 경과 시간
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.white38, size: 20.w),
                      SizedBox(width: 8.w),
                      Text(
                        '경과 시간: ${_formatDuration(_elapsedTime)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // 현재 상태
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '($_currentStatus)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // 감지 통계
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('🔊', '소리', _soundService.detectionCount.value),
                      SizedBox(width: 24.w),
                      _buildStatItem('📹', '움직임', _motionService.detectionCount.value),
                      SizedBox(width: 24.w),
                      _buildStatItem('🎵', '케어', _careService.careCount.value),
                    ],
                  )),
                ],
              ),
            ),
            
            // 하단: 밀어서 종료
            Positioned(
              bottom: 40.h,
              left: 24.w,
              right: 24.w,
              child: _buildSlideToEnd(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, int count) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 24.sp)),
        SizedBox(height: 4.h),
        Text(
          '$count회',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white38,
          ),
        ),
      ],
    );
  }

  Widget _buildSlideToEnd() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _slideProgress += details.delta.dx / (MediaQuery.of(context).size.width - 100);
          _slideProgress = _slideProgress.clamp(0.0, 1.0);
        });
      },
      onHorizontalDragEnd: (details) {
        if (_slideProgress > 0.8) {
          HapticFeedback.heavyImpact();
          _stopMonitoring();
        } else {
          setState(() => _slideProgress = 0.0);
        }
      },
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.white24),
        ),
        child: Stack(
          children: [
            // 진행 표시
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 60.w + (MediaQuery.of(context).size.width - 108.w) * _slideProgress,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3 + _slideProgress * 0.4),
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            // 슬라이더 핸들
            Positioned(
              left: _slideProgress * (MediaQuery.of(context).size.width - 108.w),
              child: Container(
                width: 56.w,
                height: 56.h,
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(Icons.stop, color: Colors.white, size: 28.w),
              ),
            ),
            // 텍스트
            Center(
              child: Text(
                _slideProgress > 0.8 ? '손을 떼면 종료' : '밀어서 종료하기 →',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
