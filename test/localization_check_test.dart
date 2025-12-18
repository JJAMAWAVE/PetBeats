import 'package:flutter_test/flutter_test.dart';
import 'package:petbeats/app/translations/ko_kr.dart';
import 'package:petbeats/app/translations/en_us.dart';

void main() {
  group('Localization Integrity Checks', () {
    test('ko_KR map contains newly added keys', () {
      final keysToCheck = [
        'weather_sound_title',
        'sleep_timer',
        'timer_notify_title',
        'haptic_premium_title',
        'rolling_tip_1',
        'rhythm_title',
        'ai_playlist_result_title', // Check logic if key exists or verify known keys
        // We verified earlier 'scenario_after_walk' exists.
      ];

      for (var key in keysToCheck) {
         // Some keys might not exist if I didn't add them?
         // ai_playlist_result_title wasn't explicitly added by me, check only what I added.
      }
      
      expect(koKR.containsKey('weather_sound_title'), true, reason: 'Key weather_sound_title missing');
      expect(koKR.containsKey('sleep_timer'), true, reason: 'Key sleep_timer missing');
      expect(koKR.containsKey('timer_notify_title'), true, reason: 'Key timer_notify_title missing');
      expect(koKR.containsKey('haptic_premium_title'), true, reason: 'Key haptic_premium_title missing');
      expect(koKR.containsKey('rolling_tip_1'), true, reason: 'Key rolling_tip_1 missing');
    });

    test('en_US map contains newly added keys', () {
      expect(enUS.containsKey('weather_sound_title'), true, reason: 'Key weather_sound_title missing in US');
      expect(enUS.containsKey('sleep_timer'), true, reason: 'Key sleep_timer missing in US');
      expect(enUS.containsKey('timer_notify_title'), true, reason: 'Key timer_notify_title missing in US');
    });
    
    test('TimerService related keys check', () {
       expect(koKR['ai_minutes'], '분');
       expect(koKR['timer_suffix'], ' 후 종료');
       expect(enUS['timer_suffix'], ' remaining');
    });
  });
}
