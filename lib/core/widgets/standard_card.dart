import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_decorations.dart';

/// 표준 카드 위젯
/// 
/// 앱 전체에서 일관된 카드 스타일 적용
class StandardCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final CardVariant variant;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  const StandardCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.variant = CardVariant.standard,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(AppDimensions.cardPadding),
      margin: margin,
      decoration: _getDecoration(),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }

  BoxDecoration _getDecoration() {
    switch (variant) {
      case CardVariant.standard:
        if (backgroundColor != null || borderColor != null) {
          return BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.primaryBlue.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: AppDecorations.standardCard.boxShadow,
          );
        }
        return AppDecorations.standardCard;
      case CardVariant.solid:
        return AppDecorations.solidCard;
      case CardVariant.dark:
        return AppDecorations.darkCard;
      case CardVariant.glass:
        return AppDecorations.glassCard;
      case CardVariant.gradient:
        return AppDecorations.gradientCard;
    }
  }
}

/// 카드 변형 타입
enum CardVariant {
  /// 표준 (반투명 흰색 + 파란 테두리)
  standard,
  /// 솔리드 (불투명 흰색)
  solid,
  /// 다크 (어두운 배경)
  dark,
  /// 글래스 (글래스모픽)
  glass,
  /// 그라데이션
  gradient,
}
