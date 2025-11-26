import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/onboarding_controller.dart';
import '../../../routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/services/haptic_service.dart'; // HapticService import

class QuestionView extends StatefulWidget {
  const QuestionView({super.key});

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> with TickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  late AnimationController _btnAnimationController;
  late Animation<double> _btnScaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    _btnAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _btnScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _btnAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _btnAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    final hapticService = Get.find<HapticService>(); // HapticService 인스턴스
    
    // 선택된 항목들을 관리하는 리스트
    final selectedItems = <String>[].obs;
    
    // 선택 가능한 옵션들 (5가지)
    final options = [
      {'value': 'sleep', 'label': '수면 유도', 'icon': Icons.bedtime},
      {'value': 'anxiety', 'label': '분리불안', 'icon': Icons.sentiment_very_dissatisfied},
      {'value': 'noise', 'label': '소음 민감', 'icon': Icons.volume_up},
      {'value': 'energy', 'label': '에너지 조절', 'icon': Icons.bolt},
      {'value': 'senior', 'label': '시니어 펫 케어', 'icon': Icons.accessibility_new},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 온보딩과 동일한 배경 그라데이션
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.2),
                  radius: 0.8,
                  colors: [
                    Color(0xFFE8F0FE),
                    Colors.white,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          
          // 민들레 씨앗 라이트 효과
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _DandelionLightsPainter(
                    animationValue: _bgAnimationController.value,
                  ),
                );
              },
            ),
          ),
          
          // 메인 컨텐츠
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Reduced top spacing
                  
                  // 질문 텍스트
                  Text(
                    '반려동물에게 필요한\n도움은 무엇인가요?',
                    style: GoogleFonts.notoSans(
                      fontSize: 28, // Slightly reduced font size
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDarkNavy,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    '최대 3개까지 선택 가능합니다',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  
                  const SizedBox(height: 24), // Reduced spacing
                  
                  // 옵션 리스트
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0), // Reduced item spacing
                          child: Obx(() {
                            final option = options[index];
                            final value = option['value'] as String;
                            final isSelected = selectedItems.contains(value);
                            
                            return _buildOptionButton(
                              label: option['label'] as String,
                              icon: option['icon'] as IconData,
                              isSelected: isSelected,
                              onTap: () {
                                hapticService.lightImpact(); // 햅틱 피드백
                                if (isSelected) {
                                  selectedItems.remove(value);
                                } else {
                                  if (selectedItems.length < 3) {
                                    selectedItems.add(value);
                                  }
                                }
                              },
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 시작하기 버튼
                  Obx(() {
                    final hasSelection = selectedItems.isNotEmpty;
                    
                    // 버튼 애니메이션 제어
                    if (hasSelection) {
                      if (!_btnAnimationController.isAnimating) {
                        _btnAnimationController.repeat(reverse: true);
                      }
                    } else {
                      _btnAnimationController.stop();
                      _btnAnimationController.reset();
                    }
                    
                    return ScaleTransition(
                      scale: hasSelection ? _btnScaleAnimation : const AlwaysStoppedAnimation(1.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: hasSelection
                              ? () {
                                  hapticService.lightImpact(); // 햅틱 피드백
                                  controller.stressTriggers.value = selectedItems.toList();
                                  Get.toNamed(Routes.QUESTION2);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasSelection
                                ? AppColors.primaryBlue
                                : AppColors.primaryBlue.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            elevation: hasSelection ? 8 : 0, // 그림자 효과 추가
                            shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.3),
                            disabledForegroundColor: Colors.white.withOpacity(0.5),
                          ),
                          child: Text(
                            '다음',
                            style: GoogleFonts.notoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: hasSelection ? Colors.white : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Reduced internal padding
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.lineLightBlue,
            width: isSelected ? 2.0 : 1.5,
          ),
          // 선택 시 은은한 글로우 효과 (그림자)
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.notoSans(
                  fontSize: 17,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryBlue : AppColors.textDarkNavy,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

// 민들레 씨앗처럼 움직이는 푸른색 라이트 효과
class _DandelionLightsPainter extends CustomPainter {
  final double animationValue;

  _DandelionLightsPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // 민들레 씨앗 라이트들 (순차적으로 떨어지도록 y값 분산)
    final lights = [
      {'x': 0.1, 'y': -0.2, 'speed': 1.0, 'size': 4.0, 'opacity': 0.4},
      {'x': 0.25, 'y': 0.3, 'speed': 0.85, 'size': 3.5, 'opacity': 0.35},
      {'x': 0.85, 'y': -0.5, 'speed': 0.92, 'size': 4.5, 'opacity': 0.45},
      {'x': 0.15, 'y': 0.6, 'speed': 0.88, 'size': 3.0, 'opacity': 0.3},
      {'x': 0.92, 'y': -0.1, 'speed': 0.95, 'size': 4.0, 'opacity': 0.4},
      {'x': 0.05, 'y': 0.4, 'speed': 0.82, 'size': 3.5, 'opacity': 0.35},
      {'x': 0.75, 'y': -0.8, 'speed': 0.9, 'size': 4.0, 'opacity': 0.4},
      {'x': 0.4, 'y': 0.1, 'speed': 0.87, 'size': 3.8, 'opacity': 0.38},
      {'x': 0.6, 'y': -0.4, 'speed': 0.93, 'size': 3.3, 'opacity': 0.33},
      {'x': 0.3, 'y': 0.7, 'speed': 0.97, 'size': 4.2, 'opacity': 0.42},
      {'x': 0.5, 'y': -0.6, 'speed': 0.84, 'size': 3.6, 'opacity': 0.36},
      {'x': 0.7, 'y': 0.2, 'speed': 0.91, 'size': 3.9, 'opacity': 0.39},
      {'x': 0.2, 'y': -0.9, 'speed': 0.86, 'size': 3.4, 'opacity': 0.34},
      {'x': 0.8, 'y': 0.5, 'speed': 0.94, 'size': 4.1, 'opacity': 0.41},
      {'x': 0.35, 'y': -0.3, 'speed': 0.89, 'size': 3.7, 'opacity': 0.37},
      {'x': 0.55, 'y': 0.8, 'speed': 0.83, 'size': 3.2, 'opacity': 0.32},
      {'x': 0.95, 'y': -0.7, 'speed': 0.96, 'size': 4.3, 'opacity': 0.43},
      {'x': 0.45, 'y': 0.0, 'speed': 0.9, 'size': 3.5, 'opacity': 0.35},
    ];

    for (final light in lights) {
      final x = light['x'] as double;
      final startY = light['y'] as double; // 시작 위치
      final speed = light['speed'] as double;
      final lightSize = light['size'] as double;
      final maxOpacity = light['opacity'] as double;
      
      // 위에서 아래로 천천히 떨어지는 애니메이션
      // startY에서 시작하여 animationValue만큼 이동
      // % 1.5로 루프 (화면 높이보다 조금 더 길게 잡아서 자연스럽게)
      double currentY = (startY + animationValue * speed) % 1.5;
      
      // 화면 좌표로 변환 (-0.2 ~ 1.3 범위)
      // -0.2를 해줘서 화면 위쪽에서 시작하는 느낌
      final animatedY = currentY - 0.2;
      
      // 화면 밖이면 그리지 않음 (최적화)
      if (animatedY < -0.2 || animatedY > 1.2) continue;
      
      final position = Offset(size.width * x, size.height * animatedY);
      
      // 투명도: 화면 상단/하단에서 부드럽게 페이드
      double fadeOpacity = 1.0;
      if (animatedY < 0.1) {
        fadeOpacity = (animatedY + 0.2) / 0.3; // 나타날 때
      } else if (animatedY > 0.9) {
        fadeOpacity = (1.2 - animatedY) / 0.3; // 사라질 때
      }
      fadeOpacity = fadeOpacity.clamp(0.0, 1.0);
      
      // 큰 글로우 (외곽)
      final outerGlowPaint = Paint()
        ..color = const Color(0xFF0055FF).withOpacity(maxOpacity * fadeOpacity * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, lightSize * 4, outerGlowPaint);
      
      // 중간 글로우
      final midGlowPaint = Paint()
        ..color = const Color(0xFF0088FF).withOpacity(maxOpacity * fadeOpacity * 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, lightSize * 2.5, midGlowPaint);
      
      // 내부 글로우 (밝은 중심)
      final innerGlowPaint = Paint()
        ..color = const Color(0xFF00AAFF).withOpacity(maxOpacity * fadeOpacity * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, lightSize, innerGlowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DandelionLightsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
