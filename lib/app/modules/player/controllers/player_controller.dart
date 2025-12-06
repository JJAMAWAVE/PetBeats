import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/therapy_control_panel.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/audio_service.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/audio_analyzer_service.dart';
import '../models/visualizer_theme.dart';
import '../widgets/first_run_guide_dialog.dart';

class PlayerController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final HapticService _hapticService = Get.find<HapticService>();
  final AudioService _audioService = Get.find<AudioService>();
  final _storage = GetStorage();
  
  final AudioAnalyzerService _audioAnalyzer = Get.put(AudioAnalyzerService());
  
  // Audio position and duration observables
  final currentPosition = Duration.zero.obs;
  final currentDuration = Duration.zero.obs;
  
  // Seek bar drag state
  final isDraggingSeekBar = false.obs;
  final tempSeekPosition = 0.0.obs;


  @override
  void onInit() {
    super.onInit();
    _showHapticTipIfFirstTime();
    
    // Subscribe to audio position and duration streams
    _audioService.positionStream.listen((position) {
      currentPosition.value = position;
    });
    
    _audioService.durationStream.listen((duration) {
      if (duration != null) {
        currentDuration.value = duration;
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
    
    if (intensity == HapticIntensity.off) {
      _hapticService.stop();
    } else {
      // All non-off intensities trigger heartbeat at track BPM
      // The intensity difference is handled by the haptic service itself
      _hapticService.startHeartbeat(currentTrackBpm);
    }
  }

  void toggleWeather() {
    isWeatherActive.value = !isWeatherActive.value;
    // TODO: Call SoundService to toggle rain layer
    print('Weather toggled: ${isWeatherActive.value}');
  }
}
