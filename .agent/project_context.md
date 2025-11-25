# Project Context: PetBeats

## 프로젝트 개요
**PetBeats**는 반려동물(강아지, 고양이)과 보호자를 위한 오디오 테라피 및 심박수 동기화(Heart-Sync) 앱입니다.
다양한 모드(수면, 진정, 놀이, 둔감화)를 통해 반려동물의 심리적 안정을 돕습니다.

## 기술 스택
- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Audio**: `just_audio`
- **Haptic**: `vibration`
- **Platform**: Android, iOS, Web (현재 Web 디버깅 중)

## 주요 기능
1.  **모드 선택**: 수면, 진정, 놀이, 둔감화 교육 등 상황별 모드 제공
2.  **Heart-Sync**: 오디오 리듬에 맞춘 햅틱 피드백 (진동) 제공
3.  **종 선택**: 강아지, 고양이, 보호자별 맞춤형 추천
4.  **프리미엄**: 고급 기능 및 추가 콘텐츠 제공 (구독 모델)

## 현재 상태 (2025-11-25)
- 기본 UI (Welcome, Home) 구현 완료
- Flutter 웹 서버 실행 성공 (`flutter run -d web-server`)
- 초기 컴파일 에러(괄호 누락, 경로 오류) 수정 완료
- **이슈**: 웹 브라우저에서 앱 실행 시 화면이 비어보이는 현상 발생하여 디버깅 중.

## 개발 규칙
- 모든 커밋 메시지 및 문서는 **한글**로 작성 (`rules.md` 참조)
- `.agent` 폴더 내의 파일들을 통해 컨텍스트 유지
