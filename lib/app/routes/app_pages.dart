import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/mode_detail_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/onboarding/views/question_view.dart';
import '../modules/onboarding/views/question2_view.dart';
import '../modules/onboarding/views/onboarding_complete_view.dart';
import '../modules/onboarding/views/loading_view.dart';
import '../modules/onboarding/views/splash_welcome_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/premium/bindings/premium_binding.dart';
import '../modules/premium/bindings/subscription_binding.dart';
import '../modules/premium/views/subscription_view.dart';
import '../modules/home/views/weather_special_view.dart';
import '../modules/home/views/rhythm_special_view.dart';
import '../modules/home/views/sitter_special_view.dart';
import '../modules/sitter/views/sitter_setup_view.dart';
import '../modules/sitter/views/sitter_monitoring_view.dart';
import '../modules/sitter/views/sitter_report_view.dart';
import '../modules/ai_recommend/views/ai_recommend_view.dart';
import '../modules/ai_recommend/views/ai_playlist_result_view.dart';
import '../modules/home/views/app_info_view.dart';
import '../modules/invite/bindings/invite_binding.dart';
import '../modules/invite/views/invite_friends_view.dart';
import '../modules/settings/controllers/settings_controller.dart';
import '../modules/premium/controllers/premium_controller.dart';
import '../modules/player/views/now_playing_view.dart';
import '../modules/player/bindings/player_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/review/controllers/review_controller.dart';
import '../modules/settings/views/pet_profile_view.dart';
import '../modules/settings/views/coupon_view.dart';
import 'app_routes.dart';
// Note: smooth_page_transitions.dart import removed - using built-in Transition.cupertino instead

class AppPages {
  static const INITIAL = Routes.LOADING;  // 시네마틱 스플래시 먼저 보여줌

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
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.QUESTION,
      page: () => const QuestionView(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.QUESTION2,
      page: () => const Question2View(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.ONBOARDING_COMPLETE,
      page: () => const OnboardingCompleteView(),
      binding: OnboardingBinding(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
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
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.MODE_DETAIL,
      page: () => const ModeDetailView(),
      binding: HomeBinding(),
      preventDuplicates: true,
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.SUBSCRIPTION,
      page: () => const SubscriptionView(),
      binding: SubscriptionBinding(),
      preventDuplicates: true,
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.WEATHER_SPECIAL,
      page: () => const WeatherSpecialView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.RHYTHM_SPECIAL,
      page: () => const RhythmSpecialView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.SITTER_SPECIAL,
      page: () => const SitterSpecialView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.SITTER_SETUP,
      page: () => const SitterSetupView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.SITTER_MONITORING,
      page: () => const SitterMonitoringView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.SITTER_REPORT,
      page: () => const SitterReportView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.AI_RECOMMEND,
      page: () => const AIRecommendView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.AI_PLAYLIST_RESULT,
      page: () => const AIPlaylistResultView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.INVITE_FRIENDS,
      page: () => const InviteFriendsView(),
      binding: InviteBinding(),
      preventDuplicates: true,
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: BindingsBuilder(() {
        Get.put(SettingsController());
      }),
      preventDuplicates: true,
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.NOW_PLAYING,
      page: () => const NowPlayingView(),
      binding: PlayerBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.REVIEW,
      page: () => const ReviewView(),
      binding: BindingsBuilder(() {
        Get.put(ReviewController());
      }),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.PET_PROFILE,
      page: () => const PetProfileView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.COUPON,
      page: () => const CouponView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
  ];
}

