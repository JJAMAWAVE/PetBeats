import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui'; // Add for Glassmorphism
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import 'package:petbeats/core/widgets/bubble_text.dart';
import 'package:petbeats/core/widgets/rainbow_gradient.dart';

class AISpecialModeWidget extends StatelessWidget {
  const AISpecialModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 타이틀 (스마트 싱크 + PRO) - 다른 섹션과 동일한 스타일
        Row(
          children: [
            BubbleText(
              text: 'special_smart_sync'.tr,
              bubbleCount: 6,
              bubbleColor: AppColors.primaryBlue.withOpacity(0.5),
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textDarkNavy,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8.w),
            // PRO Badge with Rainbow Gradient
            const RainbowProBadge(),
          ],
        ),
        const SizedBox(height: 8),
        // 모드 버튼들 - 레이어 없이 바로 표시
        Row(
          children: [
            _buildModeButton(
              context,
              'special_weather'.tr,
              'assets/icons/icon_special_weather_glass.png',
              Colors.blue.shade400,
              () {
                // ✨ 새로운 날씨 페이지로 이동
                Get.toNamed(Routes.WEATHER_SPECIAL);
              },
            ),
            SizedBox(width: 12.w),
            _buildModeButton(
              context,
              'special_rhythm'.tr,  // ✨ 시간 → 리듬으로 변경 (Rhythm Care)
              'assets/icons/icon_special_time_glass.png',
              Colors.orange.shade400,
              () => Get.toNamed(Routes.RHYTHM_SPECIAL),
            ),
            SizedBox(width: 12.w),
            _buildModeButton(
              context,
              'special_sitter'.tr,
              'assets/icons/icon_special_reaction_glass.png',
              Colors.purple.shade400,
              () => Get.toNamed(Routes.SITTER_SPECIAL),
            ),
          ],
        ),
      ],
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
          // Outer Glass Container - slightly darker background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.75),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r), // Rounded Square
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value, // Breathing Animation
                  child: Container(
                    width: 56.w, // Inner Circle Size
                    height: 56.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withOpacity(0.1), // Soft Gradient Background
                          widget.color.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                         BoxShadow(
                            color: Colors.white,
                            blurRadius: 5,
                            offset: Offset(-3, -3),
                         ),
                         BoxShadow(
                            color: widget.color.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(3, 3),
                         ),
                      ],
                    ),
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            Text(
              widget.title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkNavy,
                fontSize: 14.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
