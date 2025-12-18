import 'dart:math';
import 'package:flutter/material.dart';

/// Global floating particle effect overlay for the entire app
class GlobalParticleOverlay extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;
  final double maxParticleSize;
  final bool enabled;

  const GlobalParticleOverlay({
    super.key,
    required this.child,
    this.particleCount = 40,
    this.particleColor = const Color(0xFF87CEEB), // Light sky blue
    this.maxParticleSize = 8.0,
    this.enabled = true,
  });

  @override
  State<GlobalParticleOverlay> createState() => _GlobalParticleOverlayState();
}

class _GlobalParticleOverlayState extends State<GlobalParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(widget.particleCount, (_) => _createParticle());
  }

  Particle _createParticle() {
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * widget.maxParticleSize + 2,
      speedX: (_random.nextDouble() - 0.5) * 0.02,
      speedY: (_random.nextDouble() - 0.5) * 0.02 - 0.01, // Slight upward bias
      opacity: _random.nextDouble() * 0.35 + 0.1, // 0.1-0.45 opacity
      wobbleOffset: _random.nextDouble() * 6.28, // Random start phase
      wobbleSpeed: _random.nextDouble() * 2 + 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Stack(
      children: [
        widget.child,
        // Particle overlay (non-interactive)
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    progress: _controller.value,
                    color: widget.particleColor,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final double opacity;
  final double wobbleOffset;
  final double wobbleSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.wobbleOffset,
    required this.wobbleSpeed,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Calculate position with time-based movement
      final time = progress * 10; // Scale progress
      
      // Position with wrapping
      double xPos = (particle.x + particle.speedX * time) % 1.0;
      double yPos = (particle.y + particle.speedY * time) % 1.0;
      
      // Ensure positive values
      if (xPos < 0) xPos += 1.0;
      if (yPos < 0) yPos += 1.0;
      
      // Wobble effect
      final wobble = sin((time * particle.wobbleSpeed) + particle.wobbleOffset) * 10;
      
      // Convert to screen coordinates
      final screenX = xPos * size.width + wobble;
      final screenY = yPos * size.height;
      
      // Fade based on proximity to edges
      double fadeOpacity = particle.opacity;
      if (xPos < 0.05) fadeOpacity *= xPos / 0.05;
      if (xPos > 0.95) fadeOpacity *= (1 - xPos) / 0.05;
      if (yPos < 0.05) fadeOpacity *= yPos / 0.05;
      if (yPos > 0.95) fadeOpacity *= (1 - yPos) / 0.05;
      
      // Draw particle with gradient-like effect (multiple circles)
      paint.color = color.withOpacity(fadeOpacity * 0.3);
      canvas.drawCircle(
        Offset(screenX, screenY),
        particle.size * 1.5,
        paint,
      );
      
      paint.color = color.withOpacity(fadeOpacity * 0.6);
      canvas.drawCircle(
        Offset(screenX, screenY),
        particle.size,
        paint,
      );
      
      paint.color = color.withOpacity(fadeOpacity);
      canvas.drawCircle(
        Offset(screenX, screenY),
        particle.size * 0.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
