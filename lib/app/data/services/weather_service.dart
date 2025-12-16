import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'weather_sound_manager.dart';  // ✨ For weather sounds

class WeatherService extends GetxService {
  // Replace with your OpenWeatherMap API Key
  static const String _apiKey = '69bb5b896f02481527e34546b0c358d9'; 
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  final _storage = GetStorage();
  
  final RxString weatherCondition = 'Clear'.obs; // Clear, Rain, Clouds, Snow, etc.
  final RxDouble temperature = 20.0.obs;
  final RxString locationName = 'Unknown'.obs;
  final RxDouble windSpeed = 0.0.obs;  // ✨ NEW - for wind detection
  final RxBool isLoading = false.obs;
  final RxBool isEnabled = false.obs;  // ✨ NEW - Weather sync enabled/disabled

  /// Fetch weather by coordinates (IP-based or GPS)
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
        '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'
      );
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        weatherCondition.value = data['weather'][0]['main'];
        temperature.value = (data['main']['temp'] as num).toDouble();
        locationName.value = data['name'];
        windSpeed.value = (data['wind']['speed'] as num).toDouble();  // ✨ NEW
        
        debugPrint('🌤️ Weather: ${weatherCondition.value}, Temp: ${temperature.value}°C, Wind: ${windSpeed.value}km/h');
      } else {
        debugPrint('Weather API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Legacy method for backward compatibility
  Future<void> fetchCurrentWeather() async {
    // Use default Seoul coordinates
    await fetchWeatherByCoordinates(37.5665, 126.9780);
  }


  @override
  void onInit() {
    super.onInit();
    // Load saved state
    isEnabled.value = _storage.read('weather_sync_enabled') ?? false;
    
    if (isEnabled.value) {
      // Auto-fetch if previously enabled
      fetchCurrentWeather();
    }
  }

  /// Enable Weather Sync (Premium Feature)
  Future<void> enableWeatherSync() async {
    try {
      // Fetch current weather
      await fetchCurrentWeather();
      
      // Mark as enabled
      isEnabled.value = true;
      _storage.write('weather_sync_enabled', true);
      
      // ✨ NOTE: Weather sound is NOT auto-played here
      // User can enable it manually via debug panel or player controls
      debugPrint('✅ Weather Sync Enabled (sound not auto-played)');
    } catch (e) {
      debugPrint('❌ Failed to enable weather sync: $e');
      rethrow;
    }
  }

  /// Disable Weather Sync
  void disableWeatherSync() {
    isEnabled.value = false;
    _storage.write('weather_sync_enabled', false);
    
    // ✨ Stop weather sound mixing
    if (Get.isRegistered<WeatherSoundManager>()) {
      Get.find<WeatherSoundManager>().disableWeatherMix();
      debugPrint('🔇 Weather Sound Manager stopped');
    }
    
    debugPrint('🔇 Weather Sync Disabled');
  }

  /*
  Future<void> _simulateWeather(Position position) async {
    await Future.delayed(const Duration(seconds: 1));
    // Randomly pick a weather for testing
    final conditions = ['Clear', 'Rain', 'Clouds', 'Thunderstorm'];
    conditions.shuffle();
    weatherCondition.value = conditions.first;
    temperature.value = 22.5;
    locationName.value = 'Seoul (Simulated)';
    debugPrint('Simulated Weather: ${weatherCondition.value}');
  }
  */
}
