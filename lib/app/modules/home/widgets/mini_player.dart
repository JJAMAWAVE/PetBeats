import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import 'beat_animation.dart';

class MiniPlayer extends GetView<HomeController> {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final mode = controller.currentMode.value;
      if (mode == null) return const SizedBox.shrink();

      return Container(
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
              child: Icon(
                _getIconData(mode.iconPath),
                color: mode.color,
              ),
            ),
            const SizedBox(width: 12),
            
            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mode.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textDarkNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    controller.isPlaying.value ? '재생 중...' : '일시정지',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Visualizer (if playing)
            if (controller.isPlaying.value)
              const SizedBox(
                width: 30,
                height: 20,
                child: BeatAnimation(color: AppColors.primaryBlue),
              ),
            
            const SizedBox(width: 12),
            
            // Play/Pause Button
            IconButton(
              icon: Icon(
                controller.isPlaying.value ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: AppColors.primaryBlue,
                size: 40,
              ),
              onPressed: () {
                if (controller.isPlaying.value) {
                  controller.stopSound();
                } else {
                  controller.playSound(mode.id);
                }
              },
            ),
          ],
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
