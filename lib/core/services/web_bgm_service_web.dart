import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

/// 웹 전용 BGM 서비스 (HTML5 Audio 사용)
class WebBgmService {
  static final WebBgmService _instance = WebBgmService._internal();
  factory WebBgmService() => _instance;
  WebBgmService._internal();

  html.AudioElement? _audioElement;
  bool _isInitialized = false;

  /// BGM 초기화
  Future<void> init() async {
    if (!kIsWeb) {
      print('[WebBgmService] Not running on web, skipping');
      return;
    }

    if (_isInitialized) return;

    try {
      print('[WebBgmService] Creating audio element...');
      _audioElement = html.AudioElement();
      _audioElement!.src = 'assets/sound/BGM/sheep.mp3';
      _audioElement!.loop = true;
      _audioElement!.volume = 0.3;
      
      // Preload the audio
      _audioElement!.load();
      
      _isInitialized = true;
      print('[WebBgmService] Audio element created successfully');
    } catch (e) {
      print('[WebBgmService] Error creating audio element: $e');
    }
  }

  /// BGM 재생
  Future<void> play() async {
    if (!kIsWeb) return;

    try {
      if (!_isInitialized) {
        await init();
      }
      
      await _audioElement?.play();
      print('[WebBgmService] Playing BGM');
    } catch (e) {
      print('[WebBgmService] Error playing BGM: $e');
    }
  }

  /// BGM 일시정지
  void pause() {
    print('[WebBgmService] pause() called');
    print('[WebBgmService] Audio element exists: ${_audioElement != null}');
    print('[WebBgmService] Audio element paused before: ${_audioElement?.paused}');
    _audioElement?.pause();
    print('[WebBgmService] Audio element paused after: ${_audioElement?.paused}');
    print('[WebBgmService] pause() completed');
  }

  /// BGM 재개
  Future<void> resume() async {
    await _audioElement?.play();
  }

  /// 볼륨 설정 (0.0 ~ 1.0)
  void setVolume(double volume) {
    if (_audioElement != null) {
      _audioElement!.volume = volume.clamp(0.0, 1.0);
    }
  }

  /// 리소스 해제
  void dispose() {
    _audioElement?.pause();
    _audioElement?.remove();
    _audioElement = null;
    _isInitialized = false;
  }
}
