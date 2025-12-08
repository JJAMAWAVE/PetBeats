import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class AISpecialModeWidget extends StatelessWidget {
  const AISpecialModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        // 프리미엄 그라데이션 배경 (Smart/Tech Blue Theme)
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8EAF6), // Soft Indigo
            Color(0xFFE3F2FD), // Light Blue
            Color(0xFFF3E5F5), // Soft Purple
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Color(0xFF5C6BC0).withOpacity(0.3), // Indigo Border
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3949AB).withOpacity(0.15), // Indigo Shadow
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프리미엄 타이틀 (왕관 이미지 + PRO)
          Row(
            children: [
              // 왕관 이미지
              Image.asset(
                'assets/icons/icon_crown_pro.png',
                width: 24.w,
                height: 24.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.w),
              Text(
                '스마트 싱크',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textDarkNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5C6BC0), // Indigo
                      Color(0xFF29B6F6), // Light Blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF5C6BC0).withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildModeButton(
                context,
                '날씨',
                'assets/icons/icon_special_weather_glass.png',
                Colors.blue.shade400,
                () => Get.toNamed(Routes.WEATHER_SPECIAL),
              ),
              SizedBox(width: 12.w),
              _buildModeButton(
                context,
                '시간',
                'assets/icons/icon_special_time_glass.png',
                Colors.orange.shade400,
                () => Get.toNamed(Routes.RHYTHM_SPECIAL),
              ),
              SizedBox(width: 12.w),
              _buildModeButton(
                context,
                '돌봄',
                'assets/icons/icon_special_reaction_glass.png',
                Colors.purple.shade400,
                () => Get.toNamed(Routes.SITTER_SPECIAL),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String title,
    String imagePath,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: _AnimatedModeButton(
        title: title,
        imagePath: imagePath,
        color: color,
        onTap: onTap,
      ),
    );
  }
}

class _AnimatedModeButton extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedModeButton({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedModeButton> createState() => _AnimatedModeButtonState();
}

class _AnimatedModeButtonState extends State<_AnimatedModeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: widget.color.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        widget.imagePath,
                        width: 48.w,
                        height: 48.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 6.h),
            Text(
              widget.title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkNavy,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
