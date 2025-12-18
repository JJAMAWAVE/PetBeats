import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'core/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/theme/app_text_styles.dart';
import 'core/services/web_bgm_service.dart';
import 'app/data/services/haptic_service.dart';
import 'app/data/services/haptic_pattern_player.dart';
import 'app/data/services/playback_tracking_service.dart';
import 'app/data/services/review_service.dart';
import 'app/data/services/audio_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/weather_service.dart';
import 'app/data/services/ip_geolocation_service.dart';
import 'app/data/services/weather_sync_service.dart';
import 'app/data/services/weather_sound_manager.dart';
import 'app/data/services/sound_mixer_service.dart';  // ✨ For weather sounds
import 'app/data/services/rhythm_care_service.dart';  // ✨ Rhythm Care (24h bio-rhythm)
import 'app/data/services/iot_service.dart';
import 'app/data/services/timer_service.dart';
import 'app/data/services/pet_profile_service.dart'; // 🐾 Pet Profile
import 'app/data/services/coupon_service.dart'; // 🎟️ Coupon System
import 'app/modules/invite/controllers/invite_controller.dart'; // 📨 Invite Friends
import 'package:get_storage/get_storage.dart';
import 'package:petbeats/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart'; // 🔥 Crash reporting
import 'firebase_options.dart';
import 'app/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 🔥 Crashlytics 초기화 (웹 제외)
  if (!kIsWeb) {
    // Flutter 프레임워크 에러 캐치
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    // Flutter 프레임워크 외부의 비동기 에러 캐치
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    
    debugPrint('🔥 [Crashlytics] Initialized');
  }
  
  // ⚠️ 테스트용: 항상 신규 유저로 시작 (온보딩 표시)
  // TODO: 배포 전 이 줄 제거
  GetStorage().write('onboarding_completed', false);
  
  // 전역 서비스 초기화
  Get.put(HapticService(), permanent: true);
  Get.put(HapticPatternPlayer(), permanent: true);  // MIDI 기반 햅틱 패턴 플레이어
  Get.put(PlaybackTrackingService(), permanent: true);
  Get.put(ReviewService(), permanent: true);
  
  // New Feature Services
  Get.put(AudioService(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(WeatherService(), permanent: true);
  Get.put(IpGeolocationService(), permanent: true);  // ✨ Weather services
  Get.put(WeatherSyncService(), permanent: true);    // ✨ Weather services
  Get.put(SoundMixerService(), permanent: true);     // ✨ For weather sounds (must be before WeatherSoundManager)
  Get.put(WeatherSoundManager(), permanent: true);   // ✨ Weather services
  Get.put(RhythmCareService(), permanent: true);     // ✨ Rhythm Care (24h bio-rhythm)
  Get.put(IotService(), permanent: true);
  Get.put(TimerService(), permanent: true);
  Get.put(PetProfileService(), permanent: true);     // 🐾 Pet Profile
  Get.put(CouponService(), permanent: true);          // 🎟️ Coupon System
  Get.put(InviteController(), permanent: true);       // 📨 Invite Friends
  
  // 웹용 BGM 사전 로딩 (웹 플랫폼만)
  if (kIsWeb) {
    final webBgm = WebBgmService();
    await webBgm.init();
    // Register globally so HomeController can access it
    Get.put(webBgm, permanent: true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil 초기화 (디자인 기준: 360x800)
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'PetBeats',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          translations: AppTranslations(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'), // Korean
            Locale('en', 'US'), // English
          ],
          // 시스템 언어 자동 감지 (감지 실패 시 영어 강제)
          locale: Get.deviceLocale ?? const Locale('en', 'US'), 
          fallbackLocale: const Locale('en', 'US'), // 글로벌 스탠다드 (영어)
          builder: (context, widget) {
            // ScreenUtil 적용을 위한 builder
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
