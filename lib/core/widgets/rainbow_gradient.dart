import 'package:flutter/material.dart';

/// Animated rainbow gradient container that can be applied to any widget
/// Replicates CSS rainbow mixin with sliding animation
class AnimatedRainbowGradient extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final BorderRadius? borderRadius;
  final double opacity;
  final bool enabled;

  const AnimatedRainbowGradient({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.borderRadius,
    this.opacity = 1.0,
    this.enabled = true,
  });

  @override
  State<AnimatedRainbowGradient> createState() => _AnimatedRainbowGradientState();
}

class _AnimatedRainbowGradientState extends State<AnimatedRainbowGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Blue gradient colors (replacing rainbow)
  static const List<Color> rainbowColors = [
    Color(0xFF1A237E), // Deep Indigo
    Color(0xFF303F9F), // Indigo
    Color(0xFF3F51B5), // Primary Blue
    Color(0xFF5C6BC0), // Light Indigo
    Color(0xFF29B6F6), // Light Blue
    Color(0xFF03A9F4), // Cyan Blue
    Color(0xFF0288D1), // Dark Cyan
    Color(0xFF1A237E), // Deep Indigo (repeat for seamless)
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedRainbowGradient oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Seamless loop using sine wave for smooth transition
        final offset = _controller.value * 4.0; // Increased range for smooth motion
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1.5 + offset, -0.5),
              end: Alignment(1.5 + offset, 0.5),
              colors: rainbowColors.map((c) => c.withOpacity(widget.opacity)).toList(),
              stops: const [0.0, 0.14, 0.28, 0.42, 0.56, 0.70, 0.84, 1.0],
              tileMode: TileMode.mirror, // Mirror for seamless loop
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// PRO Badge with animated blue gradient effect
class RainbowProBadge extends StatelessWidget {
  final double fontSize;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Duration animationDuration;

  const RainbowProBadge({
    super.key,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    this.borderRadius = const BorderRadius.all(Radius.circular(7)),
    this.animationDuration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRainbowGradient(
      duration: animationDuration,
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3F51B5).withOpacity(0.4), // Blue shadow
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'PRO',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Text with rainbow gradient effect (clip text style)
class RainbowText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const RainbowText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<RainbowText> createState() => _RainbowTextState();
}

class _RainbowTextState extends State<RainbowText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + (_controller.value * 2), 0),
              end: Alignment(1.0 + (_controller.value * 2), 0),
              colors: _AnimatedRainbowGradientState.rainbowColors,
              tileMode: TileMode.repeated,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: (widget.style ?? const TextStyle()).copyWith(
              color: Colors.white, // Shader will override this
            ),
          ),
        );
      },
    );
  }
}
