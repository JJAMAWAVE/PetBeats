import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// BGM 서비스 (just_audio 사용 - 웹/네이티브 통합)
class WebBgmService {
  static final WebBgmService _instance = WebBgmService._internal();
  factory WebBgmService() => _instance;
  WebBgmService._internal();

  AudioPlayer? _player;
  bool _isInitialized = false;
  bool _isPlaying = false;

  /// BGM 초기화
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      print('[WebBgmService] Creating AudioPlayer...');
      _player = AudioPlayer();
      
      // ❌ DISABLED: sheep.mp3는 실제 BGM이 아님 - 올바른 BGM 파일로 교체 필요
      // Load BGM audio - using AudioSource.asset() for all platforms
      // await _player!.setAudioSource(
      //   AudioSource.asset('assets/sound/BGM/sheep.mp3'),
      // );
      
      // Set loop mode
      await _player!.setLoopMode(LoopMode.one);
      
      // Set volume
      await _player!.setVolume(0.3);
      
      _isInitialized = true;
      print('[WebBgmService] AudioPlayer initialized (BGM disabled - sheep.mp3 is not actual BGM)');
    } catch (e) {
      print('[WebBgmService] Error initializing: $e');
    }
  }

  /// BGM 재생
  Future<void> play() async {
    try {
      if (!_isInitialized) {
        await init();
      }
      
      // Only play if not already playing
      if (_player?.playing != true) {
        await _player?.play();
        _isPlaying = true;
        print('[WebBgmService] Playing BGM');
      }
    } catch (e) {
      print('[WebBgmService] Error playing BGM: $e');
    }
  }

  /// BGM 일시정지
  void pause() {
    print('[WebBgmService] pause() called');
    
    try {
      if (_player != null) {
        _player!.pause();
        _player!.seek(Duration.zero); // Reset to beginning
        _isPlaying = false;
        print('[WebBgmService] BGM stopped and reset');
      }
    } catch (e) {
      print('[WebBgmService] Error pausing: $e');
    }
  }

  /// BGM 재개
  Future<void> resume() async {
    try {
      // Only resume if we were playing before
      if (!_isPlaying && _player?.playing != true) {
        await _player?.play();
        _isPlaying = true;
        print('[WebBgmService] BGM resumed');
      }
    } catch (e) {
      print('[WebBgmService] Error resuming: $e');
    }
  }

  /// 볼륨 설정 (0.0 ~ 1.0)
  void setVolume(double volume) {
    try {
      _player?.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('[WebBgmService] Error setting volume: $e');
    }
  }

  /// 리소스 해제
  void dispose() {
    try {
      _player?.dispose();
      _player = null;
      _isInitialized = false;
      _isPlaying = false;
    } catch (e) {
      print('[WebBgmService] Error disposing: $e');
    }
  }
}
