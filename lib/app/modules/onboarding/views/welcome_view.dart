import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

import '../../../../core/widgets/background_decoration.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

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
              // 로고 영역 (텍스트로 대체, 추후 이미지로 변경 가능)
              Text(
                'PetBeats',
                style: AppTextStyles.title.copyWith(
                  fontSize: 40,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pet Heart-Sync Audio Therapy',
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                onPressed: () => Get.toNamed(Routes.ONBOARDING),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
