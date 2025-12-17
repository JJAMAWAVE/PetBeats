import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/services/weather_service.dart';
import '../../../data/services/weather_sync_service.dart';
import '../../../data/services/weather_sound_manager.dart';
import '../controllers/player_controller.dart';
import '../../premium/controllers/subscription_controller.dart';

/// Weather Settings Bottom Sheet - Emotional UX Design
/// "창밖 날씨에 귀 기울여볼까요?"
class WeatherSettingsBottomSheet extends StatelessWidget {
  const WeatherSettingsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherManager = Get.find<WeatherSoundManager>();
    final weatherService = Get.find<WeatherService>();
    // ✨ FIX: Use isRegistered to prevent crash if bindings not loaded yet
    final playerController = Get.isRegistered<PlayerController>() 
        ? Get.find<PlayerController>() 
        : null;
    final subscriptionController = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : null;

    return Container(
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  
                  // 감성 이미지 영역
                  _buildEmotionalImage(),
                  
                  SizedBox(height: 24.h),
                  
                  // 타이틀
                  Text(
                    'weather_sheet_title'.tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D2D2D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // 감성 설명
                  Text(
                    'weather_sheet_desc'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // 작동 도식
                  _buildWorkflowDiagram(),
                  
                  SizedBox(height: 32.h),
                  
                  // 현재 날씨 정보
                  Obx(() => _buildCurrentWeather(
                    condition: weatherService.weatherCondition.value,
                    temp: weatherService.temperature.value,
                    location: weatherService.locationName.value,
                  )),
                  
                  SizedBox(height: 24.h),
                  
                  // 날씨 조건별 사운드 매핑 테이블
                  _buildWeatherMappingTable(),
                  
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          
          // 하단 버튼
          _buildBottomButton(
            weatherManager,
            playerController,
            subscriptionController,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionalImage() {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5E60CE).withOpacity(0.1),
            const Color(0xFF81D4FA).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wb_cloudy_outlined,
              size: 80.sp,
              color: const Color(0xFF5E60CE).withOpacity(0.6),
            ),
            SizedBox(height: 8.h),
            Text(
              '🌧️ ☁️ ❄️ 💨',
              style: TextStyle(fontSize: 24.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowDiagram() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF5E60CE).withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDiagramStep('☁️', 'weather_step_detect'.tr),
          SizedBox(width: 12.w),
          Icon(Icons.arrow_forward, color: Colors.grey[400], size: 20.sp),
          SizedBox(width: 12.w),
          _buildDiagramStep('🎵', 'weather_step_mixing'.tr),
          SizedBox(width: 12.w),
          Icon(Icons.arrow_forward, color: Colors.grey[400], size: 20.sp),
          SizedBox(width: 12.w),
          _buildDiagramStep('✨', 'weather_step_therapy'.tr),
        ],
      ),
    );
  }

  Widget _buildDiagramStep(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 24.sp)),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCurrentWeather({
    required String condition,
    required double temp,
    required String location,
  }) {
    IconData icon;
    Color color;
    
    switch (condition) {
      case 'Rain':
      case 'Drizzle':
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case 'Snow':
        icon = Icons.ac_unit;
        color = Colors.lightBlue;
        break;
      case 'Thunderstorm':
        icon = Icons.flash_on;
        color = Colors.deepPurple;
        break;
      case 'Clear':
        icon = Icons.wb_sunny;
        color = Colors.orange;
        break;
      default:
        icon = Icons.wb_cloudy;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40.sp, color: color),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '$location ${temp.toStringAsFixed(1)}°C',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              _getWeatherKorean(condition),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherMappingTable() {
    final mappings = [
      {'icon': '🌧️', 'weather': 'weather_rain'.tr, 'sound': 'weather_sound_rain'.tr, 'desc': 'weather_desc_rain'.tr},
      {'icon': '⛈️', 'weather': 'weather_thunder'.tr, 'sound': 'weather_sound_white_noise'.tr, 'desc': 'weather_desc_thunder'.tr},
      {'icon': '🌨️', 'weather': 'weather_snow'.tr, 'sound': 'weather_sound_ambient'.tr, 'desc': 'weather_desc_snow'.tr},
      {'icon': '💨', 'weather': 'weather_wind'.tr, 'sound': 'weather_sound_wind'.tr, 'desc': 'weather_desc_wind'.tr},
      {'icon': '🌫️', 'weather': 'weather_fog'.tr, 'sound': 'weather_sound_noise'.tr, 'desc': 'weather_desc_fog'.tr},
      {'icon': '☀️', 'weather': 'weather_clear'.tr, 'sound': 'weather_sound_default'.tr, 'desc': 'weather_desc_clear'.tr},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'weather_mapping_title'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        SizedBox(height: 12.h),
        ...mappings.map((mapping) => _buildMappingItem(
          emoji: mapping['icon']!,
          weather: mapping['weather']!,
          sound: mapping['sound']!,
          desc: mapping['desc']!,
        )),
      ],
    );
  }

  Widget _buildMappingItem({
    required String emoji,
    required String weather,
    required String sound,
    required String desc,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24.sp)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  sound,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF5E60CE),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
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

  Widget _buildBottomButton(
    WeatherSoundManager weatherManager,
    PlayerController? playerController,  // ✨ Nullable to match build() scope
    SubscriptionController? subscriptionController,  // ✨ Nullable
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final isActive = weatherManager.isWeatherMixActive.value;
        
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive 
                ? Colors.grey[300] 
                : const Color(0xFF5E60CE),
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            // ✨ Fail-Closed: Default to non-premium if controller is null
            final isPremium = subscriptionController?.isPremium.value ?? false;
            
            if (!isPremium) {
              Get.back();
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🌧️',
                          style: TextStyle(fontSize: 48.sp),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'weather_premium_title'.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'weather_premium_desc'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5E60CE),
                            minimumSize: Size(double.infinity, 48.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.toNamed('/premium');
                          },
                          child: Text(
                            'premium_upgrade_now'.tr,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              return;
            }
            
            // ✨ Privacy: 사용자 동의 필수
            if (!isActive) {
              // 첫 사용 시 동의 다이얼로그
              final consent = await Get.dialog<bool>(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 48.sp,
                          color: const Color(0xFF5E60CE),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'weather_location_consent_title'.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'weather_location_consent_desc'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Get.back(result: false),
                                child: Text('cancel'.tr),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5E60CE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                onPressed: () => Get.back(result: true),
                                child: Text(
                                  'agree'.tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
              
              if (consent != true) {
                return;  // 동의 안함
              }
              
              // 동의 후 기능 활성화
              final syncService = Get.find<WeatherSyncService>();
              syncService.enableAutoSync();  // 이제 날씨 동기화 시작
              
              weatherManager.enableWeatherMix();
              playerController?.isWeatherActive.value = true;  // ✨ Null-safe
              Get.snackbar(
                'weather_therapy_active'.tr,
                'weather_therapy_active_desc'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF5E60CE).withOpacity(0.9),
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w),
                borderRadius: 12.r,
              );
              Get.back();
            } else {
              // 기능 끄기
              final syncService = Get.find<WeatherSyncService>();
              syncService.disableAutoSync();
              
              weatherManager.disableWeatherMix();
              playerController?.isWeatherActive.value = false;  // ✨ Null-safe
              Get.back();
            }
          },
          child: Text(
            isActive
                ? 'weather_turn_off'.tr
                : 'weather_turn_on'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.grey[600] : Colors.white,
            ),
          ),
        );
      }),
    );
  }

  String _getWeatherKorean(String condition) {
    switch (condition) {
      case 'Clear':
        return 'weather_clear_short'.tr;
      case 'Clouds':
        return 'weather_cloud_short'.tr;
      case 'Rain':
        return 'weather_rain_short'.tr;
      case 'Drizzle':
        return 'weather_drizzle_short'.tr;
      case 'Thunderstorm':
        return 'weather_thunder_short'.tr;
      case 'Snow':
        return 'weather_snow_short'.tr;
      case 'Mist':
      case 'Fog':
        return 'weather_fog_short'.tr;
      default:
        return condition;
    }
  }
}
