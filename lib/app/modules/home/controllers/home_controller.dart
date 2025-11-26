import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/audio_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../onboarding/controllers/onboarding_controller.dart';
import '../../../data/models/mode_model.dart';
import '../../../data/models/track_model.dart';

class HomeController extends GetxController {
  final AudioService _audioService = Get.put(AudioService());
  final HapticService _hapticService = Get.put(HapticService());

  // 현재 선택된 종 (0: 강아지, 1: 고양이, 2: 보호자)
  final selectedSpeciesIndex = 0.obs;

  // 현재 재생 중인지 여부
  final isPlaying = false.obs;

  // 현재 선택된 모드
  final currentMode = Rx<Mode?>(null);
  
  // 자동 모드 여부
  final isAutoMode = false.obs;
  
  // 하트비트 싱크 활성화 여부
  final isHeartbeatSyncEnabled = true.obs;

  // 프리미엄 유저 여부
  final isPremiumUser = false.obs;

  // 사용자가 선택한 관심 항목 (Question에서 선택)
  final selectedNeeds = <String>[].obs;

  // 전체 모드 리스트
  final modes = <Mode>[].obs;

  // 탭 정보
  final speciesTabs = <SpeciesTab>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initModes();
    
    // OnboardingController에서 데이터 가져오기
    try {
      final onboardingController = Get.find<OnboardingController>();
      
      // 1. 관심 항목 가져오기
      selectedNeeds.value = List<String>.from(onboardingController.stressTriggers);
      
      // 2. 종 탭 구성하기
      final selectedSpecies = List<String>.from(onboardingController.species);
      _initSpeciesTabs(selectedSpecies);
      
      // 3. 초기 모드 설정 (관심 항목 기반 추천)
      if (selectedNeeds.isNotEmpty) {
        // 첫 번째 관심 항목에 해당하는 모드 찾기
        final recommendedMode = modes.firstWhere(
          (m) => m.id == selectedNeeds.first,
          orElse: () => modes.first,
        );
        changeMode(recommendedMode);
      } else {
        // changeMode(modes.first); // Default selection removed
      }
      
    } catch (e) {
      // OnboardingController를 찾지 못한 경우 기본값 설정
      print('OnboardingController not found: $e');
      _initSpeciesTabs(['dog']); // 기본값
      changeMode(modes.first);
    }
  }

  void _initModes() {
    modes.value = [
      Mode(
        id: 'sleep',
        title: '수면 유도',
        description: '편안한 수면을 위한 사운드',
        iconPath: 'assets/icons/icon_mode_sleep.png',
        color: const Color(0xFF5C6BC0), // Indigo
        scientificFacts: ['느린 템포는 심박수를 낮춥니다.', '반복적인 리듬은 수면을 유도합니다.'],
        tracks: [
          Track(id: 's1', title: '스탠다드 자장가', target: '공용', isPremium: false, description: '가장 표준적인 피아노', duration: '3:00'),
          Track(id: 's2', title: '따뜻한 오후', target: '공용', isPremium: false, description: '먹먹하고 부드러운 소리', duration: '3:15'),
          Track(id: 's3', title: '깊은 밤의 꿈', target: '대형', isPremium: true, description: '깊은 울림 (고급형)', duration: '3:30'),
          Track(id: 's4', title: '엄마의 요람', target: '대형', isPremium: true, description: '3박자 왈츠 (차별화)', duration: '3:10'),
          Track(id: 's5', title: '깊은 울림', target: '중형', isPremium: true, description: '중형견용 표준', duration: '3:20'),
          Track(id: 's6', title: '포근한 왈츠', target: '중형', isPremium: true, description: '중형견용 왈츠', duration: '3:05'),
          Track(id: 's7', title: '맑은 아침', target: '소형', isPremium: true, description: '소형견용 맑은 소리', duration: '2:55'),
          Track(id: 's8', title: '사뿐한 왈츠', target: '소형', isPremium: true, description: '오르골 느낌 추가', duration: '3:00'),
        ],
      ),
      Mode(
        id: 'anxiety',
        title: '분리불안',
        description: '불안감 해소',
        iconPath: 'assets/icons/icon_mode_separation.png',
        color: const Color(0xFF26A69A), // Teal
        scientificFacts: ['백색 소음은 외부 자극을 차단합니다.', '부드러운 멜로디는 정서적 안정을 돕습니다.'],
        tracks: [
          Track(id: 'a7', title: '평온한 오후', target: '공용', isPremium: false, description: '기타(Guitar)의 따뜻한 울림', duration: '3:10'),
          Track(id: 'a8', title: '숲속의 쉼터', target: '공용', isPremium: false, description: '관악기의 부드러운 호흡', duration: '3:25'),
          Track(id: 'a1', title: '묵직한 위로', target: '대형', isPremium: true, description: '첼로의 묵직한 저음', duration: '3:40'),
          Track(id: 'a2', title: '따뜻한 공명', target: '대형', isPremium: true, description: '공간을 채워주는 소리', duration: '3:30'),
          Track(id: 'a3', title: '균형 잡힌 안정', target: '중형', isPremium: true, description: '너무 무겁지 않은 현악기', duration: '3:15'),
          Track(id: 'a4', title: '포근한 공기', target: '중형', isPremium: true, description: '부드러운 공기 질감', duration: '3:20'),
          Track(id: 'a5', title: '산뜻한 안정', target: '소형', isPremium: true, description: '하프(Harp)의 맑은 소리', duration: '3:00'),
          Track(id: 'a6', title: '밝은 공기', target: '소형', isPremium: true, description: '밝고 가벼운 앰비언트', duration: '3:05'),
        ],
      ),
      Mode(
        id: 'noise',
        title: '소음 민감',
        description: '외부 소음 차단',
        iconPath: 'assets/icons/icon_mode_noise.png',
        color: const Color(0xFF7E57C2), // Deep Purple
        scientificFacts: ['일정한 소음은 갑작스러운 소리를 덮어줍니다.', '청각적 과부하를 줄여줍니다.'],
        tracks: [
          Track(id: 'n7', title: '우주 여행', target: '공용', isPremium: false, description: '신비롭고 넓은 공간감', duration: '4:00'),
          Track(id: 'n8', title: '깊은 바다', target: '공용', isPremium: false, description: '물속에 있는 듯한 차단력', duration: '4:10'),
          Track(id: 'n1', title: '부드러운 장막', target: '대형', isPremium: true, description: '빗소리 믹스', duration: '3:50'),
          Track(id: 'n2', title: '깊은 방패', target: '대형', isPremium: true, description: '저음 방어막 (천둥 대비)', duration: '4:00'),
          Track(id: 'n3', title: '일상의 평온', target: '중형', isPremium: true, description: '시냇물 소리 믹스', duration: '3:45'),
          Track(id: 'n4', title: '든든한 방음벽', target: '중형', isPremium: true, description: '꽉 찬 중저음', duration: '3:55'),
          Track(id: 'n5', title: '산뜻한 보호막', target: '소형', isPremium: true, description: '새소리/바람소리 믹스', duration: '3:30'),
          Track(id: 'n6', title: '포근한 담요', target: '소형', isPremium: true, description: '답답하지 않은 포근함', duration: '3:40'),
        ],
      ),
      Mode(
        id: 'energy',
        title: '에너지 조절',
        description: '활력 증진',
        iconPath: 'assets/icons/icon_mode_energy.png',
        color: const Color(0xFFFFA726), // Orange
        scientificFacts: ['빠른 템포는 활동성을 높입니다.', '다양한 주파수는 호기심을 자극합니다.'],
        tracks: [
          Track(id: 'e7', title: '피크닉', target: '공용', isPremium: false, description: '어쿠스틱 기타의 경쾌함', duration: '2:50'),
          Track(id: 'e8', title: '댄스 타임', target: '공용', isPremium: false, description: '엉덩이가 들썩이는 리듬', duration: '3:00'),
          Track(id: 'e1', title: '리드미컬 산책', target: '대형', isPremium: true, description: '재즈풍의 둥둥거리는 베이스', duration: '3:10'),
          Track(id: 'e2', title: '활기찬 터그', target: '대형', isPremium: true, description: '신나는 록 비트', duration: '2:45'),
          Track(id: 'e3', title: '경쾌한 총총', target: '중형', isPremium: true, description: '밝은 팝 스타일', duration: '3:00'),
          Track(id: 'e4', title: '신나는 술래', target: '중형', isPremium: true, description: '통통 튀는 전자음', duration: '2:55'),
          Track(id: 'e5', title: '사뿐한 총총', target: '소형', isPremium: true, description: '우쿨렐레의 귀여운 소리', duration: '2:50'),
          Track(id: 'e6', title: '신나는 우다다', target: '소형', isPremium: true, description: '실로폰 같은 맑은 타격감', duration: '2:40'),
        ],
      ),
      Mode(
        id: 'senior',
        title: '시니어 펫 케어',
        description: '노령 반려동물 케어',
        iconPath: 'assets/icons/icon_mode_senior.png',
        color: const Color(0xFF8D6E63), // Brown
        scientificFacts: ['낮은 주파수는 관절 통증 완화에 도움을 줄 수 있습니다.', '안정적인 리듬은 인지 기능을 돕습니다.'],
        tracks: [
          Track(id: 'sn7', title: '영혼의 안식', target: '공용', isPremium: false, description: '사람 목소리(허밍) 느낌', duration: '4:00'),
          Track(id: 'sn8', title: '자연의 품', target: '공용', isPremium: false, description: '자연 치유 느낌', duration: '4:15'),
          Track(id: 'sn1', title: '치유의 주파수', target: '대형', isPremium: true, description: '싱잉볼의 웅웅거리는 진동', duration: '4:30'),
          Track(id: 'sn2', title: '깊은 안정', target: '대형', isPremium: true, description: '아주 느린 현악기', duration: '4:20'),
          Track(id: 'sn3', title: '부드러운 공명', target: '중형', isPremium: true, description: '끊기지 않는 따뜻한 소리', duration: '4:10'),
          Track(id: 'sn4', title: '편안한 휴식', target: '중형', isPremium: true, description: '아주 느린 피아노', duration: '4:00'),
          Track(id: 'sn5', title: '포근한 온기', target: '소형', isPremium: true, description: '무겁지 않은 온열감', duration: '3:50'),
          Track(id: 'sn6', title: '산뜻한 평온', target: '소형', isPremium: true, description: '느리고 맑은 하프', duration: '3:45'),
        ],
      ),
    ];
  }

  void _initSpeciesTabs(List<String> selected) {
    final allTabs = [
      SpeciesTab(id: 'dog', label: '강아지', iconPath: 'assets/icons/icon_species_dog.png'),
      SpeciesTab(id: 'cat', label: '고양이', iconPath: 'assets/icons/icon_species_cat.png'),
      SpeciesTab(id: 'owner', label: '보호자', iconPath: 'assets/icons/icon_species_owner.png'),
    ];

    final tabs = <SpeciesTab>[];

    if (selected.length >= 3) {
      tabs.addAll(allTabs);
    } else if (selected.length == 2) {
      for (var id in selected) {
        final tab = allTabs.firstWhere((t) => t.id == id, orElse: () => SpeciesTab(id: '', label: '', iconPath: ''));
        if (tab.id.isNotEmpty) tabs.add(tab);
      }
      for (var tab in allTabs) {
        if (!selected.contains(tab.id)) {
          tabs.add(tab);
        }
      }
    } else {
      if (selected.isNotEmpty) {
        final tab = allTabs.firstWhere((t) => t.id == selected.first, orElse: () => SpeciesTab(id: '', label: '', iconPath: ''));
        if (tab.id.isNotEmpty) tabs.add(tab);
      } else {
        tabs.add(allTabs[0]);
      }
      for (var tab in allTabs) {
        if (!tabs.any((t) => t.id == tab.id)) {
          tabs.add(tab);
        }
      }
    }
    
    speciesTabs.value = tabs;
  }

  // 테스트용 오디오 URL
  final String _testAudioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

  // 종 변경
  void changeSpecies(int index) {
    selectedSpeciesIndex.value = index;
    _hapticService.selectionClick();
  }

  // 프리미엄 업그레이드
  void upgradeToPremium() {
    isPremiumUser.value = true;
  }

  void stopSound() {
    isPlaying.value = false;
    _audioService.pause();
    _hapticService.stop();
  }

  void playSound(String modeId) {
    isPlaying.value = true;
    _audioService.play(_testAudioUrl);
    if (isHeartbeatSyncEnabled.value) {
      _hapticService.startHeartbeat(60);
    }
  }

  // 모드 변경
  void changeMode(Mode mode) {
    currentMode.value = mode;
    isAutoMode.value = false;
    // 모드 변경 시 자동 재생은 하지 않음 (사용자가 재생 버튼을 눌러야 함)
    // 하지만 상세 화면으로 이동하므로 거기서 재생할 수도 있음
  }
  
  // 상황별 추천
  void recommendScenario(String scenario) {
    print('Recommended scenario: $scenario');
    // 시나리오에 맞는 모드 추천 로직 (임시)
    if (scenario.contains('산책')) {
      changeMode(modes.firstWhere((m) => m.id == 'energy'));
    } else if (scenario.contains('낮잠') || scenario.contains('병원')) {
      changeMode(modes.firstWhere((m) => m.id == 'sleep'));
    } else {
      changeMode(modes.firstWhere((m) => m.id == 'anxiety'));
    }
    // 상세 화면으로 이동
    Get.toNamed('/mode_detail', arguments: currentMode.value);
  }

  // 재생 토글
  void togglePlay() {
    isPlaying.value = !isPlaying.value;

    if (isPlaying.value) {
      _audioService.play(_testAudioUrl);
      if (isHeartbeatSyncEnabled.value) {
        _hapticService.startHeartbeat(60);
      }
    } else {
      _audioService.pause();
      _hapticService.stop();
    }
  }
  
  // 하트비트 싱크 토글
  void toggleHeartbeatSync(bool value) {
    isHeartbeatSyncEnabled.value = value;
    if (isPlaying.value) {
      if (value) {
        _hapticService.startHeartbeat(60);
      } else {
        _hapticService.stop();
      }
    }
  }
}

class SpeciesTab {
  final String id;
  final String label;
  final String iconPath;
  
  SpeciesTab({required this.id, required this.label, required this.iconPath});
}
