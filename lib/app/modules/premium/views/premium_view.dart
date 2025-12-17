
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/premium_controller.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

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
                'premium_limitless'.tr,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildFeatureItem('premium_feature_1'.tr),
              _buildFeatureItem('premium_feature_2'.tr),
              _buildFeatureItem('premium_feature_3'.tr),
              _buildFeatureItem('premium_feature_4'.tr),
              
              const Spacer(),
              CustomButton(
                text: 'premium_start_price'.tr,
                onPressed: () {}, // 결제 로직 연결 필요
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'premium_maybe_later'.tr,
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
