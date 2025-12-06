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

  // 수면/시니어: 깊은 파란색과 보라 (차분하고 평화로움)
  static const sleepTheme = VisualizerTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A1A2E), // 딥 네이비
        Color(0xFF16213E), // 미드나잇 블루
        Color(0xFF0F3460), // 다크 블루
      ],
    ),
    waveformGradient: LinearGradient(
      colors: [
        Color(0xFF5E60CE), // 비비드 퍼플
        Color(0xFF6930C3), // 딥 퍼플
        Color(0xFF80FFDB), // 민트 아쿠아
      ],
    ),
    particleColor: Color(0xFF80FFDB), // 밝은 민트
    glowColor: Color(0xFF5E60CE), // 비비드 퍼플
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
