import 'package:get/get.dart';
import 'ko_kr.dart';
import 'en_us.dart';

/// GetX 번역 시스템
/// 한국어/영어 기본 지원
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ko_KR': koKR,
    'en_US': enUS,
  };
}
