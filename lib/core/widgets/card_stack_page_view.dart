import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 카드 스택 페이지 데이터
class CardStackPage {
  final Widget content;
  final String? title;
  final IconData? icon;
  final Color? iconColor;

  const CardStackPage({
    required this.content,
    this.title,
    this.icon,
    this.iconColor,
  });
}

/// 공통 카드 스택 페이지뷰 위젯
/// 
/// 3개 뷰에서 공통으로 사용:
/// - AppInfoView
/// - SitterSpecialView
/// - HapticSafetyGuideDialog
class CardStackPageView extends StatefulWidget {
  /// 페이지 리스트
  final List<CardStackPage> pages;
  
  /// 헤더 타이틀
  final String? headerTitle;
  
  /// 헤더 아이콘
  final Widget? headerIcon;
  
  /// 하단 버튼 빌더 (현재 페이지, 총 페이지 수, 다음/이전 함수)
  final Widget Function(int currentPage, int totalPages, VoidCallback next, VoidCallback prev)? bottomButtonBuilder;
  
  /// 닫기 버튼 동작
  final VoidCallback? onClose;
  
  /// 배경 색상
  final Color backgroundColor;
  
  /// 카드 배경 색상
  final Color cardBackgroundColor;
  
  /// 다크 모드 여부
  final bool isDarkMode;
  
  /// 카드 높이 (null이면 Expanded)
  final double? cardHeight;
  
  /// 초기 페이지
  final int initialPage;

  const CardStackPageView({
    super.key,
    required this.pages,
    this.headerTitle,
    this.headerIcon,
    this.bottomButtonBuilder,
    this.onClose,
    this.backgroundColor = Colors.white,
    this.cardBackgroundColor = Colors.white,
    this.isDarkMode = false,
    this.cardHeight,
    this.initialPage = 0,
  });

  @override
  State<CardStackPageView> createState() => _CardStackPageViewState();
}

class _CardStackPageViewState extends State<CardStackPageView> 
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _cardAnimationController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(
      initialPage: widget.initialPage,
      viewportFraction: 1.0,
    );
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final textColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final subTextColor = isDark ? Colors.white70 : AppColors.textGrey;
    
    return Container(
      color: widget.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(textColor),
            
            // Card Stack Area
            Expanded(
              child: Stack(
                children: [
                  // Background stacked cards
                  ..._buildBackgroundCards(),
                  
                  // Main PageView with card content
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: widget.pages.length,
                    itemBuilder: (context, index) {
                      return _buildCardPage(index);
                    },
                  ),
                ],
              ),
            ),
            
            // Page Indicator
            _buildPageIndicator(),
            
            // Bottom Buttons
            if (widget.bottomButtonBuilder != null)
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
                child: widget.bottomButtonBuilder!(
                  _currentPage,
                  widget.pages.length,
                  _nextPage,
                  _prevPage,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Back/Close Button
          IconButton(
            onPressed: widget.onClose ?? () => Get.back(),
            icon: Icon(
              Icons.close,
              color: widget.isDarkMode ? Colors.white70 : Colors.black54,
              size: 24.sp,
            ),
          ),
          
          // Header Icon
          if (widget.headerIcon != null) ...[
            widget.headerIcon!,
            SizedBox(width: 8.w),
          ],
          
          // Header Title
          if (widget.headerTitle != null)
            Expanded(
              child: Text(
                widget.headerTitle!,
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const Spacer(),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundCards() {
    final List<Widget> cards = [];
    
    for (int i = 0; i < 2; i++) {
      final bgIndex = _currentPage + i + 1;
      if (bgIndex >= widget.pages.length) continue;
      
      cards.add(
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Transform.translate(
              offset: Offset(0, (i + 1) * 12.0),
              child: Transform.scale(
                scale: 1.0 - ((i + 1) * 0.05),
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: 0.4 - (i * 0.15),
                  child: Container(
                    margin: EdgeInsets.only(top: 8.h, bottom: 80.h),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return cards.reversed.toList();
  }

  Widget _buildCardPage(int index) {
    final page = widget.pages[index];
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        margin: EdgeInsets.only(top: 8.h, bottom: 80.h),
        decoration: BoxDecoration(
          color: widget.cardBackgroundColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: page.content,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.pages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentPage == index ? 24.w : 8.w,
            height: 8.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: _currentPage == index
                  ? AppColors.primaryBlue
                  : (widget.isDarkMode ? Colors.white24 : Colors.black12),
            ),
          ),
        ),
      ),
    );
  }
}

/// 기본 하단 버튼 위젯
class CardStackDefaultButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback? onComplete;
  final String? skipText;
  final String? nextText;
  final String? completeText;
  final bool isDarkMode;

  const CardStackDefaultButtons({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrev,
    this.onComplete,
    this.skipText,
    this.nextText,
    this.completeText,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage >= totalPages - 1;
    final isFirstPage = currentPage == 0;

    return Row(
      children: [
        // Left Button (Skip/Previous)
        if (isFirstPage)
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              skipText ?? 'skip'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDarkMode ? Colors.white54 : AppColors.textGrey,
              ),
            ),
          )
        else
          TextButton(
            onPressed: onPrev,
            child: Text(
              'previous'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDarkMode ? Colors.white70 : AppColors.textGrey,
              ),
            ),
          ),
        
        const Spacer(),
        
        // Right Button (Next/Complete)
        ElevatedButton(
          onPressed: isLastPage ? (onComplete ?? () => Get.back()) : onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            isLastPage 
                ? (completeText ?? 'confirm'.tr) 
                : (nextText ?? 'next'.tr),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
