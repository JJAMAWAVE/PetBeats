import 'package:flutter/material.dart';
import 'package:petbeats/core/theme/species_theme.dart';
import 'dart:math' as math;

/// 종(Species) 전환 시 원형 리플 애니메이션으로 화면을 채우는 위젯
class SpeciesThemeTransition extends StatefulWidget {
  final Widget child;
  final SpeciesTheme theme;
  final Duration duration;

  const SpeciesThemeTransition({
    Key? key,
    required this.child,
    required this.theme,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<SpeciesThemeTransition> createState() => _SpeciesThemeTransitionState();
}

class _SpeciesThemeTransitionState extends State<SpeciesThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SpeciesTheme? _previousTheme;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _previousTheme = widget.theme;
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
          _previousTheme = widget.theme;
        });
      }
    });
  }

  @override
  void didUpdateWidget(SpeciesThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _previousTheme = oldWidget.theme;
      setState(() {
        _isAnimating = true;
      });
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = _calculateMaxRadius(screenSize);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // 이전 테마 배경 (Bottom Layer)
            Positioned.fill(
              child: Container(
                color: _isAnimating 
                    ? _previousTheme?.backgroundColor 
                    : widget.theme.backgroundColor,
              ),
            ),
            
            // 새 테마 Ripple (Top Layer) - 애니메이션 중일 때만
            if (_isAnimating)
              Positioned.fill(
                child: ClipPath(
                  clipper: CircleRevealClipper(
                    progress: _animation.value,
                    centerX: screenSize.width / 2,
                    centerY: 120, // 탭 버튼 근처
                    maxRadius: maxRadius,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.theme.backgroundColor,
                    ),
                    // 색상 차이를 더 강조하는 오버레이
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.7),
                          radius: 1.5,
                          colors: [
                            widget.theme.primaryColor.withOpacity(0.25),
                            widget.theme.primaryColor.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            
            // 실제 콘텐츠
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }

  double _calculateMaxRadius(Size screenSize) {
    return math.sqrt(
      math.pow(screenSize.width, 2) + math.pow(screenSize.height, 2)
    ) * 1.2;
  }
}

/// 원형 리플 애니메이션을 위한 CustomClipper
class CircleRevealClipper extends CustomClipper<Path> {
  final double progress;
  final double centerX;
  final double centerY;
  final double maxRadius;

  CircleRevealClipper({
    required this.progress,
    required this.centerX,
    required this.centerY,
    required this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final currentRadius = maxRadius * progress;
    
    path.addOval(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: currentRadius,
      ),
    );
    
    return path;
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
