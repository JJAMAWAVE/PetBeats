import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ModeAnimationType {
  none,
  sway,      // 살랑살랑 (Rotation)
  breathe,   // 숨쉬기 (Scale)
  wave,      // 둥실둥실 (Translation Y)
  pulse,     // 두근두근 (Scale + Opacity)
  heartbeat, // 콩닥콩닥 (Double Scale Pulse)
  shake,     // 흔들흔들 (Translation X)
  rotate,    // 빙글빙글 (Rotation Full)
}

class ModeAnimator extends StatefulWidget {
  final Widget child;
  final ModeAnimationType type;
  final bool isActive;

  const ModeAnimator({
    super.key,
    required this.child,
    required this.type,
    this.isActive = true,
  });

  @override
  State<ModeAnimator> createState() => _ModeAnimatorState();
}

class _ModeAnimatorState extends State<ModeAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _setupAnimation();
  }

  @override
  void didUpdateWidget(ModeAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      _controller.dispose();
      _controller = AnimationController(vsync: this);
      _setupAnimation();
    }
  }

  void _setupAnimation() {
    switch (widget.type) {
      case ModeAnimationType.sway:
        _controller.duration = const Duration(milliseconds: 2000);
        _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
        );
        _controller.repeat(reverse: true);
        break;
        
      case ModeAnimationType.breathe:
        _controller.duration = const Duration(milliseconds: 3000);
        _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.repeat(reverse: true);
        break;
        
      case ModeAnimationType.wave:
        _controller.duration = const Duration(milliseconds: 2500);
        _animation = Tween<double>(begin: -3.0, end: 3.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
        );
        _controller.repeat(reverse: true);
        break;
        
      case ModeAnimationType.pulse:
        _controller.duration = const Duration(milliseconds: 1500);
        _animation = Tween<double>(begin: 1.0, end: 1.15).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
        );
        _controller.repeat(reverse: true);
        break;
        
      case ModeAnimationType.heartbeat:
        _controller.duration = const Duration(milliseconds: 1200);
        // Custom heartbeat curve or just a sequence
         _animation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 3), // Pause
        ]).animate(_controller);
        _controller.repeat();
        break;
        
      case ModeAnimationType.shake:
        _controller.duration = const Duration(milliseconds: 100);
        _animation = Tween<double>(begin: -2.0, end: 2.0).animate(_controller);
        _controller.repeat(reverse: true);
        break;
        
      case ModeAnimationType.rotate:
        _controller.duration = const Duration(milliseconds: 5000);
        _animation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller);
        _controller.repeat();
        break;

      case ModeAnimationType.none:
      default:
        _animation = const AlwaysStoppedAnimation(0.0);
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
    if (widget.type == ModeAnimationType.none || !widget.isActive) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        switch (widget.type) {
          case ModeAnimationType.sway:
            return Transform.rotate(angle: _animation.value, child: child);
          case ModeAnimationType.rotate:
            return Transform.rotate(angle: _animation.value, child: child);
          case ModeAnimationType.breathe:
          case ModeAnimationType.pulse:
          case ModeAnimationType.heartbeat:
            return Transform.scale(scale: _animation.value, child: child);
          case ModeAnimationType.wave:
            return Transform.translate(offset: Offset(0, _animation.value), child: child);
           case ModeAnimationType.shake:
            return Transform.translate(offset: Offset(_animation.value, 0), child: child);
          default:
            return child!;
        }
      },
      child: widget.child,
    );
  }
}
