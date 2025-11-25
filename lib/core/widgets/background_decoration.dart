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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
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
        // 1. 배경 그라데이션 (Deep Blue Gradient)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundGradientStart,
                AppColors.backgroundGradientEnd,
              ],
            ),
          ),
        ),
        
        // 2. 은은한 빛 번짐 효과 (Glow)
        Positioned(
          top: -100,
          left: 0,
          right: 0,
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
