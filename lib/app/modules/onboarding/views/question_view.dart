import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class QuestionView extends GetView<OnboardingController> {
  const QuestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 간단한 질문 흐름을 하나의 화면에서 처리하거나, PageView로 확장 가능
    // 여기서는 간단히 종(Species) 선택 화면만 구현하고 나머지는 생략(MVP)
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                '누구를 위한\nPetBeats인가요?',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 40),
              _buildOptionCard('강아지 (Dog)', Icons.pets, 'Dog'),
              const SizedBox(height: 16),
              _buildOptionCard('고양이 (Cat)', Icons.cruelty_free, 'Cat'),
              const SizedBox(height: 16),
              _buildOptionCard('보호자 (Owner)', Icons.person, 'Owner'),
              
              const Spacer(),
              CustomButton(
                text: '시작하기',
                onPressed: () => controller.saveAnswerAndNext('completed', true),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon, String value) {
    return Obx(() {
      final isSelected = controller.species.value == value;
      return GestureDetector(
        onTap: () => controller.species.value = value,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.lineLightBlue,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.primaryBlue : Colors.grey),
              const SizedBox(width: 16),
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primaryBlue : AppColors.textDarkNavy,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
