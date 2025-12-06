import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 원형 주파수 웨이브폼 페인터
class WaveformPainter extends CustomPainter {
  final List<double> frequencyData; // 64-128 주파수 빈
  final Gradient waveformGradient;
  final Color glowColor;
  final double rotationAngle; // 회전 각도 (라디안)
  final double energy; // 전체 에너지 (0.0-1.0)
  
  WaveformPainter({
    required this.frequencyData,
    required this.waveformGradient,
    required this.glowColor,
    this.rotationAngle = 0.0,
    this.energy = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.35; // 웨이브폼 기본 반지름
    
    if (frequencyData.isEmpty) return;

    // 주파수 데이터를 원형으로 배치
    final barCount = frequencyData.length;
    final angleStep = (2 * math.pi) / barCount;

    // 그라데이션 페인트 설정
    final gradientPaint = Paint()
      ..shader = waveformGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    // 글로우 효과를 위한 페인트
    final glowPaint = Paint()
      ..color = glowColor.withOpacity(0.6) // Increased from 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20) // Doubled blur
      ..style = PaintingStyle.fill;

    // 각 주파수 빈을 바로 그리기
    for (int i = 0; i < barCount; i++) {
      final angle = (i * angleStep) + rotationAngle;
      final barHeight = frequencyData[i] * radius * 0.6; // 최대 60% 확장
      
      // 바의 시작점 (원 중심에서 radius만큼 떨어진 지점)
      final startX = center.dx + radius * math.cos(angle);
      final startY = center.dy + radius * math.sin(angle);
      
      // 바의 끝점 (주파수 강도만큼 확장)
      final endX = center.dx + (radius + barHeight) * math.cos(angle);
      final endY = center.dy + (radius + barHeight) * math.sin(angle);

      // 바 그리기
      final path = Path();
      final barWidth = 4.0 + (energy * 4); // Doubled thickness: was 2.0 + energy*2
      
      // 사각형 바 대신 부채꼴 형태로
      final halfWidth = barWidth / 2;
      final perpAngle1 = angle + math.pi / 2;
      final perpAngle2 = angle - math.pi / 2;
      
      path.moveTo(
        startX + halfWidth * math.cos(perpAngle1),
        startY + halfWidth * math.sin(perpAngle1),
      );
      path.lineTo(
        endX + halfWidth * math.cos(perpAngle1),
        endY + halfWidth * math.sin(perpAngle1),
      );
      path.lineTo(
        endX + halfWidth * math.cos(perpAngle2),
        endY + halfWidth * math.sin(perpAngle2),
      );
      path.lineTo(
        startX + halfWidth * math.cos(perpAngle2),
        startY + halfWidth * math.sin(perpAngle2),
      );
      path.close();

      // 글로우 먼저 그리기
      canvas.drawPath(path, glowPaint);
      // 실제 바 그리기
      canvas.drawPath(path, gradientPaint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.frequencyData != frequencyData ||
        oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.energy != energy;
  }
}
