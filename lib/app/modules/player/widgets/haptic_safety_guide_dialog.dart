import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart'; // ✨ For animations
import 'package:petbeats/core/theme/app_colors.dart';
import 'package:petbeats/core/theme/app_text_styles.dart';

/// Haptic Safety Guide Dialog
/// 
/// 3-card slider showing proper haptic therapy usage:
/// 1. Warning: Don't place directly on pet
/// 2. Method A: Use blanket/cushion
/// 3. Method B: Guardian's embrace
class HapticSafetyGuideDialog extends StatefulWidget {
  const HapticSafetyGuideDialog({Key? key}) : super(key: key);

  @override
  State<HapticSafetyGuideDialog> createState() => _HapticSafetyGuideDialogState();
}

class _HapticSafetyGuideDialogState extends State<HapticSafetyGuideDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> get _cards => [
    {
      'step': '1',
      'titleIcon': Icons.warning_amber_rounded,
      'titleColor': Colors.amber,
      'title': 'haptic_guide_step1_title'.tr,
      'keyPoints': [
        'haptic_guide_step1_point1'.tr,
        'haptic_guide_step1_point2'.tr,
      ],
      'bottomText': 'haptic_guide_step1_desc'.tr,
      'image': 'assets/images/Haptic/1.png',
    },
    {
      'step': '2',
      'titleIcon': Icons.pets,
      'titleColor': AppColors.primaryBlue,
      'title': 'haptic_guide_step2_title'.tr,
      'keyPoints': [
        'haptic_guide_step2_point1'.tr,
        'haptic_guide_step2_point2'.tr,
      ],
      'bottomText': 'haptic_guide_step2_desc'.tr,
      'image': 'assets/images/Haptic/2.png',
    },
    {
      'step': '3',
      'titleIcon': Icons.favorite,
      'titleColor': Colors.pinkAccent,
      'title': 'haptic_guide_step3_title'.tr,
      'keyPoints': [
        'haptic_guide_step3_point1'.tr,
        'haptic_guide_step3_point2'.tr,
      ],
      'bottomText': 'haptic_guide_step3_desc'.tr,
      'image': 'assets/images/Haptic/3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1E2A3A),
                const Color(0xFF162033),
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.pinkAccent.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with pulse animation
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Row(
                  children: [
                    Pulse(
                      infinite: true,
                      duration: const Duration(seconds: 2),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.pinkAccent,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'haptic_guide_title'.tr,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              // Page View with Card Stack Effect
              SizedBox(
                height: 500.h,
                child: Stack(
                  children: [
                    // Background cards (stacked effect)
                    ...List.generate(2, (i) {
                      final bgIndex = _currentPage + i + 1;
                      if (bgIndex >= _cards.length) return const SizedBox.shrink();
                      return Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Transform.translate(
                            offset: Offset(0, (i + 1) * 8.0),
                            child: Transform.scale(
                              scale: 1.0 - ((i + 1) * 0.04),
                              alignment: Alignment.topCenter,
                              child: Opacity(
                                opacity: 0.3 - (i * 0.1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A3A4A),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    // Main PageView
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        return _buildCard(_cards[index], index);
                      },
                    ),
                  ],
                ),
              ),

              // Animated Page Indicator
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _cards.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 24.w : 8.w,
                      height: 8.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: _currentPage == index
                            ? AppColors.primaryBlue
                            : Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation Buttons
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'previous'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'skip'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    
                    const Spacer(),

                    // Animated Next/Confirm button
                    ElasticIn(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _cards.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          _currentPage < _cards.length - 1 ? 'next'.tr : 'confirm'.tr,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> card, int index) {
    // Use key to force animation on page change
    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Step indicator with animation
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    card['titleIcon'] as IconData,
                    color: card['titleColor'] as Color,
                    size: 28.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    card['title']!,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Image with scale animation
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: (card['titleColor'] as Color).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    card['image']!,
                    height: 220.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Key Points with staggered animation
            ...List.generate(
              (card['keyPoints'] as List<String>).length,
              (i) => FadeInLeft(
                delay: Duration(milliseconds: 300 + (i * 100)),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: (card['titleColor'] as Color).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    (card['keyPoints'] as List<String>)[i],
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Bottom text with fade
            FadeIn(
              delay: const Duration(milliseconds: 500),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: (card['titleColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  card['bottomText']!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
