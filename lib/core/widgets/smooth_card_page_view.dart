import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 부드러운 좌우 카드 페이지 전환 위젯
/// 
/// 카드 형태 설명이 들어가는 곳에 공통으로 사용
/// - 온보딩 질문 페이지
/// - AI 추천 시나리오
/// - 모드 상세 설명
/// - 구독 플랜 선택
/// - 햅틱 안전 가이드
class SmoothCardPageView extends StatefulWidget {
  final List<Widget> pages;
  final int initialPage;
  final Function(int)? onPageChanged;
  final bool showIndicator;
  final Color? indicatorActiveColor;
  final Color? indicatorInactiveColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableSwipe;
  final double viewportFraction;
  final PageController? controller;

  const SmoothCardPageView({
    super.key,
    required this.pages,
    this.initialPage = 0,
    this.onPageChanged,
    this.showIndicator = true,
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeOutCubic,
    this.enableSwipe = true,
    this.viewportFraction = 1.0,
    this.controller,
  });

  @override
  State<SmoothCardPageView> createState() => _SmoothCardPageViewState();
}

class _SmoothCardPageViewState extends State<SmoothCardPageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = widget.controller ?? PageController(
      initialPage: widget.initialPage,
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  void goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: widget.animationDuration,
      curve: widget.animationCurve,
    );
  }

  void nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      goToPage(_currentPage + 1);
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      goToPage(_currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: widget.enableSwipe 
                ? const BouncingScrollPhysics() 
                : const NeverScrollableScrollPhysics(),
            itemCount: widget.pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page ?? _currentPage.toDouble()) - index;
                    value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                  }
                  
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: widget.pages[index],
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // 도트 인디케이터
        if (widget.showIndicator && widget.pages.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
            child: _buildPageIndicator(),
          ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: _currentPage == index ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? (widget.indicatorActiveColor ?? const Color(0xFF6366F1))
                : (widget.indicatorInactiveColor ?? Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}

/// AnimatedBuilder wrapper for PageController animation
class AnimatedBuilder extends StatelessWidget {
  final Listenable animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder2({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  }) : super();

  Listenable get animation => listenable;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
