import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 그라데이션 호버 효과가 적용된 커스텀 버튼
/// 
/// 탭 시 그라데이션이 좌→우로 슬라이드되는 애니메이션 효과
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientAnimation;
  bool _isPressed = false;

  // 그라데이션 색상 (더 블루 톤)
  static const List<Color> _gradientColors = [
    Color(0xFF2E5BFF), // Primary Blue
    Color(0xFF4A90E2), // Sky Blue
    Color(0xFF5B8DEF), // Medium Blue  
    Color(0xFF1E90FF), // Dodger Blue
  ];
  
  static const Color _shadowColor = Color(0xFF2E5BFF);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSecondary) {
      return _buildSecondaryButton();
    }
    return _buildPrimaryButton();
  }

  Widget _buildPrimaryButton() {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: 56.h,
            transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              gradient: LinearGradient(
                colors: _gradientColors,
                // 애니메이션: 그라데이션 위치 이동 (0% → 100%)
                begin: Alignment(-1.0 + (_gradientAnimation.value * 2), 0),
                end: Alignment(1.0 + (_gradientAnimation.value * 2), 0),
              ),
              boxShadow: [
                BoxShadow(
                  color: _shadowColor.withOpacity(_isPressed ? 0.9 : 0.75),
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
                          style: AppTextStyles.button.copyWith(
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

  Widget _buildSecondaryButton() {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 56.h,
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Colors.transparent,
          border: Border.all(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: AppColors.primaryBlue, size: 20.sp),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      widget.text,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primaryBlue,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
