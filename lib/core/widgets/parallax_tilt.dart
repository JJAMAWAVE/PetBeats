import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParallaxTilt extends StatefulWidget {
  final Widget child;
  final double tiltIntensity; // 기울기 강도 (기본값: 0.2 ~ 0.5)
  final bool isReverse; // 기울기 방향 반전 여부

  const ParallaxTilt({
    super.key, 
    required this.child, 
    this.tiltIntensity = 0.003, // 값이 작을수록 미세하게, 0.01 정도면 큼
    this.isReverse = false,
  });

  @override
  State<ParallaxTilt> createState() => _ParallaxTiltState();
}

class _ParallaxTiltState extends State<ParallaxTilt> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Offset _touchPosition = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this); // 복귀 애니메이션 속도
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    setState(() {
      _isHovering = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovering = false;
      _animation = Tween<Offset>(
        begin: _touchPosition,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      );
      _controller.forward(from: 0);
    });
  }

  void _onHover(PointerEvent details, Size size) {
    if (!_isHovering) return;
    
    // 중심점 기준으로 -1.0 ~ 1.0 정규화
    final normalizedX = (details.localPosition.dx / size.width) * 2 - 1;
    final normalizedY = (details.localPosition.dy / size.height) * 2 - 1;
    
    // 제한된 범위 내에서만 반응 (선택사항)
    
    setState(() {
      _touchPosition = Offset(normalizedX, normalizedY);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: (details) => _onHover(details, context.size ?? Size.zero),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final currentPos = _isHovering ? _touchPosition : _animation.value;
          
          final rotateY = currentPos.dx * widget.tiltIntensity * (widget.isReverse ? -1 : 1);
          final rotateX = -currentPos.dy * widget.tiltIntensity * (widget.isReverse ? -1 : 1);

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // 원근감
              ..rotateX(rotateX)
              ..rotateY(rotateY),
            alignment: FractionalOffset.center,
            child: widget.child,
          );
        },
      ),
    );
  }
}
