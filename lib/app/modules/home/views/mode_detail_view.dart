import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/mode_model.dart';
import '../../../data/models/track_model.dart';
import '../../../routes/app_routes.dart';
import '../widgets/mini_player.dart';
import '../../../../core/widgets/background_decoration.dart';
import 'package:petbeats/core/widgets/rainbow_gradient.dart';
import 'package:petbeats/core/widgets/premium_banner.dart';

class ModeDetailView extends GetView<HomeController> {
  const ModeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = Get.arguments as Mode;

    return BackgroundDecoration(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Mode Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        width: 140, // 80 -> 140 (확대)
                        height: 140,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3), // Glass effect
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: mode.color.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
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
                          return const PremiumBanner(
                            title: 'premium_unlock_tracks',
                            subtitle: 'premium_special_care',
                            icon: Icons.stars,
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
                
                // Scientific Context Section
                _buildScientificContext(mode),
                
                // Track List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100), // Extra bottom padding for MiniPlayer
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
  );
  }

  Widget _buildScientificContext(Mode mode) {
    String contextText = '';
    String sourceText = '';
    
    if (mode.id == 'sleep') {
      contextText = 'science_sleep'.tr;
      sourceText = 'Source: Journal of Veterinary Behavior, 2012';
    } else if (mode.id == 'anxiety') {
      contextText = 'science_anxiety'.tr;
      sourceText = 'Source: Applied Animal Behaviour Science';
    } else if (mode.id == 'energy') {
      contextText = 'science_energy'.tr;
      sourceText = 'Source: Animal Welfare, 2002';
    } else if (mode.id == 'senior') {
      contextText = 'science_senior'.tr;
      sourceText = 'Source: Scientific Reports, 2019';
    } else {
      contextText = 'science_default'.tr;
      sourceText = 'Source: Science, 2015';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science, size: 18, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'science_effect'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            contextText,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textDarkNavy,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sourceText,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppColors.textGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackItem(Track track) {
    return Obx(() {
      final isLocked = track.isPremium && !controller.isPremiumUser.value;
      // Fix: Exclusive playback check
      final isPlaying = controller.isPlaying.value && controller.currentTrack.value?.id == track.id;

      return GestureDetector(
        onTap: () {
          if (isLocked) {
            Get.toNamed(Routes.SUBSCRIPTION);
          } else {
            if (isPlaying) {
              controller.stopSound();
            } else {
              controller.playTrack(track); // Use playTrack instead of playSound
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPlaying 
                ? AppColors.primaryBlue.withOpacity(0.1) 
                : Colors.white.withOpacity(0.6), // Glassmorphism
            borderRadius: BorderRadius.circular(20), // 16 -> 20
            border: Border.all(
              color: isPlaying ? AppColors.primaryBlue.withOpacity(0.3) : AppColors.lineLightBlue
            ),
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
              // Play/Crown Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isLocked
                      ? LinearGradient(
                          colors: [
                            Color(0xFFFFD700),
                            Color(0xFFFFA500),
                          ],
                        )
                      : null,
                  color: isLocked ? null : AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: isLocked
                      ? [
                          BoxShadow(
                            color: Color(0xFFFFD700).withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isLocked ? Icons.workspace_premium : (isPlaying ? Icons.pause : Icons.play_arrow),
                  color: isLocked ? Colors.white : AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              
              // Title & Target & Tags
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
                    // Wrap으로 오버플로우 방지
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // 대형/중형/소형/공용 색상 구분 배지
                        _buildSizeBadge(_getSizeFromTags(track.tags) ?? track.target ?? '공용'),
                        // Tags (Instrument / BPM)
                        _buildTag(_getInstrumentFromSpecs(track)),
                        _buildTag(track.bpm ?? '60 BPM'),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Duration & PRO Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (track.isPremium)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: const RainbowProBadge(),
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

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: AppColors.textGrey,
        ),
      ),
    );
  }
  
  /// Extract pet size from tags and convert to Korean (통합 라벨: 소형/중형/대형)
  String? _getSizeFromTags(List<String>? tags) {
    if (tags == null || tags.isEmpty) return null;
    
    for (final tag in tags) {
      final lowerTag = tag.toLowerCase();
      if (lowerTag.contains('large')) return 'size_large'.tr;
      if (lowerTag.contains('medium')) return 'size_medium'.tr;
      if (lowerTag.contains('small')) return 'size_small'.tr;
      if (lowerTag.contains('all') || lowerTag.contains('common')) return 'size_all'.tr;
    }
    return null;
  }
  
  /// 대형/중형/소형/공용 색상 구분 배지
  Widget _buildSizeBadge(String size) {
    Color bgColor;
    Color textColor;
    
    switch (size) {
      case '대형':
        bgColor = const Color(0xFF9C27B0).withOpacity(0.15);  // 보라
        textColor = const Color(0xFF7B1FA2);
        break;
      case '중형':
        bgColor = const Color(0xFF2196F3).withOpacity(0.15);  // 파랑
        textColor = const Color(0xFF1565C0);
        break;
      case '소형':
        bgColor = const Color(0xFF4CAF50).withOpacity(0.15);  // 초록
        textColor = const Color(0xFF2E7D32);
        break;
      default:  // 공용
        bgColor = const Color(0xFF607D8B).withOpacity(0.15);  // 회색
        textColor = const Color(0xFF455A64);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        size,
        style: GoogleFonts.notoSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
  
  /// Extract primary instrument from technicalSpecs
  String _getInstrumentFromSpecs(Track track) {
    final specs = track.technicalSpecs;
    if (specs == null || specs['Instruments'] == null) {
      return track.instrument ?? 'Piano';
    }
    
    final instruments = specs['Instruments'] as String;
    // Get first instrument before "/" separator
    final firstInstrument = instruments.split(' / ').first;
    
    // Shorten long names
    if (firstInstrument.length > 15) {
      return firstInstrument.substring(0, 12) + '...';
    }
    return firstInstrument;
  }
}
