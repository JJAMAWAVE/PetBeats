import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/services/haptic_service.dart';

class HealthActivityDetailView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color color;
  final String activityType;

  const HealthActivityDetailView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.color,
    required this.activityType,
  });

  @override
  Widget build(BuildContext context) {
    final hapticService = Get.find<HapticService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with back button and title
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: color,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  hapticService.lightImpact();
                  Get.back();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          iconPath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle
                    Text(
                      subtitle,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 18,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Content based on activity type
                    ..._buildContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    switch (activityType) {
      case 'rest':
        return _buildRestContent();
      case 'tips':
        return _buildTipsContent();
      case 'charge':
        return _buildChargeContent();
      default:
        return [];
    }
  }

  List<Widget> _buildRestContent() {
    return [
      _buildSectionTitle('휴식이 중요한 이유'),
      _buildInfoCard(
        '스트레스 감소',
        '적절한 휴식은 반려동물의 스트레스 호르몬(코르티솔)을 낮춰줍니다.',
        Icons.favorite,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        '면역력 강화',
        '충분한 휴식은 면역 체계를 강화하고 질병 예방에 도움을 줍니다.',
        Icons.shield,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        '정서 안정',
        '평온한 환경에서의 휴식은 정서적 안정과 행복감을 증진시킵니다.',
        Icons.psychology,
      ),
      const SizedBox(height: 32),

      _buildSectionTitle('휴식을 위한 팁'),
      _buildTipItem('조용하고 편안한 공간을 마련해주세요'),
      _buildTipItem('규칙적인 휴식 시간을 정해주세요'),
      _buildTipItem('적절한 온도와 조명을 유지해주세요'),
      _buildTipItem('편안한 침구를 제공해주세요'),
    ];
  }

  List<Widget> _buildTipsContent() {
    return [
      _buildSectionTitle('반려동물 케어 필수 상식'),
      _buildInfoCard(
        '수분 섭취',
        '반려동물은 체중 1kg당 50-60ml의 물을 매일 마셔야 합니다. 신선한 물을 항상 제공해주세요.',
        Icons.water_drop,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        '운동량',
        '강아지는 하루 30-60분, 고양이는 15-30분의 활동이 필요합니다.',
        Icons.directions_run,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        '정기 검진',
        '6개월마다 한 번씩 정기 검진을 받는 것이 권장됩니다.',
        Icons.medical_services,
      ),
      const SizedBox(height: 32),

      _buildSectionTitle('건강 체크포인트'),
      _buildTipItem('식욕과 배변 상태 확인'),
      _buildTipItem('피부와 털 상태 관찰'),
      _buildTipItem('눈, 귀, 입 청결 유지'),
      _buildTipItem('체중 변화 모니터링'),
    ];
  }

  List<Widget> _buildChargeContent() {
    return [
      _buildSectionTitle('에너지 충전이 필요한 순간'),
      _buildInfoCard(
        '무기력함',
        '평소보다 활동량이 줄고 기운이 없어 보일 때 에너지 충전이 필요합니다.',
        Icons.battery_alert,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        '놀이 시간',
        '활발한 놀이 전후로 에너지를 충전하면 더욱 즐거운 시간을 보낼 수 있습니다.',
        Icons.toys,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        '날씨 변화',
        '흐린 날씨나 계절 변화로 인한 컨디션 저하 시 도움이 됩니다.',
        Icons.wb_sunny,
      ),
      const SizedBox(height: 32),

      _buildSectionTitle('에너지 충전 방법'),
      _buildTipItem('경쾌한 음악으로 기분 전환'),
      _buildTipItem('함께 가벼운 산책하기'),
      _buildTipItem('새로운 장난감이나 간식 제공'),
      _buildTipItem('긍정적인 상호작용 시간 갖기'),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textDarkNavy,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDarkNavy,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
