import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with TickerProviderStateMixin {
  final OnboardingController controller = Get.find<OnboardingController>();
  late AnimationController _rippleController;
  Offset? _ripplePosition;
  bool _showRipple = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    setState(() {
      _ripplePosition = details.localPosition;
      _showRipple = true;
    });
    
    _rippleController.forward(from: 0.0).then((_) {
      setState(() {
        _showRipple = false;
      });
      _rippleController.reset();
    });
    
    // Navigate after showing ripple
    Future.delayed(const Duration(milliseconds: 200), () {
      controller.nextSlide();
    });
  }

  @override
  Widget build(BuildContext context) {
    // V2 Slides Data
    final List<Map<String, String>> slides = [
      {
        "title": "A Shelter in the Noise",
        "desc": "시끄러운 세상 속, 보호자님의 사랑으로\n아이에게 평온한 쉼터를 선물하세요.",
        "image": "assets/images/onboarding/step1_shelter.png"
      },
      {
        "title": "Bio-Acoustic Design",
        "desc": "사람보다 예민한 아이들을 위해,\n뇌파를 안정시키는 특수 음향을 설계했습니다.",
        "image": "assets/images/onboarding/step2_brainwave_v4.png"
      },
      {
        "title": "Therapy Beyond Sound",
        "desc": "음악 그 이상입니다.\n심장 박동을 닮은 진동이 깊은 안정을 줍니다.",
        "image": "assets/images/onboarding/step3_vibration_v3.png"
      },
      {
        "title": "Resonate Together",
        "desc": "아이를 품에 안고 느껴보세요.\n심장이 맞춰지는 순간, 진정한 치유가 완성됩니다.",
        "image": "assets/images/onboarding/step4_resonance_v3.png"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient
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
          // Content layer with touch detection
          GestureDetector(
            onTapDown: _handleTap,
            behavior: HitTestBehavior.translucent,
            child: Column(
              children: [
                // 60% Image Area
                Expanded(
                  flex: 6,
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            child: Transform.scale(
                              scale: 0.8,
                              child: _BreathingImage(
                                imagePath: slides[index]["image"]!,
                              ),
                            ),
                          ),
                          if (index == 0)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: _GlowingPathOverlay(
                                  active: controller.pageIndex == 0,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                // Text Area (40%)
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Page Indicator moved here (above text)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            slides.length,
                            (i) => _IndicatorDot(
                              isActive: controller.pageIndex == i,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Animated Text Switcher
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: _AnimatedGradientText(
                            text: slides[controller.pageIndex]["title"]!,
                            key: ValueKey('title_${controller.pageIndex}'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Description
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            slides[controller.pageIndex]["desc"]!,
                            key: ValueKey('desc_${controller.pageIndex}'),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                              height: 1.6,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Touch ripple overlay
          if (_showRipple && _ripplePosition != null)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _rippleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: TouchRipplePainter(
                        center: _ripplePosition!,
                        progress: _rippleController.value,
                        color: const Color(0xFF0055FF),
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

class _AnimatedGradientText extends StatefulWidget {
  final String text;
  const _AnimatedGradientText({super.key, required this.text});

  @override
  State<_AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<_AnimatedGradientText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 3 seconds loop
    )..repeat();

    // Heartbeat-like curve: Slow start, fast middle, slow end with a bit of "back" effect
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFF0055FF), // Deep Blue
                Color(0xFF00BFFF), // Light Blue
                Color(0xFF0055FF), // Deep Blue
              ],
              stops: const [0.0, 0.5, 1.0],
              // Use the curved animation value
              begin: Alignment(-2.5 + (3.0 * _animation.value), 0.0),
              end: Alignment(-0.5 + (3.0 * _animation.value), 0.0),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Increased padding to prevent all clipping
            child: Text(
              widget.text,
              style: AppTextStyles.titleLarge.copyWith(
                color: Colors.white, // Required for ShaderMask
                fontSize: 32,
                height: 1.3, // Slightly increased line height to prevent vertical clipping
              ),
              textAlign: TextAlign.center,
              softWrap: false, // Force single line
            ),
          ),
        );
      },
    );
  }
}

class _IndicatorDot extends StatefulWidget {
  final bool isActive;
  const _IndicatorDot({required this.isActive});

  @override
  State<_IndicatorDot> createState() => _IndicatorDotState();
}

class _IndicatorDotState extends State<_IndicatorDot> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Fast blinking (0.8s loop)
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blinkController,
      builder: (context, child) {
        // Calculate dynamic shadow values for "blinking" effect
        // Opacity goes from 0.2 to 1.0
        final double opacity = widget.isActive 
            ? 0.2 + (_blinkController.value * 0.8) 
            : 0.0;
        
        // Blur goes from 4 to 12
        final double blur = widget.isActive 
            ? 4.0 + (_blinkController.value * 8.0) 
            : 0.0;
            
        // Spread goes from 1 to 4
        final double spread = widget.isActive 
            ? 1.0 + (_blinkController.value * 3.0) 
            : 0.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: widget.isActive ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: widget.isActive 
                ? const Color(0xFF0055FF) 
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(3),
            boxShadow: widget.isActive 
                ? [
                    BoxShadow(
                      color: const Color(0xFF0055FF).withOpacity(opacity),
                      blurRadius: blur,
                      spreadRadius: spread,
                    )
                  ] 
                : null,
          ),
        );
      },
    );
  }
}

class _BreathingImage extends StatefulWidget {
  final String imagePath;
  const _BreathingImage({required this.imagePath});

  @override
  State<_BreathingImage> createState() => _BreathingImageState();
}

class _BreathingImageState extends State<_BreathingImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // 4초 주기로 천천히 숨쉬기
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate( // 1.0 -> 1.05로 살짝 커짐
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          -0.5, -0.5, 0, 1, 0, // Alpha = 1 - (R+G)/2. Removes White (1,1), keeps Blue (0,0).
        ]),
        child: Image.asset(
          widget.imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _BreathingText extends StatefulWidget {
  @override
  State<_BreathingText> createState() => _BreathingTextState();
}

class _BreathingTextState extends State<_BreathingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Text(
            AppLocalizations.of(context)!.tapToStart, // Localized text
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }
}

class _GlowingPathOverlay extends StatefulWidget {
  final bool active;
  const _GlowingPathOverlay({required this.active});

  @override
  State<_GlowingPathOverlay> createState() => _GlowingPathOverlayState();
}

class _GlowingPathOverlayState extends State<_GlowingPathOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Path> _paths = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPaths();
  }

  void _initPaths() {
    _paths.clear();
    final size = MediaQuery.of(context).size;
    final w = size.width - 80; 
    final h = size.height * 0.6 - 80;

    // --- Existing Paths (Blue) ---
    // Path 1: Person Profile
    Path p1 = Path();
    p1.moveTo(w * 0.42, h * 0.85); 
    p1.quadraticBezierTo(w * 0.38, h * 0.55, w * 0.45, h * 0.4); 
    p1.cubicTo(w * 0.48, h * 0.3, w * 0.62, h * 0.3, w * 0.65, h * 0.45); 
    p1.quadraticBezierTo(w * 0.68, h * 0.55, w * 0.62, h * 0.65); 
    p1.quadraticBezierTo(w * 0.60, h * 0.75, w * 0.65, h * 0.85); 
    _paths.add(p1);

    // Path 2: Straight Line
    Path p2 = Path();
    p2.moveTo(0, h * 0.52); 
    p2.lineTo(w, h * 0.52);
    _paths.add(p2);

    // Path 3: Dome
    Path p3 = Path();
    p3.moveTo(w * 0.05, h * 0.85);
    p3.cubicTo(w * 0.05, -h * 0.05, w * 0.95, -h * 0.05, w * 0.95, h * 0.85);
    _paths.add(p3);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            paths: _paths,
            progress: _controller.value,
            color: const Color(0xFF0055FF),
          ),
        );
      },
    );
  }
}



class _ParticlePainter extends CustomPainter {
  final List<Path> paths;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.paths,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint glowPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..style = PaintingStyle.fill;

    final Paint corePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < paths.length; i++) {
      final PathMetrics pathMetrics = paths[i].computeMetrics();
      for (PathMetric metric in pathMetrics) {
        // Draw 2 particles per path
        for (int j = 0; j < 2; j++) {
          // Offset paths slightly so they aren't identical (i * 0.2)
          // Offset particles on the same path by 0.5 (j * 0.5) so they are opposite
          final double particleProgress = (progress + (i * 0.2) + (j * 0.5)) % 1.0;
          
          final double distance = metric.length * particleProgress;
          final Tangent? tangent = metric.getTangentForOffset(distance);
          
          if (tangent != null) {
            final Offset pos = tangent.position;
            
            // Draw Glow
            canvas.drawCircle(pos, 6.0, glowPaint);
            // Draw Core
            canvas.drawCircle(pos, 2.0, corePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// 작은 터치 ripple painter
class TouchRipplePainter extends CustomPainter {
  final Offset center;
  final double progress;
  final Color color;

  TouchRipplePainter({
    required this.center,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Larger max radius for better visibility - 150 pixels
    const maxRadius = 150.0;
    final radius = maxRadius * progress;
    
    // Higher opacity for better visibility
    final opacity = (1.0 - progress) * 0.6;
    
    final paint = Paint()
      ..color = color.withOpacity(opacity * 1.5)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, paint);
    
    // Add a more visible ring effect
    final ringPaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
      
    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(TouchRipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.center != center;
  }
}


