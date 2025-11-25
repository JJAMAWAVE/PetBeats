import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: isSecondary
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
          boxShadow: isSecondary
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
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // 투명하게 해서 그라데이션 보이게 함
            foregroundColor: isSecondary ? AppColors.primaryBlue : Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            side: isSecondary
                ? const BorderSide(color: AppColors.primaryBlue, width: 1.5)
                : BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: isSecondary ? AppColors.primaryBlue : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
