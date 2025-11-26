import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class SubscriptionController extends GetxController {
  final selectedPlanIndex = 0.obs;
  final isLoading = false.obs;

  final plans = [
    {'duration': '1년', 'price': '₩88,000', 'tag': '최고의 선택'},
    {'duration': '3개월', 'price': '₩27,250', 'tag': ''},
    {'duration': '1개월', 'price': '₩10,900', 'tag': ''},
    {'duration': '평생 소장', 'price': '₩290,000', 'tag': '한 번 결제로 평생 이용'},
  ];

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  void subscribe() async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    
    // Grant premium access
    Get.find<HomeController>().upgradeToPremium();
    Get.back();
    Get.snackbar('프리미엄 활성화', 'PetBeats 프리미엄에 오신 것을 환영합니다!', 
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }
}
