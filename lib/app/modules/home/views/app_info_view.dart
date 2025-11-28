import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AppInfoView extends StatelessWidget {
  const AppInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
        title: Text('PetBeats 소개', style: AppTextStyles.subtitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '반려동물을 위한\n과학적 사운드 테라피',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 28, height: 1.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PetBeats는 동물음악학(Zoomusicology)과 생체음향학(Bioacoustics)에 기반하여 설계된 반려동물 전용 힐링 앱입니다.',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(
                    icon: Icons.science,
                    title: '과학적 설계',
                    desc: '종별 청각 특성과 심박수에 맞춘 주파수와 템포를 사용합니다.',
                  ),
                  _buildFeatureItem(
                    icon: Icons.psychology,
                    title: '심리적 안정',
                    desc: '분리불안 완화 및 스트레스 감소 효과가 입증된 사운드입니다.',
                  ),
                  _buildFeatureItem(
                    icon: Icons.auto_awesome,
                    title: 'AI 맞춤 케어',
                    desc: '날씨와 시간대에 따라 최적의 사운드를 자동으로 추천합니다.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
