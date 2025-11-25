import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // 기본 스타일 정의 (Noto Sans + Fallback)
  static TextStyle get baseStyle => GoogleFonts.notoSans(
    color: AppColors.textDarkNavy,
  ).copyWith(
    fontFamilyFallback: [
      GoogleFonts.notoSansKr().fontFamily!,
      GoogleFonts.notoSansSc().fontFamily!,
      GoogleFonts.notoSansTc().fontFamily!,
    ],
  );

  static TextStyle get logo => baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
    letterSpacing: -0.5,
  );

  static TextStyle get titleLarge => baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDarkNavy,
  );

  static TextStyle get titleMedium => baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDarkNavy,
  );

  static TextStyle get bodyLarge => baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textDarkNavy,
  );

  static TextStyle get bodyMedium => baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textGrey,
  );

  static TextStyle get subtitle => baseStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
    height: 1.5,
  );

  static TextStyle get button => baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}
