import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '펫비츠';

  @override
  String get pet => 'Pet';

  @override
  String get beats => 'Beats';

  @override
  String get subtitle => '반려동물을 위한\n생체 음향 테라피';

  @override
  String get getStarted => '시작하기';

  @override
  String get tapToStart => '화면을 터치하여 시작';
}
