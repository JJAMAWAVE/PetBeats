import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/haptic_envelope.dart';
import './haptic_service.dart';

/// Plays pre-generated haptic patterns from JSON files
/// synchronized with audio playback
class HapticPatternPlayer extends GetxService {
  final HapticService _hapticService = Get.find<HapticService>();
  
  Map<String, dynamic>? _currentPattern;
  final List<Timer> _scheduledTimers = [];
  bool _isPlaying = false;
  
  /// Load haptic pattern JSON for given track
  Future<void> loadPattern(String trackId) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/haptic_patterns/$trackId.json',
      );
      _currentPattern = jsonDecode(jsonString);
      print('✅ Haptic pattern loaded: $trackId');
    } catch (e) {
      // Pattern file doesn't exist - haptic disabled for this track
      _currentPattern = null;
      print('ℹ️ No haptic pattern for: $trackId');
    }
  }
  
  /// Check if current track has haptic pattern
  bool get isHapticEnabled {
    return _currentPattern?['haptic_enabled'] == true;
  }
  
  /// Start playing haptic pattern from given position
  void start({Duration position = Duration.zero}) {
    stop(); // Clear any existing timers
    
    if (_currentPattern == null || !isHapticEnabled) {
      return; // No haptic for this track
    }
    
    _isPlaying = true;
    final events = _currentPattern!['events'] as List;
    
    for (var event in events) {
      final eventTimeMs = event['time'] as int;
      final delayMs = eventTimeMs - position.inMilliseconds;
      
      if (delayMs < 0) {
        continue; // Skip past events
      }
      
      final timer = Timer(Duration(milliseconds: delayMs), () {
        if (_isPlaying) {
          _playEvent(event);
        }
      });
      
      _scheduledTimers.add(timer);
    }
    
    print('🎵 Haptic playback started: ${events.length} events scheduled');
  }
  
  /// Stop all scheduled haptic events
  void stop() {
    _isPlaying = false;
    
    for (var timer in _scheduledTimers) {
      timer.cancel();
    }
    _scheduledTimers.clear();
  }
  
  /// Handle seek - restart from new position
  void seek(Duration position) {
    if (_isPlaying) {
      start(position: position);
    }
  }
  
  /// Play single haptic event with ADSR envelope
  void _playEvent(Map<String, dynamic> event) {
    final note = event['note'] as int;
    final velocity = event['velocity'] as int;
    
    // Use playNote which will apply ADSR envelope
    _hapticService.playNote(note, velocity);
  }
  
  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
