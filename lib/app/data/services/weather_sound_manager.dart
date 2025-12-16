import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'weather_service.dart';
import '../models/sound_layer.dart';
import 'sound_mixer_service.dart'; // ✨ Import SoundMixerService

/// Weather Sound Manager
/// Maps weather conditions to appropriate environmental sounds
/// Replaces Mix Panel with Weather-based sound mixing
class WeatherSoundManager extends GetxService {
  final WeatherService _weatherService = Get.find<WeatherService>();
  
  final RxBool isWeatherMixActive = false.obs;
  final RxString currentWeatherSound = 'None'.obs;
  final RxDouble currentMixLevel = 0.0.obs;
  
  /// Weather to Sound Layer mapping
  final Map<String, SoundLayerConfig> _weatherSoundMap = {
    'Clear': SoundLayerConfig(type: SoundLayerType.natureAmbient, volume: 0.25),  // ✨ 맑음 → 새소리
    'Clouds': SoundLayerConfig(type: SoundLayerType.whiteNoise, volume: 0.20),  // 구름
    'Rain': SoundLayerConfig(type: SoundLayerType.rain, volume: 0.35),  // 비
    'Drizzle': SoundLayerConfig(type: SoundLayerType.rain, volume: 0.25),  // 이슬비
    'Thunderstorm': SoundLayerConfig(type: SoundLayerType.whiteNoise, volume: 0.40),  // 천둥
    'Snow': SoundLayerConfig(type: SoundLayerType.wind, volume: 0.30),  // 눈 → 바람소리
    'Mist': SoundLayerConfig(type: SoundLayerType.whiteNoise, volume: 0.20),  // 안개 → 백색소음 (새소리X)
    'Fog': SoundLayerConfig(type: SoundLayerType.wind, volume: 0.20),  // 짙은 안개 → 바람
    'Haze': SoundLayerConfig(type: SoundLayerType.whiteNoise, volume: 0.15),  // 연무
  };
  
  @override
  void onInit() {
    super.onInit();
    
    // Listen to weather changes
    ever(_weatherService.weatherCondition, (_) {
      if (isWeatherMixActive.value) {
        _applyWeatherMix();
      }
    });
    
    // Listen to wind speed changes
    ever(_weatherService.windSpeed, (_) {
      if (isWeatherMixActive.value) {
        _applyWeatherMix();
      }
    });
  }
  
  /// Enable weather-based sound mixing
  void enableWeatherMix() {
    isWeatherMixActive.value = true;
    _applyWeatherMix();
    debugPrint('🌤️ Weather Mix enabled');
  }
  
  /// Disable weather mix (stop all weather layers)
  void disableWeatherMix() {
    isWeatherMixActive.value = false;
    currentWeatherSound.value = 'None';
    currentMixLevel.value = 0.0;
    
    if (Get.isRegistered<SoundMixerService>()) {
      Get.find<SoundMixerService>().stopAll();
    }
    
    debugPrint('🌤️ Weather Mix disabled');
  }
  
  /// Apply current weather condition to sound mix
  void _applyWeatherMix() {
    debugPrint('🔊 [_applyWeatherMix] Called');
    debugPrint('🔊 [_applyWeatherMix] isWeatherMixActive: ${isWeatherMixActive.value}');
    
    if (!isWeatherMixActive.value) {
      debugPrint('🔊 [_applyWeatherMix] ❌ Weather mix not active, returning');
      return;
    }
    
    final condition = _weatherService.weatherCondition.value;
    final windSpeed = _weatherService.windSpeed.value;
    debugPrint('🔊 [_applyWeatherMix] condition: $condition, windSpeed: $windSpeed');
    
    // Get sound configuration for current weather
    final config = _weatherSoundMap[condition] ?? _weatherSoundMap['Clear']!;
    debugPrint('🔊 [_applyWeatherMix] config.type: ${config.type}, config.volume: ${config.volume}');
    
    // Get SoundMixerService
    if (!Get.isRegistered<SoundMixerService>()) {
      debugPrint('🔊 [_applyWeatherMix] ❌ SoundMixerService not registered!');
      return;
    }
    final mixer = Get.find<SoundMixerService>();
    debugPrint('🔊 [_applyWeatherMix] ✅ SoundMixerService found');
    
    // 1. Clear weather or configured as None
    if (config.type == null) {
      currentWeatherSound.value = 'None';
      currentMixLevel.value = 0.0;
      mixer.stopAll(); // Clear any existing weather layer
      debugPrint('🌤️ Clear weather - stopped weather layers');
      return;
    }
    
    // 2. Map SoundLayerType to Mixer's SoundLayer
    SoundLayer? mixerLayer = _mapToMixerLayer(config.type!);
    debugPrint('🔊 [_applyWeatherMix] mixerLayer: $mixerLayer');
    
    if (mixerLayer != null) {
      // update observables
      currentWeatherSound.value = _getSoundName(config.type!);
      currentMixLevel.value = config.volume;
      
      // ✨ Play weather layer via Mixer
      debugPrint('🔊 [_applyWeatherMix] Calling mixer.playWeatherLayer($mixerLayer, ${config.volume})');
      mixer.playWeatherLayer(mixerLayer, config.volume);
      
      debugPrint('🌤️ Weather sound applied: ${currentWeatherSound.value} (${(config.volume * 100).toInt()}%)');
    } else {
      debugPrint('🔊 [_applyWeatherMix] ❌ mixerLayer is null!');
    }
    
    // 3. Check for Strong Wind override
    if (windSpeed > 20) {
      debugPrint('💨 Strong wind detected ($windSpeed km/h) - switching to wind layer');
      mixer.playWeatherLayer(SoundLayer.wind, 0.40);
      currentWeatherSound.value = '강풍';
    }
  }

  /// Map internal SoundLayerType to SoundMixerService's SoundLayer
  SoundLayer? _mapToMixerLayer(SoundLayerType type) {
    switch (type) {
      case SoundLayerType.rain: return SoundLayer.rain;
      case SoundLayerType.whiteNoise: return SoundLayer.whitenoise;
      case SoundLayerType.natureAmbient: return SoundLayer.birds; // Using birds/nature
      case SoundLayerType.wind: return SoundLayer.wind;
      default: return null;
    }
  }
  
  /// Get asset path for weather sound layer
  String _getSoundAssetPath(SoundLayerType type) {
    const basePath = 'assets/sound/weather/';
    switch (type) {
      case SoundLayerType.rain:
        return '${basePath}rain_ambient.wav';
      case SoundLayerType.whiteNoise:
        return '${basePath}cloudy_ambient.wav';
      case SoundLayerType.natureAmbient:
        return '${basePath}sunny_birds.wav'; // Default nature
      case SoundLayerType.wind:
        return '${basePath}strong_wind.wav';
      default:
        return '';
    }
  }

  /// Get specific asset for special conditions
  String _getConditionSpecificAsset(String condition) {
    const basePath = 'assets/sound/weather/';
    if (condition.contains('Snow')) return '${basePath}snow_wind.wav';
    if (condition.contains('Night')) return '${basePath}night_crickets.wav';
    if (condition.contains('Clear')) return '${basePath}sunny_birds.wav';
    return '';
  }

  /// Get human-readable sound name
  String _getSoundName(SoundLayerType type) {
    switch (type) {
      case SoundLayerType.rain:
        return '빗소리';
      case SoundLayerType.whiteNoise:
        return '백색소음';
      case SoundLayerType.natureAmbient:
        return '자연 소리';
      case SoundLayerType.wind:
        return '바람소리';
      default:
        return 'Unknown';
    }
  }
}
