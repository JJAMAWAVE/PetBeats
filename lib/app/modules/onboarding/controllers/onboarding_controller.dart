import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final _storage = GetStorage();
  
  // 페이지 컨트롤러
  final pageController = PageController();
  
  // 현재 슬라이드 인덱스
  final _pageIndex = 0.obs;
  int get pageIndex => _pageIndex.value;

  // 사용자 선택 데이터
  final species = <String>[].obs; // Dog, Cat, Owner (다중 선택)
  final ageGroup = ''.obs;
  final stressTriggers = <String>[].obs;
  
  // 슬라이드 변경 시 호출
  void onPageChanged(int index) {
    _pageIndex.value = index;
  }

  // 다음 슬라이드로 이동
  void nextSlide() {
    print('nextSlide called. pageIndex: ${_pageIndex.value}');
    if (_pageIndex.value < 3) { // 4 steps (0, 1, 2, 3)
      pageController.nextPage(
        duration: const Duration(milliseconds: 600), // Slower, smoother transition
        curve: Curves.easeInOutCubic, // More elegant curve
      );
    } else {
      print('Navigating to Routes.QUESTION');
      Get.offNamed(Routes.QUESTION);
    }
  }

  // 질문 답변 저장 및 다음으로 이동
  void saveAnswerAndNext(String key, dynamic value) {
    // 여기에 저장 로직 구현 (예: 로컬 스토리지)
    print('Saved $key: $value');
    
    // 마지막 질문이면 홈으로 이동 (임시)
    if (key == 'completed') {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void completeOnboarding() {
    // 온보딩 완료 상태 저장
    _storage.write('onboarding_completed', true);
    Get.offAllNamed(Routes.HOME);
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
