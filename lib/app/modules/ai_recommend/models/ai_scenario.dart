import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        return 'scenario_after_walk'.tr;
      case AIScenario.napTime:
        return 'scenario_nap'.tr;
      case AIScenario.hospital:
        return 'scenario_hospital'.tr;
      case AIScenario.grooming:
        return 'scenario_grooming'.tr;
      case AIScenario.thunder:
        return 'scenario_thunder'.tr;
      case AIScenario.anxiety:
        return 'scenario_anxiety'.tr;
    }
  }

  String get description {
    switch (this) {
      case AIScenario.afterWalk:
        return 'scenario_after_walk_subtitle'.tr;
      case AIScenario.napTime:
        return 'scenario_nap_subtitle'.tr;
      case AIScenario.hospital:
        return 'scenario_hospital_subtitle'.tr;
      case AIScenario.grooming:
        return 'scenario_grooming_subtitle'.tr;
      case AIScenario.thunder:
        return 'scenario_thunder_subtitle'.tr;
      case AIScenario.anxiety:
        return 'scenario_anxiety_subtitle'.tr;
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
        return const Color(0xFF4CAF50); // 초록
      case AIScenario.napTime:
        return const Color(0xFF6B8DD6); // 연한 파랑
      case AIScenario.hospital:
        return const Color(0xFFE89B6B); // 주황
      case AIScenario.grooming:
        return const Color(0xFF9C27B0); // 보라
      case AIScenario.thunder:
        return const Color(0xFF7E57C2); // 보라
      case AIScenario.anxiety:
        return const Color(0xFFFFC107); // 노랑
    }
  }
}
