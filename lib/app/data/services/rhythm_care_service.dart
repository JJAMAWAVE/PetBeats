import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// 🕐 리듬 케어 서비스 (Rhythm Care Service)
/// 
/// 24시간 생체 리듬에 맞춰 자동으로 사운드 모드를 결정합니다.
/// - 오전 (07:00~11:00): 활력 (energy/play)
/// - 주간 (11:00~17:00): 안정 (anxiety)
/// - 저녁 (17:00~22:00): 휴식 (senior)
/// - 심야 (22:00~07:00): 수면 (sleep)
class RhythmCareService extends GetxService {
  final _storage = GetStorage();
  
  /// 리듬 케어 활성화 상태
  final isEnabled = false.obs;
  
  /// 현재 시간대 모드
  final currentTimeZone = 'sleep'.obs;
  
  /// 현재 시간대 이름 (UI 표시용)
  final currentTimeZoneName = 'rhythm_night'.tr.obs;
  
  /// 현재 시간대 아이콘
  final currentTimeZoneIcon = '😴'.obs;
  
  /// 디버그용 시간 오버라이드 (null이면 현재 시간 사용)
  DateTime? _debugOverrideTime;
  
  Timer? _updateTimer;
  
  /// 시간대 정의
  static const Map<String, TimeZoneConfig> timeZones = {
    'morning': TimeZoneConfig(
      name: 'rhythm_morning',
      icon: '☀️',
      mode: 'energy',  // play/energy mode
      startHour: 7,
      endHour: 11,
      color: Color(0xFFFF9500),
    ),
    'daytime': TimeZoneConfig(
      name: 'rhythm_daytime',
      icon: '🌤️',
      mode: 'anxiety',  // anxiety/calm mode
      startHour: 11,
      endHour: 17,
      color: Color(0xFF34C759),
    ),
    'evening': TimeZoneConfig(
      name: 'rhythm_evening',
      icon: '🌅',
      mode: 'senior',  // senior/rest mode
      startHour: 17,
      endHour: 22,
      color: Color(0xFFFF6B6B),
    ),
    'night': TimeZoneConfig(
      name: 'rhythm_night',
      icon: '😴',
      mode: 'sleep',  // sleep mode
      startHour: 22,
      endHour: 7,  // 다음날 7시까지
      color: Color(0xFF5856D6),
    ),
  };
  
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _updateCurrentTimeZone();
    
    // 1분마다 시간대 체크
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateCurrentTimeZone();
    });
  }
  
  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }
  
  void _loadSettings() {
    isEnabled.value = _storage.read<bool>('rhythm_care_enabled') ?? false;
  }
  
  void _saveSettings() {
    _storage.write('rhythm_care_enabled', isEnabled.value);
  }
  
  /// 리듬 케어 활성화
  void enable() {
    isEnabled.value = true;
    _saveSettings();
    _updateCurrentTimeZone();
    debugPrint('🕐 Rhythm Care enabled');
  }
  
  /// 리듬 케어 비활성화
  void disable() {
    isEnabled.value = false;
    _saveSettings();
    debugPrint('🕐 Rhythm Care disabled');
  }
  
  /// 토글
  void toggle() {
    if (isEnabled.value) {
      disable();
    } else {
      enable();
    }
  }
  
  /// 현재 시간 가져오기 (디버그 오버라이드 지원)
  DateTime get currentTime => _debugOverrideTime ?? DateTime.now();
  
  /// 디버그용 시간 오버라이드 설정
  void setDebugTime(int hour) {
    final now = DateTime.now();
    _debugOverrideTime = DateTime(now.year, now.month, now.day, hour, 0);
    _updateCurrentTimeZone();
    debugPrint('🕐 [DEBUG] Time override: $hour:00');
  }
  
  /// 디버그 시간 초기화 (실제 시간으로 복귀)
  void clearDebugTime() {
    _debugOverrideTime = null;
    _updateCurrentTimeZone();
    debugPrint('🕐 [DEBUG] Time override cleared');
  }
  
  /// 현재 시간대 업데이트
  void _updateCurrentTimeZone() {
    final hour = currentTime.hour;
    
    String zoneKey = 'night';  // 기본값
    
    if (hour >= 7 && hour < 11) {
      zoneKey = 'morning';
    } else if (hour >= 11 && hour < 17) {
      zoneKey = 'daytime';
    } else if (hour >= 17 && hour < 22) {
      zoneKey = 'evening';
    } else {
      zoneKey = 'night';
    }
    
    final config = timeZones[zoneKey]!;
    currentTimeZone.value = config.mode;
    currentTimeZoneName.value = config.name.tr;
    currentTimeZoneIcon.value = config.icon;
    
    debugPrint('🕐 Time zone updated: ${config.name} (${config.mode})');
  }
  
  /// 현재 시간대에 맞는 모드 가져오기
  String getRecommendedMode() {
    return currentTimeZone.value;
  }
  
  /// 현재 시간대 설정 가져오기
  TimeZoneConfig? getCurrentConfig() {
    for (final entry in timeZones.entries) {
      if (entry.value.mode == currentTimeZone.value) {
        return entry.value;
      }
    }
    return timeZones['night'];
  }
}

/// 시간대 설정 모델
class TimeZoneConfig {
  final String name;
  final String icon;
  final String mode;
  final int startHour;
  final int endHour;
  final Color color;
  
  const TimeZoneConfig({
    required this.name,
    required this.icon,
    required this.mode,
    required this.startHour,
    required this.endHour,
    required this.color,
  });
}
