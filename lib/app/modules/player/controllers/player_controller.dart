import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/therapy_control_panel.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/audio_service.dart';
import '../../../data/models/haptic_settings_model.dart';
import 'package:just_audio/just_audio.dart';  // For ProcessingState
import '../../../data/services/timer_service.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/audio_analyzer_service.dart';
import '../models/visualizer_theme.dart';
import '../widgets/first_run_guide_dialog.dart';

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
  final repeatMode = RepeatMode.single.obs;  // 기본: 1곡 반복


  @override
  void onInit() {
    super.onInit();
    _showHapticTipIfFirstTime();
    
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
    
    // Listen for track completion (All loop mode)
    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Check if All loop mode is active
        if (repeatMode.value == RepeatMode.all) {
          print('🔁 Track completed, playing next (All loop mode)');
          homeController.skipNext();
        }
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
  
  @override
  void onClose() {
    _audioAnalyzer.stopAnalysis();
    super.onClose();
  }
  
  // 첫 재생 시 햅틱 사용 안내 (교감 가이드)
  void _showHapticTipIfFirstTime() {
    final hasSeenGuide = _storage.read('has_seen_haptic_guide') ?? false;
    
    if (!hasSeenGuide && isPlaying) {
      Future.delayed(Duration(seconds: 1), () {
        Get.dialog(
          const FirstRunGuideDialog(),
          barrierDismissible: false,
        );
        _storage.write('has_seen_haptic_guide', true);
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
    hapticIntensity.value = intensity;
    
    // 핵심: HapticService에 강도 업데이트 전달
    _hapticService.updateIntensity(intensity);
    
    if (intensity == HapticIntensity.off) {
      _hapticService.stop();
    } else {
      // 현재 재생 중이면 햅틱 모드 활성화
      if (isPlaying) {
        _activateHapticMode();
      }
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
          // MIDI 기반 햅틱 - HapticPatternPlayer가 처리
          print('🎵 Sound Adaptive mode - MIDI-based haptic enabled');
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
