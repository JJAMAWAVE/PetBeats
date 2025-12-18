import 'package:flutter/material.dart';

/// 부드러운 좌우 슬라이드 페이지 전환 효과
/// 
/// GetX 라우팅에서 사용:
/// GetPage(
///   transition: Transition.custom,
///   customTransition: SmoothSlideTransition(),
/// )
class SmoothSlideTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // 오른쪽에서 들어옴
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: curve ?? Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.3, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeOutCubic,
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-0.3, 0.0), // 왼쪽으로 나감
          ).animate(CurvedAnimation(
            parent: secondaryAnimation,
            curve: curve ?? Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.7).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: curve ?? Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 부드러운 카드 스케일 전환 효과
/// 카드가 뒤로 밀리면서 새 카드가 앞으로 나오는 효과
class CardStackTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final effectiveCurve = curve ?? Curves.easeOutCubic;
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // 들어오는 페이지: 오른쪽에서 슬라이드 + 페이드 인
        final slideIn = Tween<Offset>(
          begin: const Offset(0.8, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: effectiveCurve));
        
        final fadeIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: effectiveCurve));
        
        final scaleIn = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: effectiveCurve));
        
        // 나가는 페이지: 축소 + 페이드 아웃
        final scaleOut = Tween<double>(
          begin: 1.0,
          end: 0.9,
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: effectiveCurve));
        
        final fadeOut = Tween<double>(
          begin: 1.0,
          end: 0.5,
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: effectiveCurve));
        
        return FadeTransition(
          opacity: fadeIn,
          child: SlideTransition(
            position: slideIn,
            child: ScaleTransition(
              scale: scaleIn,
              child: ScaleTransition(
                scale: scaleOut,
                child: FadeTransition(
                  opacity: fadeOut,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// AnimatedBuilder for CustomTransition
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
