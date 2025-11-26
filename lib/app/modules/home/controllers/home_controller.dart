import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/audio_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../onboarding/controllers/onboarding_controller.dart';

class HomeController extends GetxController {
  final AudioService _audioService = Get.put(AudioService());
  final HapticService _hapticService = Get.put(HapticService());

  // 현재 선택된 종 (0: 강아지, 1: 고양이, 2: 보호자)
  final selectedSpeciesIndex = 0.obs;

  // 현재 재생 중인지 여부
  final isPlaying = false.obs;

  // 현재 선택된 모드 이름
  final currentModeName = ''.obs;
  
  // 하트비트 싱크 활성화 여부
  final isHeartbeatSyncEnabled = true.obs;

  // 프리미엄 유저 여부
  final isPremiumUser = false.obs;

  // 사용자가 선택한 관심 항목 (Question에서 선택)
  final selectedNeeds = <String>[].obs;

  // 전체 모드 리스트 (5가지)
  final allModes = [
    {'id': 'sleep', 'name': '수면 유도', 'icon': 'bedtime'},
    {'id': 'anxiety', 'name': '분리불안', 'icon': 'anxiety'},
    {'id': 'noise', 'name': '소음 민감', 'icon': 'noise'},
    {'id': 'energy', 'name': '에너지 조절', 'icon': 'energy'},
    {'id': 'senior', 'name': '시니어 펫 케어', 'icon': 'senior'},
  ];

  // 소팅된 모드 리스트 (computed)
  List<Map<String, String>> get sortedModes {
    if (selectedNeeds.isEmpty) {
      return allModes; // 선택 항목 없으면 기본 순서
    }

    // 선택한 항목을 우선순위로 정렬
    final priorityModes = <Map<String, String>>[];
    final otherModes = <Map<String, String>>[];

    for (final mode in allModes) {
      if (selectedNeeds.contains(mode['id'])) {
        priorityModes.add(mode);
      } else {
        otherModes.add(mode);
      }
    }

    // 선택한 순서대로 정렬
    priorityModes.sort((a, b) {
      final indexA = selectedNeeds.indexOf(a['id']!);
      final indexB = selectedNeeds.indexOf(b['id']!);
      return indexA.compareTo(indexB);
    });

    return [...priorityModes, ...otherModes];
  }

  // 탭 정보
  final speciesTabs = <SpeciesTab>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // OnboardingController에서 데이터 가져오기
    try {
      final onboardingController = Get.find<OnboardingController>();
      
      // 1. 관심 항목 가져오기
      selectedNeeds.value = List<String>.from(onboardingController.stressTriggers);
      
      // 2. 종 탭 구성하기
      final selectedSpecies = List<String>.from(onboardingController.species);
      _initSpeciesTabs(selectedSpecies);
      
    } catch (e) {
      // OnboardingController를 찾지 못한 경우 기본값 설정
      print('OnboardingController not found: $e');
      _initSpeciesTabs(['dog']); // 기본값
    }
  }

  void _initSpeciesTabs(List<String> selected) {
    final allTabs = [
      SpeciesTab(id: 'dog', label: '강아지', icon: Icons.pets),
      SpeciesTab(id: 'cat', label: '고양이', icon: Icons.cruelty_free),
      SpeciesTab(id: 'owner', label: '보호자', icon: Icons.person),
    ];

    final tabs = <SpeciesTab>[];

    if (selected.length >= 3) {
      // 3개 이상 선택 시 기본 순서 (강아지, 고양이, 보호자)
      tabs.addAll(allTabs);
    } else if (selected.length == 2) {
      // 2개 선택 시: 선택1, 선택2, 나머지
      for (var id in selected) {
        final tab = allTabs.firstWhere((t) => t.id == id, orElse: () => SpeciesTab(id: '', label: '', icon: Icons.error));
        if (tab.id.isNotEmpty) tabs.add(tab);
      }
      // 나머지 추가
      for (var tab in allTabs) {
        if (!selected.contains(tab.id)) {
          tabs.add(tab);
        }
      }
    } else {
      // 1개(또는 0개) 선택 시: 선택1, 나머지(강아지 우선)
      if (selected.isNotEmpty) {
        final tab = allTabs.firstWhere((t) => t.id == selected.first, orElse: () => SpeciesTab(id: '', label: '', icon: Icons.error));
        if (tab.id.isNotEmpty) tabs.add(tab);
      } else {
        tabs.add(allTabs[0]); // 기본 강아지
      }
      
      // 나머지 추가 (기본 순서대로 순회하면 자연스럽게 강아지>고양이>보호자 순서 적용됨)
      for (var tab in allTabs) {
        if (!tabs.any((t) => t.id == tab.id)) {
          tabs.add(tab);
        }
      }
    }
    
    speciesTabs.value = tabs;
  }

  // 테스트용 오디오 URL (저작권 없는 무료 음원)
  final String _testAudioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

  // 종 변경
  void changeSpecies(int index) {
    selectedSpeciesIndex.value = index;
  }

  // 프리미엄 업그레이드
  void upgradeToPremium() {
    isPremiumUser.value = true;
  }

  // 모드 선택 및 상세 화면 이동
  void selectMode(String modeName) {
    currentModeName.value = modeName;
    Get.toNamed('/mode_detail', arguments: {'modeName': modeName});
  }

  // 재생 토글
  void togglePlay() {
    isPlaying.value = !isPlaying.value;

    if (isPlaying.value) {
      // 재생 시작
      _audioService.play(_testAudioUrl);
      
      if (isHeartbeatSyncEnabled.value) {
        // 60 BPM 심박수 진동 시작
        _hapticService.startHeartbeat(60);
      }
    } else {
      // 일시정지
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
  final IconData icon;
  
  SpeciesTab({required this.id, required this.label, required this.icon});
}
