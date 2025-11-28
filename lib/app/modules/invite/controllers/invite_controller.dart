import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/services/haptic_service.dart';

class InviteController extends GetxController {
  // 진행 상황
  final friendsJoined = 0.obs;
  final totalFriendsNeeded = 3;
  
  // 보상 티어
  final tier1Reached = false.obs;
  final tier2Reached = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadProgress();
  }
  
  void _loadProgress() {
    // TODO: 실제 진행 상황 로드 (SharedPreferences 또는 서버에서)
    // friendsJoined.value = ...;
    _checkTierProgress();
  }
  
  void _checkTierProgress() {
    tier1Reached.value = friendsJoined.value >= 1;
    tier2Reached.value = friendsJoined.value >= 3;
  }
  
  Future<void> shareInvite() async {
    try {
      // TODO: 실제 초대 링크 생성 로직
      final inviteCode = 'PETBEATS${DateTime.now().millisecondsSinceEpoch % 100000}';
      final inviteLink = 'https://petbeats.app/invite?code=$inviteCode';
      
      final message = '''
🐾 PetBeats에서 반려동물을 위한 평온한 음악을 함께 들어요!

친구 초대 링크를 통해 가입하시면 특별 혜택이 제공됩니다.

$inviteLink

- 과학적으로 검증된 반려동물 전용 음악
- 수면 유도, 분리불안 완화
- 맞춤형 사운드 케어

함께 반려동물의 행복을 지켜요! 💙
''';
      
      await Share.share(
        message,
        subject: 'PetBeats 초대',
      );
      
      Get.find<HapticService>().lightImpact();
    } catch (e) {
      print('Error sharing invite: $e');
      Get.snackbar(
        '공유 실패',
        '초대 링크를 공유하는 중 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // 테스트용 메서드 (나중에 제거)
  void addFriend() {
    if (friendsJoined.value < totalFriendsNeeded) {
      friendsJoined.value++;
      _checkTierProgress();
    }
  }
}
