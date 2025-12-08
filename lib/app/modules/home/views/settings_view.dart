import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
        title: Text('설정 및 데이터', style: AppTextStyles.subtitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionTitle('계정'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryBlue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PetBeats 회원',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.textDarkNavy),
                      ),
                      Text(
                        '로그인하여 데이터를 동기화하세요',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Data Access Section
            _buildSectionTitle('데이터 접근 권한'),
            const SizedBox(height: 8),
            Text(
              'PetBeats는 다음 데이터를 사용하여 실시간으로 사운드를 최적화합니다.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),

            _buildPermissionItem(
              icon: Icons.location_on_outlined,
              title: '위치 정보',
              desc: '날씨 및 일조량 데이터 수집',
              isEnabled: true,
            ),
            _buildPermissionItem(
              icon: Icons.notifications_none,
              title: '알림',
              desc: '주간 리포트 및 추천 알림',
              isEnabled: true,
            ),
            // Health Data removed as per request (Pet-focused)

            const SizedBox(height: 40),

            // Language Section
            _buildSectionTitle('언어 설정'),
            const SizedBox(height: 16),
            _buildLanguageSelector(),
            
            const SizedBox(height: 40),
            Center(
              child: Text(
                '버전 1.0.0',
                style: AppTextStyles.labelSmall.copyWith(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String desc,
    required bool isEnabled,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
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
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                ),
                Text(
                  desc,
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (val) {},
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final languages = [
      {'flag': '🇰🇷', 'name': '한국어', 'code': 'ko'},
      {'flag': '🇺🇸', 'name': 'English', 'code': 'en'},
      {'flag': '🇯🇵', 'name': '日本語', 'code': 'ja'},
      {'flag': '🇨🇳', 'name': '简体中文', 'code': 'zh_CN'},
      {'flag': '🇹🇼', 'name': '繁體中文', 'code': 'zh_TW'},
      {'flag': '🇪🇸', 'name': 'Español', 'code': 'es'},
      {'flag': '🇩🇪', 'name': 'Deutsch', 'code': 'de'},
      {'flag': '🇫🇷', 'name': 'Français', 'code': 'fr'},
      {'flag': '🇵🇹', 'name': 'Português', 'code': 'pt'},
      {'flag': '🇻🇳', 'name': 'Tiếng Việt', 'code': 'vi'},
      {'flag': '🇮🇹', 'name': 'Italiano', 'code': 'it'},
    ];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // Current language display
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.language, color: AppColors.primaryBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '앱 언어',
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                    ),
                    Text(
                      '🇰🇷 한국어',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
            ],
          ),
          const Divider(height: 24),
          // Language grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: languages.map((lang) {
              final isSelected = lang['code'] == 'ko';
              return GestureDetector(
                onTap: () {
                  // TODO: Implement language change
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryBlue : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    '${lang['flag']} ${lang['name']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.primaryBlue : AppColors.textDarkNavy,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
