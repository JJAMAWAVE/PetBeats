import 'package:get/get.dart';
import '../../data/services/audio_service.dart';
import '../../data/services/haptic_service.dart';

class HomeController extends GetxController {
  final AudioService _audioService = Get.put(AudioService());
  final HapticService _hapticService = Get.put(HapticService());

  // 현재 선택된 종 (0: 강아지, 1: 고양이, 2: 보호자)
  final selectedSpeciesIndex = 0.obs;

  // 현재 재생 중인지 여부
  final isPlaying = false.obs;

  // 현재 선택된 모드 이름
  final currentModeName = ''.obs;
  
  // 하트비트 싱크 활성화 여부
  final isHeartbeatSyncEnabled = true.obs;

  // 프리미엄 유저 여부
  final isPremiumUser = false.obs;

  // 테스트용 오디오 URL (저작권 없는 무료 음원)
  final String _testAudioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

  // 종 변경
  void changeSpecies(int index) {
    selectedSpeciesIndex.value = index;
  }

  // 프리미엄 업그레이드
  void upgradeToPremium() {
    isPremiumUser.value = true;
  }

  // 모드 선택 및 상세 화면 이동
  void selectMode(String modeName) {
    currentModeName.value = modeName;
    Get.toNamed('/mode_detail', arguments: {'modeName': modeName});
  }

  // 재생 토글
  void togglePlay() {
    isPlaying.value = !isPlaying.value;

    if (isPlaying.value) {
      // 재생 시작
      _audioService.play(_testAudioUrl);
      
      if (isHeartbeatSyncEnabled.value) {
        // 60 BPM 심박수 진동 시작
        _hapticService.startHeartbeat(60);
      }
    } else {
      // 일시정지
      _audioService.pause();
      _hapticService.stop();
    }
  }
  
  // 하트비트 싱크 토글
  void toggleHeartbeatSync(bool value) {
    isHeartbeatSyncEnabled.value = value;
    if (isPlaying.value) {
      if (value) {
        _hapticService.startHeartbeat(60);
      } else {
        _hapticService.stop();
      }
    }
  }
}
