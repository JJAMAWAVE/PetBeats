import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/species_theme.dart';
import '../../app/modules/home/controllers/home_controller.dart';

import 'dart:math' as math;

class BackgroundDecoration extends StatefulWidget {
  final Widget child;

  const BackgroundDecoration({Key? key, required this.child}) : super(key: key);

  @override
  State<BackgroundDecoration> createState() => _BackgroundDecorationState();
}

class _BackgroundDecorationState extends State<BackgroundDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ParticleModel> _particles = [];
  final int _particleCount = 20;

  // 강아지 색상 테마 (블루 계열)
  static const Color dogPrimaryColor = Color(0xFFDCEAF7);
  static const Color dogSecondaryColor = Color(0xFFE1EBF5);
  static const Color dogAccentColor = Color(0xFF9FA8DA);
  static const Color dogWaveColor = Color(0xFF2196F3);

  // 고양이 색상 테마 (퍼플 계열)
  static const Color catPrimaryColor = Color(0xFFE8E0F0);
  static const Color catSecondaryColor = Color(0xFFEDE7F6);
  static const Color catAccentColor = Color(0xFFB39DDB);
  static const Color catWaveColor = Color(0xFF7C4DFF);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // 파티클 초기화
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(ParticleModel.random());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // HomeController가 등록되어 있는지 확인
    if (!Get.isRegistered<HomeController>()) {
      // HomeController가 없으면 기본 강아지 테마 사용
      return _buildBackground(
        primaryColor: dogPrimaryColor,
        secondaryColor: dogSecondaryColor,
        accentColor: dogAccentColor,
        waveColor: dogWaveColor,
      );
    }

    // HomeController가 있으면 종에 따라 색상 변경
    return GetX<HomeController>(
      builder: (controller) {
        final isCat = controller.currentSpeciesTheme.value == SpeciesTheme.cat;
        
        return _buildBackground(
          primaryColor: isCat ? catPrimaryColor : dogPrimaryColor,
          secondaryColor: isCat ? catSecondaryColor : dogSecondaryColor,
          accentColor: isCat ? catAccentColor : dogAccentColor,
          waveColor: isCat ? catWaveColor : dogWaveColor,
        );
      },
    );
  }

  Widget _buildBackground({
    required Color primaryColor,
    required Color secondaryColor,
    required Color accentColor,
    required Color waveColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Stack(
        children: [
          // 1. Mesh Gradient Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  Colors.white,
                  secondaryColor,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          
          // 1.5. Dynamic Orbs
          Positioned(
            top: -100,
            right: -50,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentColor.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // 2. 은은한 빛 번짐 효과
          Positioned(
            top: 100,
            left: -40,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      waveColor.withOpacity(0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.2, 1.0],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),

          // 3. 소리 파동 패턴
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    color: waveColor.withOpacity(0.05),
                    waves: 3,
                    amplitude: 20,
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),

          // 3.5. 파티클 이펙트
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),

          // 4. 실제 콘텐츠
          widget.child,
        ],
      ),
    );
  }
}

// 파동 효과를 그리는 Painter
class WavePainter extends CustomPainter {
  final Color color;
  final int waves;
  final double amplitude;
  final double animationValue;

  WavePainter({
    required this.color,
    this.waves = 3,
    this.amplitude = 20.0,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < waves; i++) {
      final double shimmer = math.sin((animationValue * 2 * math.pi) + (i * 1.5));
      final double opacity = (0.05 + (0.03 * shimmer)).clamp(0.02, 0.1);
      
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      final path = Path();
      final yOffset = size.height * 0.5 + (i * 40);
      
      final int speed = 1 + i; 
      final phaseShift = i * (math.pi / 2);
      
      path.moveTo(0, yOffset);
      
      for (double x = 0; x <= size.width; x++) {
        double y = yOffset + 
            math.sin((x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi * speed) + phaseShift) * amplitude +
            math.sin((x / size.width * 4 * math.pi) + (animationValue * 4 * math.pi * speed)) * (amplitude * 0.3);
            
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.color != color;
  }
}

class ParticleModel {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double opacity;

  ParticleModel.random() {
    final random = math.Random();
    x = random.nextDouble();
    y = random.nextDouble();
    size = random.nextDouble() * 4 + 2;
    speed = random.nextDouble() * 0.2 + 0.05;
    opacity = random.nextDouble() * 0.5 + 0.3;
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;
  final double animationValue;

  ParticlePainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      double currentY = (particle.y - (particle.speed * animationValue * 5)) % 1.0;
      if (currentY < 0) currentY += 1.0;

      final position = Offset(
        particle.x * size.width,
        currentY * size.height,
      );

      final double twinkle = math.sin((animationValue * 10 + particle.x * 10) * math.pi);
      final double currentOpacity = (particle.opacity + (twinkle * 0.1)).clamp(0.0, 1.0);

      paint.color = Colors.white.withOpacity(currentOpacity);
      canvas.drawCircle(position, particle.size, paint);
      
      paint.color = Colors.white.withOpacity(currentOpacity * 0.3);
      canvas.drawCircle(position, particle.size * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
