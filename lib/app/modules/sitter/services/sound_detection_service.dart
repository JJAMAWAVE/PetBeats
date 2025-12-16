import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// TODO: Android 빌드에서 noise_meter 패키지 사용
// import 'package:noise_meter/noise_meter.dart';

/// 소리 감지 서비스 (dB 레벨 모니터링)
/// Android에서 마이크를 통해 실시간 소리 레벨 측정
class SoundDetectionService extends GetxService {
  // 싱글톤 접근
  static SoundDetectionService get to => Get.find<SoundDetectionService>();
  
  // 상태
  final RxBool isListening = false.obs;
  final RxDouble currentDB = 0.0.obs;
  final RxInt detectionCount = 0.obs;
  
  // 설정
  int _sensitivity = 1; // 0: 민감, 1: 보통, 2: 둔감
  
  // 임계값 (dB)
  final Map<int, double> _thresholds = {
    0: 50.0,  // 민감: 50dB 이상
    1: 65.0,  // 보통: 65dB 이상  
    2: 80.0,  // 둔감: 80dB 이상
  };
  
  // 콜백
  Function(double db)? onSoundDetected;
  
  // 내부
  Timer? _simulationTimer;
  // NoiseMeter? _noiseMeter;
  // StreamSubscription? _noiseSubscription;
  
  /// 민감도 설정
  void setSensitivity(int level) {
    _sensitivity = level.clamp(0, 2);
    debugPrint('[SoundDetection] Sensitivity set to: $_sensitivity (${_thresholds[_sensitivity]}dB)');
  }
  
  /// 감지 시작
  Future<void> startListening() async {
    if (isListening.value) return;
    
    isListening.value = true;
    detectionCount.value = 0;
    
    debugPrint('[SoundDetection] Started listening');
    
    if (kIsWeb) {
      // 웹에서는 시뮬레이션 모드
      _startSimulation();
    } else {
      // TODO: Android에서 noise_meter 사용
      // _noiseMeter = NoiseMeter();
      // _noiseSubscription = _noiseMeter!.noise.listen(_onData);
      _startSimulation(); // 임시
    }
  }
  
  /// 감지 중지
  void stopListening() {
    isListening.value = false;
    _simulationTimer?.cancel();
    // _noiseSubscription?.cancel();
    
    debugPrint('[SoundDetection] Stopped. Total detections: ${detectionCount.value}');
  }
  
  /// 시뮬레이션 (테스트용)
  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!isListening.value) {
        timer.cancel();
        return;
      }
      
      // 랜덤하게 소리 감지 시뮬레이션
      final random = DateTime.now().millisecond % 100;
      if (random < 20) { // 20% 확률로 감지
        final simulatedDB = 60.0 + (random / 2);
        _processSound(simulatedDB);
      }
    });
  }
  
  /// 사운드 처리
  void _processSound(double db) {
    currentDB.value = db;
    
    final threshold = _thresholds[_sensitivity] ?? 65.0;
    if (db >= threshold) {
      detectionCount.value++;
      debugPrint('[SoundDetection] Detected! dB: $db, threshold: $threshold, count: ${detectionCount.value}');
      onSoundDetected?.call(db);
    }
  }
  
  @override
  void onClose() {
    stopListening();
    super.onClose();
  }
}
