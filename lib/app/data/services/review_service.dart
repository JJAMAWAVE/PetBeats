import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/material.dart';

/// Google Play Store / App Store 리뷰 연동 서비스
class ReviewService extends GetxService {
  final _storage = GetStorage();
  final InAppReview _inAppReview = InAppReview.instance;
  
  static const String _reviewRequestedKey = 'review_requested';
  static const String _lastReviewRequestKey = 'last_review_request_time';
  static const String _playCountKey = 'total_play_count';
  
  // 리뷰 요청 조건
  static const int _minPlaysForReview = 5; // 최소 5회 재생 후 리뷰 요청
  static const int _daysBetweenRequests = 30; // 30일마다 다시 요청 가능

  /// 재생 카운트 증가 (리뷰 트리거 조건)
  void incrementPlayCount() {
    final count = _storage.read<int>(_playCountKey) ?? 0;
    _storage.write(_playCountKey, count + 1);
    debugPrint('⭐ [ReviewService] Play count: ${count + 1}');
  }

  /// 리뷰 요청 가능 여부 확인
  Future<bool> canRequestReview() async {
    // 1. Play Store/App Store 리뷰 가능 여부 확인
    final isAvailable = await _inAppReview.isAvailable();
    if (!isAvailable) {
      debugPrint('⭐ [ReviewService] In-app review not available on this device');
      return false;
    }
    
    // 2. 최소 재생 횟수 확인
    final playCount = _storage.read<int>(_playCountKey) ?? 0;
    if (playCount < _minPlaysForReview) {
      debugPrint('⭐ [ReviewService] Not enough plays: $playCount / $_minPlaysForReview');
      return false;
    }
    
    // 3. 마지막 요청 시간 확인 (30일마다)
    final lastRequest = _storage.read<int>(_lastReviewRequestKey);
    if (lastRequest != null) {
      final lastDate = DateTime.fromMillisecondsSinceEpoch(lastRequest);
      final daysSinceLastRequest = DateTime.now().difference(lastDate).inDays;
      if (daysSinceLastRequest < _daysBetweenRequests) {
        debugPrint('⭐ [ReviewService] Too soon since last request: $daysSinceLastRequest days ago');
        return false;
      }
    }
    
    return true;
  }

  /// Google Play / App Store 네이티브 리뷰 다이얼로그 표시
  Future<void> requestReview() async {
    try {
      final canRequest = await canRequestReview();
      if (!canRequest) {
        debugPrint('⭐ [ReviewService] Review request conditions not met');
        return;
      }
      
      debugPrint('⭐ [ReviewService] Requesting in-app review...');
      
      // 네이티브 리뷰 다이얼로그 표시
      await _inAppReview.requestReview();
      
      // 요청 시간 기록
      _storage.write(_lastReviewRequestKey, DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('⭐ [ReviewService] Review dialog shown successfully');
    } catch (e) {
      debugPrint('⭐ [ReviewService] Error requesting review: $e');
      // 실패 시 스토어 페이지로 fallback
      _openStoreListing();
    }
  }

  /// 강제로 리뷰 요청 (조건 무시 - 설정 화면에서 사용)
  Future<void> forceRequestReview() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      
      if (isAvailable) {
        debugPrint('⭐ [ReviewService] Force requesting in-app review...');
        await _inAppReview.requestReview();
      } else {
        // 리뷰 불가능 시 스토어로 이동
        debugPrint('⭐ [ReviewService] In-app review not available, opening store...');
        await _openStoreListing();
      }
    } catch (e) {
      debugPrint('⭐ [ReviewService] Error: $e');
      await _openStoreListing();
    }
  }

  /// Play Store / App Store 페이지 직접 열기
  Future<void> _openStoreListing() async {
    try {
      // appStoreId는 iOS용, 안드로이드는 자동 감지
      await _inAppReview.openStoreListing(
        // appStoreId: 'YOUR_APP_STORE_ID', // iOS 앱 등록 후 추가
      );
    } catch (e) {
      debugPrint('⭐ [ReviewService] Error opening store: $e');
      Get.snackbar(
        'review_error_title'.tr,
        'review_error_desc'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
    }
  }

  /// 스토어 페이지 열기 (외부 호출용)
  Future<void> openStore() async {
    await _openStoreListing();
  }

  /// 테스트용: 모든 리뷰 상태 초기화
  void resetReviewStatus() {
    _storage.remove(_reviewRequestedKey);
    _storage.remove(_lastReviewRequestKey);
    _storage.remove(_playCountKey);
    debugPrint('⭐ [ReviewService] Review status reset');
  }
  
  /// 현재 재생 횟수 조회
  int get playCount => _storage.read<int>(_playCountKey) ?? 0;
}
