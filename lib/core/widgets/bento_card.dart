import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:petbeats/core/widgets/parallax_tilt.dart';
import 'package:petbeats/core/widgets/shimmer_effect.dart';

class BentoCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final List<Color>? backgroundGradientColors;
  final bool enableParallax;
  final bool enableShimmer;
  final Color? glowColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;

  const BentoCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height,
    this.backgroundGradientColors,
    this.glowColor,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(20),
    this.border,
    this.enableParallax = false,
    this.enableShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 테마 컬러 (네온 느낌을 살짝 섞은 화이트/그레이)
    final bgColors = backgroundGradientColors ?? [
      Colors.white.withOpacity(0.7),
      Colors.white.withOpacity(0.4),
    ];
    
    final shadowColor = glowColor?.withOpacity(0.25) ?? Colors.black.withOpacity(0.05);

    Widget cardContent = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          // 1. 부드러운 유색 글로우 (깊이감)
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
          // 2. 내부 반사광을 흉내낸 얇은 그림자 (선명함)
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glassmorphism
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: bgColors,
              ),
              border: border ?? Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            // Shimmer applies to content + background if overlay, but here we wrap child
            // Actually shimmer should overlay the card surface. 
            // Wrapper pattern:
            child: enableShimmer 
              ? DynamicShimmer(
                  isActive: true,
                  child: child,
                ) 
              : child,
          ),
        ),
      ),
    );

    if (enableParallax) {
      return ParallaxTilt(
        // ParallaxTilt requires no borderRadius param based on implementation
        child: cardContent,
      );
    }

    return cardContent;
  }
}
