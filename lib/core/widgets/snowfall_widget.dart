import 'dart:math';
import 'package:flutter/material.dart';

/// Snowfall animation widget - Christmas snow effect
class SnowfallWidget extends StatefulWidget {
  final int snowflakeCount;
  final Color snowColor;
  final double maxSnowflakeSize;

  const SnowfallWidget({
    super.key,
    this.snowflakeCount = 50,
    this.snowColor = Colors.white,
    this.maxSnowflakeSize = 4.0,
  });

  @override
  State<SnowfallWidget> createState() => _SnowfallWidgetState();
}

class _SnowfallWidgetState extends State<SnowfallWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Snowflake> _snowflakes;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _snowflakes = List.generate(
      widget.snowflakeCount,
      (_) => _createSnowflake(),
    );
  }

  Snowflake _createSnowflake() {
    return Snowflake(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * widget.maxSnowflakeSize + 1,
      speed: _random.nextDouble() * 0.3 + 0.2, // Slower speed
      opacity: _random.nextDouble() * 0.4 + 0.2, // Softer opacity
      drift: _random.nextDouble() * 0.01,
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
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SnowfallPainter(
            snowflakes: _snowflakes,
            progress: _controller.value,
            color: widget.snowColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Snowflake {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double drift;

  Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
  });
}

class SnowfallPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final double progress;
  final Color color;

  SnowfallPainter({
    required this.snowflakes,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final flake in snowflakes) {
      // Simple y position calculation
      final y = (flake.y + progress * flake.speed) % 1.0;
      // Gentle horizontal drift
      final x = flake.x + sin(progress * 2 * pi) * flake.drift;

      paint.color = color.withOpacity(flake.opacity);

      canvas.drawCircle(
        Offset(x.clamp(0.0, 1.0) * size.width, y * size.height),
        flake.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SnowfallPainter oldDelegate) => true;
}
