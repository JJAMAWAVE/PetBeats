import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final rating = 0.obs;
  final feedbackController = TextEditingController();

  void setRating(int value) {
    rating.value = value;
  }

  void submitReview() {
    if (rating.value == 0) {
      Get.snackbar('알림', '별점을 선택해주세요.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black);
      return;
    }
    // Mock submission
    Get.snackbar('감사합니다', '소중한 의견이 전달되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black);
    
    // 1초 후 뒤로가기
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
