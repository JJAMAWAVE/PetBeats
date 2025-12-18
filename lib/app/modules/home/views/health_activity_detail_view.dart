import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      _buildSectionTitle('health_rest_why'.tr),
      _buildInfoCard(
        'health_stress_reduce'.tr,
        'health_stress_reduce_desc'.tr,
        Icons.favorite,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        'health_immunity'.tr,
        'health_immunity_desc'.tr,
        Icons.shield,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        'health_emotional'.tr,
        'health_emotional_desc'.tr,
        Icons.psychology,
      ),
      const SizedBox(height: 32),

      _buildSectionTitle('health_rest_tips'.tr),
      _buildTipItem('health_tip_quiet'.tr),
      _buildTipItem('health_tip_schedule'.tr),
      _buildTipItem('health_tip_temp'.tr),
      _buildTipItem('health_tip_bedding'.tr),
    ];
  }

  List<Widget> _buildTipsContent() {
    return [
      _buildSectionTitle('health_care_essentials'.tr),
      _buildInfoCard(
        'health_hydration'.tr,
        'health_hydration_desc'.tr,
        Icons.water_drop,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        'health_exercise'.tr,
        'health_exercise_desc'.tr,
        Icons.directions_run,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        'health_checkup'.tr,
        'health_checkup_desc'.tr,
        Icons.medical_services,
      ),
      const SizedBox(height: 32),

      _buildSectionTitle('health_checkpoint'.tr),
      _buildTipItem('health_tip_appetite'.tr),
      _buildTipItem('health_tip_coat'.tr),
      _buildTipItem('health_tip_hygiene'.tr),
      _buildTipItem('health_tip_weight'.tr),
    ];
  }

  List<Widget> _buildChargeContent() {
    return [
      _buildSectionTitle('health_energy_needed'.tr),
      _buildInfoCard(
        'health_lethargy'.tr,
        'health_lethargy_desc'.tr,
        Icons.battery_alert,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        'health_playtime'.tr,
        'health_playtime_desc'.tr,
        Icons.toys,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        'health_weather_change'.tr,
        'health_weather_change_desc'.tr,
        Icons.wb_sunny,
      ),
      const SizedBox(height: 32),

      _buildSectionTitle('health_energy_boost'.tr),
      _buildTipItem('health_tip_music'.tr),
      _buildTipItem('health_tip_walk'.tr),
      _buildTipItem('health_tip_toy'.tr),
      _buildTipItem('health_tip_interaction'.tr),
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
        borderRadius: BorderRadius.circular(20.r),
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
              borderRadius: BorderRadius.circular(12.r),
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
