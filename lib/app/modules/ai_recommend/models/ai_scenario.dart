import 'package:flutter/material.dart';

/// AI 맞춤 추천 시나리오
enum AIScenario {
  afterWalk,
  napTime,
  hospital,
  grooming,
  thunder,
  anxiety,
}

extension AIScenarioExt on AIScenario {
  String get title {
    switch (this) {
      case AIScenario.afterWalk:
        return '산책 후';
      case AIScenario.napTime:
        return '낮잠 시간';
      case AIScenario.hospital:
        return '병원 방문';
      case AIScenario.grooming:
        return '미용 후';
      case AIScenario.thunder:
        return '천둥/번개';
      case AIScenario.anxiety:
        return '분리 불안';
    }
  }

  String get description {
    switch (this) {
      case AIScenario.afterWalk:
        return '활발한 산책 후 차분하게 진정시켜주세요';
      case AIScenario.napTime:
        return '달콤한 낮잠을 위한 수면 유도 사운드';
      case AIScenario.hospital:
        return '병원 스트레스를 줄여주는 안정 사운드';
      case AIScenario.grooming:
        return '미용 스트레스 해소를 위한 힐링 사운드';
      case AIScenario.thunder:
        return '천둥 소리를 덮어주는 마스킹 사운드';
      case AIScenario.anxiety:
        return '혼자 있을 때도 안심할 수 있도록';
    }
  }

  IconData get icon {
    switch (this) {
      case AIScenario.afterWalk:
        return Icons.water_drop_outlined;
      case AIScenario.napTime:
        return Icons.nightlight_round;
      case AIScenario.hospital:
        return Icons.favorite_border;
      case AIScenario.grooming:
        return Icons.auto_awesome;
      case AIScenario.thunder:
        return Icons.flash_on;
      case AIScenario.anxiety:
        return Icons.waves;
    }
  }

  Color get color {
    switch (this) {
      case AIScenario.afterWalk:
        return const Color(0xFF4A9AD4);
      case AIScenario.napTime:
        return const Color(0xFF6B8DD6);
      case AIScenario.hospital:
        return const Color(0xFFE89B6B);
      case AIScenario.grooming:
        return const Color(0xFFE8A96B);
      case AIScenario.thunder:
        return const Color(0xFF5AAD7A);
      case AIScenario.anxiety:
        return const Color(0xFF8B7BC7);
    }
  }
}
