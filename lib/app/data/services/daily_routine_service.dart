import 'dart:async';
import 'package:get/get.dart';

class DailyRoutineService extends GetxService {
  Timer? _timer;
  
  // Reactive variable to track if auto mode is active
  final RxBool isAutoMode = false.obs;
  
  // Test Weather State
  final RxString currentWeather = 'Sunny'.obs;
  
  // Current Recommended Mode ID (Calculated by Routine)
  final RxString recommendedModeId = 'energy'.obs;

  @override
  void onInit() {
    super.onInit();
    // Check routine every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isAutoMode.value) {
        _updateRoutine();
      }
    });
  }

  void setTestWeather(String weather) {
    currentWeather.value = weather;
    print('[DailyRoutine] Weather changed to: $weather');
    // Weather logic can influence recommendedModeId here if needed
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void toggleAutoMode(bool value) {
    isAutoMode.value = value;
    if (value) {
      _updateRoutine();
    }
  }

  void _updateRoutine() {
    final now = DateTime.now();
    final hour = now.hour;
    
    String targetModeId;
    
    // 07:00 ~ 09:00 : Energy (Morning)
    if (hour >= 7 && hour < 9) {
      targetModeId = 'energy';
    }
    // 09:00 ~ 18:00 : Separation Anxiety (Daytime)
    else if (hour >= 9 && hour < 18) {
      targetModeId = 'separation';
    }
    // 18:00 ~ 22:00 : Noise Sensitive (Evening)
    else if (hour >= 18 && hour < 22) {
      targetModeId = 'noise';
    }
    // 22:00 ~ 07:00 : Sleep (Night)
    else {
      targetModeId = 'sleep';
    }
    
    if (recommendedModeId.value != targetModeId) {
      print('[DailyRoutine] Recommended mode updated: $targetModeId');
      recommendedModeId.value = targetModeId;
    }
  }
}
