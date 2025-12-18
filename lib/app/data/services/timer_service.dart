import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// Sleep Timer Service for automatic playback stop
class TimerService extends GetxService {
  Timer? _timer;
  
  /// Remaining time in seconds
  final remainingSeconds = 0.obs;
  
  /// Whether timer is active
  final isActive = false.obs;
  
  /// Selected timer duration in minutes (for display)
  final selectedMinutes = 0.obs;
  
  /// Available timer presets in minutes
  static const List<int> presets = [10, 20, 30, 60];
  
  /// Callback when timer completes
  VoidCallback? onTimerComplete;
  
  /// Start the sleep timer
  void startTimer(int minutes) {
    cancelTimer();
    
    selectedMinutes.value = minutes;
    remainingSeconds.value = minutes * 60;
    isActive.value = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _onComplete();
      }
    });
    
    print('⏱️ Sleep timer started: $minutes minutes');
  }
  
  /// Cancel the active timer
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
    remainingSeconds.value = 0;
    selectedMinutes.value = 0;
    isActive.value = false;
    print('⏱️ Sleep timer cancelled');
  }
  
  /// Add time to existing timer
  void addTime(int minutes) {
    if (isActive.value) {
      remainingSeconds.value += minutes * 60;
      print('⏱️ Added $minutes minutes to timer');
    }
  }
  
  /// Format remaining time as MM:SS
  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Format remaining time as descriptive text
  String get remainingText {
    final mins = remainingSeconds.value ~/ 60;
    final secs = remainingSeconds.value % 60;
    
    if (mins > 0) {
      return '$mins${'ai_minutes'.tr} ${secs > 0 ? '$secs${'ai_seconds'.tr}' : ''}${'timer_suffix'.tr}';
    } else {
      return '$secs${'ai_seconds'.tr}${'timer_suffix'.tr}';
    }
  }
  
  void _onComplete() {
    cancelTimer();
    
    // Execute callback
    onTimerComplete?.call();
    
    // Show notification
    Get.snackbar(
      'timer_notify_title'.tr,
      'timer_notify_desc'.tr,
      backgroundColor: Colors.indigo.withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.bedtime, color: Colors.white),
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
    );
    
    print('⏱️ Sleep timer completed');
  }
  
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
