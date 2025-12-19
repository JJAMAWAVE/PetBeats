import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/coupon_service.dart';

class InviteController extends GetxController {
  final _storage = GetStorage();
  
  // Storage Keys
  static const String _friendsJoinedKey = 'invite_friends_joined';
  static const String _tier1RewardedKey = 'invite_tier1_rewarded';
  static const String _tier2RewardedKey = 'invite_tier2_rewarded';
  static const String _tier3RewardedKey = 'invite_tier3_rewarded';
  
  // 진행 상황
  final friendsJoined = 0.obs;
  
  // 보상 티어 설정 (1명→7일, 3명→7일, 5명→21일)
  static const int tier1Goal = 1;  // 1명 초대 → 7일
  static const int tier2Goal = 3;  // 3명 초대 → 7일 (추가)
  static const int tier3Goal = 5;  // 5명 초대 → 21일 (추가)
  
  // 보상 지급 여부
  final tier1Rewarded = false.obs;
  final tier2Rewarded = false.obs;
  final tier3Rewarded = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadProgress();
  }
  
  void _loadProgress() {
    // 저장된 진행 상황 로드
    friendsJoined.value = _storage.read<int>(_friendsJoinedKey) ?? 0;
    tier1Rewarded.value = _storage.read<bool>(_tier1RewardedKey) ?? false;
    tier2Rewarded.value = _storage.read<bool>(_tier2RewardedKey) ?? false;
    tier3Rewarded.value = _storage.read<bool>(_tier3RewardedKey) ?? false;
    
    debugPrint('📨 [InviteController] Loaded: ${friendsJoined.value} friends joined');
  }
  
  /// 친구 가입 성공 처리 (딥링크 콜백에서 호출)
  void onFriendJoined({bool showNotification = true}) {
    friendsJoined.value++;
    _storage.write(_friendsJoinedKey, friendsJoined.value);
    
    debugPrint('📨 [InviteController] Friend joined! Total: ${friendsJoined.value}');
    
    // 친구 가입 알림 표시
    if (showNotification) {
      Get.snackbar(
        '🎉 ${'invite_friend_joined_title'.tr}',
        'invite_friend_joined_desc'.trParams({
          'count': friendsJoined.value.toString(),
        }),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 2),
      );
    }
    
    // 티어별 보상 체크
    _checkAndGrantRewards();
  }
  
  /// 보상 체크 및 지급
  void _checkAndGrantRewards() {
    try {
      final couponService = Get.find<CouponService>();
      
      // Tier 1: 1명 달성
      if (friendsJoined.value >= tier1Goal && !tier1Rewarded.value) {
        tier1Rewarded.value = true;
        _storage.write(_tier1RewardedKey, true);
        couponService.grantReferralReward(1);
        debugPrint('📨 [InviteController] Tier 1 reward granted!');
      }
      
      // Tier 2: 3명 달성
      if (friendsJoined.value >= tier2Goal && !tier2Rewarded.value) {
        tier2Rewarded.value = true;
        _storage.write(_tier2RewardedKey, true);
        couponService.grantReferralReward(3);
        debugPrint('📨 [InviteController] Tier 2 reward granted!');
      }
      
      // Tier 3: 5명 달성
      if (friendsJoined.value >= tier3Goal && !tier3Rewarded.value) {
        tier3Rewarded.value = true;
        _storage.write(_tier3RewardedKey, true);
        couponService.grantReferralReward(5);
        debugPrint('📨 [InviteController] Tier 3 reward granted!');
      }
    } catch (e) {
      debugPrint('📨 [InviteController] Error granting reward: $e');
    }
  }
  
  /// 다음 티어까지 남은 친구 수
  int get friendsUntilNextReward {
    if (friendsJoined.value < tier1Goal) {
      return tier1Goal - friendsJoined.value;
    } else if (friendsJoined.value < tier2Goal) {
      return tier2Goal - friendsJoined.value;
    } else if (friendsJoined.value < tier3Goal) {
      return tier3Goal - friendsJoined.value;
    }
    return 0;
  }
  
  /// 다음 보상 일수
  int get nextRewardDays {
    if (friendsJoined.value < tier1Goal) {
      return 7;  // 1명 → 7일
    } else if (friendsJoined.value < tier2Goal) {
      return 7;  // 3명 → 7일
    } else if (friendsJoined.value < tier3Goal) {
      return 21;  // 5명 → 21일
    }
    return 0;
  }
  
  /// 모든 티어 달성 여부
  bool get allTiersCompleted => 
      tier1Rewarded.value && tier2Rewarded.value && tier3Rewarded.value;
  
  /// 내 초대 코드 (사용자별 고유)
  String get myInviteCode {
    // 저장된 코드가 있으면 사용
    final savedCode = _storage.read<String>('my_invite_code');
    if (savedCode != null) return savedCode;
    
    // 없으면 새로 생성 (타임스탬프 기반)
    final code = 'PB${DateTime.now().millisecondsSinceEpoch % 100000}';
    _storage.write('my_invite_code', code);
    return code;
  }
  
  Future<void> shareInvite() async {
    try {
      // 앱 다운로드 링크 (Play Store / App Store)
      const playStoreLink = 'https://play.google.com/store/apps/details?id=com.resonancespace.petbeats';
      
      final message = '''
🐾 PetBeats - ${'invite_share_message'.tr}

${'invite_share_benefit'.tr}

📲 다운로드: $playStoreLink

✨ ${'invite_share_features'.tr}
''';
      
      await Share.share(
        message,
        subject: 'PetBeats ${'invite_share_subject'.tr}',
      );
      
      try {
        Get.find<HapticService>().lightImpact();
      } catch (_) {}
    } catch (e) {
      debugPrint('Error sharing invite: $e');
      Get.snackbar(
        'invite_share_error_title'.tr,
        'invite_share_error_desc'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }
  
  /// 테스트용: 친구 추가 시뮬레이션 (실제 알림과 동일하게 표시)
  void simulateFriendJoin() {
    onFriendJoined(showNotification: true); // 실제 알림과 동일
  }
  
  /// 테스트용: 진행 상황 초기화
  void resetProgress() {
    friendsJoined.value = 0;
    tier1Rewarded.value = false;
    tier2Rewarded.value = false;
    tier3Rewarded.value = false;
    _storage.remove(_friendsJoinedKey);
    _storage.remove(_tier1RewardedKey);
    _storage.remove(_tier2RewardedKey);
    _storage.remove(_tier3RewardedKey);
    debugPrint('📨 [InviteController] Progress reset');
  }
}
