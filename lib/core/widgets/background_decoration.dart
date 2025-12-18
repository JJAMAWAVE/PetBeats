import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';

import 'dart:math' as math;

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
    return Stack(
      children: [
        // 1. 배경은 SpeciesThemeTransition에서 처리 (ripple 애니메이션 지원)
        // 1. Mesh Gradient Background (Rich Blue & White)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFDCEAF7), // 진한 하늘색 (Top Left)
                Colors.white,            // 중앙 화이트
                const Color(0xFFE1EBF5), // 쿨 그레이 블루 (Bottom Right)
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        
        // 1.5. Dynamic Orbs (움직이는 빛망울 - 더 진하고 크게)
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF9FA8DA).withOpacity(0.25), // Indigo (보라빛)
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

        // 2. 은은한 빛 번짐 효과 (기존 유지, 위치 조정)
        Positioned(
          top: 100, // 위치 살짝 내림
          left: -40,
          child: Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryBlue.withOpacity(0.15),
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

        // 3. 소리 파동 패턴 (Sound Wave Pattern) - Animated
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  color: AppColors.primaryBlue.withOpacity(0.05),
                  waves: 3,
                  amplitude: 20,
                  animationValue: _controller.value,
                ),
              );
            },
          ),
        ),

        // 3.5. 파티클 이펙트 (Particles)
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

        // 3. 소리 파동 패턴 (Sound Wave Pattern) - Animated

        // 4. 실제 콘텐츠
        widget.child,
      ],
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
      // 불규칙한 빛 효과 (자연광)
      // 각 파동마다, 그리고 시간에 따라 투명도가 변함
      final double shimmer = math.sin((animationValue * 2 * math.pi) + (i * 1.5));
      final double opacity = (0.05 + (0.03 * shimmer)).clamp(0.02, 0.1);
      
      final paint = Paint()
        ..color = color.withOpacity(opacity) // 기본 색상보다 약간 더 밝거나 어둡게
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5; // 선 굵기 증가 (1.5 -> 2.5)

      final path = Path();
      final yOffset = size.height * 0.5 + (i * 40); // 파동 간격 약간 넓힘
      
      // 각 파동마다 속도와 위상을 다르게 설정
      // Loop가 자연스럽게 되려면 speed는 정수여야 함 (2*pi의 배수가 되어야 하므로)
      final int speed = 1 + i; 
      final phaseShift = i * (math.pi / 2);
      
      path.moveTo(0, yOffset);
      
      for (double x = 0; x <= size.width; x++) {
        // 사인파 공식 복합 적용
        double y = yOffset + 
            math.sin((x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi * speed) + phaseShift) * amplitude +
            math.sin((x / size.width * 4 * math.pi) + (animationValue * 4 * math.pi * speed)) * (amplitude * 0.3); // 작은 파동 추가
            
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
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
    size = random.nextDouble() * 4 + 2; // 크기 증가 (2 ~ 6)
    speed = random.nextDouble() * 0.2 + 0.05;
    opacity = random.nextDouble() * 0.5 + 0.3; // 투명도 증가 (0.3 ~ 0.8)
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
      // 위로 올라가는 움직임 구현
      // animationValue (0~1)가 계속 반복되므로, 이를 이용하여 y좌표를 계산
      // (초기y - 속도 * 시간) % 1.0 을 하면 1.0 -> 0.0 으로 자연스럽게 순환
      
      double currentY = (particle.y - (particle.speed * animationValue * 5)) % 1.0;
      if (currentY < 0) currentY += 1.0;

      final position = Offset(
        particle.x * size.width,
        currentY * size.height,
      );

      // 반짝이는 효과
      final double twinkle = math.sin((animationValue * 10 + particle.x * 10) * math.pi);
      final double currentOpacity = (particle.opacity + (twinkle * 0.1)).clamp(0.0, 1.0);

      paint.color = Colors.white.withOpacity(currentOpacity);
      
      // Glow 효과를 위해 마스크 필터 적용 (성능 주의)
      // 여기서는 간단히 원을 그림
      canvas.drawCircle(position, particle.size, paint);
      
      // 외곽 Glow
      paint.color = Colors.white.withOpacity(currentOpacity * 0.3);
      canvas.drawCircle(position, particle.size * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
