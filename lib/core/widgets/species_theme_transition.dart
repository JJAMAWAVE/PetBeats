import 'package:flutter/material.dart';
import 'package:petbeats/core/theme/species_theme.dart';
import 'dart:math' as math;

/// 종(Species) 전환 시 바 로더 애니메이션으로 화면을 채우는 위젯
/// CSS 로더에서 영감을 받은 물결 형태의 바 트랜지션
class SpeciesThemeTransition extends StatefulWidget {
  final Widget child;
  final SpeciesTheme theme;
  final Duration duration;

  const SpeciesThemeTransition({
    Key? key,
    required this.child,
    required this.theme,
    this.duration = const Duration(milliseconds: 1200),
  }) : super(key: key);

  @override
  State<SpeciesThemeTransition> createState() => _SpeciesThemeTransitionState();
}

class _SpeciesThemeTransitionState extends State<SpeciesThemeTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SpeciesTheme? _previousTheme;
  bool _isAnimating = false;

  // 강아지 색상 (오렌지 계열 - CSS 기본값)
  static const List<Color> dogColors = [
    Color(0xFFFFA54F), // light
    Color(0xFFFF9834), // medium
    Color(0xFFFF8919), // dark
    Color(0xFFFF7C00), // darkest
  ];

  // 고양이 색상 (퍼플 계열)
  static const List<Color> catColors = [
    Color(0xFFD1C4E9), // light lavender
    Color(0xFFB39DDB), // medium lavender
    Color(0xFF9575CD), // deep purple light
    Color(0xFF7E57C2), // deep purple
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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

  List<Color> _getColorsForTheme(SpeciesTheme theme) {
    return theme == SpeciesTheme.cat ? catColors : dogColors;
  }

  @override
  Widget build(BuildContext context) {
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

            // 바 로더 애니메이션 (애니메이션 중일 때만)
            if (_isAnimating)
              Positioned.fill(
                child: _WaveBarLoader(
                  progress: _animation.value,
                  colors: _getColorsForTheme(widget.theme),
                  targetBackgroundColor: widget.theme.backgroundColor,
                  barCount: 8,
                ),
              ),

            // 콘텐츠 (페이드 인/아웃)
            Opacity(
              opacity: _isAnimating 
                  ? (_animation.value > 0.7 ? ((_animation.value - 0.7) / 0.3).clamp(0.0, 1.0) : 0.0)
                  : 1.0,
              child: child!,
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

/// 물결 형태 바 로더
class _WaveBarLoader extends StatelessWidget {
  final double progress;
  final List<Color> colors;
  final Color targetBackgroundColor;
  final int barCount;

  const _WaveBarLoader({
    required this.progress,
    required this.colors,
    required this.targetBackgroundColor,
    required this.barCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(barCount, (index) {
        final delay = index * 0.05; // 각 바마다 딜레이
        return Expanded(
          child: _DualAnimatedBar(
            progress: progress,
            delay: delay,
            colors: colors,
            targetColor: targetBackgroundColor,
            barIndex: index,
          ),
        );
      }),
    );
  }
}

/// CSS 로더 스타일의 듀얼 애니메이션 바
class _DualAnimatedBar extends StatelessWidget {
  final double progress;
  final double delay;
  final List<Color> colors;
  final Color targetColor;
  final int barIndex;

  const _DualAnimatedBar({
    required this.progress,
    required this.delay,
    required this.colors,
    required this.targetColor,
    required this.barIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 딜레이 적용된 진행도
    final delayedProgress = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);
    
    // CSS keyframes 시뮬레이션
    // Phase 1 (0-0.4): 왼쪽에서 오른쪽으로 채움
    // Phase 2 (0.4-0.6): 잠시 유지
    // Phase 3 (0.6-1.0): 오른쪽에서 왼쪽으로 배경색으로 전환
    
    double leftBarWidth = 0;
    double rightBarWidth = 0;
    Color leftColor = colors[0];
    Color rightColor = colors[colors.length - 1];
    
    if (delayedProgress < 0.4) {
      // Phase 1: 왼쪽 바가 확장
      final t = delayedProgress / 0.4;
      leftBarWidth = screenWidth * _easeOutQuad(t);
      leftColor = Color.lerp(colors[0], colors[2], t)!;
    } else if (delayedProgress < 0.6) {
      // Phase 2: 풀 컬러
      leftBarWidth = screenWidth;
      leftColor = colors[2];
    } else {
      // Phase 3: 배경색으로 전환 (오른쪽에서)
      final t = (delayedProgress - 0.6) / 0.4;
      rightBarWidth = screenWidth * _easeOutQuad(t);
      leftBarWidth = screenWidth - rightBarWidth;
      leftColor = Color.lerp(colors[2], targetColor, t * 0.5)!;
      rightColor = targetColor;
    }
    
    return Row(
      children: [
        // 왼쪽 바 (색상)
        Container(
          width: leftBarWidth.clamp(0, screenWidth),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                leftColor,
                Color.lerp(leftColor, colors[barIndex % colors.length], 0.3)!,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        // 오른쪽 바 (배경색)
        Container(
          width: rightBarWidth.clamp(0, screenWidth),
          color: rightColor,
        ),
      ],
    );
  }
  
  double _easeOutQuad(double t) {
    return 1 - (1 - t) * (1 - t);
  }
}
