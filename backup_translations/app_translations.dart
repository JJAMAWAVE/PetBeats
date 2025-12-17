import 'package:get/get.dart';
import 'ko_kr.dart';
import 'en_us.dart';
import 'ja_jp.dart';
import 'zh_cn.dart';
import 'zh_tw.dart';
import 'es_es.dart';
import 'fr_fr.dart';
import 'de_de.dart';
import 'pt_br.dart';
import 'it_it.dart';

/// GetX 번역 시스템
/// 10개 언어 지원 (ARPU 높은 시장 기준)
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ko_KR': koKR,
    'en_US': enUS,
    'ja_JP': jaJP,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
    'es_ES': esES,
    'fr_FR': frFR,
    'de_DE': deDE,
    'pt_BR': ptBR,
    'it_IT': itIT,
  };
}
