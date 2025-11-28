# PetBeats 비용 절감 & 기술 최적화 로드맵

## 🎯 핵심 목표
**월 고정 유지비 0원 달성**

배포 방식: **Standalone App** (모든 음원 앱 내장)

---

## 1️⃣ Audio Assets: 용량 최적화 전략

### 현황
- **총 곡 수**: 90곡 (6개 모드 × 모드당 15곡)
- **압축 전 예상 용량**: ~4GB (WAV 무압축 기준)

### ✅ 해결책: 포맷 최적화

#### 포맷 변환 가이드
```
Android: .ogg (Vorbis) - 용량 대비 음질 최강
iOS: .m4a (AAC) - Apple 최적화
비트레이트: 96kbps ~ 128kbps (VBR)
```

**예상 결과**:
- 곡당 용량: 2~3MB
- 총 용량: **200~300MB** (4GB → 93% 절감)

#### 루핑(Looping) 활용
```dart
// 예: 빗소리, Noise Masking 등 배경음
// 5분 전체 → 20초 루프로 변경 (1/10 크기)
AudioPlayer player = AudioPlayer();
player.setLoopMode(LoopMode.one);
player.setAsset('assets/audio/rain_loop_20s.ogg');
```

**적용 대상**:
- Noise Masking 트랙
- Weather 레이어 (빗소리, 천둥소리)
- 일부 Ambient 트랙

---

## 2️⃣ Weather API: 무료 쿼터 활용

### ✅ Apple WeatherKit 사용

**선택 이유**:
- ✅ 월 500,000회 **무료**
- ✅ 기상청 데이터 기반 (정확도 높음)
- ✅ 유료 유저 1~2만 명까지 평생 무료

### Smart Caching 로직
```dart
class WeatherService {
  static const cacheDuration = Duration(hours: 3);
  
  Future<WeatherData> getWeather(double lat, double lon) async {
    final storage = GetStorage();
    final cachedData = storage.read('weather_data');
    final cachedTime = storage.read('weather_timestamp');
    
    // 3시간 이내 캐시 사용
    if (cachedTime != null && 
        DateTime.now().difference(DateTime.parse(cachedTime)) < cacheDuration) {
      return WeatherData.fromJson(cachedData);
    }
    
    // API 호출
    final weatherData = await fetchFromWeatherKit(lat, lon);
    
    // 캐시 저장
    storage.write('weather_data', weatherData.toJson());
    storage.write('weather_timestamp', DateTime.now().toIso8601String());
    
    return weatherData;
  }
}
```

**효과**:
- 유저가 하루 종일 앱을 켜도 **API 호출 4~5회/일**
- 월 500,000회 무료 쿼터로 **100,000+ DAU** 지원 가능

---

## 3️⃣ Serverless Architecture: 서버 없는 앱

### 데이터베이스 (DB) 최소화

#### 앱 내부 데이터 (Local JSON)
```dart
// lib/app/data/tracks_data.dart
class TracksData {
  static final List<Track> allTracks = [
    Track(id: 's1', title: '스탠드 자장가', ...),
    Track(id: 's2', title: '따뜻한 오후', ...),
    // ... 90곡 정의
  ];
  
  static final Map<String, List<String>> playlists = {
    '산책 후': ['e7', 'e8', 'a7', 'a8', ...],
    '낮잠 시간': ['s1', 's2', 's3', ...],
    // ...
  };
}
```

#### 사용자 설정 (Local Storage)
```dart
// GetStorage 사용
final storage = GetStorage();

// 찜한 곡
storage.write('favorites', ['s1', 'a7', 'e3']);

// 알람 설정
storage.write('alarms', [
  {'time': '07:00', 'trackId': 's1'},
  {'time': '21:00', 'trackId': 's3'},
]);
```

### ✅ 구독 인증: RevenueCat 사용

**RevenueCat 장점**:
- ✅ 월 $1,000 매출까지 **무료**
- ✅ 별도 서버 개발 불필요
- ✅ iOS/Android 영수증 검증 자동화
- ✅ 구독 상태 관리 자동화

```dart
// pubspec.yaml
dependencies:
  purchases_flutter: ^6.0.0

// 구독 확인
final customerInfo = await Purchases.getCustomerInfo();
final isPremium = customerInfo.entitlements.active.containsKey('premium');
```

**비용 분석**:
- 월 매출 $0 ~ $1,000: **무료**
- 월 매출 $1,001 ~ $2,500: 1% 수수료
- 월 매출 $2,500+: 협상 가능

---

## 4️⃣ AI Sitter: On-Device 처리

### ✅ TensorFlow Lite 사용

**선택 이유**:
- ✅ 서버 비용 **0원**
- ✅ 개인정보 보호 (녹음 파일 외부 전송 없음)
- ✅ 오프라인 동작

### 구현 가이드
```yaml
# pubspec.yaml
dependencies:
  tflite_flutter: ^0.10.0
  tflite_flutter_helper: ^0.3.1
  microphone: ^0.3.0
```

```dart
import 'package:tflite_flutter/tflite_flutter.dart';

class BarkDetectionService {
  late Interpreter _interpreter;
  
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('models/bark_detection.tflite');
  }
  
  Future<bool> detectBark(Float32List audioBuffer) async {
    var output = List.filled(1, 0).reshape([1, 1]);
    _interpreter.run(audioBuffer, output);
    
    // 0.7 이상이면 짖음으로 판정
    return output[0][0] > 0.7;
  }
}
```

**마케팅 포인트**:
> "🔒 녹음된 소리는 어디에도 전송되지 않습니다.  
> 모든 분석은 사용자의 스마트폰에서만 처리됩니다."

---

## 📊 최종 비용 분석

| 항목 | 기존 방식 | 최적화 후 | 절감액 |
|------|----------|----------|--------|
| 오디오 스트리밍 | 월 $50~100 | $0 (내장) | $50~100 |
| Weather API | 월 $20~30 | $0 (무료 쿼터) | $20~30 |
| 백엔드 서버 | 월 $30~50 | $0 (Serverless) | $30~50 |
| AI 서버 | 월 $100~200 | $0 (On-Device) | $100~200 |
| 구독 인증 | 별도 개발 필요 | $0 (RevenueCat) | 개발비 절감 |
| **합계** | **월 $200~380** | **월 $0** | **월 $200~380** |

---

## 🚀 구현 우선순위

### Phase 1: 즉시 적용 가능
- [x] Local JSON 기반 트랙 데이터 (이미 구현됨)
- [x] GetStorage 기반 사용자 설정 (이미 구현됨)
- [ ] Weather API를 WeatherKit으로 전환

### Phase 2: 프로덕션 준비
- [ ] 오디오 파일 포맷 최적화 (.ogg / .m4a)
- [ ] 루핑 트랙 구현
- [ ] RevenueCat 통합 (구독 관리)

### Phase 3: 고급 기능
- [ ] TensorFlow Lite 모델 통합
- [ ] 짖음 감지 On-Device 처리
- [ ] 배터리 최적화

---

## 📱 예상 앱 스펙

| 항목 | 수치 |
|------|------|
| 앱 용량 (Android) | ~250MB |
| 앱 용량 (iOS) | ~280MB |
| 월 고정비 | **$0** |
| 월 매출 $1,000까지 추가 비용 | **$0** |
| 지원 가능 DAU (무료) | **100,000+** |

---

*최종 업데이트: 2025-11-28*
