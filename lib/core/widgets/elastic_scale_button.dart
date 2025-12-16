import 'package:flutter/material.dart';

class ElasticScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleAmount;

  const ElasticScaleButton({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleAmount = 0.95,
  });

  @override
  State<ElasticScaleButton> createState() => _ElasticScaleButtonState();
}

class _ElasticScaleButtonState extends State<ElasticScaleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // 누를 때는 빠르게
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleAmount).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    // 뗄 때는 쫀득한 탄성 효과 (Elastic)
    _playElasticRelease();
    widget.onTap();
  }

  void _handleTapCancel() {
    _playElasticRelease();
  }
  
  Future<void> _playElasticRelease() async {
    // 컨트롤러를 리셋하고 스프링 시뮬레이션으로 복구하는 느낌을 주기 위해
    // 단순 reverse는 너무 딱딱하므로 elasticOut 곡선을 적용한 역재생 애니메이션을 수행
    await _controller.animateBack(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut, // 띠요옹~ 하는 느낌
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
