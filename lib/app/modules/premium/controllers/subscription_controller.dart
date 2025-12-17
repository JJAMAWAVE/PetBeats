import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../home/controllers/home_controller.dart';

enum SubscriptionPlan {
  monthly,
  quarterly,
  halfYearly,
  yearly,
}

class SubscriptionController extends GetxController {
  final isPremium = false.obs;
  final isLoading = false.obs;
  final selectedPlan = SubscriptionPlan.yearly.obs;
  final _storage = GetStorage();
  
  // RevenueCat 설정
  static const _revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY_HERE';
  
  @override
  void onInit() {
    super.onInit();
    _configureRevenueCat();
    _checkSubscriptionStatus();
  }
  
  Future<void> _configureRevenueCat() async {
    try {
      if (_revenueCatApiKey == 'YOUR_REVENUECAT_API_KEY_HERE') {
        print('⚠️ RevenueCat API Key not set. Using Simulation Mode.');
        return;
      }
      
      await Purchases.setLogLevel(LogLevel.debug);
      
      final configuration = PurchasesConfiguration(_revenueCatApiKey);
      await Purchases.configure(configuration);
      
      print('✅ RevenueCat configured successfully');
    } catch (e) {
      print('❌ RevenueCat configuration error: $e');
    }
  }
  
  void selectPlan(SubscriptionPlan plan) {
    selectedPlan.value = plan;
  }
  
  Future<void> _checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      
      // 'premium' entitlement가 활성화되어 있는지 확인
      isPremium.value = customerInfo.entitlements.active.containsKey('premium');
      
      // 로컬 저장소에도 동기화
      _storage.write('isPremium', isPremium.value);
      
      if (isPremium.value) {
        print('✅ User is Premium');
      } else {
        print('ℹ️ User is Free');
      }
    } catch (e) {
      print('❌ Error checking subscription: $e');
      // 오프라인 시 로컬 캐시 사용
      isPremium.value = _storage.read('isPremium') ?? false;
    }
  }
  
  Future<void> startFreeTrial() async {
    try {
      isLoading.value = true;
      
      // Simulation Mode Check
      if (_revenueCatApiKey == 'YOUR_REVENUECAT_API_KEY_HERE') {
        await Future.delayed(const Duration(seconds: 2)); // Simulate network
        await _handlePurchaseSuccess();
        return;
      }

      // 1. Offerings 가져오기
      final offerings = await Purchases.getOfferings();
      
      if (offerings.current == null) {
        throw 'No active offerings found';
      }
      
      // 2. 선택된 플랜에 맞는 Package 가져오기
      final package = _getPackageFromOffering(offerings.current!);
      
      if (package == null) {
        throw 'No package found for selected plan';
      }
      
      // 3. 구매 처리
      final customerInfo = await Purchases.purchasePackage(package);
      
      // 4. 구매 성공 처리
      if (customerInfo.entitlements.active.containsKey('premium')) {
        await _handlePurchaseSuccess();
      } else {
        throw 'Purchase completed but premium not activated';
      }
      
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        print('ℹ️ User cancelled purchase');
      } else if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        Get.snackbar(
          'premium_already_subscribed_title'.tr,
          'premium_already_subscribed_desc'.tr,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          'premium_error_desc'.trParams({'message': e.message ?? 'Unknown error'}),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'premium_error_general'.tr,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Package? _getPackageFromOffering(Offering offering) {
    switch (selectedPlan.value) {
      case SubscriptionPlan.monthly:
        return offering.monthly;
      case SubscriptionPlan.quarterly:
        return offering.threeMonth;
      case SubscriptionPlan.halfYearly:
        return offering.sixMonth;
      case SubscriptionPlan.yearly:
        return offering.annual;
    }
  }
  
  Future<void> _handlePurchaseSuccess() async {
    // 1. Premium 상태 업데이트
    isPremium.value = true;
    
    // 2. GetStorage에 저장 (오프라인 캐시용)
    _storage.write('isPremium', true);
    _storage.write('subscriptionPlan', selectedPlan.value.toString());
    _storage.write('subscriptionDate', DateTime.now().toIso8601String());
    
    // 3. HomeController의 isPremiumUser도 동기화
    try {
      final homeController = Get.find<HomeController>();
      homeController.upgradeToPremium();
    } catch (e) {
      print('HomeController not found: $e');
    }
    
    // 4. 성공 메시지
    Get.back(); // 구독 페이지 닫기
    Get.snackbar(
      'premium_success_title'.tr,
      'premium_success_desc'.tr,
      backgroundColor: AppColors.successMintSoft,
      colorText: AppColors.textDarkNavy,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(Icons.check_circle, color: Colors.green.shade600),
    );
  }
  
  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      
      // RevenueCat에서 구독 복원
      final customerInfo = await Purchases.restorePurchases();
      
      // Premium 상태 확인
      final wasPremium = customerInfo.entitlements.active.containsKey('premium');
      
      if (wasPremium) {
        isPremium.value = true;
        _storage.write('isPremium', true);
        
        Get.snackbar(
          'premium_restore_success'.tr,
          'premium_restore_desc'.tr,
          backgroundColor: AppColors.successMintSoft,
          colorText: AppColors.textDarkNavy,
        );
      } else {
        Get.snackbar(
          'premium_restore_fail'.tr,
          'premium_restore_fail_desc'.tr,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
      }
      
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'premium_restore_error'.trParams({'error': e.toString()}),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  String getPlanPrice() {
    switch (selectedPlan.value) {
      case SubscriptionPlan.monthly:
        return '₩3,900';
      case SubscriptionPlan.quarterly:
        return '₩10,900';
      case SubscriptionPlan.halfYearly:
        return '₩19,900';
      case SubscriptionPlan.yearly:
        return '₩33,000';
    }
  }
  
  String getPlanTitle() {
    switch (selectedPlan.value) {
      case SubscriptionPlan.monthly:
        return '1${'month'.tr}';
      case SubscriptionPlan.quarterly:
        return '3${'month'.tr}';
      case SubscriptionPlan.halfYearly:
        return '6${'month'.tr}';
      case SubscriptionPlan.yearly:
        return '1${'year'.tr}';
    }
  }
  
  String getPlanProductId() {
    switch (selectedPlan.value) {
      case SubscriptionPlan.monthly:
        return 'petbeats_monthly';
      case SubscriptionPlan.quarterly:
        return 'petbeats_quarterly';
      case SubscriptionPlan.halfYearly:
        return 'petbeats_halfyearly';
      case SubscriptionPlan.yearly:
        return 'petbeats_yearly';
    }
  }
}
