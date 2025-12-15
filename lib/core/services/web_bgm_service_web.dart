import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

/// 웹 전용 BGM 서비스 (HTML5 Audio 사용)
class WebBgmService {
  static final WebBgmService _instance = WebBgmService._internal();
  factory WebBgmService() => _instance;
  WebBgmService._internal();

  html.AudioElement? _audioElement;
  bool _isInitialized = false;
  bool _isPlaying = false; // Track BGM state

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
      
      // Only play if not already playing
      if (_audioElement?.paused == true) {
        await _audioElement?.play();
        _isPlaying = true;
        print('[WebBgmService] Playing BGM');
      }
    } catch (e) {
      print('[WebBgmService] Error playing BGM: $e');
    }
  }

  /// BGM 일시정지
  void pause() {
    if (!kIsWeb) return;
    
    print('[WebBgmService] pause() called');
    print('[WebBgmService] _audioElement: ${_audioElement != null}');
    print('[WebBgmService] _isPlaying: $_isPlaying');
    
    if (_audioElement != null) {
      print('[WebBgmService] Before pause - paused: ${_audioElement!.paused}, currentTime: ${_audioElement!.currentTime}');
      _audioElement!.pause();
      _audioElement!.currentTime = 0; // Reset to beginning
      _isPlaying = false;
      print('[WebBgmService] After pause - paused: ${_audioElement!.paused}, currentTime: ${_audioElement!.currentTime}');
      print('[WebBgmService] BGM stopped and reset');
    } else {
      print('[WebBgmService] WARNING: _audioElement is null, cannot pause');
    }
  }

  /// BGM 재개
  Future<void> resume() async {
    if (!kIsWeb) return;
    
    // Only resume if we were actually playing before
    if (!_isPlaying && _audioElement?.paused == true) {
      await _audioElement?.play();
      _isPlaying = true;
      print('[WebBgmService] BGM resumed');
    }
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
