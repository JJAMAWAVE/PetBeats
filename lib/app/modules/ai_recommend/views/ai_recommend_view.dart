import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../premium/controllers/subscription_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/widgets/mini_player.dart';
import '../models/ai_scenario.dart';

class AIRecommendView extends StatelessWidget {
  const AIRecommendView({super.key});

  bool get _isPremium {
    try {
      // 1. First check SubscriptionController
      if (Get.isRegistered<SubscriptionController>()) {
        final subController = Get.find<SubscriptionController>();
        if (subController.isPremium.value) return true;
      }
      
      // 2. Also check HomeController (synced on subscription)
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        if (homeController.isPremiumUser.value) return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  void _onScenarioTap(BuildContext context, AIScenario scenario) {
    if (!_isPremium) {
      _showPremiumDialog(context);
      return;
    }
    
    // PRO 회원 - 플레이리스트 생성으로 이동
    _generatePlaylist(scenario);
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 48.w,
                color: AppColors.primaryBlue,
              ),
              SizedBox(height: 16.h),
              Text(
                'pro_exclusive'.tr,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'ai_auto_playlist_desc'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              SizedBox(height: 16.h),
              _buildFeatureRow('ai_feature_1'.tr),
              _buildFeatureRow('ai_feature_2'.tr),
              _buildFeatureRow('ai_feature_3'.tr),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.toNamed('/subscription');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'pro_start'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'later'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.primaryBlue, size: 20.w),
          SizedBox(width: 8.w),
          Text(text, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  void _generatePlaylist(AIScenario scenario) {
    // PRO 전용 - 결과 화면으로 이동 (거기서 로딩 처리)
    Get.toNamed('/ai-playlist-result', arguments: {'scenario': scenario});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('home_ai_recommend'.tr),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDarkNavy,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 설명
                  Text(
                    'ai_page_desc'.tr,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textDarkNavy,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.diamond_outlined,
                        size: 16.w,
                        color: AppColors.primaryBlue,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'pro_exclusive'.tr,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  // 시나리오 그리드
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 1.1,
                      children: AIScenario.values
                          .map((s) => _buildScenarioCard(context, s))
                          .toList(),
                    ),
                  ),
                  
                  SizedBox(height: 80.h), // 미니플레이어 공간
                ],
              ),
            ),
          ),
          
          // 미니플레이어
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, AIScenario scenario) {
    return GestureDetector(
      onTap: () => _onScenarioTap(context, scenario),
      child: Container(
        decoration: BoxDecoration(
          color: scenario.color,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: scenario.color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // PRO 배지 (비회원일 경우)
            if (!_isPremium)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 12.w),
                      SizedBox(width: 2.w),
                      Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // 콘텐츠
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    scenario.icon,
                    color: Colors.white,
                    size: 32.w,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    scenario.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
