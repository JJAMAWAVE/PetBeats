import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// TODO: Android 빌드에서 camera 패키지 사용
// import 'package:camera/camera.dart';

/// 움직임 감지 서비스 (카메라 프레임 분석)
/// Android에서 카메라를 통해 프레임 차이 분석
class MotionDetectionService extends GetxService {
  // 싱글톤 접근
  static MotionDetectionService get to => Get.find<MotionDetectionService>();
  
  // 상태
  final RxBool isDetecting = false.obs;
  final RxDouble motionLevel = 0.0.obs;
  final RxInt detectionCount = 0.obs;
  
  // 설정
  int _sensitivity = 1; // 0: 민감, 1: 보통, 2: 둔감
  
  // 임계값 (프레임 차이 %)
  final Map<int, double> _thresholds = {
    0: 5.0,   // 민감: 5% 이상 변화
    1: 15.0,  // 보통: 15% 이상 변화
    2: 30.0,  // 둔감: 30% 이상 변화
  };
  
  // 콜백
  Function(double level)? onMotionDetected;
  
  // 내부
  Timer? _simulationTimer;
  // CameraController? _cameraController;
  // List<int>? _previousFrame;
  
  /// 민감도 설정
  void setSensitivity(int level) {
    _sensitivity = level.clamp(0, 2);
    debugPrint('[MotionDetection] Sensitivity set to: $_sensitivity (${_thresholds[_sensitivity]}%)');
  }
  
  /// 감지 시작
  Future<void> startDetecting() async {
    if (isDetecting.value) return;
    
    isDetecting.value = true;
    detectionCount.value = 0;
    
    debugPrint('[MotionDetection] Started detecting');
    
    if (kIsWeb) {
      // 웹에서는 시뮬레이션 모드
      _startSimulation();
    } else {
      // TODO: Android에서 camera 패키지 사용
      // await _initializeCamera();
      _startSimulation(); // 임시
    }
  }
  
  /// 감지 중지
  void stopDetecting() {
    isDetecting.value = false;
    _simulationTimer?.cancel();
    // _cameraController?.dispose();
    
    debugPrint('[MotionDetection] Stopped. Total detections: ${detectionCount.value}');
  }
  
  /// 시뮬레이션 (테스트용)
  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isDetecting.value) {
        timer.cancel();
        return;
      }
      
      // 랜덤하게 움직임 감지 시뮬레이션
      final random = DateTime.now().millisecond % 100;
      if (random < 15) { // 15% 확률로 감지
        final simulatedLevel = 10.0 + (random / 3);
        _processMotion(simulatedLevel);
      }
    });
  }
  
  /// 움직임 처리
  void _processMotion(double level) {
    motionLevel.value = level;
    
    final threshold = _thresholds[_sensitivity] ?? 15.0;
    if (level >= threshold) {
      detectionCount.value++;
      debugPrint('[MotionDetection] Detected! Level: $level%, threshold: $threshold%, count: ${detectionCount.value}');
      onMotionDetected?.call(level);
    }
  }
  
  @override
  void onClose() {
    stopDetecting();
    super.onClose();
  }
}
