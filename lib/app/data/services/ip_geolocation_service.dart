import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

/// IP-Based Geolocation Service (No permission required)
/// Uses ipapi.co for free IP geolocation
class IpGeolocationService extends GetxService {
  static const String _baseUrl = 'https://ipapi.co/json/';
  
  final RxString city = 'Seoul'.obs;
  final RxDouble latitude = 37.5665.obs;
  final RxDouble longitude = 126.9780.obs;
  final RxBool isLoading = false.obs;
  
  /// Korean city name mapping
  static const Map<String, String> _cityKoreanMap = {
    'Seoul': '서울',
    'Busan': '부산',
    'Incheon': '인천',
    'Daegu': '대구',
    'Daejeon': '대전',
    'Gwangju': '광주',
    'Ulsan': '울산',
    'Suwon': '수원',
    'Seongnam': '성남',
    'Goyang': '고양',
    'Yongin': '용인',
    'Bucheon': '부천',
    'Ansan': '안산',
    'Cheongju': '청주',
    'Jeonju': '전주',
    'Anyang': '안양',
    'Pohang': '포항',
    'Changwon': '창원',
    'Gimhae': '김해',
    'Jeju': '제주',
    'Cheonan': '천안',
    'Gwangmyeong': '광명',
    'Pyeongtaek': '평택',
    'Uijeongbu': '의정부',
    'Siheung': '시흥',
    'Gimpo': '김포',
    'Paju': '파주',
    'Icheon': '이천',
    'Yangsan': '양산',
    'Hwaseong': '화성',
  };
  
  /// Fetch user location by IP address
  /// No permissions required - works on web and mobile
  Future<void> fetchLocationByIp() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Get English city name from API
        final englishCity = data['city'] ?? 'Unknown';
        
        // Convert to Korean if mapping exists, otherwise use English
        city.value = _cityKoreanMap[englishCity] ?? englishCity;
        latitude.value = data['latitude'] ?? 37.5665;
        longitude.value = data['longitude'] ?? 126.9780;
        
        debugPrint('📍 Location detected: ${city.value} ($latitude, $longitude)');
      } else {
        debugPrint('IP Geolocation API Error: ${response.statusCode}');
        _setDefaultLocation();
      }
    } catch (e) {
      debugPrint('IP Geolocation failed: $e');
      _setDefaultLocation();
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Fallback to default location (Seoul)
  void _setDefaultLocation() {
    city.value = '서울';  // Korean
    latitude.value = 37.5665;
    longitude.value = 126.9780;
    debugPrint('📍 Using default location: 서울');
  }
}
