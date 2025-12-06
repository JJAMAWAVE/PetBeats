import 'package:flutter/material.dart';

/// 모드별 비주얼라이저 색상 테마
class VisualizerTheme {
  final Gradient backgroundGradient;
  final Gradient waveformGradient;
  final Color particleColor;
  final Color glowColor;

  const VisualizerTheme({
    required this.backgroundGradient,
    required this.waveformGradient,
    required this.particleColor,
    required this.glowColor,
  });

  // 수면/시니어: 차분하고 평화로움
  static const sleepTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF2C3E50), // 다크 네이비
        Color(0xFF4A90E2), // 소프트 블루
        Color(0xFF9B6BCF), // 부드러운 퍼플
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFF4A90E2), // 소프트 블루
        Color(0xFF9B6BCF), // 부드러운 퍼플
        Color(0xFFE8C4F0), // 라이트 라벤더
      ],
    ),
    particleColor: Color(0xFFB8E6F5),
    glowColor: Color(0xFF9B6BCF),
  );

  // 불안: 진정되고 평온함
  static const anxietyTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1E3A3A), // 다크 틸
        Color(0xFF67D5B5), // 민트 그린
        Color(0xFF84C5F4), // 스카이 블루
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFF67D5B5), // 민트 그린
        Color(0xFF84C5F4), // 스카이 블루
        Color(0xFFB8E6F5), // 페일 시안
      ],
    ),
    particleColor: Color(0xFFB8E6F5),
    glowColor: Color(0xFF67D5B5),
  );

  // 에너지: 생동감 있고 고양됨
  static const energyTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF7F4A23), // 다크 오렌지
        Color(0xFFFFAE42), // 따뜻한 오렌지
        Color(0xFFFFD93D), // 밝은 노란색
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFFFFAE42), // 따뜻한 오렌지
        Color(0xFFFFD93D), // 밝은 노란색
        Color(0xFFFFF7AE), // 라이트 크림
      ],
    ),
    particleColor: Color(0xFFFFF7AE),
    glowColor: Color(0xFFFFAE42),
  );

  // 소음: 중립적이고 차폐함
  static const noiseTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF2C3E50), // 다크 그레이
        Color(0xFF95A5A6), // 미디엄 그레이
        Color(0xFFD0D3D4), // 라이트 그레이
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFF95A5A6), // 미디엄 그레이
        Color(0xFFD0D3D4), // 라이트 그레이
        Color(0xFFFFFFFF), // 화이트
      ],
    ),
    particleColor: Color(0xFFECF0F1),
    glowColor: Color(0xFFBDC3C7),
  );

  // 모드 ID로 테마 가져오기
  static VisualizerTheme getThemeForMode(String modeId) {
    switch (modeId) {
      case 'sleep':
      case 'senior':
        return sleepTheme;
      case 'anxiety':
        return anxietyTheme;
      case 'energy':
        return energyTheme;
      case 'noise':
        return noiseTheme;
      default:
        return sleepTheme;
    }
  }
}
