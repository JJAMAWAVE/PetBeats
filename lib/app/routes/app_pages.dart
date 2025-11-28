import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/mode_detail_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/onboarding/views/question_view.dart';
import '../modules/onboarding/views/question2_view.dart';
import '../modules/onboarding/views/loading_view.dart';
import '../modules/onboarding/views/splash_welcome_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/premium/bindings/premium_binding.dart';
import '../modules/premium/views/subscription_view.dart';
import '../modules/home/views/weather_special_view.dart';
import '../modules/home/views/rhythm_special_view.dart';
import '../modules/home/views/sitter_special_view.dart';
import '../modules/home/views/app_info_view.dart';
import '../modules/invite/bindings/invite_binding.dart';
import '../modules/invite/views/invite_friends_view.dart';
import '../modules/settings/controllers/settings_controller.dart';
import '../modules/premium/controllers/premium_controller.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: Routes.WELCOME,
      page: () => const SplashWelcomeView(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.QUESTION,
      page: () => const QuestionView(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.QUESTION2,
      page: () => const Question2View(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.LOADING,
      page: () => const LoadingView(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.MODE_DETAIL,
      page: () => const ModeDetailView(),
      binding: HomeBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.SUBSCRIPTION,
      page: () => const AppInfoView(),
      binding: PremiumBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.WEATHER_SPECIAL,
      page: () => const WeatherSpecialView(),
    ),
    GetPage(
      name: Routes.RHYTHM_SPECIAL,
      page: () => const RhythmSpecialView(),
    ),
    GetPage(
      name: Routes.SITTER_SPECIAL,
      page: () => const SitterSpecialView(),
    ),
    GetPage(
      name: Routes.INVITE_FRIENDS,
      page: () => const InviteFriendsView(),
      binding: InviteBinding(),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: BindingsBuilder(() {
        Get.put(SettingsController());
      }),
      preventDuplicates: true,
    ),
  ];
}
