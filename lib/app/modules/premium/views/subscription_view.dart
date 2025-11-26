import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decoration (optional, keeping it clean white for now)
            
            Column(
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textDarkNavy, size: 30),
                    onPressed: () => Get.back(),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Title
                Text(
                  'PetBeats 프리미엄 플랜 선택',
                  style: GoogleFonts.notoSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDarkNavy,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Value Proposition
                Text(
                  '더 깊은 휴식과 안정을 경험하세요\n집중력 7배 향상\n스트레스 3.6배 감소',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    color: AppColors.textGrey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Subscription Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildOptionCard(
                        title: '1년 이용권',
                        price: '₩88,000',
                        isSelected: true,
                      ),
                      const SizedBox(height: 12),
                      _buildOptionCard(
                        title: '3개월 이용권',
                        price: '₩27,250',
                        isSelected: false,
                      ),
                      const SizedBox(height: 12),
                      _buildOptionCard(
                        title: '1개월 이용권',
                        price: '₩10,900',
                        isSelected: false,
                      ),
                      const SizedBox(height: 12),
                      _buildOptionCard(
                        title: '평생 소장',
                        price: '₩290,000',
                        subtitle: '단 한 번의 결제',
                        isSelected: false,
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Subscribe Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement subscription logic
                        Get.back();
                        Get.snackbar(
                          '구독 완료',
                          '구독이 완료되었습니다 (데모)',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryBlue,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '구독하기',
                        style: GoogleFonts.notoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Footer Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterButton('계정 전환'),
                    const SizedBox(width: 16),
                    _buildFooterButton('도움말'),
                    const SizedBox(width: 16),
                    _buildFooterButton('구매 복원'),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Terms
                Text(
                  '계속 진행 시 다음 내용에 동의하게 됩니다\n개인정보 처리방침 및 이용약관',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppColors.textGrey.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String price,
    String? subtitle,
    required bool isSelected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : AppColors.lineLightBlue,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDarkNavy,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDarkNavy,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.primaryBlue, size: 24)
          else
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lineLightBlue, width: 1),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: GoogleFonts.notoSans(
          fontSize: 14,
          color: AppColors.textGrey,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
