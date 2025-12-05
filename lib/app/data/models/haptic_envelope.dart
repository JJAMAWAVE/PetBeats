/// ADSR Envelope for smooth haptic vibration
/// 
/// Provides gentle attack and release curves to avoid
/// sharp vibrations that may startle pets.
class HapticEnvelope {
  // Envelope timing (milliseconds)
  static const int attackMs = 30;
  static const int decayMs = 20;
  static const int sustainMs = 50;
  static const int releaseMs = 50;
  static const int totalDuration = attackMs + decayMs + sustainMs + releaseMs;
  
  /// Calculate envelope gain at given elapsed time
  /// Returns 0.0 to 1.0 multiplier for amplitude
  static double getGain(int elapsedMs) {
    if (elapsedMs < 0) return 0.0;
    
    if (elapsedMs < attackMs) {
      // Attack: 0 → 1.0 (Ease-In Cubic)
      final t = elapsedMs / attackMs;
      return _easeInCubic(t);
      
    } else if (elapsedMs < attackMs + decayMs) {
      // Decay: 1.0 → 0.8
      final t = (elapsedMs - attackMs) / decayMs;
      return 1.0 - (0.2 * t);
      
    } else if (elapsedMs < attackMs + decayMs + sustainMs) {
      // Sustain: 0.8 (constant)
      return 0.8;
      
    } else if (elapsedMs < totalDuration) {
      // Release: 0.8 → 0 (Ease-Out Cubic)
      final t = (elapsedMs - attackMs - decayMs - sustainMs) / releaseMs;
      return 0.8 * (1.0 - _easeOutCubic(t));
      
    } else {
      return 0.0;
    }
  }
  
  /// Cubic ease-in function (smooth acceleration)
  static double _easeInCubic(double t) {
    return t * t * t;
  }
  
  /// Cubic ease-out function (smooth deceleration)
  static double _easeOutCubic(double t) {
    final t1 = t - 1.0;
    return t1 * t1 * t1 + 1.0;
  }
}
