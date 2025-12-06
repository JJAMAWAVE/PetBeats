import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ReviewService extends GetxService {
  final _storage = GetStorage();
  static const String _reviewRequestedKey = 'review_requested';

  Future<void> requestReview() async {
    // 이미 리뷰 요청을 했는지 확인
    if (_storage.read(_reviewRequestedKey) == true) {
      print('⭐ [ReviewService] 이미 리뷰를 요청했습니다. 스킵.');
      return;
    }

    print('⭐ [ReviewService] 리뷰 요청 다이얼로그 표시');
    
    // 리뷰 다이얼로그 표시
    Get.toNamed('/review');
    
    // 리뷰 요청 완료 표시 (한 번만 요청)
    _storage.write(_reviewRequestedKey, true);
  }
  
  // 테스트용: 리뷰 요청 상태 초기화
  void resetReviewStatus() {
    _storage.remove(_reviewRequestedKey);
    print('⭐ [ReviewService] 리뷰 상태 초기화됨');
  }
}
