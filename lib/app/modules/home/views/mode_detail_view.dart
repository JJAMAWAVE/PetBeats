import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/mode_model.dart';
import '../../../data/models/track_model.dart';
import '../../../routes/app_routes.dart';

class ModeDetailView extends GetView<HomeController> {
  const ModeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = Get.arguments as Mode;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
        title: Text(mode.title, style: AppTextStyles.subtitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mode Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: mode.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      mode.iconPath,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    mode.description,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 24),
                  // Subscription Banner (if not premium)
                  Obx(() {
                    if (!controller.isPremiumUser.value) {
                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.SUBSCRIPTION),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2575FC).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Unlock All Premium Tracks',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Get access to specialized care sounds',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
            
            // Track List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: mode.tracks.length,
                itemBuilder: (context, index) {
                  final track = mode.tracks[index];
                  return _buildTrackItem(track);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackItem(Track track) {
    return Obx(() {
      final isLocked = track.isPremium && !controller.isPremiumUser.value;
      final isPlaying = controller.isPlaying.value; // Simple check, ideally check track ID too

      return GestureDetector(
        onTap: () {
          if (isLocked) {
            Get.toNamed(Routes.SUBSCRIPTION);
          } else {
            // Play logic
            controller.playSound(track.id); // Assuming playSound handles track ID
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lineLightBlue),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Play/Lock Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock : (isPlaying ? Icons.pause : Icons.play_arrow),
                  color: isLocked ? Colors.grey : AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              
              // Title & Target
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isLocked ? AppColors.textGrey : AppColors.textDarkNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.target, // e.g., "대형", "공용"
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Duration & PRO Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (track.isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PRO',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    track.duration,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.textGrey),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
