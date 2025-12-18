import 'dart:math';
import 'package:flutter/material.dart';

/// Touch particle burst effect overlay for the entire app
/// Creates particle burst animation at touch location
class TouchParticleOverlay extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;
  final double maxParticleSize;
  final bool enabled;

  const TouchParticleOverlay({
    super.key,
    required this.child,
    this.particleCount = 12,
    this.particleColor = const Color(0xFF87CEEB), // Light sky blue
    this.maxParticleSize = 8.0,
    this.enabled = true,
  });

  @override
  State<TouchParticleOverlay> createState() => _TouchParticleOverlayState();
}

class _TouchParticleOverlayState extends State<TouchParticleOverlay> {
  final List<ParticleBurst> _bursts = [];

  void _addBurst(Offset position) {
    if (!widget.enabled) return;
    
    setState(() {
      _bursts.add(ParticleBurst(
        position: position,
        particleCount: widget.particleCount,
        color: widget.particleColor,
        maxSize: widget.maxParticleSize,
        onComplete: () {
          setState(() {
            _bursts.removeWhere((b) => b.position == position);
          });
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _addBurst(details.globalPosition),
      child: Stack(
        children: [
          widget.child,
          // Particle bursts overlay
          ..._bursts.map((burst) => Positioned.fill(
            child: IgnorePointer(
              child: _ParticleBurstWidget(burst: burst),
            ),
          )),
        ],
      ),
    );
  }
}

class ParticleBurst {
  final Offset position;
  final int particleCount;
  final Color color;
  final double maxSize;
  final VoidCallback onComplete;

  ParticleBurst({
    required this.position,
    required this.particleCount,
    required this.color,
    required this.maxSize,
    required this.onComplete,
  });
}

class _ParticleBurstWidget extends StatefulWidget {
  final ParticleBurst burst;

  const _ParticleBurstWidget({required this.burst});

  @override
  State<_ParticleBurstWidget> createState() => _ParticleBurstWidgetState();
}

class _ParticleBurstWidgetState extends State<_ParticleBurstWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Quick burst
    );

    // Generate particles with random directions (smaller size)
    _particles = List.generate(widget.burst.particleCount, (i) {
      final angle = (i / widget.burst.particleCount) * 2 * pi + _random.nextDouble() * 0.5;
      final speed = 20 + _random.nextDouble() * 40; // 20-60 pixels
      return _Particle(
        angle: angle,
        speed: speed,
        size: _random.nextDouble() * (widget.burst.maxSize / 2) + 2, // Half size: 2-5px
        opacity: _random.nextDouble() * 0.3 + 0.5,
        wobble: _random.nextDouble() * 0.3,
      );
    });

    _controller.forward().then((_) {
      widget.burst.onComplete();
    });
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
          painter: _BurstPainter(
            particles: _particles,
            progress: _controller.value,
            center: widget.burst.position,
            color: widget.burst.color,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final double opacity;
  final double wobble;

  _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.wobble,
  });
}

class _BurstPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Offset center;
  final Color color;

  _BurstPainter({
    required this.particles,
    required this.progress,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Smoother easing curves
    final easeProgress = Curves.easeOutQuart.transform(progress);
    final fadeProgress = Curves.easeInQuart.transform(progress);

    // === Water droplet ripple effect at center ===
    final rippleRadius = 50 * easeProgress; // Expands to 50px
    final rippleOpacity = 0.4 * (1 - fadeProgress);
    
    // Outer ripple ring
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2 * (1 - fadeProgress * 0.5);
    paint.color = color.withOpacity(rippleOpacity * 0.5);
    canvas.drawCircle(center, rippleRadius, paint);
    
    // Inner ripple ring
    paint.strokeWidth = 1.5 * (1 - fadeProgress * 0.5);
    paint.color = color.withOpacity(rippleOpacity * 0.8);
    canvas.drawCircle(center, rippleRadius * 0.6, paint);
    
    // Center splash dot
    paint.style = PaintingStyle.fill;
    paint.color = color.withOpacity(rippleOpacity);
    canvas.drawCircle(center, 6 * (1 - easeProgress * 0.8), paint);

    // === Particles ===
    paint.style = PaintingStyle.fill;
    for (final particle in particles) {
      // Calculate position with wobble
      final wobbleAngle = particle.angle + sin(progress * pi * 3) * particle.wobble;
      final distance = particle.speed * easeProgress;
      final x = center.dx + cos(wobbleAngle) * distance;
      final y = center.dy + sin(wobbleAngle) * distance;

      // Fade out smoothly
      final opacity = particle.opacity * (1 - fadeProgress * 0.8);
      final currentSize = particle.size * (1 - fadeProgress * 0.5);

      if (opacity <= 0 || currentSize <= 0) continue;

      // Softer glow effect
      paint.color = color.withOpacity(opacity * 0.2);
      canvas.drawCircle(Offset(x, y), currentSize * 2, paint);
      
      paint.color = color.withOpacity(opacity * 0.5);
      canvas.drawCircle(Offset(x, y), currentSize * 1.3, paint);
      
      paint.color = color.withOpacity(opacity * 0.8);
      canvas.drawCircle(Offset(x, y), currentSize * 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => true;
}
