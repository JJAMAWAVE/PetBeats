import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final List<Color> gradientColors;
  final BorderRadius borderRadius;
  final bool isActive;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
    required this.gradientColors,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.isActive = true,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: widget.borderWidth,
          ),
        ),
        child: widget.child,
      );
    }

    return CustomPaint(
      foregroundPainter: _GradientBorderPainter(
        borderWidth: widget.borderWidth,
        gradientColors: widget.gradientColors,
        borderRadius: widget.borderRadius,
        animationValue: _controller,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.borderWidth), // Border space
        child: widget.child,
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double borderWidth;
  final List<Color> gradientColors;
  final BorderRadius borderRadius;
  final Animation<double> animationValue;

  _GradientBorderPainter({
    required this.borderWidth,
    required this.gradientColors,
    required this.borderRadius,
    required this.animationValue,
  }) : super(repaint: animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);

    // Create a sweep gradient that rotates
    final startAngle = animationValue.value * 2 * math.pi;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 2 * math.pi,
        colors: [...gradientColors, gradientColors.first],
        transform: GradientRotation(startAngle),
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return true;
  }
}
