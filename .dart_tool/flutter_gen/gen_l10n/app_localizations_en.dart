import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PetBeats';

  @override
  String get pet => 'Pet';

  @override
  String get beats => 'Beats';

  @override
  String get subtitle => 'Bio-Acoustic Therapy\nfor Your Beloved Pets';

  @override
  String get getStarted => 'Get Started';

  @override
  String get tapToStart => 'Tap anywhere to start';
}
