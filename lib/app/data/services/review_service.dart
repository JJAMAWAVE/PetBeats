import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewService extends GetxService {
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }
}
