import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱 전체 그림자 스타일 정의
/// 
/// 홈 화면 기준으로 통일된 그림자 사용
class AppShadows {
  AppShadows._();

  /// 표준 카드 그림자 (밝은 배경용)
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  /// 강조 카드 그림자 (호버/선택 시)
  static List<BoxShadow> get cardShadowElevated => [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  /// 버튼 그림자
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  /// 플로팅 요소 그림자 (미니 플레이어, FAB 등)
  static List<BoxShadow> get floatingShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ];

  /// 다크 모드용 그림자
  static List<BoxShadow> get darkCardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  /// 아이콘 버튼 그림자 (헤더 등)
  static List<BoxShadow> get iconButtonShadow => [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
