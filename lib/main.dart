import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'core/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/theme/app_text_styles.dart';
import 'core/services/web_bgm_service.dart';
import 'app/data/services/haptic_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:petbeats/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // 전역 서비스 초기화
  Get.put(HapticService(), permanent: true);
  
  // 웹용 BGM 사전 로딩
  await WebBgmService().init();
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', ''), // Korean
            Locale('en', ''), // English
          ],
          locale: const Locale('ko', ''), // Default to Korean
          fallbackLocale: const Locale('en', ''),
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
