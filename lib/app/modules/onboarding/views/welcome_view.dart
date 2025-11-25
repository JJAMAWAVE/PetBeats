
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

import '../../../../core/widgets/background_decoration.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1초 동안 커짐
      reverseDuration: const Duration(milliseconds: 1000), // 1초 동안 작아짐 (총 2초 주기)
    )..repeat(reverse: true); // 무한 반복

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
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
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: BackgroundDecoration(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // 로고 영역 (아이콘 + 텍스트)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 아이콘 (심박수/하트) - 이미지로 교체됨
                    Container(
                      padding: const EdgeInsets.all(4), // 테두리 여백 감소
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo_icon.jpg',
                          width: 120, // 크기 증가
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 메인 로고 텍스트
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pet',
                          style: AppTextStyles.logo,
                        ),
                        const SizedBox(width: 8), // 텍스트 간격 추가
                        // Beats 텍스트에 애니메이션 적용
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text(
                            'Beats',
                            style: AppTextStyles.logo.copyWith(
                              color: AppColors.secondaryBlue,
                            ),
                          ),
                        ),
                        // 포인트 점 (Soft Coral)
                        Container(
                          margin: const EdgeInsets.only(top: 12, left: 4),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.pointCoral,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 부제
                    Text(
                      'Bio-Acoustic Therapy\nfor Your Beloved Pets',
                      style: AppTextStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  text: 'Get Started', // 문구 변경: Continue -> Get Started
                  onPressed: () => Get.toNamed(Routes.ONBOARDING),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
