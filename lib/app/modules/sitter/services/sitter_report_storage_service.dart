import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';
import '../../../../app/data/services/auth_service.dart';

/// AI 시터 리포트 Firestore 저장 서비스
/// - 로그인 상태: Google 계정 UID 사용
/// - 비로그인 상태: Device ID 사용
class SitterReportStorageService extends GetxService {
  static SitterReportStorageService get to => Get.find<SitterReportStorageService>();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  
  // 컬렉션 이름
  static const String _collectionName = 'sitter_reports';
  static const String _deviceIdKey = 'device_id';
  
  /// 고유 사용자 ID 반환 (Google UID 또는 Device ID)
  String getUserId() {
    // 1. Google 로그인 상태 확인
    try {
      final authService = Get.find<AuthService>();
      final user = authService.currentUser.value;
      if (user != null) {
        return 'google_${user.uid}';
      }
    } catch (e) {
      debugPrint('[SitterReportStorage] AuthService not available: $e');
    }
    
    // 2. Device ID 사용 (없으면 생성)
    String? deviceId = _storage.read<String>(_deviceIdKey);
    if (deviceId == null) {
      deviceId = _generateDeviceId();
      _storage.write(_deviceIdKey, deviceId);
    }
    return 'device_$deviceId';
  }
  
  /// Device ID 생성 (랜덤 문자열)
  String _generateDeviceId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(16, (_) => chars[random.nextInt(chars.length)]).join();
  }
  
  /// 사용자가 Google 계정에 연동되어 있는지 확인
  bool get isLinkedToGoogle {
    try {
      final authService = Get.find<AuthService>();
      return authService.currentUser.value != null;
    } catch (e) {
      return false;
    }
  }
  
  /// 리포트 저장 (자동으로 적절한 ID 사용)
  Future<String?> saveReport({
    required Duration elapsedTime,
    required int soundCount,
    required int motionCount,
    required int careCount,
    List<Map<String, dynamic>>? events,
  }) async {
    try {
      final userId = getUserId();
      
      final docRef = await _firestore.collection(_collectionName).add({
        'userId': userId,
        'isGoogleLinked': isLinkedToGoogle,
        'elapsedTimeSeconds': elapsedTime.inSeconds,
        'soundCount': soundCount,
        'motionCount': motionCount,
        'careCount': careCount,
        'events': events ?? [],
        'createdAt': FieldValue.serverTimestamp(),
        // 30일 후 삭제를 위한 만료 시간
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
      });
      
      debugPrint('[SitterReportStorage] Report saved: ${docRef.id} (userId: $userId)');
      return docRef.id;
    } catch (e) {
      debugPrint('[SitterReportStorage] Error saving report: $e');
      return null;
    }
  }
  
  /// 사용자의 리포트 목록 가져오기
  Future<List<Map<String, dynamic>>> getReports() async {
    try {
      final userId = getUserId();
      
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(30)
          .get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('[SitterReportStorage] Error fetching reports: $e');
      return [];
    }
  }
  
  /// 리포트 삭제
  Future<bool> deleteReport(String reportId) async {
    try {
      await _firestore.collection(_collectionName).doc(reportId).delete();
      debugPrint('[SitterReportStorage] Report deleted: $reportId');
      return true;
    } catch (e) {
      debugPrint('[SitterReportStorage] Error deleting report: $e');
      return false;
    }
  }
  
  /// 만료된 리포트 정리 (30일 이상)
  Future<int> cleanupExpiredReports() async {
    try {
      final now = Timestamp.now();
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('expiresAt', isLessThan: now)
          .get();
      
      int deletedCount = 0;
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
        deletedCount++;
      }
      
      debugPrint('[SitterReportStorage] Cleaned up $deletedCount expired reports');
      return deletedCount;
    } catch (e) {
      debugPrint('[SitterReportStorage] Error cleaning up reports: $e');
      return 0;
    }
  }
}
