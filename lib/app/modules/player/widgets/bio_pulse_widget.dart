import 'package:flutter/material.dart';
import 'dart:math' as math;

class BioPulseWidget extends StatefulWidget {
  final int bpm;
  final bool isHapticActive;
  final Color color;

  const BioPulseWidget({
    super.key,
    required this.bpm,
    this.isHapticActive = false,
    required this.color,
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
      if (status == AnimationStatus.completed) {
        // Trigger secondary beat right after primary
        _secondaryController.forward(from: 0);
        // Restart primary beat
        Future.delayed(Duration(milliseconds: (beatDuration * 0.4).round()), () {
          if (mounted) {
            _primaryController.forward(from: 0);
          }
        });
      }
    });

    // Start the heartbeat
    _primaryController.forward();
  }

  @override
  void didUpdateWidget(BioPulseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
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
            showRipple: widget.isHapticActive,
            rippleProgress: _primaryController.value,
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

  BioPulsePainter({
    required this.scale,
    required this.color,
    required this.showRipple,
    required this.rippleProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 * 0.5;
    final currentRadius = baseRadius * scale;

    // Draw multiple glow layers for bloom effect
    for (int i = 5; i > 0; i--) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.15 / i)
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

    // Draw ripple if haptic is active
    if (showRipple) {
      final rippleRadius = baseRadius * (1.0 + rippleProgress * 0.8);
      final ripplePaint = Paint()
        ..color = color.withOpacity(0.4 * (1 - rippleProgress))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawCircle(center, rippleRadius, ripplePaint);
      
      // Secondary ripple
      if (rippleProgress > 0.3) {
        final ripple2Radius = baseRadius * (1.0 + (rippleProgress - 0.3) * 0.6);
        final ripple2Paint = Paint()
          ..color = color.withOpacity(0.3 * (1 - rippleProgress))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(center, ripple2Radius, ripple2Paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BioPulsePainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.color != color ||
        oldDelegate.showRipple != showRipple ||
        oldDelegate.rippleProgress != rippleProgress;
  }
}
