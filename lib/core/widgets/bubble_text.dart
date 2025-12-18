import 'dart:math';
import 'package:flutter/material.dart';

/// Text widget with floating bubble effect (bubbles appear only within text bounds)
class BubbleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int bubbleCount;
  final Color bubbleColor;

  const BubbleText({
    super.key,
    required this.text,
    this.style,
    this.bubbleCount = 4, // Few bubbles
    this.bubbleColor = const Color(0xFF87CEEB), // Light sky blue
  });

  @override
  State<BubbleText> createState() => _BubbleTextState();
}

class _BubbleTextState extends State<BubbleText> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> _bubbles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _bubbles = List.generate(widget.bubbleCount, (_) => _createBubble());
  }

  Bubble _createBubble() {
    return Bubble(
      x: _random.nextDouble(),
      startY: 0.8 + _random.nextDouble() * 0.2, // Start at bottom of text
      size: _random.nextDouble() * 3.0 + 2.0, // Doubled: 2.0-5.0 (was 1.0-2.5)
      speed: _random.nextDouble() * 0.3 + 0.2,
      opacity: _random.nextDouble() * 0.15 + 0.1, // Very subtle: 0.1-0.25
      delay: _random.nextDouble(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Just return Text with bubble effect behind it (no clipping that cuts text)
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bubbles behind text
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BubblePainter(
                bubbles: _bubbles,
                progress: _controller.value,
                color: widget.bubbleColor,
                style: widget.style,
                text: widget.text,
              ),
              size: Size.zero,
            );
          },
        ),
        // Text on top (not clipped)
        Text(
          widget.text,
          style: widget.style,
        ),
      ],
    );
  }
}

class Bubble {
  double x;
  double startY;
  final double size;
  final double speed;
  final double opacity;
  final double delay;

  Bubble({
    required this.x,
    required this.startY,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.delay,
  });
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double progress;
  final Color color;
  final TextStyle? style;
  final String text;

  BubblePainter({
    required this.bubbles,
    required this.progress,
    required this.color,
    required this.style,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Measure text to get bounds
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    
    final paint = Paint()..style = PaintingStyle.fill;

    for (final bubble in bubbles) {
      // Calculate bubble position with delay
      final adjustedProgress = (progress + bubble.delay) % 1.0;
      
      // Bubble rises from bottom to top within text area
      final yPos = textHeight * (bubble.startY - adjustedProgress * (bubble.startY + 0.2));
      
      // Skip if outside text bounds
      if (yPos < 0 || yPos > textHeight) continue;
      
      // X position within text width
      final xPos = bubble.x * textWidth;
      
      // Fade based on vertical position
      double fadeOpacity = bubble.opacity;
      // Fade out at top
      if (yPos < textHeight * 0.3) {
        fadeOpacity *= (yPos / (textHeight * 0.3));
      }
      // Fade in at bottom
      if (yPos > textHeight * 0.7) {
        fadeOpacity *= ((textHeight - yPos) / (textHeight * 0.3));
      }
      
      paint.color = color.withOpacity(fadeOpacity.clamp(0.0, 0.3));
      
      // Slight horizontal wobble
      final wobble = sin(adjustedProgress * 3.14 * 4) * 1.5;
      
      canvas.drawCircle(
        Offset(xPos + wobble, yPos),
        bubble.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => true;
}
