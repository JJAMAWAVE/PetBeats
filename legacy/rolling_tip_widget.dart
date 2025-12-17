import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class RollingTipWidget extends StatefulWidget {
  const RollingTipWidget({super.key});

  @override
  State<RollingTipWidget> createState() => _RollingTipWidgetState();
}

class _RollingTipWidgetState extends State<RollingTipWidget> {
  final List<String> _tips = [
    "✋ 손뼈를 통해 전해지는 진동(골전도)이 아이에겐 가장 편안해요.",
    "🔥 폰이 따뜻해지면 진동을 끄고 음악만 들려주세요.",
    "💆‍♀️ 보호자의 손길이 더해질 때 치유 효과가 배가됩니다.",
    "💤 아이가 잠들면 진동을 멈추고 편안하게 해주세요.",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRolling();
  }

  void _startRolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _tips.length;
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
          key: ValueKey<int>(_currentIndex),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tips_and_updates,
              size: 14.sp,
              color: AppColors.primaryBlue.withOpacity(0.7),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                _tips[_currentIndex],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12.sp,
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
