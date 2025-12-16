import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

/// 웹 전용 오디오 서비스 (HTML5 Audio 사용)
class WebAudioService {
  static final WebAudioService _instance = WebAudioService._internal();
  factory WebAudioService() => _instance;
  WebAudioService._internal();

  html.AudioElement? _audioElement;
  String? _currentUrl;
  Duration _savedPosition = Duration.zero;
  
  // Stream controllers
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration?>.broadcast();
  
  bool _isInitialized = false;

  /// Initialize audio element
  Future<void> init() async {
    if (!kIsWeb) return;
    if (_isInitialized) return;

    try {
      print('🎵 [WebAudioService] Initializing...');
      _audioElement = html.AudioElement();
      
      // Add event listeners
      _audioElement!.onLoadedMetadata.listen((_) {
        final duration = _audioElement!.duration;
        if (duration.isFinite) {
          _durationController.add(Duration(milliseconds: (duration * 1000).toInt()));
          print('🎵 [WebAudioService] Duration loaded: ${duration}s');
        }
      });
      
      _audioElement!.onTimeUpdate.listen((_) {
        final currentTime = _audioElement!.currentTime;
        if (currentTime.isFinite) {
          _positionController.add(Duration(milliseconds: (currentTime * 1000).toInt()));
        }
      });
      
      _audioElement!.onError.listen((event) {
        print('❌ [WebAudioService] Audio error: $event');
      });
      
      _isInitialized = true;
      print('🎵 [WebAudioService] Initialized successfully');
    } catch (e) {
      print('❌ [WebAudioService] Initialization error: $e');
    }
  }

  /// Load and play audio
  Future<void> play(String url) async {
    if (!kIsWeb) return;
    
    try {
      if (!_isInitialized) {
        await init();
      }

      print('🎵 [WebAudioService] Playing: $url');
      
      // Only reload if different URL
      if (_currentUrl != url) {
        _audioElement!.src = url;
        _currentUrl = url;
        _savedPosition = Duration.zero;
        print('🎵 [WebAudioService] Loaded new audio source');
      }
      
      await _audioElement!.play();
      print('🎵 [WebAudioService] Playback started');
    } catch (e) {
      print('❌ [WebAudioService] Play error: $e');
    }
  }

  /// Pause
  Future<void> pause() async {
    if (!kIsWeb) return;
    
    try {
      _savedPosition = Duration(milliseconds: (_audioElement!.currentTime * 1000).toInt());
      _audioElement?.pause();
      print('🎵 [WebAudioService] Paused at: $_savedPosition');
    } catch (e) {
      print('❌ [WebAudioService] Pause error: $e');
    }
  }

  /// Resume from saved position
  Future<void> resume() async {
    if (!kIsWeb) return;
    
    try {
      if (_savedPosition.inSeconds > 0) {
        _audioElement!.currentTime = _savedPosition.inSeconds.toDouble();
      }
      await _audioElement!.play();
      print('🎵 [WebAudioService] Resumed from: $_savedPosition');
    } catch (e) {
      print('❌ [WebAudioService] Resume error: $e');
    }
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    if (!kIsWeb) return;
    
    try {
      _audioElement!.currentTime = position.inMilliseconds / 1000;
      print('🎵 [WebAudioService] Seeked to: $position');
    } catch (e) {
      print('❌ [WebAudioService] Seek error: $e');
    }
  }

  /// Stop playback
  Future<void> stop() async {
    if (!kIsWeb) return;
    
    try {
      _audioElement?.pause();
      _audioElement?.currentTime = 0;
      _currentUrl = null;
      _savedPosition = Duration.zero;
      print('🎵 [WebAudioService] Stopped');
    } catch (e) {
      print('❌ [WebAudioService] Stop error: $e');
    }
  }

  /// Set volume (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    if (!kIsWeb) return;
    
    try {
      _audioElement?.volume = volume.clamp(0.0, 1.0);
    } catch (e) {
      print('❌ [WebAudioService] Volume error: $e');
    }
  }

  /// Set loop mode
  Future<void> setLoopMode(bool enabled, {bool singleTrack = true}) async {
    if (!kIsWeb) return;
    
    try {
      _audioElement?.loop = enabled && singleTrack;
      print('🔁 [WebAudioService] Loop: $enabled (single: $singleTrack)');
    } catch (e) {
      print('❌ [WebAudioService] Loop mode error: $e');
    }
  }

  /// Position stream
  Stream<Duration> get positionStream => _positionController.stream;

  /// Duration stream
  Stream<Duration?> get durationStream => _durationController.stream;

  /// Current position
  Duration get position {
    if (_audioElement?.currentTime != null && _audioElement!.currentTime.isFinite) {
      return Duration(milliseconds: (_audioElement!.currentTime * 1000).toInt());
    }
    return Duration.zero;
  }

  /// Current duration
  Duration? get duration {
    if (_audioElement?.duration != null && _audioElement!.duration.isFinite) {
      return Duration(milliseconds: (_audioElement!.duration * 1000).toInt());
    }
    return null;
  }

  /// Check if playing
  bool get isPlaying => _audioElement?.paused == false;

  /// Dispose
  void dispose() {
    _audioElement?.pause();
    _audioElement?.remove();
    _audioElement = null;
    _positionController.close();
    _durationController.close();
    _isInitialized = false;
  }
}
