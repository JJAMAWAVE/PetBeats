import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioService extends GetxService {
  final AudioPlayer _player = AudioPlayer();

  // 초기화
  @override
  void onInit() {
    super.onInit();
    // 루프 모드 설정 (무한 반복)
    _player.setLoopMode(LoopMode.one);
  }

  // URL 재생
  Future<void> play(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print("Audio play error: $e");
    }
  }

  // 일시정지
  Future<void> pause() async {
    await _player.pause();
  }

  // 정지
  Future<void> stop() async {
    await _player.stop();
  }

  // 볼륨 조절 (0.0 ~ 1.0)
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
