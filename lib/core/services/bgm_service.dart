import 'package:just_audio/just_audio.dart';

/// BGM 재생을 관리하는 서비스 클래스
class BgmService {
  static final BgmService _instance = BgmService._internal();
  factory BgmService() => _instance;
  BgmService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  /// BGM 초기화 및 재생 시작
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // 웹에서는 큰 파일 로딩에 시간이 걸릴 수 있음
      print('[BgmService] Loading BGM...');
      await _audioPlayer.setAsset('sound/BGM/sheep.mp3'); // assets/ 접두어 제거 (just_audio가 자동 추가)
      await _audioPlayer.setLoopMode(LoopMode.one); // 무한 반복
      await _audioPlayer.setVolume(0.3); // 볼륨 30%로 낮춤
      _isInitialized = true;
      print('[BgmService] BGM loaded successfully');
    } catch (e) {
      print('[BgmService] Error loading BGM: $e');
      // 웹에서는 에러가 발생해도 앱은 계속 실행
    }
  }

  /// BGM 재생 시작 (초기화 후 호출)
  Future<void> play() async {
    try {
      if (!_isInitialized) {
        await init();
      }
      await _audioPlayer.play();
      print('[BgmService] BGM playing');
    } catch (e) {
      print('[BgmService] Error playing BGM: $e');
    }
  }

  /// BGM 일시정지
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// BGM 재개
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  /// BGM 정지
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  /// 볼륨 설정 (0.0 ~ 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// 리소스 해제
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _isInitialized = false;
  }
}
