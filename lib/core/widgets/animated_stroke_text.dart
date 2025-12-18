import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Animated text that draws stroke along text path (like SVG line animation)
/// Combined with neon glow effect
class AnimatedStrokeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color strokeColor;
  final Color glowColor;
  final double strokeWidth;
  final Duration duration;
  final bool repeat;
  final Curve curve;
  final bool showUnderlines;
  final Duration? resetInterval; // Restart animation from beginning after this interval

  const AnimatedStrokeText({
    super.key,
    required this.text,
    this.style,
    this.strokeColor = Colors.white,
    this.glowColor = const Color(0xFF00BFFF), // Cyan
    this.strokeWidth = 2.0,
    this.duration = const Duration(milliseconds: 2000),
    this.repeat = false,
    this.curve = Curves.easeInOut,
    this.showUnderlines = true,
    this.resetInterval, // e.g., Duration(seconds: 4)
  });

  @override
  State<AnimatedStrokeText> createState() => _AnimatedStrokeTextState();
}

class _AnimatedStrokeTextState extends State<AnimatedStrokeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    
    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
    
    // Setup reset timer if interval is provided
    if (widget.resetInterval != null) {
      _resetTimer = Timer.periodic(widget.resetInterval!, (_) {
        _controller.reset();
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _StrokeTextPainter(
            text: widget.text,
            style: baseStyle,
            strokeColor: widget.strokeColor,
            glowColor: widget.glowColor,
            strokeWidth: widget.strokeWidth,
            progress: _animation.value,
            showUnderlines: widget.showUnderlines,
          ),
          size: _calculateTextSize(widget.text, baseStyle),
        );
      },
    );
  }

  Size _calculateTextSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }
}

class _StrokeTextPainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final Color strokeColor;
  final Color glowColor;
  final double strokeWidth;
  final double progress;
  final bool showUnderlines;

  _StrokeTextPainter({
    required this.text,
    required this.style,
    required this.strokeColor,
    required this.glowColor,
    required this.strokeWidth,
    required this.progress,
    this.showUnderlines = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = strokeColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Calculate how many characters to show based on progress
    final visibleChars = (text.length * progress).ceil();
    final visibleText = text.substring(0, visibleChars);
    
    if (visibleText.isEmpty) return;

    // Draw glow layers (outer to inner)
    for (int i = 3; i >= 0; i--) {
      final glowPainter = TextPainter(
        text: TextSpan(
          text: visibleText,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth + (i * 3)
              ..color = glowColor.withOpacity(0.1 + (progress * 0.1))
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, (i + 1) * 4.0),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      glowPainter.paint(canvas, Offset.zero);
    }

    // Draw stroke text
    final strokePainter = TextPainter(
      text: TextSpan(
        text: visibleText,
        style: style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = strokeColor.withOpacity(0.3 + (progress * 0.7)),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    strokePainter.paint(canvas, Offset.zero);

    // Draw filled text with gradient fade
    final fillPainter = TextPainter(
      text: TextSpan(
        text: visibleText,
        style: style.copyWith(
          color: Colors.white.withOpacity(progress),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    fillPainter.paint(canvas, Offset.zero);

    // Add underline decorations (like SVG)
    _drawUnderlineDecorations(canvas, textPainter.width, textPainter.height);
  }

  void _drawUnderlineDecorations(Canvas canvas, double width, double height) {
    if (!showUnderlines || progress < 0.5) return;
    
    final underlineProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
    final colors = [
      const Color(0xFFDA70D6), // Plum
      const Color(0xFF00BFFF), // Blue
      const Color(0xFF8A2BE2), // Purple
      const Color(0xFF32CD32), // Lime
    ];
    
    for (int i = 0; i < colors.length; i++) {
      final lineWidth = width * underlineProgress;
      final y = height + 4 + (i * 4);
      
      final paint = Paint()
        ..color = colors[i].withOpacity(underlineProgress)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(
        Offset(0, y),
        Offset(lineWidth, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StrokeTextPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
