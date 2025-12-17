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
import '../../premium/controllers/subscription_controller.dart';
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
        backgroundColor: Colors.transparent, // Ripple 애니메이션이 보이도록 투명 처리
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
                      final species = ['species_dog'.tr, 'species_cat'.tr, 'species_guardian'.tr][controller.selectedSpeciesIndex.value];
                      return _buildSectionTitle('home_recommended_for'.trParams({'species': species}));
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
                    _buildSectionTitleWithPro('home_ai_recommend'.tr),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('scenario_after_walk'.tr, 'assets/icons/icon_scenario_walk.png')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('scenario_nap'.tr, 'assets/icons/icon_scenario_nap.png')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('scenario_hospital'.tr, 'assets/icons/icon_scenario_vet.png')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('scenario_grooming'.tr, 'assets/icons/icon_scenario_grooming.png')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _buildScenarioChip('scenario_thunder'.tr, 'assets/icons/icon_scenario_thunder.png')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildScenarioChip('scenario_anxiety'.tr, 'assets/icons/icon_scenario_anxiety.png')),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    
                    // SECTION 3: Exercises (2-row Grid Layout)
                    _buildSectionTitle('home_health_activity'.tr),
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
                            ],
                          ),
                          const SizedBox(height: 12),
                          // 하단 1개 카드 (3번째) - 왼쪽 정렬, 절반 너비
                          Row(
                            children: [
                              Expanded(
                                child: _buildExerciseCard(
                                  title: 'home_charge_title'.tr,
                                  subtitle: 'home_charge_desc'.tr,
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
  
  Widget _buildSectionTitleWithPro(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
                        '프리미엄 사운드 테라피',
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
        // 시나리오 설명 + PRO 체크 다이얼로그
        _showScenarioDialog(label, chipColor);
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

  void _showScenarioDialog(String label, Color color) {
    // 시나리오별 설명
    final descriptions = {
      '산책 후': '활발한 산책 후 흥분한 반려동물을 차분하게 진정시켜줍니다.\n\n🎵 진정 효과 음악 + 자연의 소리로 편안한 휴식을 도와드려요.',
      '낮잠 시간': '낮잠을 위한 부드럽고 편안한 멜로디를 제공합니다.\n\n🎵 수면 유도 음악으로 깊은 휴식을 취할 수 있어요.',
      '병원 방문': '병원 방문 전후의 불안함을 완화해줍니다.\n\n🎵 안정감을 주는 저주파 음악으로 스트레스를 줄여드려요.',
      '미용 후': '미용 후의 스트레스를 해소하고 안정을 찾아줍니다.\n\n🎵 릴렉스 효과 음악으로 마음의 평화를 되찾아드려요.',
      '천둥/번개': '천둥소리나 폭풍우에 대한 공포를 완화해줍니다.\n\n🎵 불안 완화 음악으로 두려움을 잊게 해드려요.',
      '분리 불안': '혼자 있을 때 느끼는 불안감을 줄여줍니다.\n\n🎵 안정감 있는 음악으로 보호자 없이도 편안하게 지낼 수 있어요.',
    };
    
    final description = descriptions[label] ?? '맞춤 플레이리스트를 생성합니다.';
    
    // PRO 상태 확인 (HomeController의 isPremiumUser 사용 - 구독 시 동기화됨)
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
                label,
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
                        'scenario': _getScenarioFromLabel(label),
                      });
                    },
                    icon: const Icon(Icons.play_circle_filled),
                    label: const Text('AI 플레이리스트 생성'),
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
                      Text('PRO 전용 기능', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('AI가 자동으로 맞춤 플레이리스트를 생성해드려요', 
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
                    child: const Text('PRO 시작하기'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('나중에 할게요', style: TextStyle(color: AppColors.textGrey)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  // 라벨에서 AIScenario 가져오기 (dynamic import 회피)
  dynamic _getScenarioFromLabel(String label) {
    final scenarioMap = {
      '산책 후': 'afterWalk',
      '낮잠 시간': 'napTime',
      '병원 방문': 'hospital',
      '미용 후': 'grooming',
      '천둥/번개': 'thunder',
      '분리 불안': 'anxiety',
    };
    return scenarioMap[label] ?? 'afterWalk';
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
