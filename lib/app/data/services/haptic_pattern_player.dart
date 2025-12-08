import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/haptic_envelope.dart';
import './haptic_service.dart';

/// MIDI 이벤트 데이터 클래스
class MidiEventData {
  final int note;
  final int velocity;
  final int timeMs;
  
  MidiEventData({required this.note, required this.velocity, required this.timeMs});
  
  /// 노트를 주파수 대역으로 분류 (bass/mid/high)
  String get frequencyBand {
    if (note <= 48) return 'bass';       // C3 이하
    if (note <= 72) return 'mid';        // C3~C5
    return 'high';                        // C5 이상
  }
  
  /// velocity(0-127)를 intensity(0.0-1.0)로 변환
  double get intensity => velocity / 127.0;
}

/// Plays pre-generated haptic patterns from JSON files
/// synchronized with audio playback
class HapticPatternPlayer extends GetxService {
  final HapticService _hapticService = Get.find<HapticService>();
  
  // MIDI 이벤트 스트림 - 비주얼라이저에서 구독
  final StreamController<MidiEventData> _midiEventController = StreamController.broadcast();
  Stream<MidiEventData> get midiEventStream => _midiEventController.stream;
  
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
    final timeMs = event['time'] as int;
    
    // 비주얼라이저에 MIDI 이벤트 전달
    _midiEventController.add(MidiEventData(
      note: note,
      velocity: velocity,
      timeMs: timeMs,
    ));
    
    // Use playNote which will apply ADSR envelope
    _hapticService.playNote(note, velocity);
  }
  
  @override
  void onClose() {
    stop();
    _midiEventController.close();
    super.onClose();
  }
}
