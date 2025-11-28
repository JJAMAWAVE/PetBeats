import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../settings/controllers/settings_controller.dart';

class SmartCareController extends GetxController {
  final SettingsController settingsController = Get.find<SettingsController>();

  // Mock Data
  final RxString weatherCondition = '맑음'.obs; // 맑음, 비, 흐림, 눈
  final RxString timeOfDay = '오후'.obs; // 아침, 점심, 오후, 저녁, 밤
  final RxDouble temperature = 24.0.obs;
  final RxBool isAutoPlayEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMockData();
  }

  void _initializeMockData() {
    // In a real app, this would fetch from an API
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      timeOfDay.value = '아침';
    } else if (hour >= 12 && hour < 14) {
      timeOfDay.value = '점심';
    } else if (hour >= 14 && hour < 18) {
      timeOfDay.value = '오후';
    } else if (hour >= 18 && hour < 22) {
      timeOfDay.value = '저녁';
    } else {
      timeOfDay.value = '밤';
    }
  }

  String getRecommendationText() {
    if (weatherCondition.value == '비' || weatherCondition.value == '흐림') {
      return '비 오는 날, 차분한 휴식이 필요해요';
    } else if (timeOfDay.value == '밤') {
      return '깊은 잠을 위한 수면 케어';
    } else if (timeOfDay.value == '오후') {
      return '나른한 오후, 활력을 채워보세요';
    }
    return '오늘 하루도 행복하게 보내세요';
  }

  String getRecommendationIcon() {
    if (weatherCondition.value == '비') return 'assets/icons/icon_weather_rain.png'; // Need to ensure assets exist or use Material Icons for now
    if (timeOfDay.value == '밤') return 'assets/icons/icon_weather_night.png';
    return 'assets/icons/icon_weather_sun.png';
  }

  void toggleAutoPlay(bool value) {
    isAutoPlayEnabled.value = value;
    if (value) {
      Get.snackbar(
        'AI 자동 재생',
        '상황에 맞는 사운드가 자동으로 재생됩니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryBlue,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void playRecommendation() {
    // Mock play action
    Get.snackbar(
      'AI 맞춤 재생',
      '${getRecommendationText()} 모드를 재생합니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.textDarkNavy,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  // Debug Methods for Testing
  void setDebugWeather(String condition) {
    weatherCondition.value = condition;
    if (condition == '비') temperature.value = 18.0;
    else if (condition == '맑음') temperature.value = 24.0;
    else if (condition == '눈') temperature.value = -2.0;
    else temperature.value = 20.0;
  }

  void setDebugTime(String time) {
    timeOfDay.value = time;
  }
}
