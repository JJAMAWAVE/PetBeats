import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get title => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w600, // Slightly lighter bold
        color: AppColors.textDarkNavy,
      );

  static TextStyle get subtitle => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textDarkNavy,
      );

  static TextStyle get body => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textDarkNavy,
        height: 1.5, // Better readability
      );

  static TextStyle get button => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
