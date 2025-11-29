import 'dart:async';
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

  // 하트비트 시작 (BPM 기준)
  void startHeartbeat(int bpm) {
    stop(); // 기존 진동 중지
    _isVibrating = true;
    
    // BPM을 밀리초 간격으로 변환 (60 BPM = 1000ms)
    final interval = Duration(milliseconds: (60000 / bpm).round());

    _heartbeatTimer = Timer.periodic(interval, (timer) async {
      if (!_isVibrating) {
        timer.cancel();
        return;
      }
      // 짧고 부드러운 진동 (심장 박동 느낌)
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 50, amplitude: 60);
      }
    });
  }

  // 골골송 진동 (지속적인 미세 진동)
  void startPurr() async {
    stop();
    _isVibrating = true;
    
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      // 패턴: [대기, 진동, 대기, 진동...]
      Vibration.vibrate(pattern: [0, 200, 50, 200], intensities: [0, 30, 0, 30], repeat: 0);
    } else {
      // 기본 진동 (fallback)
      Vibration.vibrate(duration: 1000);
    }
  }

  // 진동 중지
  void stop() {
    _isVibrating = false;
    _heartbeatTimer?.cancel();
    Vibration.cancel();
  }
}
