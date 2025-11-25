import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> slides = [
      {
        "title": "Calm · Relax · Sleep for Pets",
        "desc": "반려동물을 위한 평온함, 휴식, 그리고 수면"
      },
      {
        "title": "A new world needs new solutions",
        "desc": "불안해하는 반려동물을 위한 새로운 솔루션"
      },
      {
        "title": "Powered by bioacoustic science",
        "desc": "생체 음향 과학으로 설계되었습니다"
      },
      {
        "title": "Improve your pet’s well-being",
        "desc": "소리의 힘으로 반려동물의 삶을 개선하세요"
      },
      {
        "title": "Over-stimulating world",
        "desc": "소음, 스트레스, 분리불안으로부터 보호해주세요"
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 일러스트레이션 자리 (임시 박스)
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.lineLightBlue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(Icons.waves, size: 80, color: AppColors.primaryBlue),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slides[index]["title"]!,
                          style: AppTextStyles.titleLarge.copyWith(fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slides[index]["desc"]!,
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // 인디케이터
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.pageIndex == index
                            ? AppColors.primaryBlue
                            : AppColors.lineLightBlue,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomButton(
                text: 'Next',
                onPressed: controller.nextSlide,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
