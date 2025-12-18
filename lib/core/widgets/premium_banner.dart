import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petbeats/app/routes/app_routes.dart';
import 'package:petbeats/core/widgets/rainbow_gradient.dart';

/// Standardized Premium Subscribe Banner with animated gradient effect
/// Used across the app for consistent subscription CTAs
class PremiumBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showArrow;
  final double? width;

  const PremiumBanner({
    super.key,
    this.title = 'premium_unlock_tracks',
    this.subtitle = 'premium_special_care',
    this.icon = Icons.star,
    this.onTap,
    this.showArrow = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed(Routes.SUBSCRIPTION),
      child: AnimatedRainbowGradient(
        duration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: width ?? double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3F51B5).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with glow
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 14.w),
              ],
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle.tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow
              if (showArrow)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.8),
                  size: 16.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact Premium Badge - for inline use
class PremiumBadge extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const PremiumBadge({
    super.key,
    this.text = 'PRO',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed(Routes.SUBSCRIPTION),
      child: const RainbowProBadge(),
    );
  }
}
