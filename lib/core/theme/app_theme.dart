import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.backgroundWhite,
    useMaterial3: true,
    fontFamily: 'Pretendard', // Assuming Pretendard based on pubspec.yaml
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
    ),
  );
}
