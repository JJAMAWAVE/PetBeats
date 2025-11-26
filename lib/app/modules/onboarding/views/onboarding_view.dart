import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';
import '../../../data/services/haptic_service.dart';

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
    try {
      Get.find<HapticService>().lightImpact();
    } catch (e) {
      // ignore
    }
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
                    physics: const BouncingScrollPhysics(),
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
                          if (index == 1)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: _WindEffectOverlay(
                                  active: controller.pageIndex == 1,
                                ),
                              ),
                            ),
                          if (index == 2)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: _HeartBeatOverlay(
                                  active: controller.pageIndex == 2,
                                ),
                              ),
                            ),
                          if (index == 3)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: _ResonanceOverlay(
                                  active: controller.pageIndex == 3,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0), // Reduced horizontal padding
            child: FittedBox(
              fit: BoxFit.scaleDown,
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

// 바람 효과 오버레이 (2번째 온보딩 이미지용)
class _WindEffectOverlay extends StatefulWidget {
  final bool active;
  const _WindEffectOverlay({required this.active});

  @override
  State<_WindEffectOverlay> createState() => _WindEffectOverlayState();
}

class _WindEffectOverlayState extends State<_WindEffectOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // 8초 주기로 더 느리게 바람 흐름
    )..repeat();
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
          painter: _WindPainter(
            progress: _controller.value,
            color: const Color(0xFF0055FF),
          ),
        );
      },
    );
  }
}

class _WindPainter extends CustomPainter {
  final double progress;
  final Color color;

  _WindPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 여러 개의 바람 라인 생성 (5개)
    for (int i = 0; i < 5; i++) {
      _drawWindLine(canvas, size, i);
    }
  }

  void _drawWindLine(Canvas canvas, Size size, int index) {
    // 각 바람 라인마다 시작 시간을 다르게 (0.15씩 차이로 더 자연스럽게)
    final double offset = (index * 0.15);
    final double lineProgress = (progress + offset) % 1.0;
    
    // 페이드 인/아웃 효과
    double opacity = 0.0;
    if (lineProgress < 0.2) {
      opacity = lineProgress / 0.2; // 페이드 인
    } else if (lineProgress > 0.8) {
      opacity = (1.0 - lineProgress) / 0.2; // 페이드 아웃
    } else {
      opacity = 1.0; // 완전히 보임
    }
    
    // 투명도가 0이면 그리지 않음
    if (opacity <= 0.0) return;
    
    // 바람 경로 생성 (부드러운 곡선)
    final Path windPath = Path();
    
    // 시작 위치 (왼쪽에서 오른쪽으로 흐름, 중앙 영역 통과)
    final double startX = -size.width * 0.3 + (size.width * 1.6 * lineProgress);
    final double yPosition = size.height * (0.35 + index * 0.08); // 중앙 영역 (0.35~0.67)
    
    windPath.moveTo(startX, yPosition);
    
    // 곡선 경로 그리기 (더 많은 웨이브로 자연스럽게)
    final int waveCount = 4;
    final double waveWidth = size.width * 0.12;
    final double waveHeight = size.height * 0.04; // 더 부드러운 웨이브
    
    for (int j = 0; j < waveCount; j++) {
      final double x1 = startX + (waveWidth * j * 2);
      final double x2 = startX + (waveWidth * (j * 2 + 1));
      final double x3 = startX + (waveWidth * (j * 2 + 2));
      
      windPath.quadraticBezierTo(
        x1 + waveWidth / 2, yPosition - waveHeight,
        x2, yPosition,
      );
      windPath.quadraticBezierTo(
        x2 + waveWidth / 2, yPosition + waveHeight,
        x3, yPosition,
      );
    }
    
    // 바람 라인 페인트 (메인)
    final Paint windPaint = Paint()
      ..color = color.withOpacity(opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(windPath, windPaint);
    
    // 바람 라인 페인트 (글로우 효과)
    final Paint glowPaint = Paint()
      ..color = color.withOpacity(opacity * 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    canvas.drawPath(windPath, glowPaint);
    
    // 바람 라인 주변에 작은 파티클 추가
    final PathMetrics pathMetrics = windPath.computeMetrics();
    for (PathMetric metric in pathMetrics) {
      // 경로를 따라 3개의 파티클 배치
      for (int k = 0; k < 3; k++) {
        final double particlePos = (k / 3.0);
        final double distance = metric.length * particlePos;
        final Tangent? tangent = metric.getTangentForOffset(distance);
        
        if (tangent != null) {
          final Offset pos = tangent.position;
          
          // 파티클 글로우
          final Paint particlePaint = Paint()
            ..color = color.withOpacity(opacity * 0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
            ..style = PaintingStyle.fill;
          
          canvas.drawCircle(pos, 3.0, particlePaint);
          
          // 파티클 코어
          final Paint corePaint = Paint()
            ..color = Colors.white.withOpacity(opacity * 0.8)
            ..style = PaintingStyle.fill;
          
          canvas.drawCircle(pos, 1.0, corePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WindPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// 하트 박동 효과 오버레이 (3번째 온보딩 이미지용)
class _HeartBeatOverlay extends StatefulWidget {
  final bool active;
  const _HeartBeatOverlay({required this.active});

  @override
  State<_HeartBeatOverlay> createState() => _HeartBeatOverlayState();
}

class _HeartBeatOverlayState extends State<_HeartBeatOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // 심장 박동 주기 (1.2초)
    )..repeat();

    // 심장 박동 커브: 빠르게 커졌다가 천천히 작아짐
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 50, // 잠시 멈춤
      ),
    ]).animate(_controller);
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
          painter: _HeartBeatPainter(
            scale: _scaleAnimation.value,
            progress: _controller.value,
            color: const Color(0xFF0055FF),
          ),
        );
      },
    );
  }
}

class _HeartBeatPainter extends CustomPainter {
  final double scale;
  final double progress;
  final Color color;

  _HeartBeatPainter({
    required this.scale,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // 하트 크기 (기준)
    final double heartSize = size.width * 0.216; // 하트 크기 1.8배 증가
    
    // 박동에 따른 투명도 계산
    double opacity = 0.0;
    if (progress < 0.2) {
      opacity = progress / 0.2 * 0.6; // 페이드 인
    } else if (progress < 0.5) {
      opacity = 0.6; // 유지
    } else {
      opacity = (1.0 - progress) / 0.5 * 0.6; // 페이드 아웃
    }

    // 글로우 효과 (여러 겹)
    for (int i = 0; i < 3; i++) {
      final double glowScale = scale + (i * 0.05);
      final double glowOpacity = opacity * (1.0 - i * 0.3);
      
      final Paint glowPaint = Paint()
        ..color = color.withOpacity(glowOpacity * 0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 + i * 5.0)
        ..style = PaintingStyle.fill;
      
      final Path heartPath = _createHeartPath(center, heartSize * glowScale);
      canvas.drawPath(heartPath, glowPaint);
    }
    
    // 메인 하트 외각선 제거 (글로우만 유지)
  }

  Path _createHeartPath(Offset center, double size) {
    final Path path = Path();
    
    // 하트를 위로 이동 (center.dy - size * 0.3)
    
    // 하트 모양 그리기 (수학적 하트 곡선)
    final double x = center.dx;
    final double y = center.dy - size * 0.4; // 위로 이동
    
    path.moveTo(x, y + size * 0.3);
    
    // 왼쪽 상단 곡선
    path.cubicTo(
      x - size * 0.5, y - size * 0.3,
      x - size * 0.8, y + size * 0.1,
      x - size * 0.4, y + size * 0.6,
    );
    
    // 하단 꼭지점
    path.lineTo(x, y + size * 0.9);
    
    // 오른쪽으로
    path.lineTo(x + size * 0.4, y + size * 0.6);
    
    // 오른쪽 상단 곡선
    path.cubicTo(
      x + size * 0.8, y + size * 0.1,
      x + size * 0.5, y - size * 0.3,
      x, y + size * 0.3,
    );
    
    path.close();
    
    return path;
  }

  @override
  bool shouldRepaint(covariant _HeartBeatPainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.progress != progress;
  }
}

// 공명 효과 오버레이 (4번째 온보딩 이미지용 - Resonate Together)
class _ResonanceOverlay extends StatefulWidget {
  final bool active;
  const _ResonanceOverlay({required this.active});

  @override
  State<_ResonanceOverlay> createState() => _ResonanceOverlayState();
}

class _ResonanceOverlayState extends State<_ResonanceOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // 6초 주기로 더 느리게
    )..repeat();
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
          painter: _ResonancePainter(
            progress: _controller.value,
            color: const Color(0xFF0055FF),
          ),
        );
      },
    );
  }
}

class _ResonancePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ResonancePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4;

    // 두 개의 파동 세트 그리기 (동기화 과정)
    // 첫 번째 파동은 정상적으로
    // 두 번째 파동은 위상이 다르게 시작했다가 점점 동기화됨
    
    // 동기화 정도 계산 (0~1, 처음엔 비동기, 끝에는 완전 동기화)
    final syncLevel = (math.sin(progress * math.pi * 2) + 1) / 2;
    
    // 두 번째 파동의 위상 차이 (점점 줄어듦)
    final phaseShift = (1.0 - syncLevel) * 0.5;

    // 각 세트당 3개의 원 그리기
    for (int set = 0; set < 2; set++) {
      for (int i = 0; i < 3; i++) {
        final double waveOffset = (i / 3.0);
        double waveProgress = (progress + waveOffset) % 1.0;
        
        // 두 번째 세트는 위상 차이 적용
        if (set == 1) {
          waveProgress = (waveProgress + phaseShift) % 1.0;
        }
        
        final radius = maxRadius * waveProgress;
        
        // 투명도 계산
        double opacity = 0.0;
        if (waveProgress < 0.1) {
          opacity = waveProgress / 0.1;
        } else if (waveProgress > 0.7) {
          opacity = (1.0 - waveProgress) / 0.3;
        } else {
          opacity = 1.0;
        }
        
        // 동기화 레벨에 따라 색상 변화
        Color waveColor = set == 0 
            ? color 
            : Color.lerp(color.withOpacity(0.6), color, syncLevel)!;
        
        // 원 그리기 (투명도 감소)
        final Paint paint = Paint()
          ..color = waveColor.withOpacity(opacity * 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        
        canvas.drawCircle(center, radius, paint);
        
        // 글로우 효과 (강도 감소)
        final Paint glowPaint = Paint()
          ..color = waveColor.withOpacity(opacity * 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        
        canvas.drawCircle(center, radius, glowPaint);
      }
    }
    
    // 동기화 순간 중심에서 빛나는 효과
    if (syncLevel > 0.8) {
      final syncIntensity = (syncLevel - 0.8) / 0.2;
      
      // 중심 글로우 (여러 겹)
      for (int i = 0; i < 5; i++) {
        final glowRadius = 20.0 + (i * 15.0);
        final glowOpacity = syncIntensity * (1.0 - i * 0.15);
        
        final Paint centralGlow = Paint()
          ..color = color.withOpacity(glowOpacity * 0.4)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15.0 + i * 5.0)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(center, glowRadius, centralGlow);
      }
      
      // 중심 별 효과 (십자가 형태)
      final Paint starPaint = Paint()
        ..color = Colors.white.withOpacity(syncIntensity * 0.8)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
      // 수평선
      canvas.drawLine(
        Offset(center.dx - 30, center.dy),
        Offset(center.dx + 30, center.dy),
        starPaint,
      );
      
      // 수직선
      canvas.drawLine(
        Offset(center.dx, center.dy - 30),
        Offset(center.dx, center.dy + 30),
        starPaint,
      );
    }
    
    // 파동 간섭 패턴 (두 파동이 만나는 지점에 파티클)
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8.0) * math.pi * 2;
      final particleProgress = (progress * 3 + i * 0.125) % 1.0;
      final distance = maxRadius * particleProgress;
      
      final x = center.dx + math.cos(angle) * distance;
      final y = center.dy + math.sin(angle) * distance;
      
      // 간섭 강도 (동기화될수록 강해짐)
      final interferenceIntensity = syncLevel * (1.0 - particleProgress);
      
      if (interferenceIntensity > 0.3) {
        final Paint particlePaint = Paint()
          ..color = color.withOpacity(interferenceIntensity * 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(Offset(x, y), 4.0, particlePaint);
        
        // 파티클 코어
        final Paint corePaint = Paint()
          ..color = Colors.white.withOpacity(interferenceIntensity * 0.9)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(Offset(x, y), 1.5, corePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ResonancePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

