import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

/// 자동 케어 서비스
/// 감지 시 자동으로 테라피 사운드 재생
class SitterCareService extends GetxService {
  // 싱글톤 접근
  static SitterCareService get to => Get.find<SitterCareService>();
  
  // 상태
  final RxBool isActive = false.obs;
  final RxBool isPlaying = false.obs;
  final RxInt careCount = 0.obs;
  
  // 설정
  int _soundMode = 0; // 0: 기본 안정 사운드, 1: 스마트 싱크
  Duration _playDuration = const Duration(minutes: 15);
  
  // 재생 타이머
  Timer? _stopTimer;
  
  /// 설정 적용
  void configure({
    required int soundMode,
    required int durationIndex, // 0: 5분, 1: 15분, 2: 30분, 3: 계속
  }) {
    _soundMode = soundMode;
    
    switch (durationIndex) {
      case 0:
        _playDuration = const Duration(minutes: 5);
        break;
      case 1:
        _playDuration = const Duration(minutes: 15);
        break;
      case 2:
        _playDuration = const Duration(minutes: 30);
        break;
      case 3:
        _playDuration = Duration.zero; // 계속 재생
        break;
    }
    
    debugPrint('[SitterCare] Configured: soundMode=$_soundMode, duration=$_playDuration');
  }
  
  /// 케어 활성화
  void activate() {
    isActive.value = true;
    careCount.value = 0;
    debugPrint('[SitterCare] Activated');
  }
  
  /// 케어 비활성화
  void deactivate() {
    isActive.value = false;
    _stopTimer?.cancel();
    debugPrint('[SitterCare] Deactivated. Total care activations: ${careCount.value}');
  }
  
  /// 감지 시 자동 케어 트리거
  Future<void> triggerCare({String reason = 'detection'}) async {
    if (!isActive.value) return;
    if (isPlaying.value) return; // 이미 재생 중이면 무시
    
    careCount.value++;
    isPlaying.value = true;
    
    debugPrint('[SitterCare] Triggered! Reason: $reason, count: ${careCount.value}');
    
    // 사운드 재생
    if (_soundMode == 0) {
      // 기본 안정 사운드 (첫 번째 트랙 재생)
      _playDefaultSound();
    } else {
      // 스마트 싱크 적용 (날씨/리듬 기반)
      _playSmartSyncSound();
    }
    
    // 재생 시간 설정
    if (_playDuration != Duration.zero) {
      _stopTimer?.cancel();
      _stopTimer = Timer(_playDuration, () {
        _stopSound();
      });
    }
  }
  
  void _playDefaultSound() {
    try {
      final homeController = Get.find<HomeController>();
      // 분리불안에 좋은 사운드 (첫 번째 트랙)
      final mode = homeController.currentMode.value;
      if (mode != null && mode.tracks.isNotEmpty) {
        homeController.playTrack(mode.tracks.first);
      }
      debugPrint('[SitterCare] Playing default calming sound');
    } catch (e) {
      debugPrint('[SitterCare] Error playing default sound: $e');
    }
  }
  
  void _playSmartSyncSound() {
    try {
      final homeController = Get.find<HomeController>();
      // 스마트 싱크가 적용된 현재 추천 모드 재생
      final mode = homeController.currentMode.value;
      if (mode != null && mode.tracks.isNotEmpty) {
        homeController.playTrack(mode.tracks.first);
      }
      debugPrint('[SitterCare] Playing smart sync sound');
    } catch (e) {
      debugPrint('[SitterCare] Error playing smart sync sound: $e');
    }
  }
  
  void _stopSound() {
    try {
      final homeController = Get.find<HomeController>();
      homeController.stopSound();
      isPlaying.value = false;
      debugPrint('[SitterCare] Sound stopped after duration');
    } catch (e) {
      debugPrint('[SitterCare] Error stopping sound: $e');
    }
  }
  
  @override
  void onClose() {
    deactivate();
    super.onClose();
  }
}
