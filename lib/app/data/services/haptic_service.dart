import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../models/midi_note_event.dart';
import '../models/haptic_envelope.dart';
import '../models/haptic_settings_model.dart';

enum HapticPattern { none, heartbeat, purr, rampDown }

class HapticService extends GetxService {
  Timer? _heartbeatTimer;
  bool _isVibrating = false;
  HapticIntensity _currentIntensity = HapticIntensity.medium; // Default
  
  // State tracking for pause/resume
  HapticPattern _currentPattern = HapticPattern.none;
  HapticPattern _pausedPattern = HapticPattern.none;
  int _pausedBpm = 60;

  // MIDI 노트 이벤트 스트림
  final StreamController<MidiNoteEvent> _midiNoteController = StreamController<MidiNoteEvent>.broadcast();
  Stream<MidiNoteEvent> get midiNoteStream => _midiNoteController.stream;

  void updateIntensity(HapticIntensity intensity) {
    _currentIntensity = intensity;
    if (intensity == HapticIntensity.off) {
      _isVibrating = false;  // 상태 확실히 리셋
      stop(); // 즉시 정지
    }
    print('🎚️ [HapticService] Intensity updated: $intensity -> base amplitude: ${_getBaseAmplitude()}');
  }
  
  /// 강도에 따른 기본 amplitude 반환
  int _getBaseAmplitude() {
    switch (_currentIntensity) {
      case HapticIntensity.off:
        return 0;
      case HapticIntensity.light:
        return 30;   // 약한 진동
      case HapticIntensity.medium:
        return 80;   // 중간 진동
      case HapticIntensity.strong:
        return 150;  // 강한 진동
      case HapticIntensity.deep:
        return 255;  // 최대 진동
    }
  }
  
  /// masterGain이 적용된 최종 amplitude 반환
  int _getAdjustedAmplitude() {
    final base = _getBaseAmplitude();
    return (base * _masterGain).round().clamp(0, 255);
  }

  // 짧고 경쾌한 햅틱 피드백 (UI 상호작용용)
  void lightImpact() {
    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    HapticFeedback.lightImpact();
  }

  // 중간 강도 햅틱 피드백
  void mediumImpact() {
    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    HapticFeedback.mediumImpact();
  }

  // Selection click feedback
  void selectionClick() {
    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    lightImpact();
  }

  // 강한 햅틱 피드백 (완료/성공 등)
  void heavyImpact() {
    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    HapticFeedback.heavyImpact();
  }

  // Safety & Soft Start Variables
  double _masterGain = 0.0; // 0.0 ~ 1.0
  Timer? _rampUpTimer;
  Timer? _safetyTimer;
  static const int _safetyTimeoutMinutes = 20;
  static const double _maxAmplitudeScale = 0.8; // Soft Envelope (Max 80%)

  // 하트비트 시작 (BPM 기준)
  void startHeartbeat(int bpm) {
    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    
    stop(); // 기존 진동 중지
    
    _currentPattern = HapticPattern.heartbeat;
    _currentBpm = bpm; // Store for resume
    
    _isVibrating = true;
    _startRampUp(); // Soft Start 시작
    _startSafetyTimer(); // Safety Timeout 시작
    
    // BPM을 밀리초 간격으로 변환 (60 BPM = 1000ms)
    final interval = Duration(milliseconds: (60000 / bpm).round());

    _heartbeatTimer = Timer.periodic(interval, (timer) async {
      if (!_isVibrating) {
        timer.cancel();
        return;
      }
      // 짧고 부드러운 진동 (심장 박동 느낌)
      if (await Vibration.hasVibrator() ?? false) {
        // Apply intensity-based amplitude
        final amplitude = _getAdjustedAmplitude();
        if (amplitude > 0) {
           Vibration.vibrate(duration: 50, amplitude: amplitude);
        }
      }
    });
  }

  // Calming Ramp-down: 100 BPM → 60 BPM over 5 minutes
  // 산책 후 과흥분/소음 스트레스 완화용
  Timer? _rampdownTimer;
  int _currentBpm = 100;
  
  void startCalmingRampdown() {
    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    
    stop(); // 기존 진동 중지
    
    _currentPattern = HapticPattern.rampDown;
    _isVibrating = true;
    _startSafetyTimer();
    
    // Initial settings
    _currentBpm = 100;
    _masterGain = 1.0; // Start at full gain (no soft start for rampdown)
    
    // Calculate: 100 → 60 BPM over 5 minutes (300 seconds)
    // That's 40 BPM reduction over 300 seconds = ~0.133 BPM per second
    const totalDurationSeconds = 300;
    const startBpm = 100;
    const endBpm = 60;
    const bpmReduction = startBpm - endBpm; // 40
    
    int elapsedSeconds = 0;
    
    _rampdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isVibrating) {
        timer.cancel();
        return;
      }
      
      elapsedSeconds++;
      
      // Calculate current BPM based on linear interpolation
      final progress = (elapsedSeconds / totalDurationSeconds).clamp(0.0, 1.0);
      _currentBpm = (startBpm - (bpmReduction * progress)).round();
      
      if (elapsedSeconds >= totalDurationSeconds) {
        // Reached target - continue at 60 BPM
        _currentBpm = endBpm;
        timer.cancel();
        
        // Show completion notification
        Get.snackbar(
          '🌿 진정 완료',
          '심박수가 안정되었습니다. 편안한 상태를 유지합니다.',
          backgroundColor: Colors.teal.withOpacity(0.9),
          colorText: Colors.white,
          icon: const Icon(Icons.favorite, color: Colors.white),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    });
    
    // Start the heartbeat with dynamic BPM
    _startDynamicHeartbeat();
    
    print('🌿 Calming Ramp-down started: 100 → 60 BPM over 5 minutes');
  }
  
  void _startDynamicHeartbeat() {
    // Dynamic heartbeat that respects _currentBpm
    Future.doWhile(() async {
      if (!_isVibrating) return false;
      
      final interval = Duration(milliseconds: (60000 / _currentBpm).round());
      await Future.delayed(interval);
      
      if (!_isVibrating) return false;
      
      if (await Vibration.hasVibrator() ?? false) {
        // Apply intensity-based amplitude
        final amplitude = _getAdjustedAmplitude();
        if (amplitude > 0) {
          Vibration.vibrate(duration: 50, amplitude: amplitude);
        }
      }
      
      return _isVibrating;
    });
  }
  
  /// Get current BPM (for UI display during rampdown)
  int get currentBpm => _currentBpm;

  /// 사운드 어댑티브 모드 시작 (MIDI 기반 햅틱용)
  /// HapticPatternPlayer에서 playNote를 호출할 수 있도록 _isVibrating 활성화
  void startSoundAdaptive() {
    if (_currentIntensity == HapticIntensity.off) return;
    
    stop();  // 기존 패턴 중지
    _isVibrating = true;
    _startRampUp();  // Soft start
    _startSafetyTimer();  // Safety timeout
    
    print('🎵 [HapticService] Sound Adaptive mode activated');
  }

  // 골골송 진동 (지속적인 미세 진동)
  void startPurr() async {
    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    
    stop();
    _currentPattern = HapticPattern.purr;
    _isVibrating = true;
    _startRampUp();
    _startSafetyTimer();
    
    // Purring loop
    Future.doWhile(() async {
      if (!_isVibrating) return false;
      
      // 골골송 패턴: 25Hz ~ 150Hz 변조
      if (await Vibration.hasVibrator() ?? false) {
        final baseAmp = _getAdjustedAmplitude();
        // 약간의 랜덤성 추가
        final amp = (baseAmp * 0.8 + (baseAmp * 0.2 * 0.5)).round().clamp(1, 255);
        
        if (amp > 0) {
          Vibration.vibrate(duration: 40, amplitude: amp);
        }
      }
      
      await Future.delayed(const Duration(milliseconds: 50));
      return _isVibrating;
    });
  }

  // MIDI 노트 재생 및 이벤트 발행 (ADSR Envelope 적용)
  void playNote(int note, int velocity) async {
    // 이벤트 발행 (비주얼라이저용) - 원본 데이터 전송
    _midiNoteController.add(MidiNoteEvent(
      note: note,
      velocity: velocity,
      timestamp: DateTime.now(),
    ));

    if (_currentIntensity == HapticIntensity.off) return; // Check OFF
    if (!_isVibrating) return; // Safety Mute 상태면 진동 안함

    // ADSR Envelope을 적용한 부드러운 진동
    if (await Vibration.hasAmplitudeControl() ?? false) {
      // 1. Base amplitude 계산
      double baseAmplitude = (velocity * 2).toDouble();
      baseAmplitude *= _maxAmplitudeScale; // Limit to 80%
      baseAmplitude *= _masterGain; // Apply Soft Start Gain
      
      // 2. ADSR Envelope 적용 (150ms 총 지속시간)
      Timer.periodic(Duration(milliseconds: 10), (timer) {
        final elapsedMs = timer.tick * 10;
        
        if (elapsedMs >= HapticEnvelope.totalDuration) {
          timer.cancel();
          return;
        }
        
        // Envelope gain 계산
        final envelopeGain = HapticEnvelope.getGain(elapsedMs);
        final finalAmplitude = (baseAmplitude * envelopeGain).round().clamp(1, 255);
        
        if (finalAmplitude > 5) {
          Vibration.vibrate(duration: 10, amplitude: finalAmplitude);
        }
      });
    } else {
      // Fallback for devices without amplitude control
      if (_masterGain > 0.5) {
         Vibration.vibrate(duration: 50);
      }
    }
  }

  // Soft Start Logic: 15초 동안 0.0 -> 1.0
  void _startRampUp() {
    _masterGain = 0.0;
    _rampUpTimer?.cancel();
    
    int steps = 150; // 15 seconds * 10 updates/sec
    int currentStep = 0;
    
    _rampUpTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      currentStep++;
      _masterGain = (currentStep / steps).clamp(0.0, 1.0);
      
      if (currentStep >= steps) {
        timer.cancel();
      }
    });
  }

  // Safety Timeout Logic: 20분 후 차단
  void _startSafetyTimer() {
    _safetyTimer?.cancel();
    _safetyTimer = Timer(Duration(minutes: _safetyTimeoutMinutes), () {
      stop(); // Stop vibration
      Get.snackbar(
        "안전을 위해 햅틱을 잠시 쉽니다",
        "장시간 사용 시 발열 방지를 위해 햅틱이 자동 종료되었습니다.",
        backgroundColor: Get.theme.colorScheme.surface.withOpacity(0.9),
        colorText: Get.theme.colorScheme.onSurface,
        icon: Icon(Icons.safety_check, color: Colors.orange),
        duration: Duration(seconds: 5),
      );
    });
  }
  
  // Pause vibration but remember state
  void pause() {
    if (_currentPattern == HapticPattern.none) return;
    print('⏸️ [HapticService] Pausing haptic feedback');
    _pausedPattern = _currentPattern;
    _pausedBpm = _currentBpm;
    stop();
    // Restore _currentPattern to none is done by stop(), but we have _pausedPattern
  }
  
  // Resume vibration from paused state
  void resume() {
    if (_pausedPattern == HapticPattern.none) return;
    print('▶️ [HapticService] Resuming haptic feedback: $_pausedPattern');
    
    if (_pausedPattern == HapticPattern.heartbeat) {
      startHeartbeat(_pausedBpm);
    } else if (_pausedPattern == HapticPattern.purr) {
      startPurr();
    } else if (_pausedPattern == HapticPattern.rampDown) {
      // For rampdown, we just restart for now as complex state restoration is tricky
      startCalmingRampdown();
    }
    
    _pausedPattern = HapticPattern.none;
  }

  // 진동 중지
  void stop() {
    _isVibrating = false;
    _currentPattern = HapticPattern.none; // Reset pattern
    _heartbeatTimer?.cancel();
    _rampUpTimer?.cancel();
    _rampdownTimer?.cancel();
    _safetyTimer?.cancel();
    Vibration.cancel();
    _masterGain = 0.0; // Reset gain
    _currentBpm = 60; // Reset to default
  }
}
