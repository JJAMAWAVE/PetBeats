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
  
  // 보상 티어 설정
  static const int tier1Goal = 1;  // 1명 초대 → 7일
  static const int tier2Goal = 3;  // 3명 초대 → 21일
  static const int tier3Goal = 5;  // 5명 초대 → 30일
  
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
  void onFriendJoined() {
    friendsJoined.value++;
    _storage.write(_friendsJoinedKey, friendsJoined.value);
    
    debugPrint('📨 [InviteController] Friend joined! Total: ${friendsJoined.value}');
    
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
      return 7;
    } else if (friendsJoined.value < tier2Goal) {
      return 21;
    } else if (friendsJoined.value < tier3Goal) {
      return 30;
    }
    return 0;
  }
  
  /// 모든 티어 달성 여부
  bool get allTiersCompleted => 
      tier1Rewarded.value && tier2Rewarded.value && tier3Rewarded.value;
  
  Future<void> shareInvite() async {
    try {
      // TODO: Firebase Dynamic Links로 실제 초대 링크 생성
      final inviteCode = 'PETBEATS${DateTime.now().millisecondsSinceEpoch % 100000}';
      final inviteLink = 'https://petbeats.app/invite?code=$inviteCode';
      
      final message = '''
🐾 PetBeats - ${'invite_share_message'.tr}

${'invite_share_benefit'.tr}

$inviteLink

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
  
  /// 테스트용: 친구 추가 시뮬레이션
  void simulateFriendJoin() {
    onFriendJoined();
    Get.snackbar(
      '🧪 테스트',
      '친구 1명이 가입했습니다! (총 ${friendsJoined.value}명)',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade800,
    );
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
