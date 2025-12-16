import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

/// Sound layer types for mixing
enum SoundLayer {
  rain,
  thunder,
  ocean,
  forest,
  fireplace,
  wind,
  birds,
  whitenoise,
}

/// Model for a mixable sound layer
class MixableSound {
  final SoundLayer type;
  final String name;
  final String iconPath;
  final String assetPath;
  final RxDouble volume;
  final RxBool isActive;
  
  MixableSound({
    required this.type,
    required this.name,
    required this.iconPath,
    required this.assetPath,
    double initialVolume = 0.5,
    bool active = false,
  }) : volume = initialVolume.obs,
       isActive = active.obs;
}

/// Service for mixing multiple ambient sound layers
class SoundMixerService extends GetxService {
  final Map<SoundLayer, AudioPlayer> _players = {};
  
  /// Available sound layers
  final RxList<MixableSound> layers = <MixableSound>[
    MixableSound(
      type: SoundLayer.rain,
      name: '빗소리',
      iconPath: 'assets/icons/mix/icon_rain.png',
      assetPath: 'assets/sound/weather/rain_ambient.mp3',  // ✨ Compressed
    ),
    MixableSound(
      type: SoundLayer.thunder,
      name: '천둥',
      iconPath: 'assets/icons/mix/icon_thunder.png',
      assetPath: 'assets/sound/weather/strong_wind.mp3',  // ✨ Compressed
    ),
    MixableSound(
      type: SoundLayer.ocean,
      name: '눈/바람',
      iconPath: 'assets/icons/mix/icon_ocean.png',
      assetPath: 'assets/sound/weather/snow_wind.mp3',  // ✨ Compressed
    ),
    MixableSound(
      type: SoundLayer.forest,
      name: '귀뚜라미',
      iconPath: 'assets/icons/mix/icon_forest.png',
      assetPath: 'assets/sound/weather/night_crickets.mp3',  // ✨ Compressed
    ),
    MixableSound(
      type: SoundLayer.fireplace,
      name: '구름',
      iconPath: 'assets/icons/mix/icon_fireplace.png',
      assetPath: 'assets/sound/weather/cloudy_ambient.mp3',
    ),
    MixableSound(
      type: SoundLayer.wind,
      name: '바람',
      iconPath: 'assets/icons/mix/icon_wind.png',
      assetPath: 'assets/sound/weather/strong_wind.mp3',  // ✨ Compressed
    ),
    MixableSound(
      type: SoundLayer.birds,
      name: '새소리',
      iconPath: 'assets/icons/mix/icon_birds.png',
      assetPath: 'assets/sound/weather/sunny_birds.mp3',  // ✨ Compressed
    ),
    MixableSound(
      type: SoundLayer.whitenoise,
      name: '백색소음',
      iconPath: 'assets/icons/mix/icon_whitenoise.png',
      assetPath: 'assets/sound/weather/cloudy_ambient.mp3',
    ),
  ].obs;
  
  /// Master volume for all ambient layers (0.0 ~ 1.0)
  final masterVolume = 0.7.obs;
  
  /// Whether mixing is enabled (premium feature)
  final isMixEnabled = false.obs;
  
  /// Number of active layers
  int get activeLayerCount => layers.where((l) => l.isActive.value).length;
  
  /// Toggle a specific layer (single selection only)
  Future<void> toggleLayer(SoundLayer type) async {
    final layer = layers.firstWhere((l) => l.type == type);
    
    if (layer.isActive.value) {
      // Turn off the selected layer
      await _stopLayer(type);
      layer.isActive.value = false;
    } else {
      // Turn off all other layers first (single selection mode)
      for (final otherLayer in layers) {
        if (otherLayer.isActive.value) {
          await _stopLayer(otherLayer.type);
          otherLayer.isActive.value = false;
        }
      }
      // Then turn on the selected layer
      await _playLayer(layer);
      layer.isActive.value = true;
    }
    
    print('🎧 Mix layer ${layer.name}: ${layer.isActive.value ? 'ON' : 'OFF'}');
  }
  
  /// Set volume for a specific layer
  Future<void> setLayerVolume(SoundLayer type, double volume) async {
    final layer = layers.firstWhere((l) => l.type == type);
    layer.volume.value = volume.clamp(0.0, 1.0);
    
    final player = _players[type];
    if (player != null) {
      await player.setVolume(volume * masterVolume.value);
    }
  }
  
  /// Set master volume for all layers
  Future<void> setMasterVolume(double volume) async {
    masterVolume.value = volume.clamp(0.0, 1.0);
    
    // Update all active players
    for (final entry in _players.entries) {
      final layer = layers.firstWhere((l) => l.type == entry.key);
      await entry.value.setVolume(layer.volume.value * masterVolume.value);
    }
  }
  
  Future<void> _playLayer(MixableSound layer) async {
    try {
      print('🎵 [_playLayer] Starting: ${layer.name}');
      print('🎵 [_playLayer] Asset path: ${layer.assetPath}');
      print('🎵 [_playLayer] Volume: ${layer.volume.value}, Master: ${masterVolume.value}');
      
      if (!_players.containsKey(layer.type)) {
        _players[layer.type] = AudioPlayer();
        print('🎵 [_playLayer] Created new AudioPlayer for ${layer.name}');
      }
      
      final player = _players[layer.type]!;
      print('🎵 [_playLayer] Setting asset...');
      await player.setAsset(layer.assetPath);
      print('🎵 [_playLayer] Asset set successfully');
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(layer.volume.value * masterVolume.value);
      print('🎵 [_playLayer] Playing...');
      await player.play();
      print('🎵 [_playLayer] ✅ Playing ${layer.name} successfully');
    } catch (e, stack) {
      print('❌ [_playLayer] Error playing layer ${layer.name}: $e');
      print('❌ [_playLayer] Stack trace: $stack');
    }
  }
  
  Future<void> _stopLayer(SoundLayer type) async {
    final player = _players[type];
    if (player != null) {
      await player.stop();
    }
  }
  
  /// Stop all layers
  Future<void> stopAll() async {
    for (final layer in layers) {
      layer.isActive.value = false;
    }
    
    for (final player in _players.values) {
      await player.stop();
    }
    
    print('🎧 All mix layers stopped');
  }
  
  /// Pause all active layers
  Future<void> pauseAll() async {
    for (final player in _players.values) {
      await player.pause();
    }
  }
  
  /// Resume all active layers
  Future<void> resumeAll() async {
    for (final entry in _players.entries) {
      final layer = layers.firstWhere((l) => l.type == entry.key);
      if (layer.isActive.value) {
        await entry.value.play();
      }
    }
  }
  

  /// Play a specific layer for Weather Service
  /// This bypasses the toggle logic but updates the active state
  Future<void> playWeatherLayer(SoundLayer type, double volume) async {
    print('🌦️ [playWeatherLayer] Called with type: $type, volume: $volume');
    
    // Determine the asset path based on type or existing config
    final layer = layers.firstWhere((l) => l.type == type, orElse: () => layers[0]);
    print('🌦️ [playWeatherLayer] Found layer: ${layer.name}, asset: ${layer.assetPath}');
    
    // Update layer volume
    layer.volume.value = volume;
    
    // Pre-load the asset first, THEN stop others
    try {
      // Create or reuse player
      if (!_players.containsKey(layer.type)) {
        _players[layer.type] = AudioPlayer();
        print('🌦️ [playWeatherLayer] Created new AudioPlayer');
      }
      
      final player = _players[layer.type]!;
      
      // Load asset (this can take time for large files)
      print('🌦️ [playWeatherLayer] Loading asset...');
      await player.setAsset(layer.assetPath);
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(volume * masterVolume.value);
      print('🌦️ [playWeatherLayer] Asset loaded successfully');
      
      // NOW stop other layers (after our asset is ready)
      for (final otherLayer in layers) {
        if (otherLayer.type != layer.type && otherLayer.isActive.value) {
          await _stopLayer(otherLayer.type);
          otherLayer.isActive.value = false;
        }
      }
      
      // Mark as active and play
      layer.isActive.value = true;
      await player.play();
      print('🌦️ [playWeatherLayer] ✅ Weather Layer Activated: ${layer.name}');
    } catch (e) {
      print('🌦️ [playWeatherLayer] ❌ ERROR: $e');
    }
  }
  
  @override
  void onClose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
    super.onClose();
  }
}
