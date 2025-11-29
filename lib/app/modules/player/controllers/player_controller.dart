import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/therapy_control_panel.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/services/haptic_service.dart';
import 'package:get_storage/get_storage.dart';

class PlayerController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final HapticService _hapticService = Get.find<HapticService>();
  final _storage = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    _showHapticTipIfFirstTime();
  }
  
  // 첫 재생 시 햅틱 사용 안내
  void _showHapticTipIfFirstTime() {
    final hasSeenTip = _storage.read('has_seen_haptic_tip') ?? false;
    
    if (!hasSeenTip && isPlaying) {
      Future.delayed(Duration(seconds: 2), () {
        Get.snackbar(
          '💡 Haptic Therapy 사용 팁',
          '아이의 등이나 배에 폰을 가볍게 올려주세요.\n심장 박동 진동이 깊은 안정을 선물합니다.',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.black.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.favorite, color: Colors.pinkAccent),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        
        _storage.write('has_seen_haptic_tip', true);
      });
    }
  }
  
  // Get data from HomeController
  bool get isPlaying => homeController.isPlaying.value;
  String get currentTrackTitle => homeController.currentTrack.value?.title ?? "Unknown";
  String get currentTrackArtist => "PetBeats AI";
  int get currentTrackBpm {
    final track = homeController.currentTrack.value;
    if (track == null) return 60;
    
    if (track.bpm.contains('BPM')) {
      try {
        return int.parse(track.bpm.split(' ')[0]);
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
  final hapticIntensity = HapticIntensity.soft.obs;
  final isWeatherActive = false.obs;

  void togglePlay() {
    homeController.togglePlay();
  }
  
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
    } else if (intensity == HapticIntensity.soft) {
      _hapticService.startHeartbeat(currentTrackBpm);
    } else if (intensity == HapticIntensity.deep) {
      // Deep intensity - you can adjust the pattern here
      _hapticService.startHeartbeat(currentTrackBpm);
    }
  }

  void toggleWeather() {
    isWeatherActive.value = !isWeatherActive.value;
    // TODO: Call SoundService to toggle rain layer
    print('Weather toggled: ${isWeatherActive.value}');
  }
}
