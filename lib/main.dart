import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/theme/app_text_styles.dart';
import 'core/services/web_bgm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 웹용 BGM 사전 로딩
  await WebBgmService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PetBeats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.backgroundWhite,
        useMaterial3: true,
        fontFamily: AppTextStyles.baseStyle.fontFamily,
        textTheme: TextTheme(
          titleLarge: AppTextStyles.titleLarge,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // Korean
      ],
      defaultTransition: Transition.fadeIn,
      initialRoute: Routes.WELCOME,
      getPages: AppPages.routes,
    );
  }
}
