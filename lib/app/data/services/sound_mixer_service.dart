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
      assetPath: 'assets/sound/ambient/rain_loop.mp3',
    ),
    MixableSound(
      type: SoundLayer.thunder,
      name: '천둥',
      iconPath: 'assets/icons/mix/icon_thunder.png',
      assetPath: 'assets/sound/ambient/thunder_loop.mp3',
    ),
    MixableSound(
      type: SoundLayer.ocean,
      name: '파도',
      iconPath: 'assets/icons/mix/icon_ocean.png',
      assetPath: 'assets/sound/ambient/ocean_loop.mp3',
    ),
    MixableSound(
      type: SoundLayer.forest,
      name: '숲속',
      iconPath: 'assets/icons/mix/icon_forest.png',
      assetPath: 'assets/sound/ambient/forest_loop.mp3',
    ),
    MixableSound(
      type: SoundLayer.fireplace,
      name: '벽난로',
      iconPath: 'assets/icons/mix/icon_fireplace.png',
      assetPath: 'assets/sound/ambient/fireplace_loop.mp3',
    ),
    MixableSound(
      type: SoundLayer.wind,
      name: '바람',
      iconPath: 'assets/icons/mix/icon_wind.png',
      assetPath: 'assets/sound/ambient/wind_loop.mp3',
    ),
    MixableSound(
      type: SoundLayer.whitenoise,
      name: '백색소음',
      iconPath: 'assets/icons/mix/icon_whitenoise.png',
      assetPath: 'assets/sound/ambient/whitenoise_loop.mp3',
    ),
  ].obs;
  
  /// Master volume for all ambient layers (0.0 ~ 1.0)
  final masterVolume = 0.7.obs;
  
  /// Whether mixing is enabled (premium feature)
  final isMixEnabled = false.obs;
  
  /// Number of active layers
  int get activeLayerCount => layers.where((l) => l.isActive.value).length;
  
  /// Toggle a specific layer
  Future<void> toggleLayer(SoundLayer type) async {
    final layer = layers.firstWhere((l) => l.type == type);
    
    if (layer.isActive.value) {
      await _stopLayer(type);
      layer.isActive.value = false;
    } else {
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
      if (!_players.containsKey(layer.type)) {
        _players[layer.type] = AudioPlayer();
      }
      
      final player = _players[layer.type]!;
      await player.setAsset(layer.assetPath);
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(layer.volume.value * masterVolume.value);
      await player.play();
    } catch (e) {
      print('❌ Error playing layer ${layer.name}: $e');
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
  
  @override
  void onClose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
    super.onClose();
  }
}
