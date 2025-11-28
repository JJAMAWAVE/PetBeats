import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final hapticService = Get.find<HapticService>();
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: BackgroundDecoration(
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100), // Space for MiniPlayer
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const HeartbeatText('PetBeats', fontSize: 24),
                          Row(
                            children: [
                              HeaderIconButton(
                                iconPath: 'assets/icons/icon_nav_notification.png',
                                animationType: HeaderIconAnimationType.shake,
                                onTap: () {
                                  hapticService.lightImpact();
                                  Get.toNamed(Routes.INVITE_FRIENDS);
                                },
                              ),
                              const SizedBox(width: 8),
                              HeaderIconButton(
                                iconPath: 'assets/icons/icon_nav_settings.png',
                                animationType: HeaderIconAnimationType.rotate,
                                onTap: () {
                                  Get.to(() => const SettingsView());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Species Toggle
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: SpeciesToggle(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Banner Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildBannerCard(hapticService),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // SECTION 1: Recommended Modes (Circular)
                    Obx(() {
                      final species = ['강아지', '고양이', '보호자'][controller.selectedSpeciesIndex.value];
                      return _buildSectionTitle('$species를 위한 추천 모드');
                    }),
                    const SizedBox(height: 16),
                    
                    // Modes List - Wrapped in Unified Layered Container
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Stack(
                          children: [
                            // Shadow Layer (Bottom)
                            Positioned(
                              top: 8,
                              left: 4,
                              right: 4,
                              child: Container(
                                height: 210,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Main Container (Top Surface)
                            Container(
                              height: 210,
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
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Row(
                                  children: [
                                    // Special "AI Auto Recommend" Button
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: _buildCircularModeButton(
                                        title: 'AI 자동 추천',
                                        iconPath: 'assets/icons/icon_mode_auto.png',
                                        isActive: false,
                                        isPlaying: false,
                                        onTap: () {
                                          hapticService.lightImpact();
                                          // Show all modes bottom sheet or navigate
                                        },
                                        isSpecial: true,
                                        animationType: ModeAnimationType.pulse,
                                      ),
                                    ),
                                    
                                    // Individual Modes
                                    ...controller.modes.map((mode) {
                                      final isSelected = controller.currentMode.value?.id == mode.id && !controller.isAutoMode.value;
                                      final isPlaying = isSelected && controller.isPlaying.value;
                                      
                                      ModeAnimationType animType = ModeAnimationType.none;
                                      if (mode.id == 'sleep') animType = ModeAnimationType.sway;
                                      else if (mode.id == 'anxiety') animType = ModeAnimationType.breathe;
                                      else if (mode.id == 'noise') animType = ModeAnimationType.wave;
                                      else if (mode.id == 'energy') animType = ModeAnimationType.pulse;
                                      else if (mode.id == 'senior') animType = ModeAnimationType.heartbeat;

                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16),
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

                    const SizedBox(height: 40),
                    
                    // SECTION 2: Scenario Chips
                    _buildSectionTitle('AI 맞춤 추천'),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildScenarioChip('산책 후', 'assets/icons/icon_scenario_walk.png'),
                          _buildScenarioChip('낮잠 시간', 'assets/icons/icon_scenario_nap.png'),
                          _buildScenarioChip('병원 방문', 'assets/icons/icon_scenario_vet.png'),
                          _buildScenarioChip('미용 후', 'assets/icons/icon_scenario_grooming.png'),
                          _buildScenarioChip('천둥/번개', 'assets/icons/icon_scenario_thunder.png'),
                          _buildScenarioChip('분리 불안', 'assets/icons/icon_scenario_anxiety.png'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    
                    // SECTION 3: Exercises (Horizontal Cards)
                    _buildSectionTitle('건강 & 활동'),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        children: [
                          _buildExerciseCard(
                            title: '휴식',
                            subtitle: '스트레스를 낮추고\n평온함을 찾으세요',
                            iconPath: 'assets/icons/icon_health_rest.png',
                            color: Colors.teal,
                            activityType: 'rest',
                          ),
                          const SizedBox(width: 16),
                          _buildExerciseCard(
                            title: '반려 상식',
                            subtitle: '반려동물을 위한\n유용한 팁',
                            iconPath: 'assets/icons/icon_health_tips.png',
                            color: Colors.indigo,
                            activityType: 'tips',
                          ),
                          const SizedBox(width: 16),
                          _buildExerciseCard(
                            title: '에너지 충전',
                            subtitle: '활력을 되찾아주는\n사운드',
                            iconPath: 'assets/icons/icon_health_charge.png',
                            color: Colors.orange,
                            activityType: 'charge',
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
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
    );
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
    return GestureDetector(
      onTap: () {
        hapticService.lightImpact();
        Get.to(() => const AppInfoView());
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/images/MainBanner/MainBanner.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
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
          color: const Color(0xFF5B67F2), // Blue-Purple Mix
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B67F2).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            // Inner shadow simulation via gradient or another box shadow if needed, 
            // but double border usually means an outer ring. 
            // Let's add a second outer ring using a container wrap if strictly needed, 
            // but for now a distinct border + shadow looks premium.
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48, // 2x size (24 -> 48)
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
                fontSize: 16, // Slightly larger text
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
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textGrey,
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
