import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../../app/data/services/haptic_service.dart';
import 'dart:async';
import 'dart:math' as math;

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _textController;
  late AnimationController _transitionController; // 전환 애니메이션
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;
  late Animation<Offset> _slideAnimation;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    // Ripple Animation (Faster: 2.0s -> 1.6s)
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat();

    // Text Animations (Faster: 2000ms -> 1600ms)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    // Transition Animation (Faster: 3.0s -> 2.5s)
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _textController.forward();
    
    // Initial Haptic
    Get.find<HapticService>().lightImpact();

    // Trigger transition after 2.5 seconds (Faster)
    Timer(const Duration(milliseconds: 2500), () {
      _startTransition();
    });
  }

  void _startTransition() {
    if (_isTransitioning) return;
    
    setState(() {
      _isTransitioning = true;
    });

    Get.find<HapticService>().mediumImpact();
    _transitionController.forward();
    
    // Navigate to Home after animation covers screen (Faster: 1800ms -> 1500ms)
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _textController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient Animation (Subtle breathing - Pastel Blue)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rippleController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.5 + (math.sin(_rippleController.value * 2 * math.pi) * 0.1),
                      colors: [
                        Colors.white,
                        AppColors.pastelBlueStart, // Light Blue 50
                        AppColors.pastelBlueEnd.withOpacity(0.3), // Light Blue 100 tint
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premium Ripple Animation (Pastel Blue)
                SizedBox(
                  width: 120,
                  height: 120,
                  child: AnimatedBuilder(
                    animation: _rippleController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _RipplePainter(
                          animationValue: _rippleController.value,
                          color: AppColors.pastelBlueAccent, // Light Blue 200 for ripple
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 48),
                
                // Staggered Text Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation1,
                        child: Text(
                          '당신의 선택에 맞춰',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textGrey,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnimation2,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.pastelBlueAccent, AppColors.primaryBlue], // Blue Gradient Text
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'UX를 구성합니다',
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Required for ShaderMask
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Screen Fill Transition Animation (Pastel Blue Bloom)
          if (_isTransitioning)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _transitionController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ScreenFillTransitionPainter(
                        animationValue: _transitionController.value,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _RipplePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw 3 ripple circles
    for (int i = 0; i < 3; i++) {
      final double progress = (animationValue + (i * 0.33)) % 1.0;
      final double opacity = (1.0 - progress).clamp(0.0, 1.0);
      final double radius = progress * maxRadius;

      final paint = Paint()
        ..color = color.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
      
      // Fill effect for the innermost circle
      if (i == 0) {
        final fillPaint = Paint()
          ..color = color.withOpacity(opacity * 0.1)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, radius, fillPaint);
      }
    }
    
    // Center Core
    final corePaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
    canvas.drawCircle(center, 8 + (math.sin(animationValue * 2 * math.pi) * 2), corePaint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}

// Screen Fill Transition Painter (Pastel Blue Bloom)
class ScreenFillTransitionPainter extends CustomPainter {
  final double animationValue;

  ScreenFillTransitionPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Calculate max radius to cover the entire screen (diagonal)
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);

    // Use an exponential curve for the expansion to make it feel like "entering"
    final double progress = math.pow(animationValue, 2).toDouble();
    final double radius = maxRadius * progress;

    if (radius <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          AppColors.pastelBlueStart, // Light Blue 50
          AppColors.pastelBlueEnd, // Light Blue 100
          AppColors.pastelBlueAccent, // Light Blue 200
        ],
        stops: const [0.0, 0.5, 1.0],
        center: Alignment.center,
        radius: 1.0, // Relative to the circle being drawn
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(ScreenFillTransitionPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
