import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/therapy_control_panel.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/haptic_pattern_player.dart';
import '../../../data/services/audio_service.dart';
import '../../../data/models/haptic_settings_model.dart';
import 'package:just_audio/just_audio.dart';  // For ProcessingState
import '../../../data/services/timer_service.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/audio_analyzer_service.dart';
import '../models/visualizer_theme.dart';
import '../widgets/first_run_guide_dialog.dart';
import '../widgets/haptic_safety_guide_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Repeat Mode: Off → Single (1곡 반복) → All (전체 반복)
enum RepeatMode { off, single, all }

class PlayerController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final HapticService _hapticService = Get.find<HapticService>();
  final AudioService _audioService = Get.find<AudioService>();
  final TimerService timerService = Get.find<TimerService>();
  final _storage = GetStorage();
  
  final AudioAnalyzerService _audioAnalyzer = Get.put(AudioAnalyzerService());
  
  // Audio position and duration observables
  final currentPosition = Duration.zero.obs;
  final currentDuration = Duration.zero.obs;
  
  // Seek bar drag state
  final isDraggingSeekBar = false.obs;
  final tempSeekPosition = 0.0.obs;
  
  // Repeat mode: off → single (1곡 반복) → all (전체 반복)
  final repeatMode = RepeatMode.all.obs;  // 기본: 전체 반복


  @override
  void onInit() {
    super.onInit();
    _showHapticTipIfFirstTime();
    _showHapticSafetyGuideIfFirstTime();  // ✨ Auto-popup safety guide
    
    // Initialize repeat mode to All (default)
    // Use LoopMode.off so track completion triggers skipNext()
    _audioService.setLoopMode(false);
    print('🔁 [PlayerController] Initialized with RepeatMode.all (LoopMode.off for playlist)');
    
    // Setup sleep timer completion callback
    timerService.onTimerComplete = () {
      homeController.stopSound();
    };
    
    // Subscribe to audio position and duration streams
    _audioService.positionStream.listen((position) {
      currentPosition.value = position;
    });
    
    _audioService.durationStream.listen((duration) {
      if (duration != null) {
        currentDuration.value = duration;
      }
    });
    
    // ✨ WEB FIX: Listen to track changes and set expected duration immediately
    ever(homeController.currentTrack, (track) {
      if (track != null) {
        _trySetExpectedDurationFromTrack(track, source: 'ever(currentTrack)');
      }
    });
    
    // ✨ WEB FIX (Critical): ever() is NOT called for the initial value.
    // If a track is already selected/playing before PlayerController is created,
    // we must apply the expected duration once here.
    final initialTrack = homeController.currentTrack.value;
    if (initialTrack != null) {
      _trySetExpectedDurationFromTrack(initialTrack, source: 'onInit(initialTrack)');
    }
    
    // Listen for track completion (All loop mode)
    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Check if All loop mode is active
        if (repeatMode.value == RepeatMode.all) {
          print('🔁 Track completed, playing next (All loop mode)');
          homeController.skipNext();
        } else if (repeatMode.value == RepeatMode.off) {
          print('🔁 Track completed, stopping (RepeatMode.off)');
          // Track just stops
        }
        // RepeatMode.single handles itself via LoopMode.one
      }
    });
    
    // Playback state listener for Audio Analyzer
    ever(homeController.isPlaying, (playing) {
      if (playing) {
        _audioAnalyzer.startAnalysis();
      } else {
        _audioAnalyzer.stopAnalysis();
      }
    });
  }
  
  // -------------------------------------------------------------------
  // Expected duration helper (Web-first)
  //
  // Why this exists:
  // - On Web, just_audio's durationStream may be delayed or null for some sources.
  // - GetX ever() DOES NOT fire for the current(initial) Rx value; it only fires on changes.
  //   So if PlayerController is created after HomeController.currentTrack is already set,
  //   we must set the expected duration once in onInit.
  // -------------------------------------------------------------------
  void _trySetExpectedDurationFromTrack(dynamic track, {required String source}) {
    try {
      final raw = (track.duration ?? '').toString().trim();
      if (raw.isEmpty) {
        print('⚠️ [PlayerController] [$source] Track.duration is empty for ${track.title}');
        return;
      }

      final parts = raw.split(':').map((p) => p.trim()).toList();

      int hours = 0;
      int minutes = 0;
      int seconds = 0;

      if (parts.length == 2) {
        // mm:ss
        minutes = int.tryParse(parts[0]) ?? 0;
        seconds = int.tryParse(parts[1]) ?? 0;
      } else if (parts.length == 3) {
        // hh:mm:ss
        hours = int.tryParse(parts[0]) ?? 0;
        minutes = int.tryParse(parts[1]) ?? 0;
        seconds = int.tryParse(parts[2]) ?? 0;
      } else {
        print('⚠️ [PlayerController] [$source] Unsupported duration format: "$raw" for ${track.title}');
        return;
      }

      // Basic sanity: avoid negative values
      if (hours < 0 || minutes < 0 || seconds < 0) {
        print('⚠️ [PlayerController] [$source] Negative duration parsed from "$raw" for ${track.title}');
        return;
      }

      final expected = Duration(hours: hours, minutes: minutes, seconds: seconds);

      // If it's zero, still set it (some tracks might be very short), but log for visibility.
      if (expected == Duration.zero) {
        print('⚠️ [PlayerController] [$source] Parsed expected duration is 0:00 from "$raw" for ${track.title}');
      }

      final resetPosition = source.startsWith('ever(');
      setExpectedDuration(expected, resetPosition: resetPosition);
      print('🕒 [PlayerController] [$source] Set expected duration: $expected for ${track.title}');
    } catch (e) {
      print('⚠️ [PlayerController] [$source] Failed to parse track duration: $e');
    }
  }

  // ✨ WEB FIX: Set expected duration immediately when track changes
  void setExpectedDuration(Duration duration, {bool resetPosition = false}) {
    print('🕒 [PlayerController] Setting expected duration: $duration');
    currentDuration.value = duration;
    if (resetPosition) {
      currentPosition.value = Duration.zero;  // Reset position when a new track is selected
    }
  }
  
  @override
  void onClose() {
    _audioAnalyzer.stopAnalysis();
    super.onClose();
  }
  
  // 첫 재생 시 햅틱 사용 안내 (교감 가이드)
  void _showHapticTipIfFirstTime() {
    final hasSeenTip = _storage.read('has_seen_haptic_tip') ?? false;
    
    if (!hasSeenTip && isPlaying) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.snackbar(
          '💡 Haptic Therapy 사용 팁',
          '아이의 등이나 배에 폰을 가볍게 올려주세요.\n'
          '심장 박동 진동이 깊은 안정을 선물합니다.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
          margin: const EdgeInsets.all(16),
        );
        _storage.write('has_seen_haptic_tip', true);
      });
    }
  }

  /// Show haptic safety guide on first playback
  void _showHapticSafetyGuideIfFirstTime() {
    final hasSeenGuide = _storage.read('has_seen_haptic_safety_guide') ?? false;
    
    if (!hasSeenGuide && isPlaying) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.dialog(
          const HapticSafetyGuideDialog(),
          barrierDismissible: false,
        );
        _storage.write('has_seen_haptic_safety_guide', true);
      });
    }
  }
  
  // Get data from HomeController
  bool get isPlaying => homeController.isPlaying.value;
  String get currentTrackTitle => homeController.currentTrack.value?.title ?? "Unknown";
  String get currentTrackArtist => "PetBeats AI";
  int get currentTrackBpm {
    final track = homeController.currentTrack.value;
    if (track == null || track.bpm == null) return 60;
    
    if (track.bpm!.contains('BPM')) {
      try {
        return int.parse(track.bpm!.split(' ')[0]);
      } catch (e) {
        return 60;
      }
    }
    return 60;
  }
  
  Color get currentTrackColor {
    final mode = homeController.currentMode.value;
    return mode?.color ?? const Color(0xFF5E60CE);
  }

  // Therapy Controls
  final hapticIntensity = HapticIntensity.off.obs;  // Changed default from soft to off
  final isWeatherActive = false.obs;

  void togglePlay() {
    print('🔘 [PlayerController] togglePlay() called');
    homeController.togglePlay();
  }

  VisualizerTheme get currentVisualizerTheme {
    final modeId = homeController.currentMode.value?.id;
    
    switch (modeId) {
      case 'sleep':
        return VisualizerTheme.sleep;
      case 'energy':
        return VisualizerTheme.energy;
      case 'anxiety':
        return VisualizerTheme.anxiety;
      case 'senior':
        return VisualizerTheme.senior;
      case 'noise':
        return VisualizerTheme.noise;
      default:
        return VisualizerTheme.sleep;
    }
  }

  // Legacy getter support
  String get currentVisualizerMode {
    final mode = homeController.currentMode.value;
    if (mode == null) return 'sleep';
    
    final modeId = mode.id;
    if (modeId == 'sleep' || modeId == 'anxiety' || modeId == 'senior') {
      return 'sleep';
    } else if (modeId == 'energy' || modeId == 'noise') {
      return 'energy';
    } else {
      return 'focus';
    }
  }

  void setHapticIntensity(HapticIntensity intensity) {
    final previousIntensity = hapticIntensity.value;
    hapticIntensity.value = intensity;
    
    // 핵심: HapticService에 강도 업데이트 전달
    _hapticService.updateIntensity(intensity);
    
    if (intensity == HapticIntensity.off) {
      _hapticService.stop();
    } else {
      // 처음 햅틱 켜 때 가이드 표시
      if (previousIntensity == HapticIntensity.off) {
        _showHapticGuide();
      }
      
      // ✨ 사운드 햅틱 모드일 때, 음악이 꺼져있으면 경고 표시
      // (심장박동/골골송/진정모드는 음악 불필요하므로 제외)
      if (hapticMode.value == HapticMode.soundAdaptive) {
        if (!isPlaying) {
          // 음악 재생 중이 아니면 토스트 표시
          Get.snackbar(
            '음악과 함께 사용하세요',
            '사운드 햅틱은 음악 재생 중에 작동합니다',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orangeAccent.withOpacity(0.9),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w),
            borderRadius: 12.r,
          );
        } else {
          // 음악 재생 중이면 햅틱 모드 활성화
          _activateHapticMode();
        }
      } else {
        // 다른 모드(심장박동/골골송 등)는 음악 없이도 동작
        _activateHapticMode();
      }
    }
  }
  
  // 햅틱 처음 사용 시 가이드 표시
  void _showHapticGuide() {
    final hasSeenGuide = _storage.read('has_seen_haptic_guide') ?? false;
    
    if (!hasSeenGuide) {
      Get.dialog(
        const FirstRunGuideDialog(),
        barrierDismissible: true,
      );
      _storage.write('has_seen_haptic_guide', true);
    }
  }
  
  // Haptic Mode (heartbeat, rampdown, purr, soundAdaptive)
  final hapticMode = HapticMode.soundAdaptive.obs;  // 기본값: 사운드
  
  void setHapticMode(HapticMode mode) {
    hapticMode.value = mode;
    
    // 항상 기존 패턴 중지 후 새 모드로 전환
    _hapticService.stop();
    
    // If haptic is currently active, switch to new mode
    if (hapticIntensity.value != HapticIntensity.off && isPlaying) {
      _activateHapticMode();
    }
    
    print('🎵 Haptic mode changed to: $mode');
  }
  
  void _activateHapticMode() {
    // 먼저 모든 기존 패턴 중지
    _hapticService.stop();
    
    // HapticPatternPlayer도 중지
    try {
      final hapticPatternPlayer = Get.find<HapticPatternPlayer>();
      hapticPatternPlayer.stop();
    } catch (e) {
      // 무시
    }
    
    // 잠시 대기 후 새 모드 시작 (중복 방지)
    Future.delayed(const Duration(milliseconds: 50), () {
      switch (hapticMode.value) {
        case HapticMode.heartbeat:
          _hapticService.startHeartbeat(currentTrackBpm);
          break;
        case HapticMode.rampdown:
          _hapticService.startCalmingRampdown();
          break;
        case HapticMode.purr:
          _hapticService.startPurr();
          break;
        case HapticMode.soundAdaptive:
          // MIDI 기반 햅틱 - 패턴 파일이 있는 경우에만 사용
          try {
            final hapticPatternPlayer = Get.find<HapticPatternPlayer>();
            if (hapticPatternPlayer.isHapticEnabled) {
              // 패턴 파일 있음 → MIDI 기반 햅틱
              _hapticService.startSoundAdaptive();
              hapticPatternPlayer.start(position: currentPosition.value);
              print('🎵 Sound Adaptive mode - MIDI haptic started');
            } else {
              // 패턴 파일 없음 → heartbeat로 폴백
              _hapticService.startHeartbeat(currentTrackBpm);
              print('🎵 Sound Adaptive mode - No pattern, fallback to heartbeat');
            }
          } catch (e) {
            // HapticPatternPlayer 없음 → heartbeat로 폴백
            _hapticService.startHeartbeat(currentTrackBpm);
            print('⚠️ HapticPatternPlayer not available, fallback to heartbeat');
          }
          break;
      }
    });
  }

  void toggleWeather() {
    isWeatherActive.value = !isWeatherActive.value;
    // TODO: Call SoundService to toggle rain layer
    print('Weather toggled: ${isWeatherActive.value}');
  }
  
  /// 반복 모드 토글: Off → Single (1곡) → All (전체) → Off
  void toggleRepeatMode() {
    switch (repeatMode.value) {
      case RepeatMode.off:
        repeatMode.value = RepeatMode.single;
        _audioService.setLoopMode(true, singleTrack: true);
        print('🔁 Repeat mode: Single track');
        break;
      case RepeatMode.single:
        repeatMode.value = RepeatMode.all;
        _audioService.setLoopMode(true, singleTrack: false);
        print('🔁 Repeat mode: All tracks');
        break;
      case RepeatMode.all:
        repeatMode.value = RepeatMode.off;
        _audioService.setLoopMode(false);
        print('🔁 Repeat mode: Off');
        break;
    }
  }
  
  /// 반복 모드에 따른 아이콘 반환
  IconData get repeatModeIcon {
    switch (repeatMode.value) {
      case RepeatMode.off:
        return Icons.repeat;
      case RepeatMode.single:
        return Icons.repeat_one;
      case RepeatMode.all:
        return Icons.repeat;
    }
  }
  
  /// 반복 모드 활성 여부
  bool get isRepeatActive => repeatMode.value != RepeatMode.off;
}
