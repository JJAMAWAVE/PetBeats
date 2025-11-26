import 'bgm_service.dart';

/// 모바일 플랫폼을 위한 WebBgmService 어댑터
/// (이름은 WebBgmService지만 실제로는 BgmService를 래핑하여 모바일에서 동작)
class WebBgmService {
  static final WebBgmService _instance = WebBgmService._internal();
  factory WebBgmService() => _instance;
  WebBgmService._internal();

  final BgmService _bgmService = BgmService();

  Future<void> init() async {
    await _bgmService.init();
  }

  Future<void> play() async {
    await _bgmService.play();
  }

  Future<void> pause() async {
    await _bgmService.pause();
  }

  Future<void> resume() async {
    await _bgmService.resume();
  }

  Future<void> setVolume(double volume) async {
    await _bgmService.setVolume(volume);
  }

  Future<void> dispose() async {
    await _bgmService.dispose();
  }
}
