import 'package:get/get.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/onboarding/views/question_view.dart';
import '../modules/onboarding/views/splash_welcome_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/mode_detail_view.dart';
import '../modules/premium/bindings/premium_binding.dart';
import '../modules/premium/views/premium_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: Routes.WELCOME,
      page: () => const SplashWelcomeView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.QUESTIONS,
      page: () => const QuestionView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/mode_detail',
      page: () => const ModeDetailView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/premium',
      page: () => const PremiumView(),
      binding: PremiumBinding(),
    ),
  ];
}
