import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/species_theme_transition.dart';
import '../controllers/home_controller.dart';
import '../widgets/premium_mode_button.dart';
import '../widgets/species_toggle.dart';
import '../widgets/mini_player.dart';
import '../widgets/heartbeat_text.dart';
import '../widgets/header_icon_button.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../../../../app/data/services/haptic_service.dart';
import '../../settings/views/settings_view.dart';
import 'mode_detail_view.dart';
import 'health_activity_detail_view.dart';
import 'app_info_view.dart';
import '../../../../app/data/services/daily_routine_service.dart';
import '../../../routes/app_routes.dart';
import '../widgets/ai_special_mode_widget.dart';
import '../../premium/controllers/subscription_controller.dart';
import '../controllers/smart_care_controller.dart';
// Bento Style Widgets
import 'package:petbeats/core/widgets/bento_card.dart';
import 'package:petbeats/core/widgets/elastic_scale_button.dart';
import 'package:petbeats/core/widgets/mode_animator.dart';
import 'package:petbeats/core/widgets/staggered_slide_in.dart';
import 'package:petbeats/core/widgets/animated_gradient_border.dart';
import '../widgets/debug_bottom_sheet.dart';
import '../../../../app/data/services/pet_profile_service.dart';
import 'dart:convert';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final hapticService = Get.find<HapticService>();
    return Obx(() => SpeciesThemeTransition(
      theme: controller.currentSpeciesTheme.value,
      child: Scaffold(
        backgroundColor: Colors.transparent, // Ripple 애니메이션이 보이도록 투명 처리
        body: BackgroundDecoration(
          child: SafeArea(
            child: Stack(
              children: [
                // Fixed Layout Container
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header with Staggered Animation
                    StaggeredSlideIn(
                      index: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const HeartbeatText('PetBeats', fontSize: 28), // 폰트 사이즈 키움
                            Row(
                              children: [
                                // 디버그 패널 (DEV ONLY) - 스타일 통일
                                GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                      const DebugBottomSheet(),
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: Container(
                                    width: 40, // 36 -> 40 (터치 영역 확대)
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.bug_report_rounded, // Rounded 아이콘
                                      color: Colors.orange,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12), // 간격 8 -> 12
                                // 친구 초대 아이콘
                                HeaderIconButton(
                                  iconPath: 'assets/icons/icon_nav_notification.png',
                                  animationType: HeaderIconAnimationType.shake,
                                  onTap: () {
                                    Get.toNamed(Routes.INVITE_FRIENDS);
                                  },
                                ),
                                const SizedBox(width: 12), // 간격 8 -> 12
                                HeaderIconButton(
                                  iconPath: 'assets/icons/icon_nav_settings.png',
                                  animationType: HeaderIconAnimationType.rotate,
                                  onTap: () {
                                    Get.toNamed(Routes.SETTINGS);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12), // Header bottom spacing
                    
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                    
                    // Pet Profile Mini Bar
                    StaggeredSlideIn(
                      index: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildPetProfileBar(),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Species Toggle
                    StaggeredSlideIn(
                      index: 1,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: SpeciesToggle(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // SECTION: Recommended Songs (Circular) - NOW FIRST
                    Obx(() {
                      final species = ['species_dog'.tr, 'species_cat'.tr, 'species_guardian'.tr][controller.selectedSpeciesIndex.value];
                      return _buildSectionTitle('home_recommended_for'.trParams({'species': species}));
                    }),
                    const SizedBox(height: 12),
                    
                    // Modes List - Enhanced UI with Scroll Indicator
                    Obx(() {
                      return StaggeredSlideIn(
                        index: 2,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          height: 140, // Compact height
                          decoration: BoxDecoration(
                            // Solid light blue-white background for visibility
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(24),
                            // Blue-tinted border for definition
                            border: Border.all(
                              color: AppColors.primaryBlue.withOpacity(0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  ...controller.modes.where((mode) {
                                    final isDogMode = !mode.id.startsWith('cat_');
                                    final isCatMode = mode.id.startsWith('cat_');
                                    
                                    if (controller.selectedSpeciesIndex.value == 0) {
                                      return isDogMode;
                                    } else if (controller.selectedSpeciesIndex.value == 1) {
                                      return isCatMode;
                                    }
                                    return true;
                                  }).map((mode) {
                                    final isSelected = controller.currentMode.value?.id == mode.id && !controller.isAutoMode.value;
                                    final isPlaying = isSelected && controller.isPlaying.value;
                                    
                                    ModeAnimationType animType = ModeAnimationType.none;
                                    if (mode.id == 'sleep' || mode.id == 'cat_sleep') animType = ModeAnimationType.sway;
                                    else if (mode.id == 'anxiety' || mode.id == 'cat_anxiety') animType = ModeAnimationType.breathe;
                                    else if (mode.id == 'noise' || mode.id == 'cat_noise') animType = ModeAnimationType.wave;
                                    else if (mode.id == 'energy' || mode.id == 'cat_energy') animType = ModeAnimationType.pulse;
                                    else if (mode.id == 'senior' || mode.id == 'cat_senior') animType = ModeAnimationType.heartbeat;

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: _buildCircularModeButton(
                                        title: mode.title,
                                        iconPath: mode.iconPath,
                                        isActive: isSelected,
                                        isPlaying: isPlaying,
                                        onTap: () {
                                          hapticService.lightImpact();
                                          controller.changeMode(mode);
                                          Get.to(() => const ModeDetailView(), arguments: mode);
                                        },
                                        color: mode.color,
                                        animationType: animType,
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // SECTION: AI Special Mode (Smart Sync) - NOW SECOND
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: AISpecialModeWidget(),
                    ),

                    const SizedBox(height: 24),

                    // SECTION: AI Custom Recommendation (Scenario Chips)
                    _buildSectionTitleWithPro('home_ai_recommend'.tr),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('scenario_after_walk'.tr, 'scenario_after_walk', 'assets/icons/icon_scenario_walk.png', color: const Color(0xFF4CAF50))),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('scenario_nap'.tr, 'scenario_nap', 'assets/icons/icon_scenario_nap.png', color: const Color(0xFF673AB7))),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('scenario_hospital'.tr, 'scenario_hospital', 'assets/icons/icon_scenario_vet.png', color: const Color(0xFFFF9800))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('scenario_grooming'.tr, 'scenario_grooming', 'assets/icons/icon_scenario_grooming.png', color: const Color(0xFFFF7043))), // Deep Orange
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('scenario_thunder'.tr, 'scenario_thunder', 'assets/icons/icon_scenario_thunder.png', color: const Color(0xFFFFA726))), // Orange Amber
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('scenario_anxiety'.tr, 'scenario_anxiety', 'assets/icons/icon_scenario_anxiety.png', color: const Color(0xFF9575CD))), // Soft Purple
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    
                    // SECTION: Exercises (2-row Grid Layout)
                    _buildSectionTitle('home_health_activity'.tr),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                          // 3-Column Row for Health & Activity
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildExerciseCard(
                                  title: 'home_rest_title'.tr,
                                  subtitle: 'home_rest_desc'.tr,
                                  iconPath: 'assets/icons/icon_health_rest.png',
                                  color: Colors.teal,
                                  activityType: 'rest',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildExerciseCard(
                                  title: 'home_tips_title'.tr,
                                  subtitle: 'home_tips_desc'.tr,
                                  iconPath: 'assets/icons/icon_health_tips.png',
                                  color: Colors.indigo,
                                  activityType: 'tips',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildExerciseCard(
                                  title: 'home_charge_title'.tr,
                                  subtitle: 'home_charge_desc'.tr,
                                  iconPath: 'assets/icons/icon_health_charge.png',
                                  color: Colors.orange,
                                  activityType: 'charge',
                                ),
                              ),
                            ],
                          ),

                    ),
                    
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              
              // Mini Player (Floating Bottom Bar)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: const MiniPlayer(),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  


  Widget _buildBannerCard(HapticService hapticService) {
    return ElasticScaleButton(
      onTap: () {
        hapticService.lightImpact();
        Get.to(() => const AppInfoView());
      },
      child: BentoCard(
        height: 160,
        borderRadius: 32,
        padding: EdgeInsets.zero,
        enableParallax: true, // 3D Tilt Effect
        enableShimmer: true,  // Glass Shimmer Effect
        glowColor: const Color(0xFF6A5AE0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'assets/images/MainBanner/MainBanner.png',
              fit: BoxFit.cover,
            ),
            
            // Modern Gradient Overlay (Mesh-like)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Text Overlay with Glass Badge
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PetBeats',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'home_premium_therapy'.tr,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularModeButton({
    required String title,
    required String iconPath,
    required bool isActive,
    required bool isPlaying,
    required VoidCallback onTap,
    Color? color,
    bool isSpecial = false,
    ModeAnimationType animationType = ModeAnimationType.none,
  }) {
    return PremiumModeButton(
      title: title,
      iconPath: iconPath,
      isActive: isActive,
      isPlaying: isPlaying,
      onTap: onTap,
      color: color,
      isSpecial: isSpecial,
      animationType: animationType,
    );
  }



  void _showScenarioDialog(String label, String key, Color color) {
    // 시나리오별 설명 (Localized using key)
    final description = '${key}_desc'.tr; // e.g., scenario_after_walk_desc
    
    // PRO 상태 확인
    bool isPremium = controller.isPremiumUser.value;
    
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이콘
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              
              // 제목
              Text(
                label, // Already translated
                style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // 설명
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.5),
              ),
              const SizedBox(height: 24),
              
              if (isPremium) ...[
                // PRO 사용자 - 바로 플레이리스트 생성
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // 시나리오에 맞는 AI 플레이리스트 생성
                      Get.toNamed('/ai-playlist-result', arguments: {
                        'scenario': _getScenarioID(key),
                      });
                    },
                    icon: const Icon(Icons.play_circle_filled),
                    label: Text('dialog_ai_playlist_create'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ] else ...[
                // 무료 사용자 - PRO 결제 유도
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.diamond, color: AppColors.primaryBlue, size: 32),
                      const SizedBox(height: 8),
                      Text('dialog_pro_feature'.tr, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('dialog_pro_desc'.tr, 
                           style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
                           textAlign: TextAlign.center),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.toNamed('/subscription');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('dialog_start_pro'.tr),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('dialog_later'.tr, style: TextStyle(color: AppColors.textGrey)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  // 키에서 AIScenario ID 가져오기
  String _getScenarioID(String key) {
    final scenarioMap = {
      'scenario_after_walk': 'afterWalk',
      'scenario_nap': 'napTime',
      'scenario_hospital': 'hospital',
      'scenario_grooming': 'grooming',
      'scenario_thunder': 'thunder',
      'scenario_anxiety': 'anxiety',
    };
    return scenarioMap[key] ?? 'afterWalk';
  }

  Widget _buildExerciseCard({
    required String title,
    required String subtitle,
    required String iconPath,
    required Color color,
    required String activityType,
  }) {
    final hapticService = Get.find<HapticService>();
    
    return ElasticScaleButton( // 터치 인터랙션
      onTap: () {
        hapticService.lightImpact();
        Get.to(() => HealthActivityDetailView(
          title: title,
          subtitle: subtitle,
          iconPath: iconPath,
          color: color,
          activityType: activityType,
        ));
      },
      child: Container( // BentoCard 스타일 (White Glass with Gradient)
        padding: const EdgeInsets.all(20),
        height: 160,
        decoration: BoxDecoration(
          // Internal Gradient for soft 3D effect
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          // White Outer Border for depth
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 2,
          ),
          boxShadow: [
             BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.08), // Blue Soft Shadow
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: 0,
             ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위아래 정렬
          children: [
            // 아이콘 (좌측 상단)
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
                color: color, // 아이콘 틴트
              ),
            ),
            
            // 텍스트 (좌측 하단)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDarkNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textGrey,
                    height: 1.4,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Pet Profile Mini Bar - 홈 상단에 표시되는 압축된 프로필 정보
  Widget _buildPetProfileBar() {
    try {
      final profileService = Get.find<PetProfileService>();
      
      return Obx(() {
        final profile = profileService.profile.value;
        final hasProfile = profile.name != null && profile.name!.isNotEmpty;
        
        if (!hasProfile) {
          // 프로필이 없으면 설정 유도
          return GestureDetector(
            onTap: () => Get.toNamed(Routes.PET_PROFILE),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // 크기 확대
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pets, color: AppColors.primaryBlue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'home_add_pet_profile'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDarkNavy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey.withOpacity(0.5), size: 16),
                ],
              ),
            ),
          );
        }
        
        // 프로필이 있으면 미니 바 표시
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.PET_PROFILE),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 패딩 조정
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24), // 20 -> 24
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.08), // Blue Shadow
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // 프로필 사진 (크게)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: profile.photoPath != null && profile.photoPath!.startsWith('data:')
                        ? Image.memory(
                            base64Decode(profile.photoPath!.split(',').last),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildDefaultPetIcon(profile.species),
                          )
                        : _buildDefaultPetIcon(profile.species),
                  ),
                ),
                const SizedBox(width: 12),
                
                // 이름과 나이
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.name ?? '',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textDarkNavy,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.species == 'dog' ? 'species_dog'.tr : 'species_cat'.tr} • ${profile.age ?? 0} ${'pet_years_old'.tr}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 수정 아이콘
                Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryBlue.withOpacity(0.6),
                  size: 18,
                ),
              ],
            ),
          ),
        );
      });
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
  
  Widget _buildDefaultPetIcon(String? species) {
    return Container(
      color: AppColors.primaryBlue.withOpacity(0.1),
      child: Center(
        child: Image.asset(
          species == 'cat' 
              ? 'assets/icons/icon_species_cat.png'
              : 'assets/icons/icon_species_dog.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  Widget _buildSectionTitleWithPro(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5C6BC0), Color(0xFF29B6F6)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioChip(String title, String id, String iconPath, {Color color = AppColors.primaryBlue}) {
    return GestureDetector(
      onTap: () {
        // 시나리오 클릭 시 기능 (추후 구현)
        // controller.onScenarioSelected(id); 
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          // Internal Gradient (Dark to Light for depth)
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.95),
              color.withOpacity(0.75),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          // White Outer Border for 3D effect
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with white tint
            if (iconPath.isNotEmpty) ...[
               Image.asset(iconPath, width: 24, height: 24, color: Colors.white.withOpacity(0.9), errorBuilder: (_,__,___) => const Icon(Icons.star, color: Colors.white, size: 24)),
               const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
