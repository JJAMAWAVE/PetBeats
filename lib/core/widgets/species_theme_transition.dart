import 'package:flutter/material.dart';
import 'package:petbeats/core/theme/species_theme.dart';

/// 종(Species) 전환 시 바 로더 애니메이션으로 화면을 덮는 위젯
/// CSS 로더에서 영감을 받은 부드러운 물결 형태의 바 트랜지션
class SpeciesThemeTransition extends StatefulWidget {
  final Widget child;
  final SpeciesTheme theme;
  final Duration duration;

  const SpeciesThemeTransition({
    Key? key,
    required this.child,
    required this.theme,
    this.duration = const Duration(milliseconds: 1000),
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

  // 강아지 색상 (블루 계열)
  static const List<Color> dogColors = [
    Color(0xFF64B5F6), // light blue
    Color(0xFF42A5F5), // blue
    Color(0xFF2196F3), // primary blue
    Color(0xFF1E88E5), // dark blue
  ];

  // 고양이 색상 (퍼플 계열)
  static const List<Color> catColors = [
    Color(0xFFCE93D8), // light purple
    Color(0xFFBA68C8), // medium purple
    Color(0xFFAB47BC), // purple
    Color(0xFF9C27B0), // deep purple
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
      curve: Curves.easeInOutCubic, // 더 부드러운 커브
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
            // 실제 콘텐츠 (항상 보임)
            Positioned.fill(
              child: Container(
                color: widget.theme.backgroundColor,
                child: child!,
              ),
            ),

            // 바 로더 오버레이 (애니메이션 중일 때만, 콘텐츠 위에 표시)
            if (_isAnimating)
              Positioned.fill(
                child: _SmoothWaveLoader(
                  progress: _animation.value,
                  colors: _getColorsForTheme(widget.theme),
                  barCount: 20, // 더 많은 바
                ),
              ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

/// 부드러운 물결 로더 오버레이
class _SmoothWaveLoader extends StatelessWidget {
  final double progress;
  final List<Color> colors;
  final int barCount;

  const _SmoothWaveLoader({
    required this.progress,
    required this.colors,
    required this.barCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final barHeight = screenHeight / barCount;

    return Column(
      children: List.generate(barCount, (index) {
        return SizedBox(
          height: barHeight,
          child: _SmoothBar(
            progress: progress,
            barIndex: index,
            totalBars: barCount,
            colors: colors,
          ),
        );
      }),
    );
  }
}

/// 개별 부드러운 바
class _SmoothBar extends StatelessWidget {
  final double progress;
  final int barIndex;
  final int totalBars;
  final List<Color> colors;

  const _SmoothBar({
    required this.progress,
    required this.barIndex,
    required this.totalBars,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 각 바마다 약간의 딜레이 (물결 효과)
    final waveDelay = barIndex * 0.02;
    final delayedProgress = ((progress - waveDelay) / (1.0 - waveDelay * totalBars * 0.5))
        .clamp(0.0, 1.0);
    
    // 부드러운 easing
    final easedProgress = _smoothStep(delayedProgress);
    
    // Phase 1 (0-0.5): 오른쪽으로 채움
    // Phase 2 (0.5-1.0): 왼쪽으로 빠짐
    double barWidth;
    double leftOffset;
    
    if (easedProgress < 0.5) {
      // 채워지는 단계
      final t = easedProgress * 2;
      barWidth = screenWidth * _smoothStep(t);
      leftOffset = 0;
    } else {
      // 빠지는 단계
      final t = (easedProgress - 0.5) * 2;
      barWidth = screenWidth * (1 - _smoothStep(t));
      leftOffset = screenWidth * _smoothStep(t);
    }
    
    // 색상 그라데이션 (바 인덱스에 따라)
    final colorIndex = barIndex % colors.length;
    final nextColorIndex = (colorIndex + 1) % colors.length;
    final colorT = (barIndex / totalBars);
    final barColor = Color.lerp(colors[colorIndex], colors[nextColorIndex], colorT)!;
    
    // 부드러운 불투명도 (시작/끝에서 페이드)
    double opacity = 1.0;
    if (easedProgress < 0.1) {
      opacity = easedProgress * 10;
    } else if (easedProgress > 0.9) {
      opacity = (1.0 - easedProgress) * 10;
    }
    
    return Stack(
      children: [
        Positioned(
          left: leftOffset,
          top: 0,
          bottom: 0,
          child: Container(
            width: barWidth.clamp(0, screenWidth),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  barColor.withOpacity(opacity * 0.95),
                  Color.lerp(barColor, colors[(colorIndex + 2) % colors.length], 0.3)!
                      .withOpacity(opacity * 0.85),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// 부드러운 스텝 함수 (더 자연스러운 이징)
  double _smoothStep(double t) {
    // Smoother step: 6t^5 - 15t^4 + 10t^3
    return t * t * t * (t * (t * 6 - 15) + 10);
  }
}
