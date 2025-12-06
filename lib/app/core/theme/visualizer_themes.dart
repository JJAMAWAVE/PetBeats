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

  // 수면/시니어: 따뜻한 새벽빛 (포근하고 치유적)
  static const sleepTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF2D1B2E), // 따뜻한 딥 퍼플
        Color(0xFF4A2C4A), // 로즈 그레이
        Color(0xFF6B4A6B), // 소프트 모브
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFFFFD700), // 골드
        Color(0xFFFFA500), // 오렌지 골드
        Color(0xFFFFF8DC), // 웜 크림
      ],
    ),
    particleColor: Color(0xFFFFE66D), // 반딧불이 옐로우
    glowColor: Color(0xFFFFD700), // 웜 골드
  );

  // 불안: 청록색과 초록 (진정되고 평온함)
  static const anxietyTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0A2F35), // 다크 틸
        Color(0xFF0F4C5C), // 딥 시안
        Color(0xFF1B5E63), // 오션 그린
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFF2EC4B6), // 터키시 블루
        Color(0xFF64DFDF), // 아쿠아 민트
        Color(0xFFCBF3F0), // 라이트 시안
      ],
    ),
    particleColor: Color(0xFFCBF3F0), // 소프트 민트
    glowColor: Color(0xFF2EC4B6), // 터키시 블루
  );

  // 에너지: 생동감 있는 주황과 빨강 (활기차고 고양됨)
  static const energyTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF641E16), // 딥 레드
        Color(0xFF922B21), // 다크 카민
        Color(0xFFBA4A00), // 버닝 오렌지
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFFFF6B6B), // 코랄 레드
        Color(0xFFFFBE0B), // 선샤인 옐로우
        Color(0xFFFB5607), // 파이어 오렌지
      ],
    ),
    particleColor: Color(0xFFFFBE0B), // 골든 옐로우
    glowColor: Color(0xFFFF6B6B), // 코랄 레드
  );

  // 소음: 차가운 실버와 화이트 (중립적이고 차폐함)
  static const noiseTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF212121), // 차콜
        Color(0xFF424242), // 다크 그레이
        Color(0xFF616161), // 미디엄 그레이
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFFB0BEC5), // 실버 그레이
        Color(0xFFCFD8DC), // 라이트 스틸
        Color(0xFFECEFF1), // 페일 그레이
      ],
    ),
    particleColor: Color(0xFFECEFF1), // 오프 화이트
    glowColor: Color(0xFFB0BEC5), // 실버
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
