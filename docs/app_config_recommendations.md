# PetBeats 최신 앱 구성 권장사항

## 📅 작성일: 2025-12-08

---

## ✅ 현재 적용된 구성

### 1. Android App Bundle (AAB) 설정
- **파일**: `android/app/build.gradle`
- **기능**:
  - ABI 분리 (arm64-v8a, armeabi-v7a, x86_64)
  - 화면 밀도 분리 (hdpi, xhdpi, xxhdpi 등)
  - 언어 분리

```groovy
bundle {
    language { enableSplit = true }
    density { enableSplit = true }
    abi { enableSplit = true }
}
```

### 2. 빌드 결과
| 타입 | 용량 | 용도 |
|------|------|------|
| APK Debug | 511 MB | 개발 테스트 |
| APK Release | 354 MB | 직접 배포 |
| AAB Release | 322.5 MB | Play Store |

---

## 📋 추후 작업 목록

### 🔴 우선순위: 높음

#### 1. Play Asset Delivery (PAD) 구현
- **목적**: 대용량 오디오 파일 온디맨드 다운로드
- **효과**: 초기 설치 용량 ~50MB로 감소
- **비용**: 무료 (Play Store 기본 제공)
- **구현 방법**:
  ```
  assets/
  ├── install-time/  (설치 시 포함 - 필수 리소스)
  ├── fast-follow/   (설치 직후 자동 다운로드)
  └── on-demand/     (사용자 요청 시 다운로드 - 추가 모드)
  ```

#### 2. 서명 키 설정 (Release Signing)
- **파일**: `android/key.properties` (Git 제외)
- **내용**:
  ```properties
  storePassword=<비밀번호>
  keyPassword=<비밀번호>
  keyAlias=petbeats
  storeFile=<경로>/petbeats-release.keystore
  ```

### 🟡 우선순위: 중간

#### 3. ProGuard/R8 최적화
- **효과**: 코드 용량 10-20% 감소, 난독화
- **주의**: Firebase, JustAudio 등 keep 규칙 필요
- **파일**: `android/app/proguard-rules.pro`

#### 4. 버전 자동 관리
- **파일**: `pubspec.yaml`
- **방법**: CI/CD에서 versionCode 자동 증가

### 🟢 우선순위: 낮음

#### 5. Flavor 설정 (개발/스테이징/프로덕션)
- 환경별 API 엔드포인트 분리
- 앱 아이콘/이름 분리

#### 6. Crashlytics 설정
- 앱 크래시 모니터링
- Firebase Console에서 실시간 확인

---

## 💰 비용 정보

### Play Asset Delivery
| 항목 | 비용 |
|------|------|
| 기능 사용 | **무료** |
| 다운로드 대역폭 | **무료** (Google 부담) |
| 저장 공간 | AAB 크기 제한 내 무료 (150MB 기본, 확장 가능) |

### Play Console
| 항목 | 비용 |
|------|------|
| 개발자 등록비 | $25 (1회) |
| 앱 호스팅/배포 | **무료** |
| 업데이트 배포 | **무료** |

### 참고: 클라우드 스토리지 대안 비용 (비교용)
| 서비스 | 월 비용 (100GB 기준) |
|--------|---------------------|
| Firebase Storage | ~$2.6/월 |
| AWS S3 | ~$2.3/월 |
| Google Cloud Storage | ~$2.0/월 |

**결론**: Play Asset Delivery는 Play Store 기본 기능이므로 **추가 비용 없이** 사용 가능!

---

## 📚 참고 문서

- [Play Asset Delivery 공식 문서](https://developer.android.com/guide/playcore/asset-delivery)
- [Android App Bundle 가이드](https://developer.android.com/guide/app-bundle)
- [Flutter AAB 빌드](https://docs.flutter.dev/deployment/android)
