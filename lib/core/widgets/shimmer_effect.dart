import 'package:flutter/material.dart';

class DynamicShimmer extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final Duration duration;
  final Duration interval; // 반복 간격
  final Color shimmerColor;

  const DynamicShimmer({
    super.key,
    required this.child,
    this.isActive = true,
    this.duration = const Duration(milliseconds: 1500),
    this.interval = const Duration(seconds: 3),
    this.shimmerColor = const Color(0x33FFFFFF), // 20% White
  });

  @override
  State<DynamicShimmer> createState() => _DynamicShimmerState();
}

class _DynamicShimmerState extends State<DynamicShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isActive) {
      _startShimmerLoop();
    }
  }

  void _startShimmerLoop() async {
    if (!mounted) return;
    try {
      await _controller.forward(from: 0.0);
      if (!mounted) return;
      await Future.delayed(widget.interval);
      if (mounted && widget.isActive) {
        _startShimmerLoop();
      }
    } catch (e) {
      // Controller disposed error prevention
    }
  }

  @override
  void didUpdateWidget(DynamicShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startShimmerLoop();
      } else {
        _controller.stop();
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
    if (!widget.isActive) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
         // -1.0 ~ 2.0 범위로 이동하여 자연스럽게 지나가도록
        final slidePercent = _controller.value * 3 - 1; 
        
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - slidePercent, -1.0), // 대각선 이동
              end: Alignment(1.0 - slidePercent, 1.0),
              colors: [
                Colors.transparent,
                widget.shimmerColor,
                Colors.transparent,
              ],
              stops: const [0.3, 0.5, 0.7],
              transform: _SlidingGradientTransform(slidePercent),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // X축 이동만 적용 or 대각선?
    // createShader 내에서 Alignment로 충분할 수도 있지만, 정교한 이동을 위해 Translation 사용
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
