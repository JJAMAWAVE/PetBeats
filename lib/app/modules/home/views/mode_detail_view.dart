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
            
            // Scientific Context Section
            _buildScientificContext(mode),
            
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

  Widget _buildScientificContext(Mode mode) {
    String contextText = '';
    String sourceText = '';
    
    if (mode.id == 'sleep') {
      contextText = 'Wells & Kogan의 연구에 따르면, 60 BPM의 단순한 피아노 선율은 강아지의 휴식 심박수와 동조하여 깊은 수면을 유도합니다.';
      sourceText = 'Source: Journal of Veterinary Behavior, 2012';
    } else if (mode.id == 'anxiety') {
      contextText = '백색 소음과 부드러운 멜로디의 조화는 외부 자극을 차단하고 분리 불안을 완화하는 데 효과적입니다.';
      sourceText = 'Source: Applied Animal Behaviour Science';
    } else if (mode.id == 'energy') {
      contextText = '다양한 주파수와 빠른 템포는 반려동물의 호기심을 자극하고 활동성을 높여줍니다.';
      sourceText = 'Source: Animal Welfare, 2002';
    } else if (mode.id == 'senior') {
      contextText = '낮은 주파수의 진동은 시니어 펫의 관절 통증 완화에 도움을 주며, 안정적인 리듬은 인지 기능을 돕습니다.';
      sourceText = 'Source: Scientific Reports, 2019';
    } else {
      contextText = '반려동물과 보호자의 옥시토신 루프를 활성화하여 깊은 유대감을 형성합니다.';
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
                'Scientific Insight',
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
            color: isPlaying ? AppColors.primaryBlue.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                    Row(
                      children: [
                        Text(
                          _getSizeFromTags(track.tags) ?? track.target ?? '공용',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Tags (Instrument / BPM)
                        _buildTag(_getInstrumentFromSpecs(track)),
                        const SizedBox(width: 4),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFD700),
                            Color(0xFFFFA500),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFFD700).withOpacity(0.4),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('👑', style: TextStyle(fontSize: 10)),
                          SizedBox(width: 2),
                          Text(
                            'PRO',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
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
  
  /// Extract pet size from tags and convert to Korean
  String? _getSizeFromTags(List<String>? tags) {
    if (tags == null || tags.isEmpty) return null;
    
    for (final tag in tags) {
      final lowerTag = tag.toLowerCase();
      if (lowerTag.contains('large')) return '대형견';
      if (lowerTag.contains('medium')) return '중형견';
      if (lowerTag.contains('small')) return '소형견';
      if (lowerTag.contains('all') || lowerTag.contains('common')) return '공용';
    }
    return null;
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
