import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../data/services/haptic_service.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
    );
    Get.lazyPut<HapticService>(
      () => HapticService(),
    );
  }
}
