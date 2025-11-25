
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
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                '모든 기능을 제한 없이\n이용해보세요',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildFeatureItem('모든 힐링 사운드 잠금 해제'),
              _buildFeatureItem('오프라인 재생 지원'),
              _buildFeatureItem('광고 없는 쾌적한 환경'),
              _buildFeatureItem('백그라운드 재생'),
              
              const Spacer(),
              CustomButton(
                text: '월 4,900원으로 시작하기',
                onPressed: () {}, // 결제 로직 연결 필요
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  '나중에 하기',
                  style: AppTextStyles.bodyMedium.copyWith(
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

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primaryBlue),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
