import 'package:flutter/material.dart';
import 'package:petbeats/core/theme/species_theme.dart';

/// 종(Species) 전환 시 색상이 위→아래로 애니메이션되는 위젯
class SpeciesThemeTransition extends StatefulWidget {
  final Widget child;
  final SpeciesTheme theme;
  final Duration duration;

  const SpeciesThemeTransition({
    Key? key,
    required this.child,
    required this.theme,
    this.duration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  State<SpeciesThemeTransition> createState() => _SpeciesThemeTransitionState();
}

class _SpeciesThemeTransitionState extends State<SpeciesThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SpeciesTheme? _previousTheme;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _previousTheme = widget.theme;
  }

  @override
  void didUpdateWidget(SpeciesThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _previousTheme = oldWidget.theme;
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // 이전 테마와 현재 테마 사이를 보간
        final interpolatedTheme = _previousTheme != null
            ? SpeciesTheme.lerp(_previousTheme!, widget.theme, _animation.value)
            : widget.theme;

        return Container(
          decoration: BoxDecoration(
            color: interpolatedTheme.backgroundColor,
          ),
          child: Stack(
            children: [
              // 배경 그라데이션 오버레이 (위→아래 sweep 효과)
              if (_animation.value < 1.0 && _previousTheme != null)
                Positioned.fill(
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _animation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              widget.theme.backgroundColor.withOpacity(0.9),
                              widget.theme.backgroundColor.withOpacity(0.7),
                              widget.theme.backgroundColor.withOpacity(0.0),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              
              // 실제 콘텐츠
              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
