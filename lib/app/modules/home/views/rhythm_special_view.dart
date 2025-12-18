import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../../../data/services/rhythm_care_service.dart';
import '../../../routes/app_routes.dart';
import '../widgets/mini_player.dart';
import 'package:petbeats/core/widgets/premium_banner.dart';

/// Rhythm Care Feature Page
/// 
/// Premium feature that automatically adjusts sound modes based on time of day
class RhythmSpecialView extends StatelessWidget {
  const RhythmSpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final rhythmService = Get.isRegistered<RhythmCareService>() 
        ? Get.find<RhythmCareService>() 
        : null;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'rhythm_title'.tr,
          style: AppTextStyles.subtitle,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Image Card (리듬.png)
                  _buildHeroImageCard(),
                  
                  // Header Section with description
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        Text(
                          'rhythm_subtitle'.tr,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDarkNavy,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'rhythm_desc'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textGrey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        
                        // Premium Check
                        Obx(() {
                          if (!homeController.isPremiumUser.value) {
                            return _buildPremiumBanner();
                          }
                          return _buildActivationStatus(rhythmService);
                        }),
                      ],
                    ),
                  ),
                  
                  // Core Value Proposition
                  _buildCoreValue(),
                  
                  SizedBox(height: 20.h),
                  
                  // Time Slots
                  _buildTimeSlots(rhythmService),
                  
                  SizedBox(height: 20.h),
                  
                  // Scientific Insight
                  _buildScientificInsight(),
                  
                  SizedBox(height: 120.h), // Space for MiniPlayer
                ],
              ),
            ),
          ),
          
          // Mini Player
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const MiniPlayer(),
          ),
        ],
      ),
    );
  }

  /// Hero Image Card - 리듬.png (30% 축소)
  Widget _buildHeroImageCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h), // 여백 축소
      constraints: BoxConstraints(maxHeight: 180.h), // 최대 높이 제한
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Image.asset(
          'assets/images/rhythm_care.png',
          fit: BoxFit.contain, // contain으로 비율 유지
          width: double.infinity,
        ),
      ),
    );
  }

  /// Premium Banner (Non-Premium Users Only)
  Widget _buildPremiumBanner() {
    return const PremiumBanner(
      title: 'rhythm_premium_title',
      subtitle: 'rhythm_premium_desc',
      icon: Icons.schedule,
    );
  }

  /// Activation Status (Premium Users) - 컴팩트 버전
  Widget _buildActivationStatus(RhythmCareService? rhythmService) {
    if (rhythmService == null) return const SizedBox.shrink();
    
    return Obx(() {
      final isEnabled = rhythmService.isEnabled.value;
      final currentMode = rhythmService.currentTimeZoneName.value;
      final icon = rhythmService.currentTimeZoneIcon.value;
      
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h), // 패딩 축소
        decoration: BoxDecoration(
          color: isEnabled 
              ? AppColors.primaryBlue.withOpacity(0.08) 
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isEnabled ? AppColors.primaryBlue.withOpacity(0.5) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w), // 아이콘 패딩 축소
              decoration: BoxDecoration(
                color: isEnabled ? AppColors.primaryBlue : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule,
                color: Colors.white,
                size: 18.w, // 아이콘 크기 축소
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                isEnabled ? 'rhythm_active'.tr : 'rhythm_inactive'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDarkNavy,
                ),
              ),
            ),
            if (isEnabled)
              Text(
                '$icon $currentMode',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            SizedBox(width: 8.w),
            Switch(
              value: isEnabled,
              onChanged: (_) => rhythmService.toggle(),
              activeColor: AppColors.primaryBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      );
    });
  }

  /// Core Value Proposition
  Widget _buildCoreValue() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFE8EAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: Color(0xFF6A11CB), size: 40.w),
          SizedBox(height: 12.h),
          Text(
            'rhythm_core_quote'.tr,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Color(0xFF6A11CB),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'rhythm_core_desc'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textGrey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Time Slots Grid
  Widget _buildTimeSlots(RhythmCareService? rhythmService) {
    final slots = [
      {'time': 'rhythm_mode_morning_time'.tr, 'mode': 'rhythm_mode_morning_name'.tr, 'iconPath': 'assets/icons/icon_rhythm_morning.png', 'color': Colors.orange, 'modeId': 'energy'},
      {'time': 'rhythm_mode_day_time'.tr, 'mode': 'rhythm_mode_day_name'.tr, 'iconPath': 'assets/icons/icon_rhythm_daytime.png', 'color': Colors.blue, 'modeId': 'anxiety'},
      {'time': 'rhythm_mode_evening_time'.tr, 'mode': 'rhythm_mode_evening_name'.tr, 'iconPath': 'assets/icons/icon_rhythm_evening.png', 'color': Colors.brown, 'modeId': 'senior'},
      {'time': 'rhythm_mode_night_time'.tr, 'mode': 'rhythm_mode_night_name'.tr, 'iconPath': 'assets/icons/icon_rhythm_night.png', 'color': Colors.indigo, 'modeId': 'sleep'},
    ];
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'rhythm_time_slots_title'.tr,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkNavy,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.1, // 카드를 더 높게 (1.5 → 1.1)
            children: slots.map((slot) {
              final isCurrent = rhythmService?.currentTimeZone.value == slot['modeId'];
              
              return Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isCurrent 
                      ? (slot['color'] as Color).withOpacity(0.15) 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isCurrent 
                        ? (slot['color'] as Color) 
                        : Colors.grey.shade200,
                    width: isCurrent ? 2 : 1,
                  ),
                  boxShadow: [
                    if (isCurrent)
                      BoxShadow(
                        color: (slot['color'] as Color).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          slot['iconPath'] as String,
                          width: 48.w,  // 아이콘 크기 증가 (32 → 48)
                          height: 48.w,
                          fit: BoxFit.contain,
                        ),
                        if (isCurrent) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: slot['color'] as Color,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      slot['mode'] as String,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? slot['color'] as Color : AppColors.textDarkNavy,
                      ),
                    ),
                    Text(
                      slot['time'] as String,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Scientific Insight
  Widget _buildScientificInsight() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science, color: AppColors.primaryBlue, size: 20.w),
              SizedBox(width: 8.w),
              Text(
                'rhythm_scientific_title'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDarkNavy,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'rhythm_scientific_desc'.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
