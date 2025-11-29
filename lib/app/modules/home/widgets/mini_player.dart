import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../../player/widgets/reactive_visualizer.dart';
import '../../player/models/visualizer_theme.dart';
import '../../../routes/app_routes.dart';

class MiniPlayer extends GetView<HomeController> {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final track = controller.currentTrack.value;
      final mode = controller.currentMode.value;
      final isPlaying = controller.isPlaying.value;

      // 재생 중이 아니거나 트랙이 없으면 숨김 (사용자 요청: 재생 시에만 노출)
      if (!isPlaying || track == null || mode == null) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () => Get.toNamed(Routes.NOW_PLAYING),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon / Art
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: mode.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  mode.iconPath,
                  fit: BoxFit.contain,
                  colorBlendMode: BlendMode.multiply,
                  color: Colors.white.withOpacity(0.0),
                ),
              ),
              const SizedBox(width: 12),
              
              // Title & Type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      track.title, // 곡 제목
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDarkNavy,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${mode.title} • ${track.target}', // 곡 타입 (모드 + 타겟)
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Visualizer
              SizedBox(
                width: 40,
                height: 24,
                child: ReactiveVisualizer(
                  isPlaying: isPlaying,
                  theme: VisualizerTheme(
                    colorPalette: [AppColors.primaryBlue, AppColors.primaryBlue.withOpacity(0.5)],
                    blurIntensity: 2,
                    rippleSpeed: 1.0,
                    particleType: ParticleEffect.none,
                  ),
                  barCount: 4,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Play/Pause Button
              IconButton(
                icon: const Icon(
                  Icons.pause_circle_filled,
                  color: AppColors.primaryBlue,
                  size: 40,
                ),
                onPressed: () {
                  controller.stopSound();
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData _getIconData(String iconPath) {
    if (iconPath.contains('sleep')) return Icons.bedtime;
    if (iconPath.contains('home')) return Icons.home;
    if (iconPath.contains('sound')) return Icons.volume_off;
    if (iconPath.contains('play')) return Icons.play_circle;
    if (iconPath.contains('heart')) return Icons.favorite;
    return Icons.music_note;
  }
}
