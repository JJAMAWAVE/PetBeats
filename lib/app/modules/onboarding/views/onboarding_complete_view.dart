import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import 'dart:async';
import 'dart:math' as math;

/// 온보딩 완료 후 홈으로 전환되는 로딩 화면
class OnboardingCompleteView extends StatefulWidget {
  const OnboardingCompleteView({super.key});

  @override
  State<OnboardingCompleteView> createState() => _OnboardingCompleteViewState();
}

class _OnboardingCompleteViewState extends State<OnboardingCompleteView>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _fadeIn;
  late Animation<double> _scale;
  late Animation<double> _pulse;
  
  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _pulse = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    _mainController.forward();
    
    // 3초 후 홈으로 이동
    Timer(const Duration(milliseconds: 3000), () {
      Get.offAllNamed(Routes.HOME);
    });
  }
  
  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _pulseController]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.white,
                  AppColors.primaryBlue.withOpacity(0.05),
                  AppColors.primaryBlue.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: _fadeIn.value,
                child: Transform.scale(
                  scale: _scale.value * _pulse.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 하트 + 사운드 웨이브 아이콘
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 60.w,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      
                      SizedBox(height: 32.h),
                      
                      // 메시지
                      Text(
                        '맞춤 케어를 준비하고 있어요',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textDarkNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      Text(
                        '반려동물에게 최적화된 사운드를\n준비중입니다...',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textGrey,
                          height: 1.5,
                        ),
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // 로딩 인디케이터
                      SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
