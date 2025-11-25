import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // 반응 속도 빠르게
      lowerBound: 0.0,
      upperBound: 0.04, // 4% 축소 (1.0 -> 0.96)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - _controller.value,
            child: child,
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: widget.isSecondary
                  ? null
                  : const LinearGradient(
                      colors: [
                        Color(0xFF4B7BFF), // Lighter Blue (Highlight)
                        AppColors.primaryBlue, // Main Blue
                        AppColors.secondaryBlue, // Darker Blue
                      ],
                      stops: [0.0, 0.4, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              boxShadow: widget.isSecondary
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: widget.isSecondary ? Colors.transparent : null,
                border: widget.isSecondary
                    ? Border.all(color: AppColors.primaryBlue, width: 1.5)
                    : null,
              ),
              child: Text(
                widget.text,
                style: AppTextStyles.button.copyWith(
                  color: widget.isSecondary ? AppColors.primaryBlue : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
