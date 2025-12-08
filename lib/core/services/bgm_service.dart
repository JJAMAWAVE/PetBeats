import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
      print('[BgmService] Loading BGM...');
      
      // Platform-specific loading
      if (kIsWeb) {
        // Web: Use URL-based loading
        await _audioPlayer.setUrl('/assets/sound/BGM/sheep.mp3');
      } else {
        // Android/iOS: Use asset-based loading
        await _audioPlayer.setAsset('assets/sound/BGM/sheep.mp3');
      }
      
      await _audioPlayer.setLoopMode(LoopMode.one); // 무한 반복
      await _audioPlayer.setVolume(0.3); // 볼륨 30%로 낮춤
      _isInitialized = true;
      print('[BgmService] BGM loaded successfully');
      
      // Auto-play BGM after initialization
      await play();
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
    print('[BgmService] pause() called');
    print('[BgmService] AudioPlayer state before: ${_audioPlayer.playing}');
    await _audioPlayer.pause();
    print('[BgmService] AudioPlayer state after: ${_audioPlayer.playing}');
    print('[BgmService] pause() completed');
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
