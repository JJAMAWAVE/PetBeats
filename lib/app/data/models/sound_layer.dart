/// Sound Layer Model for Weather Sound Manager
/// Defines different types of environmental sounds that can be layered

enum SoundLayerType {
  rain,
  whiteNoise,
  natureAmbient,
  wind,
}

/// Sound Layer Configuration
class SoundLayerConfig {
  final SoundLayerType? type;
  final double volume;  // 0.0 ~ 1.0
  
  SoundLayerConfig({
    required this.type,
    required this.volume,
  });
}
