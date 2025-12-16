import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'weather_service.dart';
import 'ip_geolocation_service.dart';

/// Background Weather Sync Service
/// Syncs weather data every 30 minutes using IP-based location
class WeatherSyncService extends GetxService {
  Timer? _syncTimer;
  static const Duration _syncInterval = Duration(minutes: 30);
  
  final WeatherService _weatherService = Get.find<WeatherService>();
  final IpGeolocationService _ipService = Get.find<IpGeolocationService>();
  
  final RxBool isAutoSyncEnabled = false.obs;  // ✨ Privacy: default false
  final Rx<DateTime> lastSyncTime = DateTime.now().obs;
  
  @override
  void onInit() {
    super.onInit();
    // ❌ 자동 시작 제거 - 사용자 동의 필수
    // _startBackgroundSync();  // Privacy: 사용자가 기능 켜야만 시작
    
    // 자동 동기화 설정이 저장되어 있는 경우에만 시작
    if (isAutoSyncEnabled.value) {
      _startBackgroundSync();
    }
  }
  
  /// Start automatic background weather synchronization
  void _startBackgroundSync() {
    if (!isAutoSyncEnabled.value) return;
    
    // Initial sync
    syncWeather();
    
    // Schedule periodic sync every 30 minutes
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      if (isAutoSyncEnabled.value) {
        syncWeather();
      }
    });
    
    debugPrint('🔄 Weather background sync started (30min interval)');
  }
  
  /// Manually trigger weather sync
  Future<void> syncWeather() async {
    try {
      debugPrint('🔄 Syncing weather...');
      
      // Step 1: Get location by IP (no permission required)
      await _ipService.fetchLocationByIp();
      
      // Step 2: Fetch weather for detected location
      await _weatherService.fetchWeatherByCoordinates(
        _ipService.latitude.value,
        _ipService.longitude.value,
      );
      
      // Update last sync time
      lastSyncTime.value = DateTime.now();
      
      debugPrint('✅ Weather synced: ${_weatherService.weatherCondition.value} at ${_ipService.city.value}');
    } catch (e) {
      debugPrint('❌ Weather sync failed: $e');
    }
  }
  
  
  /// Enable auto sync (after user consent)
  void enableAutoSync() {
    isAutoSyncEnabled.value = true;
    _startBackgroundSync();
  }
  
  /// Disable auto sync
  void disableAutoSync() {
    isAutoSyncEnabled.value = false;
    _syncTimer?.cancel();
    debugPrint('🔄 Weather background sync stopped');
  }
  
  @override
  void onClose() {
    _syncTimer?.cancel();
    super.onClose();
  }
}
