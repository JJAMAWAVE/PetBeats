import 'package:flutter/material.dart';
import 'dart:math' as math;

class BioPulseWidget extends StatefulWidget {
  final int bpm;
  final bool isPlaying;  // Renamed from isHapticActive
  final Color color;
  final double bassIntensity;  // FFT bass (0.0 ~ 1.0)
  final double midIntensity;   // FFT mid (0.0 ~ 1.0)
  final String mode;           // 'sleep', 'energy', 'calm', 'senior'

  const BioPulseWidget({
    super.key,
    required this.bpm,
    this.isPlaying = false,  // Renamed from isHapticActive
    required this.color,
    this.bassIntensity = 0.0,
    this.midIntensity = 0.0,
    this.mode = 'sleep',
  });

  @override
  State<BioPulseWidget> createState() => _BioPulseWidgetState();
}

class _BioPulseWidgetState extends State<BioPulseWidget>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late Animation<double> _primaryAnimation;
  late Animation<double> _secondaryAnimation;

  @override
  void initState() {
    super.initState();
    _setupControllers();
  }

  void _setupControllers() {
    // Primary beat (Lub)
    final beatDuration = (60000 / widget.bpm).round();
    _primaryController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: beatDuration),
    );

    // Secondary beat (Dub) - shorter and happens right after primary
    _secondaryController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (beatDuration * 0.4).round()),
    );

    // Lub animation - stronger beat
    _primaryAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 50,
      ),
    ]).animate(_primaryController);

    // Dub animation - softer beat
    _secondaryAnimation = Tween<double>(begin: 1.0, end: 1.12)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_secondaryController);

    _primaryController.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.isPlaying) {
        // Trigger secondary beat right after primary
        _secondaryController.forward(from: 0);
        // Restart primary beat
        Future.delayed(Duration(milliseconds: (beatDuration * 0.4).round()), () {
          if (mounted && widget.isPlaying) {
            _primaryController.forward(from: 0);
          }
        });
      }
    });

    // Start the heartbeat only if playing
    if (widget.isPlaying) {
      _primaryController.forward();
    }
  }

  @override
  void didUpdateWidget(BioPulseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Control animation based on isPlaying
    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _primaryController.forward();
      } else {
        _primaryController.stop();
        _secondaryController.stop();
      }
    }
    
    if (oldWidget.bpm != widget.bpm) {
      _primaryController.dispose();
      _secondaryController.dispose();
      _setupControllers();
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryController, _secondaryController]),
      builder: (context, child) {
        final combinedScale = _primaryAnimation.value * _secondaryAnimation.value;
        
        return CustomPaint(
          painter: BioPulsePainter(
            scale: combinedScale,
            color: widget.color,
            showRipple: widget.isPlaying,
            rippleProgress: _primaryController.value,
            bassIntensity: widget.bassIntensity,
            midIntensity: widget.midIntensity,
            mode: widget.mode,
          ),
          child: const SizedBox(width: 300, height: 300),
        );
      },
    );
  }
}

class BioPulsePainter extends CustomPainter {
  final double scale;
  final Color color;
  final bool showRipple;
  final double rippleProgress;
  final double bassIntensity;
  final double midIntensity;
  final String mode;

  BioPulsePainter({
    required this.scale,
    required this.color,
    required this.showRipple,
    required this.rippleProgress,
    required this.bassIntensity,
    required this.midIntensity,
    required this.mode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 * 0.5;
    
    // Mode-based reactivity multiplier
    final double reactivityMultiplier = mode == 'sleep' ? 0.3
        : mode == 'senior' ? 0.2
        : mode == 'energy' ? 1.0
        : 0.5; // calm, noise
    
    // Dynamic scale based on bass intensity
    final bassScale = 1.0 + (bassIntensity * 0.8 * reactivityMultiplier);
    final currentRadius = baseRadius * scale * bassScale;

    // Dynamic glow opacity based on mid intensity
    final glowOpacity = 0.6 + (midIntensity * 0.4);
    
    // Draw multiple glow layers for bloom effect
    for (int i = 5; i > 0; i--) {
      final glowPaint = Paint()
        ..color = color.withOpacity((0.15 / i) * glowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20.0 * i);
      canvas.drawCircle(center, currentRadius * (1 + i * 0.1), glowPaint);
    }

    // Draw core sphere with radial gradient
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.9),
          color.withOpacity(0.6),
          color.withOpacity(0.2),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));
    
    canvas.drawCircle(center, currentRadius, paint);

    // Draw soft edge with blur
    final edgePaint = Paint()
      ..color = color.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, currentRadius * 0.95, edgePaint);

    // Draw ripple if haptic is active (with dynamic speed)
    if (showRipple) {
      // Dynamic ripple expansion based on bass
      final rippleSpeedMultiplier = 0.8 + (bassIntensity * 0.4 * reactivityMultiplier);
      final rippleRadius = baseRadius * (1.0 + rippleProgress * rippleSpeedMultiplier);
      final ripplePaint = Paint()
        ..color = color.withOpacity(0.4 * (1 - rippleProgress))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawCircle(center, rippleRadius, ripplePaint);
      
      // Secondary ripple (also dynamic)
      if (rippleProgress > 0.3) {
        final ripple2Speed = 0.6 + (bassIntensity * 0.3 * reactivityMultiplier);
        final ripple2Radius = baseRadius * (1.0 + (rippleProgress - 0.3) * ripple2Speed);
        final ripple2Paint = Paint()
          ..color = color.withOpacity(0.3 * (1 - rippleProgress))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(center, ripple2Radius, ripple2Paint);
      }
    }
    
    // Draw particles - ALWAYS show them, not based on audio analysis
    // Use ripple progress to create pulsing particle effect
    final particleCount = 12;  // Fixed count for consistent display
    final energySimulation = 0.5 + (rippleProgress * 0.5);  // Simulate energy from pulse
    
    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * math.pi;
      final distance = currentRadius * (1.15 + rippleProgress * 0.3);
      final particleX = center.dx + math.cos(angle) * distance;
      final particleY = center.dy + math.sin(angle) * distance;
      
      // Make particles much bigger and more visible
      final particleSize = 6.0 + (energySimulation * 4);  // 6-10 pixels
      final particleOpacity = (0.7 + energySimulation * 0.3) * (1 - rippleProgress * 0.3);
      
      final particlePaint = Paint()
        ..color = color.withOpacity(particleOpacity)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particleSize * 1.5);  // Strong glow
      
      canvas.drawCircle(
        Offset(particleX, particleY),
        particleSize,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BioPulsePainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.color != color ||
        oldDelegate.showRipple != showRipple ||
        oldDelegate.rippleProgress != rippleProgress ||
        oldDelegate.bassIntensity != bassIntensity ||
        oldDelegate.midIntensity != midIntensity;
  }
}
