import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PlaybackTrackingService extends GetxService {
  final _storage = GetStorage();
  DateTime? _sessionStartTime;
  
  static const String _keyTotalSeconds = 'total_playback_seconds';
  static const String _keyConsecutiveDays = 'consecutive_days';
  static const String _keyLastPlayDate = 'last_play_date';
  
  int get totalPlaybackSeconds => _storage.read(_keyTotalSeconds) ?? 0;
  int get consecutiveDays => _storage.read(_keyConsecutiveDays) ?? 0;
  
  void startTracking() {
    _sessionStartTime = DateTime.now();
  }
  
  int stopTracking() {
    if (_sessionStartTime == null) return 0;
    
    final duration = DateTime.now().difference(_sessionStartTime!);
    final seconds = duration.inSeconds;
    
    final newTotal = totalPlaybackSeconds + seconds;
    _storage.write(_keyTotalSeconds, newTotal);
    
    _updateConsecutiveDays();
    
    _sessionStartTime = null;
    return seconds;
  }
  
  void _updateConsecutiveDays() {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    
    final lastPlayDate = _storage.read(_keyLastPlayDate);
    
    if (lastPlayDate != todayKey) {
      if (lastPlayDate != null) {
        final yesterday = today.subtract(const Duration(days: 1));
        final yesterdayKey = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
        
        if (lastPlayDate == yesterdayKey) {
          _storage.write(_keyConsecutiveDays, consecutiveDays + 1);
        } else {
          _storage.write(_keyConsecutiveDays, 1);
        }
      } else {
        _storage.write(_keyConsecutiveDays, 1);
      }
      
      _storage.write(_keyLastPlayDate, todayKey);
    }
  }
  
  bool wasLastSessionLongEnough(int seconds) {
    return seconds >= 300; // 5분 이상
  }
  
  bool hasReachedMilestone() {
    return consecutiveDays >= 3 || totalPlaybackSeconds >= 3600;
  }
}
