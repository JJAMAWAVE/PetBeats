import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get title => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700, // Bold
        color: AppColors.textDarkNavy,
        letterSpacing: -0.5,
      );

  static TextStyle get logo => GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w800, // Extra Bold
        color: AppColors.primaryBlue,
        letterSpacing: -1.0,
      );

  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
        height: 1.4,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textDarkNavy,
        height: 1.6,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.5,
      );
}
