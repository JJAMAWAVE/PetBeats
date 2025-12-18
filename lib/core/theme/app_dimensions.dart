import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱 전체 디자인 규격 상수
/// 
/// 홈 화면 기준으로 통일된 값 사용
class AppDimensions {
  AppDimensions._();

  // ============ Card ============
  /// 카드 모서리 둥글기
  static double get cardBorderRadius => 20.r;
  
  /// 카드 내부 패딩
  static double get cardPadding => 20.w;
  
  /// 카드 그림자 블러
  static const double cardShadowBlur = 12;
  
  /// 카드 그림자 오프셋
  static const double cardShadowOffsetY = 6;
  
  /// 카드 그림자 투명도
  static const double cardShadowOpacity = 0.08;

  // ============ Spacing ============
  /// 화면 좌우 패딩
  static double get screenPadding => 24.w;
  
  /// 섹션 간격
  static double get sectionGap => 24.h;
  
  /// 아이템 간격
  static double get itemGap => 12.h;
  
  /// 작은 간격
  static double get smallGap => 8.h;

  // ============ Icon ============
  /// 큰 아이콘 (카드 메인)
  static double get iconLarge => 32.sp;
  
  /// 중간 아이콘 (버튼)
  static double get iconMedium => 24.sp;
  
  /// 작은 아이콘 (닫기 버튼)
  static double get iconSmall => 20.sp;

  // ============ Button ============
  /// 닫기 버튼 컨테이너 사이즈
  static double get closeButtonSize => 36.w;
  
  /// 기본 버튼 높이
  static double get buttonHeight => 56.h;
  
  /// 버튼 모서리 둥글기
  static double get buttonBorderRadius => 16.r;
}
