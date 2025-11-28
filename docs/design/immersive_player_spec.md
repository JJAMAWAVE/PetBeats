# PetBeats Immersive Player (상세 기획)

## 1. 기획 의도
- **몰입감(Immersion)**: 시각적 파형(Visualizer)과 진동(Haptic)을 통해 "치료받고 있다"는 느낌 극대화
- **제어권(Control)**: 햅틱 세기, 스마트 싱크(날씨/환경음) 등 고급 기능을 플레이어 내에서 즉시 조절
- **신뢰(Info)**: 곡의 과학적 원리(BPM, 주파수 등)를 명시하여 신뢰도 향상

## 2. UI 레이아웃 구성 (Top-Down)

### 🟢 Zone A. 헤더 (Context)
- **좌측**: ⌄ (플레이어 내리기/최소화)
- **중앙**: 현재 모드 (예: 🌙 Deep Sleep) - 컨텍스트 유지
- **우측**: ⋮ (더보기: 수면 타이머, 즐겨찾기)

### 🔵 Zone B. 비주얼 & 트랙 정보 (Visual & Info)
- **Bio-Pulse (비주얼라이저)**:
  - 앨범 아트 대신 심장 박동을 형상화한 '원형 파동' 애니메이션
  - 햅틱 진동 시 시각적 파동(Ripple) 동기화 (청각+촉각+시각 일치)
- **트랙 정보**:
  - **Title (H1)**: 곡 제목 (예: 깊은 밤의 꿈)
  - **Scientific Subtitle (H2)**: 과학적 근거 요약 (예: "60 BPM • Piano for Heartbeat Sync", "50 Hz • Purring Frequency")

### 🟣 Zone C. 테라피 컨트롤 패널 (Killer Feature)
- **1. 햅틱 제어 (Haptic Intensity)**
  - UI: 📳 아이콘 + 3단계 토글 (OFF / 약 / 강)
  - 로직: CSV 데이터(📳)가 있는 곡만 활성화, 없는 곡(🔇)은 비활성화
- **2. 스마트 레이어 (Smart Layer)**
  - UI: 🌧️ 날씨 / 🎙️ 시터 아이콘 뱃지
  - 기능: 날씨/시터 모듈 작동 시 뱃지 노출, 클릭 시 해당 레이어(빗소리 등) ON/OFF 제어

### 🟠 Zone D. 재생 컨트롤 (Playback)
- **Progress**: 재생 바 (남은 시간)
- **Main**: ⏮ (이전), ⏯ (재생/일시정지), ⏭ (다음)
- **Sub**: 🔀 (셔플), 🔁 (반복)

---

## 3. 기능 명세 (Spec)

### 데이터 연동 로직
| 구분 | UI 요소 | 데이터 소스 | 작동 로직 |
|---|---|---|---|
| **정보** | 과학적 근거 | CSV '과학적 근거' 컬럼 | 곡 변경 시 해당 특징 텍스트 노출 |
| **제어** | Haptic Toggle | CSV '햅틱' 컬럼 (📳/🔇) | 📳: 활성화(기본 ON), 🔇: 비활성화(Dimmed) |
| **제어** | Smart Sync Badge | 스마트 싱크 모듈 상태 | 기능 작동 중일 때만 노출, 클릭 시 레이어 토글 |
| **비주얼** | Pulse Animation | BPM 데이터 (Tempo) | 60 BPM = 1초 1회 두근거림 (속도 동기화) |

### 햅틱 패턴 디자인 (Vibration Patterns)
- **❤️ 패턴 A: The Heartbeat (심박동)**
  - 적용: Deep Sleep, Calm Shelter
  - 로직: BPM 기반 Lub(약, 100ms) - Rest(100ms) - Dub(강, 200ms) - Wait
- **🐱 패턴 B: The Purr (골골송)**
  - 적용: Senior Care, Cat Mode
  - 로직: 끊기지 않는 저강도 진동 + 3초 주기 Waveform 강도 변화

### 제어 옵션
- **강도 조절**: OFF / Soft(약, 소형견용) / Deep(강, 대형견용)
- **Soft Start**: 진동 시작 시 5초간 Fade-in (놀람 방지)

---

## 4. 시각화 (Visual System)

### Visual Layer 1: The "Bio-Pulse"
- **형태**: 유기적으로 일렁이는 구체(Sphere) + Bloom 효과
- **BPM 동기화**:
  - 60 BPM: "두근(Double beat)" 심박동 패턴
  - 그 외: 부드러운 "호흡(Sine wave)" 패턴
- **햅틱 시각화**: 진동 발생 시 강렬한 빛의 파동(Ripple) 확산

### Visual Layer 2: Atmosphere Particles
- **Deep Sleep/Calm**: Deep Blue ~ Purple, 느리게 부유하는 먼지 입자
- **Happy Play**: Orange ~ Yellow, 상승하는 탄산 기포 입자
- **Weather Sync**: 'Rain' 상태 시 사선으로 내리는 빗줄기 파티클 추가

### Visual Layer 3: Text Transition
- 곡 변경 시 텍스트 Dissolve / Fade In + Bloom 효과로 고급스러운 전환
