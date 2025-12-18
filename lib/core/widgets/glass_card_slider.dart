import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 슬라이드 페이지 데이터
class GlassCardData {
  final String? imagePath;
  final String title;
  final String subtitle;
  final List<Map<String, String>>? badges;
  final String? footer;
  final Widget? customContent;

  const GlassCardData({
    this.imagePath,
    required this.title,
    required this.subtitle,
    this.badges,
    this.footer,
    this.customContent,
  });
}

/// 통일된 글래스 카드 슬라이더 위젯
/// 
/// 3개 뷰에서 완전히 동일한 디자인으로 사용:
/// - AppInfoView
/// - SitterSpecialView  
/// - HapticSafetyGuideDialog
class GlassCardSlider extends StatefulWidget {
  /// 슬라이드 데이터 리스트
  final List<GlassCardData> slides;
  
  /// 헤더 타이틀 (없으면 숨김)
  final String? headerTitle;
  
  /// 헤더 아이콘
  final Widget? headerIcon;
  
  /// 다크 모드 (다이얼로그용)
  final bool isDarkMode;
  
  /// 하단 CTA 버튼 빌더
  final Widget Function(int currentPage, int totalPages)? ctaButtonBuilder;
  
  /// 닫기 버튼 눌렀을 때
  final VoidCallback? onClose;
  
  /// 초기 페이지
  final int initialPage;

  const GlassCardSlider({
    super.key,
    required this.slides,
    this.headerTitle,
    this.headerIcon,
    this.isDarkMode = false,
    this.ctaButtonBuilder,
    this.onClose,
    this.initialPage = 0,
  });

  @override
  State<GlassCardSlider> createState() => _GlassCardSliderState();
}

class _GlassCardSliderState extends State<GlassCardSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.slides.length - 1) {
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
    final bgColor = widget.isDarkMode 
        ? const Color(0xFF1A1F2E) 
        : Colors.white;
    final textColor = widget.isDarkMode 
        ? Colors.white 
        : AppColors.textDarkNavy;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 헤더 (통일된 위치)
            _buildHeader(textColor),
            
            // 카드 영역 (스택 효과)
            Expanded(
              child: Stack(
                children: [
                  // 배경 스택 카드들
                  ..._buildBackgroundCards(),
                  
                  // 메인 PageView
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: widget.slides.length,
                    itemBuilder: (context, index) {
                      return _buildGlassCard(widget.slides[index]);
                    },
                  ),
                ],
              ),
            ),
            
            // 페이지 인디케이터 (통일된 스타일)
            _buildPageIndicator(),
            
            // 네비게이션 버튼 (통일된 위치)
            _buildNavigationButtons(textColor),
            
            // CTA 버튼 영역
            if (widget.ctaButtonBuilder != null)
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                child: widget.ctaButtonBuilder!(_currentPage, widget.slides.length),
              ),
          ],
        ),
      ),
    );
  }

  /// 헤더 - 통일된 위치와 스타일
  Widget _buildHeader(Color textColor) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // 닫기 버튼 (항상 동일 위치)
          IconButton(
            onPressed: widget.onClose ?? () => Get.back(),
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: widget.isDarkMode 
                    ? Colors.white.withOpacity(0.1) 
                    : Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                size: 20.sp,
              ),
            ),
          ),
          
          // 헤더 아이콘
          if (widget.headerIcon != null) ...[
            SizedBox(width: 8.w),
            widget.headerIcon!,
          ],
          
          // 헤더 타이틀
          if (widget.headerTitle != null) ...[
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                widget.headerTitle!,
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ] else
            const Spacer(),
        ],
      ),
    );
  }

  /// 배경 스택 카드들 - 겹쳐진 효과
  List<Widget> _buildBackgroundCards() {
    final List<Widget> cards = [];
    
    for (int i = 0; i < 2; i++) {
      final bgIndex = _currentPage + i + 1;
      if (bgIndex >= widget.slides.length) continue;
      
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
                  opacity: 0.5 - (i * 0.15),
                  child: Container(
                    margin: EdgeInsets.only(top: 8.h, bottom: 80.h),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode 
                          ? Colors.white.withOpacity(0.08)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: widget.isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white,
                        width: 1.5,
                      ),
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

  /// 글래스 카드 - 통일된 스타일
  Widget _buildGlassCard(GlassCardData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        margin: EdgeInsets.only(top: 8.h, bottom: 80.h),
        decoration: BoxDecoration(
          // 글래스 효과 배경
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isDarkMode
                ? [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.05),
                  ]
                : [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          // 글래스 테두리
          border: Border.all(
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.8),
            width: 1.5,
          ),
          // 입체감 그림자
          boxShadow: [
            BoxShadow(
              color: widget.isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : AppColors.primaryBlue.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
            // 내부 광택 효과
            BoxShadow(
              color: Colors.white.withOpacity(widget.isDarkMode ? 0.05 : 0.5),
              blurRadius: 1,
              offset: const Offset(0, -1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: _buildCardContent(data),
          ),
        ),
      ),
    );
  }

  /// 카드 내용 - 통일된 레이아웃 (이미지 + 텍스트)
  Widget _buildCardContent(GlassCardData data) {
    final textColor = widget.isDarkMode ? Colors.white : AppColors.textDarkNavy;
    final subTextColor = widget.isDarkMode 
        ? Colors.white70 
        : AppColors.textDarkNavy.withOpacity(0.7);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 이미지 영역 - 통일된 높이
          if (data.imagePath != null)
            Container(
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  data.imagePath!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    child: Icon(
                      Icons.image_outlined,
                      size: 48.sp,
                      color: AppColors.primaryBlue.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          
          // 커스텀 콘텐츠 (이미지 대신)
          if (data.customContent != null)
            data.customContent!,
          
          SizedBox(height: 20.h),
          
          // 타이틀 - 통일된 폰트 사이즈
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleLarge.copyWith(
              color: textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // 서브타이틀 - 통일된 폰트 사이즈
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: subTextColor,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          
          // 뱃지
          if (data.badges != null && data.badges!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.center,
              children: data.badges!.map((badge) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(badge['icon'] ?? '', style: TextStyle(fontSize: 14.sp)),
                      SizedBox(width: 4.w),
                      Text(
                        badge['text'] ?? '',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          
          // 푸터
          if (data.footer != null) ...[
            SizedBox(height: 16.h),
            Text(
              data.footer!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white38 : Colors.grey[400],
                fontSize: 10.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 페이지 인디케이터 - 통일된 스타일
  Widget _buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.slides.length,
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
              boxShadow: _currentPage == index
                  ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  /// 네비게이션 버튼 - 통일된 위치와 스타일
  Widget _buildNavigationButtons(Color textColor) {
    final isFirst = _currentPage == 0;
    final isLast = _currentPage >= widget.slides.length - 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          // 이전/건너뛰기 버튼
          TextButton(
            onPressed: isFirst ? (widget.onClose ?? () => Get.back()) : _prevPage,
            child: Text(
              isFirst ? 'skip'.tr : 'previous'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: widget.isDarkMode ? Colors.white54 : AppColors.textGrey,
                fontSize: 14.sp,
              ),
            ),
          ),
          
          const Spacer(),
          
          // 다음/확인 버튼
          ElevatedButton(
            onPressed: isLast ? (widget.onClose ?? () => Get.back()) : _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 4,
              shadowColor: AppColors.primaryBlue.withOpacity(0.4),
            ),
            child: Text(
              isLast ? 'confirm'.tr : 'next'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
