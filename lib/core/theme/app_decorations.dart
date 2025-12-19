import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_shadows.dart';

/// 앱 전체 데코레이션 스타일 정의
/// 
/// 홈 화면 기준으로 통일된 BoxDecoration 사용
class AppDecorations {
  AppDecorations._();

  // ============ Card Decorations ============

  /// 표준 카드 (밝은 배경, 파란 테두리)
  static BoxDecoration get standardCard => BoxDecoration(
    color: Colors.white.withOpacity(0.85),
    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
    border: Border.all(
      color: AppColors.primaryBlue.withOpacity(0.15),
      width: 1.5,
    ),
    boxShadow: AppShadows.cardShadow,
  );

  /// 흰색 솔리드 카드 (투명도 없음)
  static BoxDecoration get solidCard => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
    border: Border.all(
      color: AppColors.primaryBlue.withOpacity(0.1),
      width: 1,
    ),
    boxShadow: AppShadows.cardShadow,
  );

  /// 다크 카드 (플레이어 등)
  static BoxDecoration get darkCard => BoxDecoration(
    color: AppColors.backgroundDarkNavy,
    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
    boxShadow: AppShadows.darkCardShadow,
  );

  /// 글래스모픽 카드 (투명 배경)
  static BoxDecoration get glassCard => BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: 1,
    ),
  );

  /// 그라데이션 카드 (프리미엄 느낌)
  static BoxDecoration get gradientCard => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white,
        Colors.grey.shade50,
      ],
    ),
    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
    border: Border.all(
      color: Colors.white.withOpacity(0.8),
      width: 2,
    ),
    boxShadow: AppShadows.cardShadow,
  );

  // ============ Button Decorations ============

  /// Primary 버튼 (파란색)
  static BoxDecoration get primaryButton => BoxDecoration(
    color: AppColors.primaryBlue,
    borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
    boxShadow: AppShadows.buttonShadow,
  );

  /// Secondary 버튼 (투명 + 테두리)
  static BoxDecoration get secondaryButton => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
    border: Border.all(
      color: AppColors.primaryBlue,
      width: 1.5,
    ),
  );

  /// 아이콘 버튼 (헤더용)
  static BoxDecoration get iconButton => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: AppShadows.iconButtonShadow,
  );

  // ============ Input Decorations ============

  /// 표준 입력 필드
  static BoxDecoration get inputField => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(
      color: AppColors.lineLightBlue,
      width: 1,
    ),
  );

  /// 포커스된 입력 필드
  static BoxDecoration get inputFieldFocused => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(
      color: AppColors.primaryBlue,
      width: 2,
    ),
  );

  // ============ Special Decorations ============

  /// 바텀 시트 상단
  static BoxDecoration get bottomSheet => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(24.r),
    ),
    boxShadow: AppShadows.floatingShadow,
  );

  /// 미니 플레이어
  static BoxDecoration get miniPlayer => BoxDecoration(
    color: AppColors.backgroundDarkNavy,
    borderRadius: BorderRadius.circular(20.r),
    boxShadow: AppShadows.floatingShadow,
  );

  /// 선택된 아이템 (모드 버튼 등)
  static BoxDecoration selectedItem(Color color) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
    border: Border.all(
      color: color,
      width: 2,
    ),
  );

  /// 비선택 아이템
  static BoxDecoration get unselectedItem => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
    border: Border.all(
      color: Colors.grey.shade200,
      width: 1,
    ),
  );
}
