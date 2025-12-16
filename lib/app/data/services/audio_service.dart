import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioService extends GetxService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentLoadedUrl; // Track the currently loaded URL
  Duration _savedPosition = Duration.zero;  // Store position before pause (WEB FIX)

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
  
  // Player state stream (곡 완료 감지용)
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  
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
        _savedPosition = Duration.zero;  // Reset saved position for new track
        
        // Use AudioSource.asset() for ALL platforms (web + native)
        if (url.startsWith('assets/')) {
          print("🎵 [AudioService] Loading asset: $url");
          try {
            await _player.setAudioSource(AudioSource.asset(url));
            print("🎵 [AudioService] Asset loaded successfully");
          } catch (e) {
            print("❌ [AudioService] Asset loading failed: $e");
            rethrow;
          }
        } else if (url.startsWith('http://') || url.startsWith('https://')) {
          // External URLs
          print("🎵 [AudioService] Loading external URL: $url");
          await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
        } else {
          // Fallback: assume asset without prefix
          final assetPath = 'assets/$url';
          print("🎵 [AudioService] Loading asset (fallback): $assetPath");
          await _player.setAudioSource(AudioSource.asset(assetPath));
        }
        
        _currentLoadedUrl = url;
        print("🎵 [AudioService] Audio source set");
      } else {
        print("🎵 [AudioService] Same URL already loaded, skipping setAudioSource");
      }
      
      print("🎵 [AudioService] Calling play()");
      await _player.play();
      print("🎵 [AudioService] Play() called successfully");
    } catch (e, stackTrace) {
      print("❌ [AudioService] Error: $e");
      print("❌ [AudioService] Stack trace: $stackTrace");
      print("❌ [AudioService] Attempted URL: $url");
    }
  }

  // 일시정지 - WEB FIX: 위치 저장 후 pause
  Future<void> pause() async {
    try {
      // Save current position BEFORE pausing (WEB FIX)
      _savedPosition = _player.position;
      print("🎵 [AudioService] pause() - saved position: $_savedPosition");
      
      await _player.pause();
      print("🎵 [AudioService] pause() successful");
    } catch (e) {
      print("⚠️ [AudioService] pause() error (ignored): $e");
    }
  }

  // 재개 - WEB FIX: 저장된 위치로 seek 후 play
  Future<void> resume() async {
    try {
      print("🎵 [AudioService] resume() - restoring position: $_savedPosition");
      
      // Restore position before playing (WEB FIX)
      if (_savedPosition > Duration.zero) {
        await _player.seek(_savedPosition);
        print("🎵 [AudioService] resume() - seek completed");
      }
      
      await _player.play();
      print("🎵 [AudioService] resume() successful");
    } catch (e) {
      print("⚠️ [AudioService] resume() error (ignored): $e");
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
      _currentLoadedUrl = null;  // Reset so next play() reloads audio
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
  
  // 루프 모드 설정
  Future<void> setLoopMode(bool enabled, {bool singleTrack = true}) async {
    try {
      if (!enabled) {
        await _player.setLoopMode(LoopMode.off);
        print("🔁 [AudioService] Loop mode: Off");
      } else if (singleTrack) {
        await _player.setLoopMode(LoopMode.one);
        print("🔁 [AudioService] Loop mode: Single track");
      } else {
        await _player.setLoopMode(LoopMode.all);
        print("🔁 [AudioService] Loop mode: All");
      }
    } catch (e) {
      print("⚠️ [AudioService] setLoopMode() error (ignored): $e");
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
