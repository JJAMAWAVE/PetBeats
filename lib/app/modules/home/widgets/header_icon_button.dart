import 'package:flutter/material.dart';
import 'dart:math' as math;

enum HeaderIconAnimationType {
  shake,
  rotate,
}

class HeaderIconButton extends StatefulWidget {
  final String iconPath;
  final VoidCallback onTap;
  final HeaderIconAnimationType animationType;
  final double size;

  const HeaderIconButton({
    super.key,
    required this.iconPath,
    required this.onTap,
    required this.animationType,
    this.size = 56.0, // 2x original 28
  });

  @override
  State<HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<HeaderIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 2 seconds cycle
    )..repeat();

    if (widget.animationType == HeaderIconAnimationType.shake) {
      // Shake: Rotate +/- 15 degrees quickly, then pause
      // 0.0 - 0.1: Shake left
      // 0.1 - 0.2: Shake right
      // 0.2 - 0.3: Shake left
      // 0.3 - 0.4: Shake right
      // 0.4 - 1.0: Pause
      _animation = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.15), weight: 5),
        TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.15), weight: 10),
        TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.15), weight: 10),
        TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.0), weight: 5),
        TweenSequenceItem(tween: ConstantTween(0.0), weight: 70),
      ]).animate(_controller);
    } else {
      // Rotate: Full 360 rotation, then pause
      // 0.0 - 0.5: Rotate 360
      // 0.5 - 1.0: Pause
      _animation = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 2 * math.pi), weight: 50),
        TweenSequenceItem(tween: ConstantTween(2 * math.pi), weight: 50),
      ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Image.asset(
                widget.iconPath,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
