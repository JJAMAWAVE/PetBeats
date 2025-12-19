import 'dart:async';
import 'package:get/get.dart';
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
    'rolling_tip_1',
    'rolling_tip_2',
    'rolling_tip_3',
    'rolling_tip_4',
    'rolling_tip_5',
    'rolling_tip_6',
    'rolling_tip_7',
    'rolling_tip_8',
    'rolling_tip_9',
    'rolling_tip_10',
    'rolling_tip_11',
    'rolling_tip_12',
    'rolling_tip_13',
    'rolling_tip_14',
    'rolling_tip_15',
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
                _tips[tipIndex].tr,
                style: TextStyle(
                color: AppColors.textGrey,
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
