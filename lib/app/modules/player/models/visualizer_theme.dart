import 'package:flutter/material.dart';

enum ParticleEffect {
  none,
  sparkle, // 반짝임 (에너지)
  bubble,  // 비눗방울 (놀이)
  star,    // 별 (수면)
  heart,   // 하트 (시니어/돌봄)
}

class VisualizerTheme {
  final List<Color> colorPalette;
  final double rippleSpeed;
  final double blurIntensity;
  final ParticleEffect particleType;
  final double baseOpacity;

  const VisualizerTheme({
    required this.colorPalette,
    this.rippleSpeed = 1.0,
    this.blurIntensity = 20.0,
    this.particleType = ParticleEffect.none,
    this.baseOpacity = 0.3,
  });

  // Predefined Themes
  static const sleep = VisualizerTheme(
    colorPalette: [Color(0xFF1A237E), Color(0xFF3949AB), Color(0xFF7986CB)], // Deep Blue
    rippleSpeed: 0.5,
    blurIntensity: 30.0,
    particleType: ParticleEffect.star,
    baseOpacity: 0.2,
  );

  static const energy = VisualizerTheme(
    colorPalette: [Color(0xFFFF6D00), Color(0xFFFFAB40), Color(0xFFFFD180)], // Orange
    rippleSpeed: 1.5,
    blurIntensity: 15.0,
    particleType: ParticleEffect.sparkle,
    baseOpacity: 0.4,
  );

  static const anxiety = VisualizerTheme(
    colorPalette: [Color(0xFF00695C), Color(0xFF26A69A), Color(0xFF80CBC4)], // Teal
    rippleSpeed: 0.8,
    blurIntensity: 25.0,
    particleType: ParticleEffect.bubble,
    baseOpacity: 0.3,
  );

  static const senior = VisualizerTheme(
    colorPalette: [Color(0xFF6A1B9A), Color(0xFFAB47BC), Color(0xFFE1BEE7)], // Purple
    rippleSpeed: 0.7,
    blurIntensity: 20.0,
    particleType: ParticleEffect.heart,
    baseOpacity: 0.25,
  );
  
  static const noise = VisualizerTheme(
    colorPalette: [Color(0xFF455A64), Color(0xFF78909C), Color(0xFFB0BEC5)], // Blue Grey
    rippleSpeed: 1.0,
    blurIntensity: 10.0,
    particleType: ParticleEffect.none,
    baseOpacity: 0.3,
  );
}
