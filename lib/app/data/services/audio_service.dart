import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioService extends GetxService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentLoadedUrl; // Track the currently loaded URL

  // 초기화
  @override
  void onInit() {
    super.onInit();
    // 루프 모드 설정 (무한 반복)
    _player.setLoopMode(LoopMode.one);
  }
  
  // Position stream (현재 재생 위치)
  Stream<Duration> get positionStream => _player.positionStream;
  
  // Duration stream (총 길이)
  Stream<Duration?> get durationStream => _player.durationStream;
  
  // Get current values
  Duration get position => _player.position;
  Duration? get duration => _player.duration;

  // URL 재생
  Future<void> play(String url) async {
    try {
      print("🎵 [AudioService] Starting playback: $url");
      
      // Only set audio source if it's a different URL
      if (_currentLoadedUrl != url) {
        print("🎵 [AudioService] Loading new audio source");
        
        // For web, use URI-based loading
        if (url.startsWith('assets/')) {
          // Web: Convert asset path to web URL
          final webUrl = '/$url'; // /assets/sound/1_1.mp3
          print("🎵 [AudioService] Web URL: $webUrl");
          await _player.setAudioSource(AudioSource.uri(Uri.parse(webUrl)));
        } else if (url.startsWith('http://') || url.startsWith('https://')) {
          // External URLs
          await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
        } else {
          // Fallback: assume asset without prefix
          final webUrl = '/assets/$url';
          print("🎵 [AudioService] Web URL (fallback): $webUrl");
          await _player.setAudioSource(AudioSource.uri(Uri.parse(webUrl)));
        }
        
        _currentLoadedUrl = url;
        print("🎵 [AudioService] Audio source set");
      } else {
        print("🎵 [AudioService] Same URL already loaded, skipping setAudioSource");
      }
      
      print("🎵 [AudioService] Calling play()");
      await _player.play();
      print("🎵 [AudioService] Play() called successfully");
    } catch (e) {
      print("❌ [AudioService] Error: $e");
      print("❌ [AudioService] Attempted URL: $url");
    }
  }

  // 일시정지
  Future<void> pause() async {
    try {
      print("🎵 [AudioService] pause() called");
      await _player.pause();
      print("🎵 [AudioService] pause() successful");
    } catch (e) {
      print("⚠️ [AudioService] pause() error (ignored): $e");
      // Silently ignore - web platform may throw MissingPluginException
    }
  }

  // 재개 (resume)
  Future<void> resume() async {
    try {
      print("🎵 [AudioService] resume() called");
      await _player.play();
      print("🎵 [AudioService] resume() successful");
    } catch (e) {
      print("⚠️ [AudioService] resume() error (ignored): $e");
      // Silently ignore - web platform may throw MissingPluginException
    }
  }
  
  // Seek to position
  Future<void> seek(Duration position) async {
    try {
      print("🎵 [AudioService] seek() to $position");
      await _player.seek(position);
      print("🎵 [AudioService] seek() successful");
    } catch (e) {
      print("⚠️ [AudioService] seek() error (ignored): $e");
      // Silently ignore - web platform may throw MissingPluginException
    }
  }

  // 정지
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print("⚠️ [AudioService] stop() error (ignored): $e");
    }
  }

  // 볼륨 조절 (0.0 ~ 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume);
    } catch (e) {
      print("⚠️ [AudioService] setVolume() error (ignored): $e");
    }
  }
  
  @override
  void onClose() {
    try {
      _player.dispose();
    } catch (e) {
      print("⚠️ [AudioService] dispose() error (ignored): $e");
    }
    super.onClose();
  }
}
