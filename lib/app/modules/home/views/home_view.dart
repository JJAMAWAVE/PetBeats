import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../widgets/mode_card.dart';
import '../widgets/species_toggle.dart';
import '../../../../core/widgets/ad_banner_placeholder.dart';

import '../../../../core/widgets/background_decoration.dart';
import '../../../../app/data/services/haptic_service.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final hapticService = Get.find<HapticService>();
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: BackgroundDecoration(
        child: SafeArea(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // 상단 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PetBeats', style: AppTextStyles.titleLarge.copyWith(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: AppColors.textDarkNavy),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 종 선택 토글
              const SpeciesToggle(),
              const SizedBox(height: 32),
              // 메인 섹션 타이틀
              Obx(() {
                final species = ['강아지', '고양이', '보호자'][controller.selectedSpeciesIndex.value];
                return Text(
                  '$species를 위한 추천 모드',
                  style: AppTextStyles.subtitle,
                );
              }),
              const SizedBox(height: 16),
              // 모드 그리드
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    ModeCard(
                      title: '수면 모드',
                      subtitle: '깊은 잠을 위해',
                      icon: Icons.nightlight_round,
                      color: Colors.indigo,
                      onTap: () {
                        hapticService.lightImpact();
                        controller.selectMode('수면 모드');
                      },
                    ),
                    ModeCard(
                      title: '진정 모드',
                      subtitle: '불안감 해소',
                      icon: Icons.spa,
                      color: Colors.teal,
                      onTap: () {
                        hapticService.lightImpact();
                        controller.selectMode('진정 모드');
                      },
                    ),
                    ModeCard(
                      title: '놀이 모드',
                      subtitle: '활기찬 에너지',
                      icon: Icons.sports_baseball,
                      color: Colors.orange,
                      onTap: () {
                        hapticService.lightImpact();
                        controller.selectMode('놀이 모드');
                      },
                    ),
                    ModeCard(
                      title: '둔감화 교육',
                      subtitle: '소음 적응 훈련',
                      icon: Icons.volume_up,
                      color: Colors.redAccent,
                      onTap: () {
                        hapticService.lightImpact();
                        controller.selectMode('둔감화 교육');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 광고 배너
              const AdBannerPlaceholder(),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
