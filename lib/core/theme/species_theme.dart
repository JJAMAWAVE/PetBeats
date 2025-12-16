import 'package:flutter/material.dart';

/// 종(Species)별 색상 테마 정의
/// 강아지와 고양이의 색상을 구분하되, 전체적인 통일성 유지
class SpeciesTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final LinearGradient headerGradient;
  final LinearGradient cardGradient;

  const SpeciesTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.headerGradient,
    required this.cardGradient,
  });

  /// 🐶 강아지 테마 (기존 블루 계열 유지)
  static final dog = SpeciesTheme(
    primaryColor: Color(0xFF4A90E2),      // 따뜻한 블루
    secondaryColor: Color(0xFF50C7E8),    // 하늘색
    accentColor: Color(0xFF6BA3FF),       // 밝은 블루
    backgroundColor: Color(0xFFF5F7FA),   // 밝은 회색-블루
    
    headerGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF4A90E2),
        Color(0xFF357ABD),
      ],
    ),
    
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF0F4F8),
      ],
    ),
  );

  /// 🐱 고양이 테마 (우아한 퍼플/틸 계열)
  /// 강아지와 비슷한 밝기/채도로 통일성 유지
  static final cat = SpeciesTheme(
    primaryColor: Color(0xFF8B7ABD),      // 부드러운 퍼플 (강아지 블루와 유사한 톤)
    secondaryColor: Color(0xFF6EC6C9),    // 틸/시안 (강아지 하늘색과 유사)
    accentColor: Color(0xFFA691D4),       // 라벤더 (강아지 밝은 블루와 유사)
    backgroundColor: Color(0xFFF7F5FA),   // 라벤더 화이트 (강아지와 유사한 밝기)
    
    headerGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF8B7ABD),
        Color(0xFF6B5B9D),
      ],
    ),
    
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF3F0F8),
      ],
    ),
  );

  /// 테마 간 보간 (애니메이션용)
  static SpeciesTheme lerp(SpeciesTheme a, SpeciesTheme b, double t) {
    return SpeciesTheme(
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t)!,
      secondaryColor: Color.lerp(a.secondaryColor, b.secondaryColor, t)!,
      accentColor: Color.lerp(a.accentColor, b.accentColor, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      headerGradient: LinearGradient.lerp(a.headerGradient, b.headerGradient, t)!,
      cardGradient: LinearGradient.lerp(a.cardGradient, b.cardGradient, t)!,
    );
  }
}
