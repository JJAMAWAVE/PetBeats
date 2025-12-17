import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../../../data/services/weather_service.dart';
import '../../../routes/app_routes.dart';
import '../widgets/mini_player.dart';

/// Weather Feature Page - Smart Weather Sync
/// 
/// Premium feature that adapts sound layers based on real-time weather
class WeatherSpecialView extends GetView<HomeController> {
  const WeatherSpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherService = Get.find<WeatherService>();
    
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
          '스마트 날씨 싱크',
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
                  // Hero Image Card (날씨.png - full width card)
                  _buildHeroImageCard(),
                  
                  // Header Section
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        Text(
                          '반려동물과 당신의 하루를 날씨와 함께',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textGrey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        
                        // Premium Check
                        Obx(() {
                          if (!controller.isPremiumUser.value) {
                            return _buildPremiumBanner();
                          }
                          return _buildActivationStatus(weatherService);
                        }),
                      ],
                    ),
                  ),
                  
                  // Scientific Insight
                  _buildScientificInsight(),
                  
                  // Feature List (5+ Weather Layers)
                  _buildFeatureList(),
                  
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

  /// Hero Image Card - 날씨.png as full-width card
  Widget _buildHeroImageCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          'assets/images/날씨.png',
          fit: BoxFit.contain, // Changed to contain to show full image
          height: 180.h,
        ),
      ),
    );
  }

  /// Premium Banner (Non-Premium Users Only)
  Widget _buildPremiumBanner() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.SUBSCRIPTION),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2575FC).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.stars, color: Colors.white, size: 28),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '스마트 날씨 싱크 잠금해제',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '실시간 날씨 기반 사운드 적응',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18.w),
          ],
        ),
      ),
    );
  }

  /// Activation Status & Button (Premium Users Only)
  Widget _buildActivationStatus(WeatherService weatherService) {
    return Obx(() {
      final isEnabled = weatherService.isEnabled.value;
      
      return Column(
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isEnabled 
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isEnabled
                    ? AppColors.primaryBlue.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isEnabled ? Icons.check_circle : Icons.cloud_off,
                  color: isEnabled ? AppColors.primaryBlue : Colors.grey,
                  size: 32.w,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnabled ? '날씨 동기화 활성화됨' : '날씨 동기화 비활성화',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isEnabled ? AppColors.primaryBlue : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isEnabled
                            ? '플레이어에서 날씨 아이콘을 확인하세요'
                            : '버튼을 눌러 날씨 동기화를 시작하세요',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () => _disableWeatherSync(weatherService)
                  : () => _requestLocationAndActivate(weatherService),
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? Colors.grey[400] : AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: isEnabled ? 0 : 4,
              ),
              child: Text(
                isEnabled ? '날씨 동기화 비활성화' : '날씨 동기화 활성화',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  /// Scientific Insight Section
  Widget _buildScientificInsight() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science, size: 20.w, color: AppColors.primaryBlue),
              SizedBox(width: 8.w),
              Text(
                '과학적 효과',
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '환경 적응 사운드는 반려동물의 생체 리듬을 자연스럽게 조율합니다. '
            '빗소리는 심박수를 안정시키고, 맑은 날씨는 활동성을 높이며, '
            '야간 모드는 멜라토닌 분비를 촉진합니다.',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textDarkNavy,
              height: 1.6,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Source: Animal Behaviour Science, 2020',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: AppColors.textGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Feature List - 5+ Weather Layers
  Widget _buildFeatureList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '날씨별 자동 사운드 레이어',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          _buildFeatureCard(
            icon: '🌧️',
            title: '빗소리와 함께하는 안정',
            description: '비 오는 날, 빗소리 레이어가 자동으로 추가됩니다',
            color: Colors.blue,
          ),
          _buildFeatureCard(
            icon: '☀️',
            title: '맑은 날의 활기',
            description: '화창한 날씨에는 밝은 톤의 사운드를 제공합니다',
            color: Colors.orange,
          ),
          _buildFeatureCard(
            icon: '🌙',
            title: '야간 수면 모드',
            description: '밤 시간대에는 자동으로 수면 유도 모드로 전환',
            color: Colors.indigo,
          ),
          _buildFeatureCard(
            icon: '❄️',
            title: '눈 내리는 포근함',
            description: '눈 오는 날, 부드러운 앰비언트 사운드를 더합니다',
            color: Colors.lightBlue,
          ),
          _buildFeatureCard(
            icon: '🌪️',
            title: '강풍 속 평온',
            description: '바람 부는 날, 브라운 노이즈로 외부 소음을 차단합니다',
            color: Colors.grey,
          ),
          _buildFeatureCard(
            icon: '☁️',
            title: '구름 낀 차분함',
            description: '흐린 날씨에는 차분한 저음역 사운드를 강화합니다',
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lineLightBlue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDarkNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Request Location Permission and Activate Weather Sync
  Future<void> _requestLocationAndActivate(WeatherService weatherService) async {
    // For now, directly enable (permission_handler will be added later)
    try {
      await weatherService.enableWeatherSync();
      
      Get.snackbar(
        '✅ 날씨 동기화 활성화',
        '플레이어에서 날씨 아이콘을 확인하세요!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        '⚠️ 오류',
        '날씨 정보를 가져올 수 없습니다',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
    }
  }

  /// Disable Weather Sync
  void _disableWeatherSync(WeatherService weatherService) {
    weatherService.disableWeatherSync();
    
    Get.snackbar(
      '날씨 동기화 비활성화',
      '날씨 기반 사운드 레이어가 비활성화되었습니다',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[600],
      colorText: Colors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
      duration: const Duration(seconds: 2),
    );
  }
}
