import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A neon sign text effect widget with flickering glow animation
/// Inspired by the "no festival today" neon sign effect
class NeonText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color glowColor;
  final double blurRadius;
  final bool enableFlicker;

  const NeonText({
    super.key,
    required this.text,
    this.style,
    this.glowColor = const Color(0xFF00FFFF), // Cyan neon
    this.blurRadius = 20.0,
    this.enableFlicker = true,
  });

  @override
  State<NeonText> createState() => _NeonTextState();
}

class _NeonTextState extends State<NeonText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final math.Random _random = math.Random();
  double _flickerOpacity = 1.0;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    
    if (widget.enableFlicker) {
      _startFlicker();
    }
  }

  void _startFlicker() async {
    while (mounted && widget.enableFlicker) {
      // Random flicker timing (2~8초 간격)
      await Future.delayed(Duration(milliseconds: _random.nextInt(6000) + 2000));
      
      if (mounted) {
        setState(() {
          // Random flicker intensity
          final flickerChance = _random.nextDouble();
          if (flickerChance < 0.1) {
            // Occasional strong flicker
            _flickerOpacity = 0.3 + _random.nextDouble() * 0.3;
          } else if (flickerChance < 0.3) {
            // Subtle flicker
            _flickerOpacity = 0.7 + _random.nextDouble() * 0.3;
          } else {
            // Normal brightness
            _flickerOpacity = 0.9 + _random.nextDouble() * 0.1;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 50),
      opacity: _flickerOpacity,
      child: Stack(
        children: [
          // Outer glow layer 1 (largest, most diffuse)
          Text(
            widget.text,
            style: baseStyle.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..color = widget.glowColor.withOpacity(0.3),
              shadows: [
                Shadow(
                  color: widget.glowColor.withOpacity(0.8),
                  blurRadius: widget.blurRadius * 2,
                ),
                Shadow(
                  color: widget.glowColor.withOpacity(0.6),
                  blurRadius: widget.blurRadius * 1.5,
                ),
              ],
            ),
          ),
          // Outer glow layer 2 (medium)
          Text(
            widget.text,
            style: baseStyle.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..color = widget.glowColor.withOpacity(0.5),
              shadows: [
                Shadow(
                  color: widget.glowColor.withOpacity(0.7),
                  blurRadius: widget.blurRadius,
                ),
              ],
            ),
          ),
          // Inner bright core
          Text(
            widget.text,
            style: baseStyle.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  color: widget.glowColor,
                  blurRadius: widget.blurRadius * 0.5,
                ),
                Shadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
