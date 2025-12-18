import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../data/services/audio_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/haptic_pattern_player.dart';
import '../../../data/services/review_service.dart';
import '../../../../core/services/bgm_service.dart';
import '../../../../core/services/web_bgm_service.dart';
import '../../../../core/theme/species_theme.dart';
import '../../onboarding/controllers/onboarding_controller.dart';
import '../../premium/controllers/subscription_controller.dart';
import '../../player/controllers/player_controller.dart';  // ✨ Duration fix
import '../../../data/models/mode_model.dart';
import '../../../data/models/track_model.dart';
import '../../../data/data_source/track_data.dart';
import '../../../data/services/sound_mixer_service.dart';  // ✨ Weather sounds

class HomeController extends GetxController with WidgetsBindingObserver {
  final AudioService _audioService = Get.put(AudioService());
  final HapticService _hapticService = Get.put(HapticService());
  final ReviewService _reviewService = Get.find<ReviewService>();
  // Use WebBgmService on web, BgmService otherwise (싱글톤으로 관리)
  late final dynamic _bgmService = kIsWeb 
      ? Get.find<WebBgmService>() 
      : Get.put(BgmService(), permanent: true);

  // 현재 선택된 종 (0: 강아지, 1: 고양이, 2: 보호자)
  final selectedSpeciesIndex = 0.obs;
  
  // 현재 종 테마
  final currentSpeciesTheme = SpeciesTheme.dog.obs;

  // 현재 재생 중인지 여부
  final isPlaying = false.obs;

  // 현재 선택된 모드
  final currentMode = Rx<Mode?>(null);

  // 현재 재생 중인 트랙
  final currentTrack = Rx<Track?>(null);
  
  // 현재 재생 중인 플레이리스트 (모드 트랙 또는 AI 플레이리스트)
  final currentPlaylist = <Track>[].obs;
  
  // 자동 모드 여부
  final isAutoMode = false.obs;
  
  // Spinner visibility states (dismissible on tap)
  final showBellSpinner = true.obs;
  final showHapticSpinner = true.obs;
  
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
  
  // 리뷰 요청을 위한 재생 시간 추적
  Timer? _playTimeTimer;
  int _totalPlayTimeSeconds = 0;
  static const int _reviewRequestThreshold = 300; // 5분 = 300초

  @override
  void onInit() {
    super.onInit();
    // 앱 생명주기 감지 등록
    WidgetsBinding.instance.addObserver(this);
    
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
  
  /// Immediately upgrade user to premium status (called from SubscriptionController)
  void upgradeToPremium() {
    isPremiumUser.value = true;
    _storage.write('isPremium', true);
    print('✅ [HomeController] User upgraded to Premium!');
  }

  void _initModes() {
    modes.value = [
      // Dog Modes
      Mode(
        id: 'sleep',
        title: 'mode_sleep_title'.tr,
        description: 'mode_sleep_desc'.tr,
        iconPath: 'assets/icons/icon_mode_sleep.png',
        color: const Color(0xFF5C6BC0), // Indigo
        scientificFacts: ['fact_sleep_1'.tr, 'fact_sleep_2'.tr],
        tracks: TrackData.sleepTracks,
      ),
      Mode(
        id: 'anxiety',
        title: 'mode_anxiety_title'.tr,
        description: 'mode_anxiety_desc'.tr,
        iconPath: 'assets/icons/icon_mode_separation.png',
        color: const Color(0xFF26A69A), // Teal
        scientificFacts: ['fact_anxiety_1'.tr, 'fact_anxiety_2'.tr],
        tracks: TrackData.separationTracks,
      ),
      Mode(
        id: 'noise',
        title: 'mode_noise_title'.tr,
        description: 'mode_noise_desc'.tr,
        iconPath: 'assets/icons/icon_mode_noise.png',
        color: const Color(0xFF7E57C2), // Deep Purple
        scientificFacts: ['fact_noise_1'.tr, 'fact_noise_2'.tr],
        tracks: TrackData.noiseTracks,
      ),
      Mode(
        id: 'energy',
        title: 'mode_energy_title'.tr,
        description: 'mode_energy_desc'.tr,
        iconPath: 'assets/icons/icon_mode_energy.png',
        color: const Color(0xFFFFA726), // Orange
        scientificFacts: ['fact_energy_1'.tr, 'fact_energy_2'.tr],
        tracks: TrackData.energyTracks,
      ),
      Mode(
        id: 'senior',
        title: 'mode_senior_title'.tr,
        description: 'mode_senior_desc'.tr,
        iconPath: 'assets/icons/icon_mode_senior.png',
        color: const Color(0xFF8D6E63), // Brown
        scientificFacts: ['fact_senior_1'.tr, 'fact_senior_2'.tr],
        tracks: TrackData.seniorTracks,
      ),
      
      // Cat Modes
      Mode(
        id: 'cat_sleep',
        title: 'mode_sleep_title'.tr,
        description: 'mode_cat_sleep_desc'.tr,
        iconPath: 'assets/icons/icon_mode_sleep.png',
        color: const Color(0xFF5C6BC0), // Indigo
        scientificFacts: ['fact_sleep_1'.tr, 'fact_sleep_2'.tr],
        tracks: TrackData.catSleepTracks,
      ),
      Mode(
        id: 'cat_separation',
        title: 'mode_anxiety_title'.tr,
        description: 'mode_cat_anxiety_desc'.tr,
        iconPath: 'assets/icons/icon_mode_separation.png',
        color: const Color(0xFF26A69A), // Teal
        scientificFacts: ['fact_anxiety_1'.tr, 'fact_anxiety_2'.tr],
        tracks: TrackData.catSeparationTracks,
      ),
      Mode(
        id: 'cat_noise',
        title: 'mode_noise_title'.tr,
        description: 'mode_cat_noise_desc'.tr,
        iconPath: 'assets/icons/icon_mode_noise.png',
        color: const Color(0xFF7E57C2), // Deep Purple
        scientificFacts: ['fact_noise_1'.tr, 'fact_noise_2'.tr],
        tracks: TrackData.catNoiseTracks,
      ),
      Mode(
        id: 'cat_energy',
        title: 'mode_energy_title'.tr,
        description: 'mode_cat_energy_desc'.tr,
        iconPath: 'assets/icons/icon_mode_energy.png',
        color: const Color(0xFFFFA726), // Orange
        scientificFacts: ['fact_energy_1'.tr, 'fact_energy_2'.tr],
        tracks: TrackData.catEnergyTracks,
      ),
      Mode(
        id: 'cat_senior',
        title: 'mode_senior_title'.tr,
        description: 'mode_cat_senior_desc'.tr,
        iconPath: 'assets/icons/icon_mode_senior.png',
        color: const Color(0xFF8D6E63), // Brown
        scientificFacts: ['fact_senior_1'.tr, 'fact_senior_2'.tr],
        tracks: TrackData.catSeniorTracks,
      ),
    ];
  }

  void _initSpeciesTabs(List<String> selected) {
    print('DEBUG: Initializing species tabs with: $selected');
    
    final allTabs = [
      SpeciesTab(id: 'dog', label: 'species_dog'.tr, iconPath: 'assets/icons/icon_species_dog.png'),
      SpeciesTab(id: 'cat', label: 'species_cat'.tr, iconPath: 'assets/icons/icon_species_cat.png'),
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
    
    // 테마 변경 (애니메이션 적용)
    if (index == 0) {
      currentSpeciesTheme.value = SpeciesTheme.dog;
    } else if (index == 1) {
      currentSpeciesTheme.value = SpeciesTheme.cat;
    }
    
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
    
    // ✨ Also pause weather sounds
    if (Get.isRegistered<SoundMixerService>()) {
      Get.find<SoundMixerService>().pauseAll();
    }
    
    _stopPlayTimeTracking(); // 재생 시간 추적 중지
  }

  void playSound(String modeId) {
    // Legacy method, might be used by HomeView play button
    // If we have a current track, play it, otherwise play first track of mode
    if (currentTrack.value != null && currentMode.value?.id == modeId) {
       // Stop BGM when playing track
       _bgmService.pause();
       isPlaying.value = true;
       _audioService.play(currentTrack.value!.audioUrl);
       // 햅틱은 PlayerController에서 관리 (기본값 OFF)
    } else {
      // Find mode and play first track
      final mode = modes.firstWhere((m) => m.id == modeId, orElse: () => modes.first);
      if (mode.tracks.isNotEmpty) {
        // Set playlist for skip functionality
        currentPlaylist.value = List<Track>.from(mode.tracks);
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
    // Stop BGM when playing track (force pause to ensure it stops)
    try {
      _bgmService.pause();
      print('🎵 [DEBUG] BGM stopped');
    } catch (e) {
      print('⚠️ [DEBUG] BGM pause error: $e');
    }
    
    currentTrack.value = track;
    isPlaying.value = true;
    
    print('🎵 [DEBUG] Calling AudioService.play with URL: ${track.audioUrl}');
    // Play the actual track audio file
    _audioService.play(track.audioUrl);
    print('🎵 [DEBUG] AudioService.play called');
    
    // MIDI 기반 햅틱 패턴 로드 및 시작 (비주얼라이저용 - 햅틱 ON/OFF와 무관)
    try {
      final hapticPatternPlayer = Get.find<HapticPatternPlayer>();
      hapticPatternPlayer.loadPattern(track.id).then((_) {
        // 패턴 로드 완료 후 시작 (비주얼라이저에 MIDI 이벤트 전달)
        hapticPatternPlayer.start();
        print('🎵 [DEBUG] Haptic pattern started for visualizer: ${track.id}');
      });
    } catch (e) {
      print('⚠️ [DEBUG] HapticPatternPlayer not available: $e');
    }
    
    // 햅틱 진동은 PlayerController에서 관리 - 기본값 OFF이므로 자동 시작하지 않음
    // 사용자가 햅틱을 켜면 PlayerController.setHapticIntensity에서 시작됨
    print('🎵 [DEBUG] Haptic vibration will be controlled by PlayerController (default: OFF)');
    
    // 재생 시간 추적 시작
    _startPlayTimeTracking();
    
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
      // _hapticService.stop(); // Old way
      _hapticService.pause(); // New way: pause and remember state
      
      // ✨ Also pause weather sounds
      if (Get.isRegistered<SoundMixerService>()) {
        Get.find<SoundMixerService>().pauseAll();
      }
      
      _stopPlayTimeTracking(); // 재생 시간 추적 중지
    } else {
      // Resume
      print('▶️ [DEBUG] Resuming playback');
      if (currentTrack.value != null) {
        isPlaying.value = true;
        _audioService.resume(); // Resume instead of play() to continue from current position
        
        // _hapticService.startHeartbeat(bpm); // Old way
        _hapticService.resume(); // New way: resume previous state
        
        // ✨ Also resume weather sounds (if weather mix was active)
        if (Get.isRegistered<SoundMixerService>()) {
          Get.find<SoundMixerService>().resumeAll();
        }
        
        _startPlayTimeTracking(); // 재생 시간 추적 재개
      }
    }
  }

  void seekTo(Duration position) {
    print('⏩ [DEBUG] Seeking to $position');
    _audioService.seek(position);
  }
  
  /// Skip to previous track in current playlist
  void skipPrevious() {
    if (currentTrack.value == null) return;
    
    // Use currentPlaylist if available, otherwise fall back to currentMode.tracks
    final tracks = currentPlaylist.isNotEmpty 
        ? currentPlaylist.toList() 
        : (currentMode.value?.tracks ?? []);
    
    if (tracks.isEmpty) {
      print('⚠️ [skipPrevious] No tracks available');
      return;
    }
    
    final currentIndex = tracks.indexWhere((t) => t.id == currentTrack.value!.id);
    
    if (currentIndex <= 0) {
      // First track or not found - go to last track
      _playTrackAtIndex(tracks, tracks.length - 1);
    } else {
      _playTrackAtIndex(tracks, currentIndex - 1);
    }
  }
  
  /// Skip to next track in current playlist
  void skipNext() {
    if (currentTrack.value == null) return;
    
    // Use currentPlaylist if available, otherwise fall back to currentMode.tracks
    final tracks = currentPlaylist.isNotEmpty 
        ? currentPlaylist.toList() 
        : (currentMode.value?.tracks ?? []);
    
    if (tracks.isEmpty) {
      print('⚠️ [skipNext] No tracks available');
      return;
    }
    
    final currentIndex = tracks.indexWhere((t) => t.id == currentTrack.value!.id);
    
    if (currentIndex < 0 || currentIndex >= tracks.length - 1) {
      // Last track or not found - go to first track
      _playTrackAtIndex(tracks, 0);
    } else {
      _playTrackAtIndex(tracks, currentIndex + 1);
    }
  }
  
  void _playTrackAtIndex(List<Track> tracks, int index) {
    final track = tracks[index];
    
    // Check if premium
    if (track.isPremium && !isPremiumUser.value) {
      // Find next free track
      for (int i = index; i < tracks.length; i++) {
        if (!tracks[i].isPremium) {
          _switchToTrack(tracks[i]);
          return;
        }
      }
      // If no free track found, loop from beginning
      for (int i = 0; i < index; i++) {
        if (!tracks[i].isPremium) {
          _switchToTrack(tracks[i]);
          return;
        }
      }
      // All tracks are premium - show subscription
      Get.toNamed('/subscription');
      return;
    }
    
    _switchToTrack(track);
  }
  
  void _switchToTrack(Track track) async {
    print('⏭️ [DEBUG] Switching to track: ${track.title}');
    print('⏭️ [DEBUG] Track audioUrl: ${track.audioUrl}');
    
    // 이전 햅틱 패턴 중지 (오디오/햅틱 겹침 방지)
    try {
      final hapticPatternPlayer = Get.find<HapticPatternPlayer>();
      hapticPatternPlayer.stop();
    } catch (e) {
      print('⚠️ [DEBUG] HapticPatternPlayer stop error: $e');
    }
    
    // Stop current playback and reset
    await _audioService.stop();
    
    // Small delay to ensure previous audio is fully stopped
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Update current track
    currentTrack.value = track;
    isPlaying.value = true;  // Set playing state
    
    // Duration is now handled by PlayerController via ever() and onInit()
    // No need to manually set it here - PlayerController will react to currentTrack change
    
    // Start new track
    await _audioService.play(track.audioUrl);
    
    // 새 트랙의 MIDI 패턴 로드 및 시작 (비주얼라이저용)
    try {
      final hapticPatternPlayer = Get.find<HapticPatternPlayer>();
      await hapticPatternPlayer.loadPattern(track.id);
      hapticPatternPlayer.start();
      print('🎵 [DEBUG] Haptic pattern started for new track: ${track.id}');
    } catch (e) {
      print('⚠️ [DEBUG] HapticPatternPlayer start error: $e');
    }
    
    print('⏭️ [DEBUG] Now playing: ${track.title}');
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
  
  // 재생 시간 추적 시작
  void _startPlayTimeTracking() {
    _playTimeTimer?.cancel(); // 기존 타이머 정리
    _playTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalPlayTimeSeconds++;
      print('⏱️ [DEBUG] Total play time: $_totalPlayTimeSeconds seconds');
      
      // 5분(300초) 달성 시 리뷰 요청
      if (_totalPlayTimeSeconds >= _reviewRequestThreshold) {
        print('⭐ [DEBUG] 5분 재생 완료! 리뷰 요청 호출');
        _playTimeTimer?.cancel();
        _reviewService.requestReview();
      }
    });
  }
  
  // 재생 시간 추적 중지
  void _stopPlayTimeTracking() {
    _playTimeTimer?.cancel();
  }
  
  // Force update UI strings when language changes
  void refreshLocalizedData() {
    print('🔄 Refreshing localized data...');
    _initModes();
    
    if (speciesTabs.isNotEmpty) {
      final currentIds = speciesTabs.map((t) => t.id).toList();
      _initSpeciesTabs(currentIds);
    } else {
      _initSpeciesTabs(['dog', 'cat']);
    }

    _initScenarioPlaylists();
  }

  @override
  void onClose() {
    // 앱 생명주기 감지 해제
    WidgetsBinding.instance.removeObserver(this);
    _playTimeTimer?.cancel();
    super.onClose();
  }
  
  /// 앱 생명주기 변경 감지 - 백그라운드로 갈 때 BGM 중지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('📱 [HomeController] App lifecycle changed: $state');
    
    if (state == AppLifecycleState.paused) {
      // 앱이 완전히 백그라운드로 갈 때만 BGM 중지
      print('📱 [HomeController] App paused - stopping BGM');
      _bgmService.pause();
    } else if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아올 때
      print('📱 [HomeController] App resumed to foreground');
      // 트랙이 재생 중이 아니면 BGM 재개
      if (!isPlaying.value) {
        print('📱 [HomeController] No track playing - resuming BGM');
        _bgmService.resume();
      } else {
        print('📱 [HomeController] Track is playing - skipping BGM resume');
      }
    }
    // inactive 상태 무시 - 웹에서 다이얼로그나 화면 전환 시에도 발생
  }
}

class SpeciesTab {
  final String id;
  final String label;
  final String iconPath;
  
  SpeciesTab({required this.id, required this.label, required this.iconPath});
}
