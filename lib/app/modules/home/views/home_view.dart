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
import 'settings_view.dart';
import 'mode_detail_view.dart';
import 'health_activity_detail_view.dart';
import 'app_info_view.dart';
import '../../../../app/data/services/daily_routine_service.dart';
import '../../../routes/app_routes.dart';
import '../widgets/ai_special_mode_widget.dart';
import '../controllers/smart_care_controller.dart';
// Bento Style Widgets
import 'package:petbeats/core/widgets/bento_card.dart';
import 'package:petbeats/core/widgets/elastic_scale_button.dart';
import 'package:petbeats/core/widgets/mode_animator.dart';
import 'package:petbeats/core/widgets/staggered_slide_in.dart';
import 'package:petbeats/core/widgets/animated_gradient_border.dart';
import '../widgets/debug_bottom_sheet.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final hapticService = Get.find<HapticService>();
    return Obx(() => SpeciesThemeTransition(
      theme: controller.currentSpeciesTheme.value,
      child: Scaffold(
        backgroundColor: controller.currentSpeciesTheme.value.backgroundColor,
        body: BackgroundDecoration(
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100), // Space for MiniPlayer
                  child: Column(
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
                            const HeartbeatText('PetBeats', fontSize: 24),
                            Row(
                              children: [
                                // 디버그 패널 (DEV ONLY)
                                GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                      const DebugBottomSheet(),
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                    ),
                                    child: const Icon(
                                      Icons.bug_report,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // 친구 초대 아이콘 복원
                                HeaderIconButton(
                                  iconPath: 'assets/icons/icon_nav_notification.png',
                                  animationType: HeaderIconAnimationType.shake,
                                  onTap: () {
                                    Get.toNamed(Routes.INVITE_FRIENDS);
                                  },
                                ),
                                const SizedBox(width: 8),
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
                    const SizedBox(height: 12),
                    
                    // Species Toggle with Staggered Animation
                    StaggeredSlideIn(
                      index: 1,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: SpeciesToggle(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Banner Card with Staggered Animation
                    StaggeredSlideIn(
                      index: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildBannerCard(hapticService),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // SECTION 1: Recommended Modes (Circular)
                    Obx(() {
                      final species = ['강아지', '고양이', '보호자'][controller.selectedSpeciesIndex.value];
                      return _buildSectionTitle('$species를 위한 추천 모드');
                    }),
                    const SizedBox(height: 12),
                    
                    // Modes List - Wrapped in Unified Layered Container
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Stack(
                          children: [
                            // Shadow Layer (Bottom)
                            Positioned(
                              top: 6,
                              left: 4,
                              right: 4,
                              child: Container(
                                height: 130,  // 높이 축소하여 오버플로우 방지
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Main Container (Top Surface)
                            Container(
                              height: 130,  // 높이 축소
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    const Color(0xFFF8F9FB),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [

                                      
                                      // Individual Modes - Filtered by species
                                      ...controller.modes.where((mode) {
                                        // Dog modes: IDs don't contain 'cat_'
                                        // Cat modes: IDs contain 'cat_'
                                        final isDogMode = !mode.id.startsWith('cat_');
                                        final isCatMode = mode.id.startsWith('cat_');
                                        
                                        if (controller.selectedSpeciesIndex.value == 0) {
                                          // Dog selected - show only dog modes
                                          return isDogMode;
                                        } else if (controller.selectedSpeciesIndex.value == 1) {
                                          // Cat selected - show only cat modes
                                          return isCatMode;
                                        }
                                        return true; // Show all if neither (shouldn't happen)
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
                                          padding: const EdgeInsets.only(right: 8),  // 간격 축소
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
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                    
                    // SECTION 2: AI Special Mode
                    // _buildSectionTitle('AI 스마트 케어'), // Title is inside the widget now
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: AISpecialModeWidget(),
                    ),
                    const SizedBox(height: 20),

                    // SECTION 3: Scenario Chips
                    _buildSectionTitle('AI 맞춤 추천'),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('산책 후', 'assets/icons/icon_scenario_walk.png')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('낮잠 시간', 'assets/icons/icon_scenario_nap.png')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('병원 방문', 'assets/icons/icon_scenario_vet.png')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('미용 후', 'assets/icons/icon_scenario_grooming.png')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('천둥/번개', 'assets/icons/icon_scenario_thunder.png')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('분리 불안', 'assets/icons/icon_scenario_anxiety.png')),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    
                    // SECTION 3: Exercises (2-row Grid Layout)
                    _buildSectionTitle('건강 & 활동'),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // 상단 2개 카드
                          Row(
                            children: [
                              Expanded(
                                child: _buildExerciseCard(
                                  title: '휴식',
                                  subtitle: '스트레스를 낮추고\n평온함을 찾으세요',
                                  iconPath: 'assets/icons/icon_health_rest.png',
                                  color: Colors.teal,
                                  activityType: 'rest',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildExerciseCard(
                                  title: '반려 상식',
                                  subtitle: '반려동물을 위한\n유용한 팁',
                                  iconPath: 'assets/icons/icon_health_tips.png',
                                  color: Colors.indigo,
                                  activityType: 'tips',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // 하단 1개 카드 (3번째) - 왼쪽 정렬, 절반 너비
                          Row(
                            children: [
                              Expanded(
                                child: _buildExerciseCard(
                                  title: '에너지 충전',
                                  subtitle: '활력을 되찾아주는\n사운드',
                                  iconPath: 'assets/icons/icon_health_charge.png',
                                  color: Colors.orange,
                                  activityType: 'charge',
                                ),
                              ),
                              const SizedBox(width: 12),
                              // 빈 공간 (추후 카드 추가 가능)
                              Expanded(child: Container()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
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
                        'Premium Sound Therapy',
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

  Widget _buildScenarioChip(String label, String iconPath) {
    // 시나리오별 컬러 코딩
    Color chipColor;
    Color shadowColor;
    
    switch (label) {
      case '낮잠 시간':
      case '분리 불안':
        // 안정/수면 - Deep Indigo / Soft Purple
        chipColor = AppColors.scenarioCalm;
        shadowColor = AppColors.scenarioCalmLight;
        break;
        
      case '산책 후':
      case '미용 후':
        // 활력/케어 - Sage Green / Warm Orange
        chipColor = label == '산책 후' 
            ? AppColors.scenarioVital 
            : AppColors.scenarioVitalWarm;
        shadowColor = chipColor;
        break;
        
      case '병원 방문':
      case '천둥/번개':
        // 긴급/주의 - Muted Coral / Warm Gray
        chipColor = AppColors.scenarioAlert;
        shadowColor = AppColors.scenarioAlertSoft;
        break;
        
      default:
        chipColor = const Color(0xFF5B67F2);
        shadowColor = chipColor;
    }
    
    return GestureDetector(
      onTap: () {
        // Navigate to corresponding mode detail view instead of auto-playing
        final modeMap = {
          '산책 후': 'energy',
          '낮잠 시간': 'sleep',
          '병원 방문': 'anxiety',
          '미용 후': 'noise',
          '천둥/번개': 'noise',
          '분리 불안': 'anxiety',
        };
        final mode = controller.modes.firstWhere(
          (m) => m.id == modeMap[label],
          orElse: () => controller.modes.first,
        );
        Get.to(() => const ModeDetailView(), arguments: mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required String subtitle,
    required String iconPath,
    required Color color,
    required String activityType,
  }) {
    final hapticService = Get.find<HapticService>();
    
    return GestureDetector(
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
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textGrey,
              height: 1.3,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
