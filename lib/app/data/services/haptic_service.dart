import 'dart:async';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class HapticService extends GetxService {
  Timer? _heartbeatTimer;
  bool _isVibrating = false;

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
