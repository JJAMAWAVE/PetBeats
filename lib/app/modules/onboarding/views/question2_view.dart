import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/onboarding_controller.dart';
import '../../../routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/services/haptic_service.dart';

class Question2View extends StatefulWidget {
  const Question2View({super.key});

  @override
  State<Question2View> createState() => _Question2ViewState();
}

class _Question2ViewState extends State<Question2View> with TickerProviderStateMixin {
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
    final hapticService = Get.find<HapticService>();
    
    final options = [
      {'value': 'dog', 'label': '강아지', 'icon': 'assets/icons/icon_species_dog.png'},
      {'value': 'cat', 'label': '고양이', 'icon': 'assets/icons/icon_species_cat.png'},
      {'value': 'owner', 'label': '보호자', 'icon': 'assets/icons/icon_species_owner.png'},
    ];

    return Scaffold(
      body: Stack(
        children: [
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
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  Text(
                    '누구를 위한\n케어인가요?',
                    style: GoogleFonts.notoSans(
                      fontSize: 28,
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
                  
                  const SizedBox(height: 40),
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Obx(() {
                            final option = options[index];
                            final value = option['value'] as String;
                            final isSelected = controller.species.contains(value);
                            
                            return _buildOptionButton(
                              label: option['label'] as String,
                              iconPath: option['icon'] as String,
                              isSelected: isSelected,
                              onTap: () {
                                hapticService.lightImpact();
                                // Toggle selection with max 3 limit
                                if (isSelected) {
                                  // Remove if already selected
                                  controller.species.remove(value);
                                } else {
                                  // Add if not at max limit (3)
                                  if (controller.species.length < 3) {
                                    controller.species.add(value);
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
                  
                  Obx(() {
                    final hasSelection = controller.species.isNotEmpty;
                    
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
                                  hapticService.lightImpact();
                                  controller.completeOnboarding();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasSelection
                                ? AppColors.primaryBlue
                                : AppColors.primaryBlue.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            elevation: hasSelection ? 8 : 0,
                            shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.3),
                            disabledForegroundColor: Colors.white.withOpacity(0.5),
                          ),
                          child: Text(
                            '시작하기',
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
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.lineLightBlue,
            width: isSelected ? 2.0 : 1.5,
          ),
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
            SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
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

class _DandelionLightsPainter extends CustomPainter {
  final double animationValue;

  _DandelionLightsPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
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
      final startY = light['y'] as double;
      final speed = light['speed'] as double;
      final lightSize = light['size'] as double;
      final maxOpacity = light['opacity'] as double;
      
      double currentY = (startY + animationValue * speed) % 1.5;
      final animatedY = currentY - 0.2;
      
      if (animatedY < -0.2 || animatedY > 1.2) continue;
      
      final position = Offset(size.width * x, size.height * animatedY);
      
      double fadeOpacity = 1.0;
      if (animatedY < 0.1) {
        fadeOpacity = (animatedY + 0.2) / 0.3;
      } else if (animatedY > 0.9) {
        fadeOpacity = (1.2 - animatedY) / 0.3;
      }
      fadeOpacity = fadeOpacity.clamp(0.0, 1.0);
      
      final outerGlowPaint = Paint()
        ..color = const Color(0xFF0055FF).withOpacity(maxOpacity * fadeOpacity * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, lightSize * 4, outerGlowPaint);
      
      final midGlowPaint = Paint()
        ..color = const Color(0xFF0088FF).withOpacity(maxOpacity * fadeOpacity * 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, lightSize * 2.5, midGlowPaint);
      
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
