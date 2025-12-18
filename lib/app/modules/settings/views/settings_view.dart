import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/pet_profile_service.dart';
import '../../../data/services/review_service.dart';
import '../../../data/services/coupon_service.dart';
import 'package:intl/intl.dart';
import '../controllers/settings_controller.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';
import 'package:petbeats/core/widgets/rainbow_gradient.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textDarkNavy, size: 20.w),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'settings_title'.tr,
          style: AppTextStyles.titleLarge.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRO 멤버십 관리 카드 (최상단)
            _buildMembershipCard(),
            SizedBox(height: 24.h),
            
            // 반려동물 프로필 섹션
            _buildSectionTitle('settings_profile'.tr),
            SizedBox(height: 12.h),
            _buildPetProfileCard(),
            SizedBox(height: 32.h),
            
            // 계정 섹션
            _buildSectionTitle('settings_account'.tr),
            SizedBox(height: 12.h),
            _buildAccountCard(),
            SizedBox(height: 32.h),
            
            // 볼륨 설정 섹션
            _buildSectionTitle('settings_volume'.tr),
            SizedBox(height: 12.h),
            _buildVolumeControls(),
            SizedBox(height: 32.h),
            
            // 언어 설정 섹션
            _buildSectionTitle('settings_language'.tr),
            SizedBox(height: 12.h),
            _buildLanguageSelector(),
            SizedBox(height: 32.h),
            
            // 데이터 접근 권한
            _buildSectionTitle('settings_data_permission'.tr),
            SizedBox(height: 8.h),
            Text(
              'settings_data_desc'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Obx(() => _buildPermissionTile(
              icon: Icons.location_on_outlined,
              title: 'settings_location'.tr,
              subtitle: 'settings_location_desc'.tr,
              value: controller.isLocationEnabled.value,
              onChanged: controller.toggleLocation,
            )),
            SizedBox(height: 12.h),
            Obx(() => _buildPermissionTile(
              icon: Icons.notifications_none_outlined,
              title: 'settings_notification'.tr,
              subtitle: 'settings_notification_desc'.tr,
              value: controller.isNotificationEnabled.value,
              onChanged: controller.toggleNotification,
            )),
            
            SizedBox(height: 32.h),
            
            // 앱 리뷰 섹션
            _buildReviewButton(),
            
            SizedBox(height: 48.h),
            Center(
              child: Text(
                'settings_version'.trParams({'version': '1.0.0'}),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey.withOpacity(0.5),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(
        fontSize: 16.sp,
        color: AppColors.textDarkNavy,
      ),
    );
  }

  /// 반려동물 프로필 카드
  Widget _buildPetProfileCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PET_PROFILE),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue.withOpacity(0.1),
              AppColors.primaryBlue.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
        ),
        child: Obx(() {
          final profile = Get.find<PetProfileService>().profile.value;
          final hasProfile = profile.hasProfile;
          
          return Row(
            children: [
              // 프로필 사진
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildPetPhoto(profile),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasProfile ? profile.name! : 'settings_register_profile'.tr,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.textDarkNavy,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      hasProfile 
                          ? '${profile.speciesKorean} • ${'pet_age_years'.trParams({'age': profile.age.toString()})}${profile.breed != null ? ' • ${profile.breed}' : ''}'
                          : 'settings_tap_to_register'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit, size: 20.w, color: AppColors.primaryBlue),
            ],
          );
        }),
      ),
    );
  }
  
  Widget _buildPetPhoto(PetProfile profile) {
    if (profile.photoPath != null && profile.photoPath!.startsWith('data:')) {
      // Base64 이미지
      final base64Data = profile.photoPath!.split(',').last;
      return Image.memory(
        base64Decode(base64Data),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultPetIcon(profile.species),
      );
    }
    return _buildDefaultPetIcon(profile.species);
  }
  
  Widget _buildDefaultPetIcon(String? species) {
    return Image.asset(
      species == 'cat' 
          ? 'assets/icons/icon_species_cat.png' 
          : 'assets/icons/icon_species_dog.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Icon(
        Icons.pets,
        size: 30.w,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildAccountCard() {
    final authService = Get.find<AuthService>();
    
    return GestureDetector(
      onTap: controller.handleLogin,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(() {
          final user = authService.currentUser.value;
          final isLoggedIn = user != null;
          
          return Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: isLoggedIn && user.photoURL != null
                    ? Image.network(user.photoURL!, fit: BoxFit.cover)
                    : Icon(Icons.person, color: Colors.white, size: 24.w),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoggedIn ? (user.displayName ?? 'settings_member'.tr) : 'settings_login_needed'.tr,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isLoggedIn ? (user.email ?? 'settings_logged_in'.tr) : 'settings_tap_to_login'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.w, color: AppColors.textGrey),
            ],
          );
        }),
      ),
    );
  }

  /// 볼륨 조절 위젯
  Widget _buildVolumeControls() {
    final storage = GetStorage();
    final musicVolume = (storage.read<double>('musicVolume') ?? 0.7).obs;
    final weatherVolume = (storage.read<double>('weatherVolume') ?? 0.5).obs;
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // 음악 볼륨
          _buildVolumeSlider(
            icon: Icons.music_note,
            label: 'settings_music_volume'.tr,
            volume: musicVolume,
            onChanged: (value) {
              musicVolume.value = value;
              storage.write('musicVolume', value);
            },
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.grey.shade200),
          SizedBox(height: 16.h),
          // 날씨 효과음 볼륨
          _buildVolumeSlider(
            icon: Icons.cloud,
            label: 'settings_weather_volume'.tr,
            volume: weatherVolume,
            onChanged: (value) {
              weatherVolume.value = value;
              storage.write('weatherVolume', value);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildVolumeSlider({
    required IconData icon,
    required String label,
    required RxDouble volume,
    required ValueChanged<double> onChanged,
  }) {
    return Obx(() => Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 24.w),
        SizedBox(width: 12.w),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Slider(
            value: volume.value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            inactiveColor: AppColors.primaryBlue.withOpacity(0.2),
          ),
        ),
        SizedBox(
          width: 40.w,
          child: Text(
            '${(volume.value * 100).toInt()}%',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
            ),
          ),
        ),
      ],
    ));
  }

  /// 지원 언어 목록 (ARPU 높은 시장 기준 10개)
  static const List<Map<String, String>> _supportedLanguages = [
    {'code': 'ko', 'flag': '🇰🇷', 'name': '한국어'},
    {'code': 'en', 'flag': '🇺🇸', 'name': 'English'},
    {'code': 'ja', 'flag': '🇯🇵', 'name': '日本語'},
    {'code': 'zh', 'flag': '🇨🇳', 'name': '中文 (简体)'},
    {'code': 'zh_TW', 'flag': '🇹🇼', 'name': '中文 (繁體)'},
    {'code': 'es', 'flag': '🇪🇸', 'name': 'Español'},
    {'code': 'fr', 'flag': '🇫🇷', 'name': 'Français'},
    {'code': 'de', 'flag': '🇩🇪', 'name': 'Deutsch'},
    {'code': 'pt', 'flag': '🇧🇷', 'name': 'Português'},
    {'code': 'it', 'flag': '🇮🇹', 'name': 'Italiano'},
  ];

  /// 언어 선택 위젯 (15개 언어)
  Widget _buildLanguageSelector() {
    final storage = GetStorage();
    final currentLocale = (storage.read<String>('locale') ?? 'ko').obs;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() {
        final current = _supportedLanguages.firstWhere(
          (l) => l['code'] == currentLocale.value,
          orElse: () => _supportedLanguages[0],
        );
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 선택된 언어
            GestureDetector(
              onTap: () => _showLanguageBottomSheet(currentLocale, storage),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Text(current['flag']!, style: TextStyle(fontSize: 24.sp)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        current['name']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textDarkNavy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: AppColors.primaryBlue, size: 28.w),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
  
  void _showLanguageBottomSheet(RxString currentLocale, GetStorage storage) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들바
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'settings_language_select'.tr,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 18.sp),
              ),
            ),
            SizedBox(height: 16.h),
            // 언어 목록
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _supportedLanguages.length,
                itemBuilder: (context, index) {
                  final lang = _supportedLanguages[index];
                  final isSelected = currentLocale.value == lang['code'];
                  
                  return ListTile(
                    leading: Text(lang['flag']!, style: TextStyle(fontSize: 28.sp)),
                    title: Text(
                      lang['name']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? AppColors.primaryBlue : AppColors.textDarkNavy,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected 
                        ? Icon(Icons.check_circle, color: AppColors.primaryBlue)
                        : null,
                    onTap: () {
                      currentLocale.value = lang['code']!;
                      storage.write('locale', lang['code']);
                      
                      // Locale 업데이트
                      final parts = lang['code']!.split('_');
                      Get.updateLocale(Locale(parts[0], parts.length > 1 ? parts[1] : ''));
                      
                      // Refresh Home Controller Data
                      try {
                         if (Get.isRegistered<HomeController>()) {
                           Get.find<HomeController>().refreshLocalizedData();
                         }
                      } catch (e) {
                        print('Error refreshing home data: $e');
                      }
                      
                      Get.back();
                      Get.snackbar(
                        'settings_language_changed_title'.tr,
                        'settings_language_changed'.trParams({'lang': lang['name']!}),
                        backgroundColor: Colors.green.shade100,
                        colorText: Colors.green.shade800,
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption({
    required String code,
    required String label,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(flag, style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 8.w),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.textGrey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  /// 앱 리뷰 버튼
  Widget _buildReviewButton() {
    return GestureDetector(
      onTap: () async {
        try {
          final reviewService = Get.find<ReviewService>();
          await reviewService.forceRequestReview();
        } catch (e) {
          debugPrint('Error requesting review: $e');
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade400,
              Colors.orange.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'review_settings_title'.tr,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'review_settings_desc'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.8),
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  /// PRO 멤버십 관리 카드
  Widget _buildMembershipCard() {
    try {
      final couponService = Get.find<CouponService>();
      
      return Obx(() {
        final isPro = couponService.isPro;
        final expiryDate = couponService.proExpiryDate.value;
        final remainingDays = couponService.proRemainingDays;
        
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.COUPON),
          child: AnimatedRainbowGradient(
            duration: const Duration(seconds: 4),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // 아이콘
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      isPro ? Icons.workspace_premium : Icons.card_giftcard,
                      color: Colors.white,
                      size: 28.w,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  
                  // 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'coupon_settings_title'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isPro) ...[
                              SizedBox(width: 8.w),
                              const RainbowProBadge(),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          isPro && expiryDate != null
                              ? 'coupon_days_remaining'.trParams({'days': remainingDays.toString()})
                              : 'coupon_settings_desc'.tr,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 화살표
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 16.w,
                  ),
                ],
              ),
            ),
          ),
        );
      });
    } catch (e) {
      // CouponService가 없는 경우 기본 UI
      return GestureDetector(
        onTap: () => Get.toNamed(Routes.COUPON),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.primaryBlue.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(Icons.card_giftcard, color: Colors.white, size: 28.w),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  'coupon_settings_title'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16.w),
            ],
          ),
        ),
      );
    }
  }
}
