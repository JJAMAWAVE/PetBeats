import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:petbeats/core/theme/app_colors.dart';
import 'package:petbeats/core/widgets/glass_card_slider.dart';

/// Haptic Safety Guide Dialog
/// 
/// 3-card slider showing proper haptic therapy usage
class HapticSafetyGuideDialog extends StatelessWidget {
  const HapticSafetyGuideDialog({Key? key}) : super(key: key);

  List<GlassCardData> get _slides => [
    GlassCardData(
      imagePath: 'assets/images/Haptic/1.png',
      title: 'haptic_guide_step1_title'.tr,
      subtitle: '${'haptic_guide_step1_point1'.tr}\n${'haptic_guide_step1_point2'.tr}',
      footer: 'haptic_guide_step1_desc'.tr,
    ),
    GlassCardData(
      imagePath: 'assets/images/Haptic/2.png',
      title: 'haptic_guide_step2_title'.tr,
      subtitle: '${'haptic_guide_step2_point1'.tr}\n${'haptic_guide_step2_point2'.tr}',
      footer: 'haptic_guide_step2_desc'.tr,
    ),
    GlassCardData(
      imagePath: 'assets/images/Haptic/3.png',
      title: 'haptic_guide_step3_title'.tr,
      subtitle: '${'haptic_guide_step3_point1'.tr}\n${'haptic_guide_step3_point2'.tr}',
      footer: 'haptic_guide_step3_desc'.tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E2A3A),
                Color(0xFF162033),
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
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: GlassCardSlider(
              slides: _slides,
              headerTitle: 'haptic_guide_title'.tr,
              headerIcon: Pulse(
                infinite: true,
                duration: const Duration(seconds: 2),
                child: Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                  size: 24.sp,
                ),
              ),
              isDarkMode: true,
            ),
          ),
        ),
      ),
    );
  }
}
