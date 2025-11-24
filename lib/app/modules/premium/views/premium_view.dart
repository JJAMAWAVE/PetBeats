import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/premium_controller.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.workspace_premium, size: 80, color: Colors.amber),
              const SizedBox(height: 24),
              Text(
                'PetBeats Premium',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 16),
              Text(
                '모든 사운드와 기능을 제한 없이 이용하세요.',
                style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildBenefitItem('모든 사운드 잠금 해제'),
              _buildBenefitItem('광고 없는 쾌적한 환경'),
              _buildBenefitItem('고급 하트비트 싱크 패턴'),
              _buildBenefitItem('백그라운드 재생 무제한'),
              
              const Spacer(),
              CustomButton(
                text: '월 1,100원에 시작하기',
                onPressed: controller.subscribe,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {}, // 복구 로직 (생략)
                child: Text(
                  '구매 복구하기',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primaryBlue),
          const SizedBox(width: 16),
          Text(text, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
