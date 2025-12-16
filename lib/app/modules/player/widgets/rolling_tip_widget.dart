import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class RollingTipWidget extends StatefulWidget {
  const RollingTipWidget({super.key});

  @override
  State<RollingTipWidget> createState() => _RollingTipWidgetState();
}

class _RollingTipWidgetState extends State<RollingTipWidget> {
  // ✨ 15개 초간단 한 줄 팁
  final List<String> _tips = [
    // [진동(햅틱) 활용]
    "🛋️ 담요나 쿠션 아래 두세요.",
    "🤗 등 뒤에 살며시 놓아주세요.",
    "💕 보호자님 품에 안고 써보세요.",
    "⚠️ 직접 접촉은 피해주세요.",
    "🌡️ 처음엔 약한 진동부터.",
    // [사운드/볼륨]
    "🔈 볼륨은 작게 시작하세요.",
    "👂 사람 귀에 '약간 작은 듯'이 좋아요.",
    "🎵 아이 취향의 소리를 찾아보세요.",
    "🌊 백색소음은 낯선 소리를 덮어줘요.",
    // [상황/타이밍]
    "🌙 자기 전, 수면 루틴으로 딱!",
    "🌧️ 비 오거나 천둥 칠 때 좋아요.",
    "🚗 외출할 때 안정을 선물하세요.",
    "🏠 낯선 환경에 갔을 때 틀어주세요.",
    "⏰ 매일 같은 시간에 틀어주면 더 좋아요.",
    "💤 리듬 케어로 하루를 맡겨보세요.",
  ];

  int _currentIndex = 0;
  Timer? _timer;
  late List<int> _shuffledIndices;

  @override
  void initState() {
    super.initState();
    _shuffleAndStart();
  }

  void _shuffleAndStart() {
    // 랜덤 순서로 셔플
    _shuffledIndices = List.generate(_tips.length, (i) => i);
    _shuffledIndices.shuffle(Random());
    _currentIndex = 0;
    _startRolling();
  }

  void _startRolling() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _shuffledIndices.length;
          // 한 바퀴 돌면 다시 셔플
          if (_currentIndex == 0) {
            _shuffledIndices.shuffle(Random());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tipIndex = _shuffledIndices[_currentIndex];
    
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.5),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Row(
          key: ValueKey<int>(tipIndex),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 14.sp,
              color: AppColors.primaryBlue.withOpacity(0.7),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                _tips[tipIndex],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
