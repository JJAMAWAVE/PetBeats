import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

/// 쿠폰 모델
class Coupon {
  final String code;
  final String type; // 'pro_days', 'pro_month', 'discount'
  final int value; // days or percentage
  final String description;
  final DateTime? expiryDate;
  final DateTime registeredAt;
  final bool isUsed;

  Coupon({
    required this.code,
    required this.type,
    required this.value,
    required this.description,
    this.expiryDate,
    required this.registeredAt,
    this.isUsed = false,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'type': type,
    'value': value,
    'description': description,
    'expiryDate': expiryDate?.millisecondsSinceEpoch,
    'registeredAt': registeredAt.millisecondsSinceEpoch,
    'isUsed': isUsed,
  };

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    code: json['code'] ?? '',
    type: json['type'] ?? 'pro_days',
    value: json['value'] ?? 0,
    description: json['description'] ?? '',
    expiryDate: json['expiryDate'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(json['expiryDate']) 
        : null,
    registeredAt: DateTime.fromMillisecondsSinceEpoch(json['registeredAt'] ?? 0),
    isUsed: json['isUsed'] ?? false,
  );
}

/// 쿠폰/구독 권한 관리 서비스
class CouponService extends GetxService {
  final _storage = GetStorage();
  
  // Storage Keys
  static const String _proExpiryKey = 'pro_expiry_date';
  static const String _registeredCouponsKey = 'registered_coupons';
  static const String _pendingCouponsKey = 'pending_coupons';
  
  // Observable States
  final Rx<DateTime?> proExpiryDate = Rx<DateTime?>(null);
  final RxList<Coupon> registeredCoupons = <Coupon>[].obs;
  final RxList<Coupon> pendingCoupons = <Coupon>[].obs; // 미확인 쿠폰
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  /// 초기 데이터 로드
  void _loadData() {
    // PRO 만료일 로드
    final expiryMs = _storage.read<int>(_proExpiryKey);
    if (expiryMs != null) {
      proExpiryDate.value = DateTime.fromMillisecondsSinceEpoch(expiryMs);
    }
    
    // 등록된 쿠폰 내역 로드
    final couponsJson = _storage.read<List>(_registeredCouponsKey);
    if (couponsJson != null) {
      registeredCoupons.value = couponsJson
          .map((e) => Coupon.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    
    // 미확인 쿠폰 로드
    final pendingJson = _storage.read<List>(_pendingCouponsKey);
    if (pendingJson != null) {
      pendingCoupons.value = pendingJson
          .map((e) => Coupon.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    
    debugPrint('🎫 [CouponService] Loaded ${registeredCoupons.length} coupons, PRO until: ${proExpiryDate.value}');
  }

  /// PRO 유저인지 확인
  bool get isPro {
    if (proExpiryDate.value == null) return false;
    return proExpiryDate.value!.isAfter(DateTime.now());
  }

  /// PRO 남은 일수
  int get proRemainingDays {
    if (proExpiryDate.value == null) return 0;
    final diff = proExpiryDate.value!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  /// 쿠폰 코드 검증 및 등록
  Future<CouponResult> registerCoupon(String code) async {
    isLoading.value = true;
    
    try {
      // 코드 정규화
      final normalizedCode = code.trim().toUpperCase();
      
      // 이미 등록된 쿠폰인지 확인
      if (registeredCoupons.any((c) => c.code == normalizedCode)) {
        isLoading.value = false;
        return CouponResult(
          success: false,
          message: 'coupon_already_used'.tr,
        );
      }
      
      // TODO: Firebase에서 쿠폰 유효성 검증
      // 현재는 로컬 시뮬레이션
      final couponData = await _validateCouponCode(normalizedCode);
      
      if (couponData == null) {
        isLoading.value = false;
        return CouponResult(
          success: false,
          message: 'coupon_invalid'.tr,
        );
      }
      
      // 쿠폰 적용
      final coupon = Coupon(
        code: normalizedCode,
        type: couponData['type'],
        value: couponData['value'],
        description: couponData['description'],
        registeredAt: DateTime.now(),
      );
      
      // PRO 기간 연장
      _extendProPeriod(coupon);
      
      // 등록 내역에 추가
      registeredCoupons.insert(0, coupon);
      _saveCoupons();
      
      isLoading.value = false;
      
      // 성공 토스트
      Get.snackbar(
        'coupon_success_title'.tr,
        'coupon_success_desc'.trParams({'days': coupon.value.toString()}),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.celebration, color: Colors.green),
      );
      
      return CouponResult(
        success: true,
        message: 'coupon_success_desc'.trParams({'days': coupon.value.toString()}),
        coupon: coupon,
      );
    } catch (e) {
      isLoading.value = false;
      debugPrint('🎫 [CouponService] Error registering coupon: $e');
      return CouponResult(
        success: false,
        message: 'coupon_error'.tr,
      );
    }
  }

  /// 쿠폰 코드 검증 (Firebase 연동 전 시뮬레이션)
  Future<Map<String, dynamic>?> _validateCouponCode(String code) async {
    // 시뮬레이션 딜레이
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 테스트 쿠폰 코드들 (나중에 Firebase로 대체)
    final testCoupons = {
      'LAUNCH2024': {'type': 'pro_days', 'value': 30, 'description': 'coupon_launch_event'.tr},
      'FRIEND7': {'type': 'pro_days', 'value': 7, 'description': 'coupon_friend_invite'.tr},
      'FRIEND21': {'type': 'pro_days', 'value': 21, 'description': 'coupon_friend_3'.tr},
      'WELCOME': {'type': 'pro_days', 'value': 7, 'description': 'coupon_welcome'.tr},
      'TEST30': {'type': 'pro_days', 'value': 30, 'description': 'coupon_test'.tr},
    };
    
    return testCoupons[code];
  }

  /// PRO 기간 연장
  void _extendProPeriod(Coupon coupon) {
    final now = DateTime.now();
    DateTime baseDate;
    
    if (proExpiryDate.value != null && proExpiryDate.value!.isAfter(now)) {
      // 이미 PRO인 경우 만료일에서 추가
      baseDate = proExpiryDate.value!;
    } else {
      // 무료 유저인 경우 오늘부터
      baseDate = now;
    }
    
    // 일수 추가
    final newExpiry = baseDate.add(Duration(days: coupon.value));
    proExpiryDate.value = newExpiry;
    
    // 저장
    _storage.write(_proExpiryKey, newExpiry.millisecondsSinceEpoch);
    
    debugPrint('🎫 [CouponService] PRO extended until: $newExpiry');
  }

  /// 친구 초대 보상 쿠폰 자동 발급
  void grantReferralReward(int friendCount) {
    String? couponCode;
    String? description;
    int? days;
    
    if (friendCount == 1) {
      couponCode = 'REF_${DateTime.now().millisecondsSinceEpoch}_1';
      description = 'coupon_friend_invite'.tr;
      days = 7;
    } else if (friendCount == 3) {
      couponCode = 'REF_${DateTime.now().millisecondsSinceEpoch}_3';
      description = 'coupon_friend_3'.tr;
      days = 21; // 3주
    } else if (friendCount == 5) {
      couponCode = 'REF_${DateTime.now().millisecondsSinceEpoch}_5';
      description = 'coupon_friend_5'.tr;
      days = 30; // 1개월
    }
    
    if (couponCode != null && days != null) {
      final coupon = Coupon(
        code: couponCode,
        type: 'pro_days',
        value: days,
        description: description ?? '',
        registeredAt: DateTime.now(),
      );
      
      // 자동 적용
      _extendProPeriod(coupon);
      registeredCoupons.insert(0, coupon);
      _saveCoupons();
      
      // 축하 토스트
      Get.snackbar(
        '🎉 ${'coupon_reward_title'.tr}',
        'coupon_reward_desc'.trParams({'days': days.toString()}),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.amber.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.card_giftcard, color: Colors.amber),
      );
      
      debugPrint('🎫 [CouponService] Referral reward granted: $days days');
    }
  }

  /// 쿠폰 저장
  void _saveCoupons() {
    _storage.write(
      _registeredCouponsKey,
      registeredCoupons.map((c) => c.toJson()).toList(),
    );
  }

  /// 테스트용: 초기화
  void resetAll() {
    proExpiryDate.value = null;
    registeredCoupons.clear();
    pendingCoupons.clear();
    _storage.remove(_proExpiryKey);
    _storage.remove(_registeredCouponsKey);
    _storage.remove(_pendingCouponsKey);
    debugPrint('🎫 [CouponService] All data reset');
  }
}

/// 쿠폰 등록 결과
class CouponResult {
  final bool success;
  final String message;
  final Coupon? coupon;

  CouponResult({
    required this.success,
    required this.message,
    this.coupon,
  });
}
