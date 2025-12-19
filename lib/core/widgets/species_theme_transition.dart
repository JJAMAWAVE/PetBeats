import 'package:flutter/material.dart';
import 'package:petbeats/core/theme/species_theme.dart';

/// 종(Species) 전환 시 자연스러운 색상 페이드 애니메이션
/// 탭 버튼으로 아이콘과 색감이 부드럽게 변경됨
class SpeciesThemeTransition extends StatefulWidget {
  final Widget child;
  final SpeciesTheme theme;
  final Duration duration;

  const SpeciesThemeTransition({
    Key? key,
    required this.child,
    required this.theme,
    this.duration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  State<SpeciesThemeTransition> createState() => _SpeciesThemeTransitionState();
}

class _SpeciesThemeTransitionState extends State<SpeciesThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SpeciesTheme? _previousTheme;
  Color? _previousColor;
  Color? _previousAccent;

  // 강아지 색상 (블루 계열)
  static const Color dogBackgroundColor = Color(0xFFF8FAFF); // 밝은 블루 베이스
  static const Color dogAccentColor = Color(0xFF2196F3); // 블루 악센트

  // 고양이 색상 (진한 퍼플 계열 - 블루보다 살짝 진한)
  static const Color catBackgroundColor = Color(0xFFF5F3FF); // 밝은 퍼플 베이스
  static const Color catAccentColor = Color(0xFF7C4DFF); // 진한 퍼플 악센트

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
    _previousColor = _getBackgroundColor(widget.theme);
    _previousAccent = _getAccentColor(widget.theme);
  }

  @override
  void didUpdateWidget(SpeciesThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _previousTheme = oldWidget.theme;
      _previousColor = _getBackgroundColor(oldWidget.theme);
      _previousAccent = _getAccentColor(oldWidget.theme);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(SpeciesTheme theme) {
    return theme == SpeciesTheme.cat ? catBackgroundColor : dogBackgroundColor;
  }

  Color _getAccentColor(SpeciesTheme theme) {
    return theme == SpeciesTheme.cat ? catAccentColor : dogAccentColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // 이전 색상에서 새 색상으로 부드럽게 전환
        final currentBgColor = Color.lerp(
          _previousColor ?? _getBackgroundColor(widget.theme),
          _getBackgroundColor(widget.theme),
          _animation.value,
        )!;

        return Container(
          decoration: BoxDecoration(
            color: currentBgColor,
            // 미묘한 그라데이션 오버레이
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                currentBgColor,
                currentBgColor.withOpacity(0.95),
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
