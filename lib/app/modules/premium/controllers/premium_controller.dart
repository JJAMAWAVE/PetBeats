import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class PremiumController extends GetxController {
  // 홈 컨트롤러에 접근하여 프리미엄 상태 변경
  final HomeController _homeController = Get.find<HomeController>();

  void subscribe() {
    // 실제 결제 로직 대신 상태만 변경
    _homeController.upgradeToPremium();
    Get.back();
    Get.snackbar('성공', '프리미엄 구독이 시작되었습니다!');
  }
}
