import 'package:flutter/material.dart';

/// CSS Spinner #3 Effect - Three circles pulsing/expanding animation
/// Based on https://github.com/eisenfox/css-spinners-2
class CirclePulseSpinner extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const CirclePulseSpinner({
    super.key,
    this.size = 60,
    this.color = const Color(0xFF3D5AF1), // Blue
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<CirclePulseSpinner> createState() => _CirclePulseSpinnerState();
}

class _CirclePulseSpinnerState extends State<CirclePulseSpinner>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    // Circle 1 - starts immediately
    _controller1 = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    // Circle 2 - starts with delay
    _controller2 = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    Future.delayed(Duration(milliseconds: widget.duration.inMilliseconds ~/ 3), () {
      if (mounted) _controller2.repeat();
    });

    // Circle 3 - starts with more delay
    _controller3 = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    Future.delayed(Duration(milliseconds: (widget.duration.inMilliseconds ~/ 3) * 2), () {
      if (mounted) _controller3.repeat();
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circle 1 (outermost, fades first)
          _buildPulsingCircle(_controller1, 0),
          // Circle 2 (middle)
          _buildPulsingCircle(_controller2, 1),
          // Circle 3 (innermost, core)
          _buildPulsingCircle(_controller3, 2),
        ],
      ),
    );
  }

  Widget _buildPulsingCircle(AnimationController controller, int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Scale: starts small, grows to full size
        final scale = Tween<double>(begin: 0.3, end: 1.0)
            .animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeOut,
            ))
            .value;

        // Opacity: starts visible, fades out
        final opacity = Tween<double>(begin: 0.8, end: 0.0)
            .animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeIn,
            ))
            .value;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(opacity),
              border: Border.all(
                color: widget.color.withOpacity(opacity * 0.5),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
