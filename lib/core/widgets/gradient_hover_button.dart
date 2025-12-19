import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// CSS btn-hover 효과를 Flutter로 구현한 그라데이션 애니메이션 버튼
/// 
/// 호버/탭 시 그라데이션이 좌→우로 애니메이션되는 효과
class GradientHoverButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final GradientButtonStyle style;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;

  const GradientHoverButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = GradientButtonStyle.color9, // 기본: 파란색
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<GradientHoverButton> createState() => _GradientHoverButtonState();
}

class _GradientHoverButtonState extends State<GradientHoverButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.style.colors;
    final shadowColor = widget.style.shadowColor;

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: widget.width ?? 200.w,
            height: widget.height ?? 55.h,
            transform: Matrix4.identity()
              ..scale(_isPressed ? 0.98 : 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              gradient: LinearGradient(
                colors: gradientColors,
                // 애니메이션: 0% → 100% (그라데이션 위치 이동)
                begin: Alignment(-1.0 + (_animation.value * 2), 0),
                end: Alignment(1.0 + (_animation.value * 2), 0),
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(_isPressed ? 0.9 : 0.75),
                  blurRadius: _isPressed ? 20 : 15,
                  offset: Offset(0, _isPressed ? 6 : 4),
                ),
              ],
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 20.sp),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

/// 버튼 스타일 (CSS color-1 ~ color-11 대응)
enum GradientButtonStyle {
  /// 그린-시안 (color-1)
  color1,
  /// 오렌지-핑크 (color-2)
  color2,
  /// 퍼플-바이올렛 (color-3)
  color3,
  /// 코랄-오렌지 (color-4)
  color4,
  /// 그린 (color-5)
  color5,
  /// 그린-옐로우 (color-6)
  color6,
  /// 퍼플-레드 (color-7)
  color7,
  /// 다크 그레이 (color-8)
  color8,
  /// 블루 (color-9) - 앱 기본 스타일
  color9,
  /// 핑크-오렌지 (color-10)
  color10,
  /// 레드 (color-11)
  color11,
}

extension GradientButtonStyleExtension on GradientButtonStyle {
  List<Color> get colors {
    switch (this) {
      case GradientButtonStyle.color1:
        return const [Color(0xFF25AAE1), Color(0xFF40E495), Color(0xFF30DD8A), Color(0xFF2BB673)];
      case GradientButtonStyle.color2:
        return const [Color(0xFFF5CE62), Color(0xFFE43603), Color(0xFFFA7199), Color(0xFFE85A19)];
      case GradientButtonStyle.color3:
        return const [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFF6B8DD6), Color(0xFF8E37D7)];
      case GradientButtonStyle.color4:
        return const [Color(0xFFFC6076), Color(0xFFFF9A44), Color(0xFFEF9D43), Color(0xFFE75516)];
      case GradientButtonStyle.color5:
        return const [Color(0xFF0BA360), Color(0xFF3CBA92), Color(0xFF30DD8A), Color(0xFF2BB673)];
      case GradientButtonStyle.color6:
        return const [Color(0xFF009245), Color(0xFFFCEE21), Color(0xFF00A8C5), Color(0xFFD9E021)];
      case GradientButtonStyle.color7:
        return const [Color(0xFF6253E1), Color(0xFF852D91), Color(0xFFA3A1FF), Color(0xFFF24645)];
      case GradientButtonStyle.color8:
        return const [Color(0xFF29323C), Color(0xFF485563), Color(0xFF2B5876), Color(0xFF4E4376)];
      case GradientButtonStyle.color9:
        return const [Color(0xFF25AAE1), Color(0xFF4481EB), Color(0xFF04BEFE), Color(0xFF3F86ED)];
      case GradientButtonStyle.color10:
        return const [Color(0xFFED6EA0), Color(0xFFEC8C69), Color(0xFFF7186A), Color(0xFFFBB03B)];
      case GradientButtonStyle.color11:
        return const [Color(0xFFEB3941), Color(0xFFF15E64), Color(0xFFE14E53), Color(0xFFE2373F)];
    }
  }

  Color get shadowColor {
    switch (this) {
      case GradientButtonStyle.color1:
        return const Color(0xFF31C4BE);
      case GradientButtonStyle.color2:
        return const Color(0xFFE5420A);
      case GradientButtonStyle.color3:
        return const Color(0xFF744FA8);
      case GradientButtonStyle.color4:
        return const Color(0xFFFC686E);
      case GradientButtonStyle.color5:
        return const Color(0xFF17A86C);
      case GradientButtonStyle.color6:
        return const Color(0xFF53B039);
      case GradientButtonStyle.color7:
        return const Color(0xFF7E34A1);
      case GradientButtonStyle.color8:
        return const Color(0xFF2D3641);
      case GradientButtonStyle.color9:
        return const Color(0xFF4184EA);
      case GradientButtonStyle.color10:
        return const Color(0xFFEC7495);
      case GradientButtonStyle.color11:
        return const Color(0xFFF26167);
    }
  }
}
