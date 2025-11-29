import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../models/midi_note_event.dart';

class HapticService extends GetxService {
  Timer? _heartbeatTimer;
  bool _isVibrating = false;

  // MIDI 노트 이벤트 스트림
  final StreamController<MidiNoteEvent> _midiNoteController = StreamController<MidiNoteEvent>.broadcast();
  Stream<MidiNoteEvent> get midiNoteStream => _midiNoteController.stream;

  // 짧고 경쾌한 햅틱 피드백 (UI 상호작용용)
  void lightImpact() {
    HapticFeedback.lightImpact();
  }

  // 중간 강도 햅틱 피드백
  void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  // Selection click feedback
  void selectionClick() {
    lightImpact();
  }

  // 강한 햅틱 피드백 (완료/성공 등)
  void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  // Safety & Soft Start Variables
  double _masterGain = 0.0; // 0.0 ~ 1.0
  Timer? _rampUpTimer;
  Timer? _safetyTimer;
  static const int _safetyTimeoutMinutes = 20;
  static const double _maxAmplitudeScale = 0.8; // Soft Envelope (Max 80%)

  // ... existing code ...

  // 하트비트 시작 (BPM 기준)
  void startHeartbeat(int bpm) {
    stop(); // 기존 진동 중지
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
        // Apply Master Gain
        final amplitude = (60 * _masterGain).round().clamp(1, 255);
        if (amplitude > 0) {
           Vibration.vibrate(duration: 50, amplitude: amplitude);
        }
      }
    });
  }

  // 골골송 진동 (지속적인 미세 진동)
  void startPurr() async {
    stop();
    _isVibrating = true;
    _startRampUp();
    _startSafetyTimer();
    
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      // 패턴: [대기, 진동, 대기, 진동...]
      // Note: Pattern vibration might not support dynamic amplitude change easily without restarting
      // For now, we apply static pattern but conceptually it should follow gain
      Vibration.vibrate(pattern: [0, 200, 50, 200], intensities: [0, 30, 0, 30], repeat: 0);
    } else {
      // 기본 진동 (fallback)
      Vibration.vibrate(duration: 1000);
    }
  }

  // MIDI 노트 재생 및 이벤트 발행
  void playNote(int note, int velocity) async {
    // 이벤트 발행 (비주얼라이저용) - 원본 데이터 전송
    _midiNoteController.add(MidiNoteEvent(
      note: note,
      velocity: velocity,
      timestamp: DateTime.now(),
    ));

    if (!_isVibrating) return; // Safety Mute 상태면 진동 안함

    // 실제 햅틱 재생
    if (await Vibration.hasAmplitudeControl() ?? false) {
      // 1. Velocity Mapping (0-127 -> 0-255)
      // 2. Soft Envelope (Max 80%)
      // 3. Master Gain (Ramp-up)
      
      double targetAmplitude = (velocity * 2).toDouble();
      targetAmplitude *= _maxAmplitudeScale; // Limit to 80%
      targetAmplitude *= _masterGain; // Apply Soft Start Gain

      final amplitude = targetAmplitude.round().clamp(1, 255);
      
      if (amplitude > 5) { // 의미 있는 진동만 재생
        Vibration.vibrate(duration: 100, amplitude: amplitude);
      }
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

  // 진동 중지
  void stop() {
    _isVibrating = false;
    _heartbeatTimer?.cancel();
    _rampUpTimer?.cancel();
    _safetyTimer?.cancel();
    Vibration.cancel();
    _masterGain = 0.0; // Reset gain
  }
}
