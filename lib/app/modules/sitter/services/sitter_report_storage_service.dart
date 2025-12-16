import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// AI 시터 리포트 Firestore 저장 서비스
class SitterReportStorageService extends GetxService {
  static SitterReportStorageService get to => Get.find<SitterReportStorageService>();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // 컬렉션 이름
  static const String _collectionName = 'sitter_reports';
  
  /// 리포트 저장
  Future<String?> saveReport({
    required String userId,
    required Duration elapsedTime,
    required int soundCount,
    required int motionCount,
    required int careCount,
    List<Map<String, dynamic>>? events,
  }) async {
    try {
      final docRef = await _firestore.collection(_collectionName).add({
        'userId': userId,
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
      
      debugPrint('[SitterReportStorage] Report saved: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('[SitterReportStorage] Error saving report: $e');
      return null;
    }
  }
  
  /// 사용자의 리포트 목록 가져오기
  Future<List<Map<String, dynamic>>> getReports(String userId) async {
    try {
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
  /// Cloud Functions에서 자동 실행하는 것이 권장됨
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
