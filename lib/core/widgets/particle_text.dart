import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ParticleType {
  bubbles,
  confetti,
  hearts,
  fire,
}

class ParticleText extends StatefulWidget {
  final String text;
  final ParticleType type;
  final TextStyle? style;
  final double particleScale;

  const ParticleText({
    super.key,
    required this.text,
    required this.type,
    this.style,
    this.particleScale = 1.0,
  });

  @override
  State<ParticleText> createState() => _ParticleTextState();
}

class _ParticleTextState extends State<ParticleText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100), // Long duration for continuous loop
    )..addListener(_updateParticles)
     ..repeat();
     
    // Initialize some particles
    for (int i = 0; i < 30; i++) {
        _addParticle(initial: true);
    }
  }
  
  void _updateParticles() {
      // Add new particles periodically
      if (_random.nextDouble() < 0.1) {
          _addParticle();
      }
      
      // Update existing particles
      for (var particle in _particles) {
          particle.update();
      }
      
      // Remove dead particles
      _particles.removeWhere((p) => p.isDead);
  }

  void _addParticle({bool initial = false}) {
     // Create particle based on type
     switch (widget.type) {
         case ParticleType.bubbles:
            _particles.add(BubbleParticle(random: _random, initial: initial));
            break;
         case ParticleType.confetti:
            _particles.add(ConfettiParticle(random: _random, initial: initial));
            break;
        case ParticleType.hearts:
            _particles.add(HeartParticle(random: _random, initial: initial));
            break;
        case ParticleType.fire:
            _particles.add(FireParticle(random: _random, initial: initial));
            break;
     }
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
          painter: _ParticleTextPainter(
            particles: _particles,
            type: widget.type,
          ),
          child: Text(
            widget.text,
            style: widget.style,
          ),
        );
      },
    );
  }
}

class _ParticleTextPainter extends CustomPainter {
  final List<Particle> particles;
  final ParticleType type;

  _ParticleTextPainter({required this.particles, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

abstract class Particle {
  double x = 0;
  double y = 0;
  double life = 0.0;
  double maxLife = 1.0;
  bool get isDead => life >= maxLife;
  
  void update();
  void paint(Canvas canvas, Size size);
}

// --------------------------------------------------------------------------
// 1. Bubbles Implementation
// --------------------------------------------------------------------------
class BubbleParticle extends Particle {
    final math.Random random;
    double size = 0;
    double speed = 0;
    double opacity = 0;
    
    BubbleParticle({required this.random, bool initial = false}) {
        x = random.nextDouble();
        y = initial ? random.nextDouble() : 1.2; // Start below or random if initial
        size = random.nextDouble() * 10 + 5;
        speed = random.nextDouble() * 0.005 + 0.002;
        maxLife = 1.0;
        life = 0.0;
    }

    @override
    void update() {
        y -= speed;
        life += 0.01;
        
        // CSS: 0% -> 20% (opacity 0->1), 20% -> 100% (opacity 1->0)
        if (life < 0.2) {
            opacity = life / 0.2;
        } else {
            opacity = 1.0 - ((life - 0.2) / 0.8);
        }
        
        if (y < -0.2) life = 1.0; // Die if goes too high
    }

    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
          ..color = const Color(0xFF2196F3).withOpacity(opacity.clamp(0.0, 0.5))
          ..style = PaintingStyle.fill;
          
        canvas.drawCircle(
            Offset(this.x * size.width, this.y * size.height), 
            this.size, 
            paint
        );
    }
}

// --------------------------------------------------------------------------
// 2. Hearts Implementation
// --------------------------------------------------------------------------
class HeartParticle extends Particle {
    final math.Random random;
    double size = 0;
    double speed = 0;
    double opacity = 0;
    
    HeartParticle({required this.random, bool initial = false}) {
        x = random.nextDouble();
        y = initial ? random.nextDouble() : 1.2;
        size = random.nextDouble() * 0.5 + 0.5; // Scale factor
        speed = random.nextDouble() * 0.005 + 0.002;
        maxLife = 1.0;
        life = 0.0;
    }

    @override
    void update() {
        y -= speed;
        life += 0.01;

        if (life < 0.2) {
            opacity = (life / 0.2) * 0.8;
        } else {
            opacity = (1.0 - ((life - 0.2) / 0.8)) * 0.8;
        }
    }

    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
          ..color = const Color(0xFFCC2A5D).withOpacity(opacity.clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        
        final center = Offset(this.x * size.width, this.y * size.height);
        
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(math.pi / 4); // 45deg rotation from CSS
        canvas.scale(this.size);
        
        // Draw Heart
        // Simplified heart shape corresponding to CSS pseudo-elements
        // CSS used ::before and ::after circles. We draw a heart path.
        double r = 6;
        Path path = Path();
        path.moveTo(0, 0);
        path.arcTo(Rect.fromCircle(center: Offset(-r/2, 0), radius: r/2), 0, math.pi, true);
        path.arcTo(Rect.fromCircle(center: Offset(0, -r/2), radius: r/2), -math.pi/2, math.pi, true);
        path.lineTo(0, r);
        path.lineTo(-r, 0); // Close
        
        // Drawing actual heart shape properly
        // Let's us CustomPainter heart
        Path heartPath = Path();
        heartPath.moveTo(0,0);
        // Left circle
        heartPath.addOval(Rect.fromCircle(center: const Offset(-5, -5), radius: 5));
        // Right circle
        heartPath.addOval(Rect.fromCircle(center: const Offset(5, -5), radius: 5));
        // Rotating for the square part? 
        // CSS logic: square rotated 45deg, with circles on top/left
        canvas.drawRect(const Rect.fromLTWH(-5, -5, 10, 10), paint);
        canvas.drawCircle(const Offset(-5, 0), 5, paint);
        canvas.drawCircle(const Offset(0, -5), 5, paint);

        canvas.restore();
    }
}

// --------------------------------------------------------------------------
// 3. Confetti Implementation
// --------------------------------------------------------------------------
class ConfettiParticle extends Particle {
    final math.Random random;
    Color color = Colors.red;
    double size = 0;
    double speedY = 0;
    double rotation = 0;
    double rotationSpeed = 0;
    
    ConfettiParticle({required this.random, bool initial = false}) {
        x = random.nextDouble();
        y = initial ? random.nextDouble() : -0.2; // Start from TOP
        // Colors: c1 (Green), c2 (Purple) from CSS
        color = random.nextBool() 
            ? const Color(0xFF4CAF50) 
            : const Color(0xFF9C27B0);
        color = color.withOpacity(0.5);
        
        size = random.nextDouble() * 5 + 3;
        speedY = random.nextDouble() * 0.01 + 0.005;
        rotation = random.nextDouble() * 2 * math.pi;
        rotationSpeed = random.nextDouble() * 0.1;
    }

    @override
    void update() {
        y += speedY; // Falling down
        rotation += rotationSpeed;
        
        if (y > 1.2) life = 1.0; // Die if goes too low
    }

    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
          
        canvas.save();
        canvas.translate(this.x * size.width, this.y * size.height);
        canvas.rotate(rotation);
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: this.size, height: this.size/2), paint);
        canvas.restore();
    }
}

// --------------------------------------------------------------------------
// 4. Fire Implementation
// --------------------------------------------------------------------------
class FireParticle extends Particle {
    final math.Random random;
    double size = 0;
    double speed = 0;
    double angle = 0;
    double opacity = 0;
    
    FireParticle({required this.random, bool initial = false}) {
        x = random.nextDouble();
        y = 1.0; // Start at bottom
        size = random.nextDouble() * 10 + 10;
        speed = random.nextDouble() * 0.01 + 0.005;
        maxLife = 1.0;
        life = 0.0;
    }

    @override
    void update() {
        life += 0.02; // Faster life
        y -= speed;
        
        // CSS: 0% -70deg, 25% -20deg, 50% -70deg ... 
        // Oscillating rotation
        double progress = life * 4; // approximate cycles
        angle = -45 + 25 * math.sin(progress); 
        
        opacity = 1.0 - life; // Fade out
    }

    @override
    void paint(Canvas canvas, Size size) {
         // Amber/Orange color
        final paint = Paint()
          ..color = const Color(0xFFFFC107).withOpacity((opacity * 0.5).clamp(0.0, 0.5))
          ..style = PaintingStyle.fill;
        
        final center = Offset(this.x * size.width, this.y * size.height);

        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(angle * math.pi / 180);
        
        // Draw flame shape (Rounded rect with one sharp corner)
        // CSS: border-radius: 40px, border-top-right-radius: 0
        RRect rrect = RRect.fromRectAndCorners(
            Rect.fromCenter(center: Offset.zero, width: this.size, height: this.size),
            topLeft: const Radius.circular(20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
            topRight: Radius.zero,
        );
        canvas.drawRRect(rrect, paint);
        
        // Inner flame
        final innerPaint = Paint()
            ..color = const Color(0xFFFB8C00).withOpacity((opacity * 0.5).clamp(0.0, 0.5));
        
        canvas.scale(0.5); // Inner is smaller
        canvas.drawRRect(rrect, innerPaint);

        canvas.restore();
    }
}
