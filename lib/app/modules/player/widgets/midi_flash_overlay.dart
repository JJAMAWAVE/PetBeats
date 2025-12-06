import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../data/services/haptic_service.dart';

/// MIDI 비트에 반응하여 섬광 효과를 표시하는 오버레이 위젯
class MidiFlashOverlay extends StatefulWidget {
  const MidiFlashOverlay({super.key});

  @override
  State<MidiFlashOverlay> createState() => _MidiFlashOverlayState();
}

class _MidiFlashOverlayState extends State<MidiFlashOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  final HapticService _haptic = Get.find<HapticService>();
  StreamSubscription? _midiSubscription;
  double _flashIntensity = 0.0;

  @override
  void initState() {
    super.initState();
    
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // 섬광 지속 시간
    );

    // MIDI 이벤트 리스닝
    _midiSubscription = _haptic.midiNoteStream.listen((event) {
      if (!mounted) return;

      // velocity를 0-1 범위로 정규화
      final intensity = (event.velocity / 127).clamp(0.0, 1.0);
      
      setState(() {
        _flashIntensity = intensity;
      });

      // 섬광 애니메이션: 빠르게 밝아졌다가 서서히 사라짐
      _flashController.forward(from: 0.0).then((_) {
        if (mounted) {
          setState(() {
            _flashIntensity = 0.0;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _flashController.dispose();
    _midiSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_flashIntensity == 0.0) {
      return const SizedBox.shrink(); // 섬광이 없을 때는 아무것도 표시하지 않음
    }

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _flashController,
        builder: (context, child) {
          // 애니메이션에 따라 페이드 아웃
          final opacity = _flashIntensity * (1.0 - _flashController.value);
          
          return Center(
            child: Container(
              width: 200 + (_flashIntensity * 100), // 강도에 따라 크기 변화
              height: 200 + (_flashIntensity * 100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(opacity * 0.8), // 중앙이 가장 밝음
                    Colors.amber.withOpacity(opacity * 0.5),
                    Colors.orange.withOpacity(opacity * 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(opacity * 0.6),
                    blurRadius: 80 + (_flashIntensity * 40),
                    spreadRadius: 40 + (_flashIntensity * 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
