import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../data/services/audio_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../../core/services/bgm_service.dart';
import '../../../../core/services/web_bgm_service.dart';
import '../../onboarding/controllers/onboarding_controller.dart';
import '../../premium/controllers/subscription_controller.dart';
import '../../../data/models/mode_model.dart';
import '../../../data/models/track_model.dart';
import '../../../data/data_source/track_data.dart';

class HomeController extends GetxController {
  final AudioService _audioService = Get.put(AudioService());
  final HapticService _hapticService = Get.put(HapticService());
  // Use WebBgmService on web, BgmService otherwise
  late final dynamic _bgmService = kIsWeb ? Get.find<WebBgmService>() : BgmService();

  // 현재 선택된 종 (0: 강아지, 1: 고양이, 2: 보호자)
  final selectedSpeciesIndex = 0.obs;

  // 현재 재생 중인지 여부
  final isPlaying = false.obs;

  // 현재 선택된 모드
  final currentMode = Rx<Mode?>(null);

  // 현재 재생 중인 트랙
  final currentTrack = Rx<Track?>(null);
  
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

  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _initModes();
    _initScenarioPlaylists(); // 시나리오별 플레이리스트 초기화
    
    // OnboardingController에서 데이터 가져오기
    try {
      final onboardingController = Get.find<OnboardingController>();
      
      // 1. 관심 항목 가져오기
      selectedNeeds.value = List<String>.from(onboardingController.stressTriggers);
      
      // 2. 종 탭 구성하기
      final selectedSpecies = List<String>.from(onboardingController.species);
      _initSpeciesTabs(selectedSpecies);
      
      // 3. 초기 모드 설정: 저장된 값 또는 null
      _loadSavedSettings();
      
    } catch (e) {
      // OnboardingController를 찾지 못한 경우 기본값 설정
      print('OnboardingController not found: $e');
      _initSpeciesTabs(['dog', 'cat', 'owner']); // 모든 탭 표시
      _loadSavedSettings();
    }
    
    // Subscribe to SubscriptionController's premium status
    try {
      final subscriptionController = Get.find<SubscriptionController>();
      ever(subscriptionController.isPremium, (isPremium) {
        isPremiumUser.value = isPremium;
        print('✅ [HomeController] Premium status updated: $isPremium');
      });
      // Initial sync
      isPremiumUser.value = subscriptionController.isPremium.value;
    } catch (e) {
      print('⚠️ [HomeController] SubscriptionController not found: $e');
    }
  }

  void _loadSavedSettings() {
    // Load saved species index
    if (_storage.hasData('selectedSpeciesIndex')) {
      selectedSpeciesIndex.value = _storage.read('selectedSpeciesIndex');
    }

    // Load saved mode
    if (_storage.hasData('lastModeId')) {
      final lastModeId = _storage.read('lastModeId');
      final mode = modes.firstWhereOrNull((m) => m.id == lastModeId);
      if (mode != null) {
        currentMode.value = mode;
      }
    }
    
    // Load premium status
    isPremiumUser.value = _storage.read('isPremium') ?? false;
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
        tracks: TrackData.sleepTracks,
      ),
      Mode(
        id: 'anxiety',
        title: '분리불안',
        description: '불안감 해소',
        iconPath: 'assets/icons/icon_mode_separation.png',
        color: const Color(0xFF26A69A), // Teal
        scientificFacts: ['백색 소음은 외부 자극을 차단합니다.', '부드러운 멜로디는 정서적 안정을 돕습니다.'],
        tracks: [
          Track(id: 'a7', title: '평온한 오후', target: '공용', isPremium: false, description: '기타(Guitar)의 따뜻한 울림', duration: '3:10', instrument: 'Acoustic Guitar', bpm: '60 BPM'),
          Track(id: 'a8', title: '숲속의 쉼터', target: '공용', isPremium: false, description: '관악기의 부드러운 호흡', duration: '3:25', instrument: 'Flute & Nature', bpm: '58 BPM'),
          Track(id: 'a1', title: '묵직한 위로', target: '대형', isPremium: true, description: '첼로의 묵직한 저음', duration: '3:40', instrument: 'Cello', bpm: '50 BPM'),
          Track(id: 'a2', title: '따뜻한 공명', target: '대형', isPremium: true, description: '공간을 채워주는 소리', duration: '3:30', instrument: 'Pad', bpm: '55 BPM'),
          Track(id: 'a3', title: '균형 잡힌 안정', target: '중형', isPremium: true, description: '너무 무겁지 않은 현악기', duration: '3:15', instrument: 'Viola', bpm: '60 BPM'),
          Track(id: 'a4', title: '포근한 공기', target: '중형', isPremium: true, description: '부드러운 공기 질감', duration: '3:20', instrument: 'Ambient', bpm: '58 BPM'),
          Track(id: 'a5', title: '산뜻한 안정', target: '소형', isPremium: true, description: '하프(Harp)의 맑은 소리', duration: '3:00', instrument: 'Harp', bpm: '65 BPM'),
          Track(id: 'a6', title: '밝은 공기', target: '소형', isPremium: true, description: '밝고 가벼운 앰비언트', duration: '3:05', instrument: 'Synth Pad', bpm: '62 BPM'),
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
          Track(id: 'n7', title: '우주 여행', target: '공용', isPremium: false, description: '신비롭고 넓은 공간감', duration: '4:00', instrument: 'Deep Synth', bpm: '40 BPM'),
          Track(id: 'n8', title: '깊은 바다', target: '공용', isPremium: false, description: '물속에 있는 듯한 차단력', duration: '4:10', instrument: 'Brown Noise', bpm: 'N/A'),
          Track(id: 'n1', title: '부드러운 장막', target: '대형', isPremium: true, description: '빗소리 믹스', duration: '3:50', instrument: 'Rain & Piano', bpm: '50 BPM'),
          Track(id: 'n2', title: '깊은 방패', target: '대형', isPremium: true, description: '저음 방어막 (천둥 대비)', duration: '4:00', instrument: 'Low Drone', bpm: '45 BPM'),
          Track(id: 'n3', title: '일상의 평온', target: '중형', isPremium: true, description: '시냇물 소리 믹스', duration: '3:45', instrument: 'Stream & Pad', bpm: '55 BPM'),
          Track(id: 'n4', title: '든든한 방음벽', target: '중형', isPremium: true, description: '꽉 찬 중저음', duration: '3:55', instrument: 'Cello & Noise', bpm: '52 BPM'),
          Track(id: 'n5', title: '산뜻한 보호막', target: '소형', isPremium: true, description: '새소리/바람소리 믹스', duration: '3:30', instrument: 'Wind & Chimes', bpm: '60 BPM'),
          Track(id: 'n6', title: '포근한 담요', target: '소형', isPremium: true, description: '답답하지 않은 포근함', duration: '3:40', instrument: 'Soft Pad', bpm: '58 BPM'),
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
          Track(id: 'e7', title: '피크닉', target: '공용', isPremium: false, description: '어쿠스틱 기타의 경쾌함', duration: '2:50', instrument: 'Guitar', bpm: '100 BPM'),
          Track(id: 'e8', title: '댄스 타임', target: '공용', isPremium: false, description: '엉덩이가 들썩이는 리듬', duration: '3:00', instrument: 'Drums & Bass', bpm: '110 BPM'),
          Track(id: 'e1', title: '리드미컬 산책', target: '대형', isPremium: true, description: '재즈풍의 둥둥거리는 베이스', duration: '3:10', instrument: 'Double Bass', bpm: '95 BPM'),
          Track(id: 'e2', title: '활기찬 터그', target: '대형', isPremium: true, description: '신나는 록 비트', duration: '2:45', instrument: 'Rock Band', bpm: '120 BPM'),
          Track(id: 'e3', title: '경쾌한 총총', target: '중형', isPremium: true, description: '밝은 팝 스타일', duration: '3:00', instrument: 'Synth Pop', bpm: '105 BPM'),
          Track(id: 'e4', title: '신나는 술래', target: '중형', isPremium: true, description: '통통 튀는 전자음', duration: '2:55', instrument: 'Chiptune', bpm: '115 BPM'),
          Track(id: 'e5', title: '사뿐한 총총', target: '소형', isPremium: true, description: '우쿨렐레의 귀여운 소리', duration: '2:50', instrument: 'Ukulele', bpm: '100 BPM'),
          Track(id: 'e6', title: '신나는 우다다', target: '소형', isPremium: true, description: '실로폰 같은 맑은 타격감', duration: '2:40', instrument: 'Xylophone', bpm: '110 BPM'),
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
          Track(id: 'sn7', title: '영혼의 안식', target: '공용', isPremium: false, description: '사람 목소리(허밍) 느낌', duration: '4:00', instrument: 'Humming', bpm: '50 BPM'),
          Track(id: 'sn8', title: '자연의 품', target: '공용', isPremium: false, description: '자연 치유 느낌', duration: '4:15', instrument: 'Nature Sounds', bpm: 'N/A'),
          Track(id: 'sn1', title: '치유의 주파수', target: '대형', isPremium: true, description: '싱잉볼의 웅웅거리는 진동', duration: '4:30', instrument: 'Singing Bowl', bpm: 'Low Freq'),
          Track(id: 'sn2', title: '깊은 안정', target: '대형', isPremium: true, description: '아주 느린 현악기', duration: '4:20', instrument: 'Slow Strings', bpm: '45 BPM'),
          Track(id: 'sn3', title: '부드러운 공명', target: '중형', isPremium: true, description: '끊기지 않는 따뜻한 소리', duration: '4:10', instrument: 'Resonance Pad', bpm: '50 BPM'),
          Track(id: 'sn4', title: '편안한 휴식', target: '중형', isPremium: true, description: '아주 느린 피아노', duration: '4:00', instrument: 'Slow Piano', bpm: '48 BPM'),
          Track(id: 'sn5', title: '포근한 온기', target: '소형', isPremium: true, description: '무겁지 않은 온열감', duration: '3:50', instrument: 'Warm Pad', bpm: '55 BPM'),
          Track(id: 'sn6', title: '산뜻한 평온', target: '소형', isPremium: true, description: '느리고 맑은 하프', duration: '3:45', instrument: 'Harp', bpm: '58 BPM'),
        ],
      ),
    ];
  }

  void _initSpeciesTabs(List<String> selected) {
    print('DEBUG: Initializing species tabs with: $selected');
    
    final allTabs = [
      SpeciesTab(id: 'dog', label: '강아지', iconPath: 'assets/icons/icon_species_dog.png'),
      SpeciesTab(id: 'cat', label: '고양이', iconPath: 'assets/icons/icon_species_cat.png'),
      // SpeciesTab(id: 'owner', label: '보호자', iconPath: 'assets/icons/icon_species_owner.png'), // Removed
    ];

    final tabs = <SpeciesTab>[];

    if (selected.isEmpty || selected.length >= 3) {
      // No species selected or all selected - show all tabs
      tabs.addAll(allTabs);
    } else if (selected.length == 1) {
      // Only 1 species selected - show that one first, then others
      final selectedTab = allTabs.firstWhere(
        (t) => t.id == selected[0],
        orElse: () => allTabs[0],
      );
      tabs.add(selectedTab);
      for (var tab in allTabs) {
        if (tab.id != selected[0]) {
          tabs.add(tab);
        }
      }
    } else if (selected.length == 2) {
      // 2 species selected - show those first, then the remaining one
      for (var id in selected) {
        final tab = allTabs.firstWhere((t) => t.id == id, orElse: () => SpeciesTab(id: '', label: '', iconPath: ''));
        if (tab.id.isNotEmpty) tabs.add(tab);
      }
      for (var tab in allTabs) {
        if (!selected.contains(tab.id)) {
          tabs.add(tab);
        }
      }
    }
    
    speciesTabs.value = tabs;
    print('DEBUG: Species tabs initialized: ${tabs.map((t) => t.label).toList()}');
  }

  // 테스트용 오디오 URL
  final String _testAudioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  final scenarioPlaylists = <String, List<String>>{}.obs;
  
  void _initScenarioPlaylists() {
    // 논문 기반: 각 시나리오에 맞는 트랙 ID 순서 정의
    scenarioPlaylists.value = {
      '산책 후': [
        'e7', 'e8', 'a7', 'a8', // 에너지 조절 → 분리불안 (Free tracks)
        'e1', 'a1', 's1', 's2', // 점진적 진정 (Premium)
      ],
      '낮잠 시간': [
        's1', 's2', // 수면 유도 무료
        's3', 's5', 's7', // 수면 유도 프리미엄
      ],
      '병원 방문': [
        'a7', 'a8', 's1', 's2', // 분리불안 → 수면 유도 무료
        'a1', 'a3', 's3', 's5', // 프리미엄
      ],
      '미용 후': [
        'n7', 'n8', 'a7', 'a8', // 소음 민감 → 분리불안 무료
        'n1', 'a1', 's1', // 프리미엄
      ],
      '천둥/번개': [
        'n7', 'n8', // 소음 차단 무료
        'n1', 'n2', 'n3', 'n4', // 강력한 차단 프리미엄
      ],
      '분리 불안': [
        'a7', 'a8', 's1', 's2', // 분리불안 → 수면 유도 무료
        'a1', 'a2', 's3', 's5', // 프리미엄
      ],
    };
  }
  
  // 종 변경
  void changeSpecies(int index) {
    selectedSpeciesIndex.value = index;
    _storage.write('selectedSpeciesIndex', index);
    _hapticService.selectionClick();
  }

  // 프리미엄 업그레이드
  void upgradeToPremium() {
    isPremiumUser.value = true;
  }

  void stopSound() {
    isPlaying.value = false;
    // Don't reset currentTrack - keep it to show track title even when stopped
    // currentTrack.value = null; // REMOVED
    _audioService.pause();
    _hapticService.stop();
  }

  void playSound(String modeId) {
    // Legacy method, might be used by HomeView play button
    // If we have a current track, play it, otherwise play first track of mode
    if (currentTrack.value != null && currentMode.value?.id == modeId) {
       // Stop BGM when playing track
       _bgmService.pause();
       isPlaying.value = true;
       _audioService.play(currentTrack.value!.audioUrl);
       if (isHeartbeatSyncEnabled.value) {
         _hapticService.startHeartbeat(60);
       }
    } else {
      // Find mode and play first track
      final mode = modes.firstWhere((m) => m.id == modeId, orElse: () => modes.first);
      if (mode.tracks.isNotEmpty) {
        playTrack(mode.tracks.first);
      }
    }
  }

  void playTrack(Track track) {
    print('🎵 [DEBUG] playTrack called for: ${track.title}');
    print('🎵 [DEBUG] Track audio URL: ${track.audioUrl}');
    print('🎵 [DEBUG] Track isPremium: ${track.isPremium}');
    print('🎵 [DEBUG] User isPremiumUser: ${isPremiumUser.value}');
    print('🔍 [DEBUG] Checking premium access...');
    
    if (track.isPremium && !isPremiumUser.value) {
      print('🚫 [DEBUG] Premium track blocked - redirecting to subscription');
      print('🔍 [DEBUG] isPremiumUser.value = ${isPremiumUser.value}');
      Get.toNamed('/subscription');
      return;
    }
    
    print('✅ [DEBUG] Premium check passed or free track');
    print('🎵 [DEBUG] Stopping BGM...');
    // Stop BGM when playing track
    _bgmService.pause();
    print('🎵 [DEBUG] BGM stopped');
    
    currentTrack.value = track;
    isPlaying.value = true;
    
    print('🎵 [DEBUG] Calling AudioService.play with URL: ${track.audioUrl}');
    // Play the actual track audio file
    _audioService.play(track.audioUrl);
    print('🎵 [DEBUG] AudioService.play called');
    
    if (isHeartbeatSyncEnabled.value) {
      // Parse BPM if possible, else default to 60
      int bpm = 60;
      if (track.bpm != null && track.bpm!.contains('BPM')) {
        try {
          bpm = int.parse(track.bpm!.split(' ')[0]);
        } catch (e) {
          bpm = 60;
        }
      }
      print('🎵 [DEBUG] Starting haptic with BPM: $bpm');
      _hapticService.startHeartbeat(bpm);
    }
    
    print('🎵 [DEBUG] Navigating to now-playing');
    // Navigate to Immersive Player
    Get.toNamed('/now-playing');
    print('🎵 [DEBUG] playTrack completed');
  }

  void togglePlay() {
    if (isPlaying.value) {
      // Pause
      print('⏸️ [DEBUG] Pausing playback');
      isPlaying.value = false;
      _audioService.pause();
      _hapticService.stop();
    } else {
      // Resume
      print('▶️ [DEBUG] Resuming playback');
      if (currentTrack.value != null) {
        isPlaying.value = true;
        _audioService.resume(); // Resume instead of play() to continue from current position
        
        if (isHeartbeatSyncEnabled.value) {
          int bpm = 60;
          if (currentTrack.value!.bpm != null && currentTrack.value!.bpm!.contains('BPM')) {
            try {
              bpm = int.parse(currentTrack.value!.bpm!.split(' ')[0]);
            } catch (e) {
              bpm = 60;
            }
          }
          _hapticService.startHeartbeat(bpm);
        }
      }
    }
  }

  void seekTo(Duration position) {
    print('⏩ [DEBUG] Seeking to $position');
    _audioService.seek(position);
  }

  // 모드 변경
  void changeMode(Mode mode) {
    currentMode.value = mode;
    _storage.write('lastModeId', mode.id);
    isAutoMode.value = false;
  }

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
