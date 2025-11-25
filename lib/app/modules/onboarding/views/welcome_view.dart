
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

import '../../../../core/widgets/background_decoration.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _beatController; // 비트 애니메이션용 컨트롤러
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 1. 텍스트 스케일 애니메이션 (기존)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 2. 비트 라인 애니메이션 (신규)
    _beatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 3초마다 한 번씩
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _beatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: BackgroundDecoration(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // 로고 영역 (아이콘 + 텍스트) - 전체 스케일 애니메이션 적용
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 아이콘 (심박수/하트) - 새로운 이미지 + 비트 애니메이션
                      Hero(
                        tag: 'app_logo', // 로고 태그 설정
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/logo_icon_new.png',
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // 비트 애니메이션 (아이콘 위에 오버레이)
                              SizedBox(
                                width: 140,
                                height: 140,
                                child: ClipOval(
                                  child: AnimatedBuilder(
                                    animation: _beatController,
                                    builder: (context, child) {
                                      return CustomPaint(
                                        painter: BeatLinePainter(
                                          animationValue: _beatController.value,
                                          color: Colors.white.withOpacity(0.9), // 밝은 흰색 라인
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 메인 로고 텍스트
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pet, // 'Pet'
                            style: AppTextStyles.logo,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.beats, // 'Beats'
                            style: AppTextStyles.logo.copyWith(
                              color: AppColors.secondaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 부제 (애니메이션 제외)
                Text(
                  AppLocalizations.of(context)!.subtitle, // 'Bio-Acoustic Therapy...'
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                CustomButton(
                  text: AppLocalizations.of(context)!.getStarted, // 'Get Started'
                  onPressed: () => Get.toNamed(Routes.ONBOARDING),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 심전도(EKG) 라인을 그리는 Painter
class BeatLinePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  BeatLinePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // 애니메이션 속도 2배 증가: 0.0 ~ 0.25 구간에서만 비트가 지나가도록 함 (전체 3초 중 0.75초)
    if (animationValue > 0.25) return;

    // 0.0 ~ 0.25 범위를 0.0 ~ 1.0으로 정규화
    final progress = animationValue * 4.0;

    // 1. 광원 효과 (Glow) - 뒤에 먼저 그림
    final glowPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0 // 더 굵게
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10); // 블러 효과

    // 2. 메인 라인
    final mainPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color,
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    // 심전도 경로 정의
    path.moveTo(0, midY);
    path.lineTo(w * 0.2, midY);
    path.lineTo(w * 0.25, midY - 10); // P wave
    path.lineTo(w * 0.3, midY + 10);
    path.lineTo(w * 0.35, midY);
    path.lineTo(w * 0.4, midY - 40); // QRS complex (High peak)
    path.lineTo(w * 0.45, midY + 30);
    path.lineTo(w * 0.5, midY);
    path.lineTo(w * 0.6, midY + 15); // T wave
    path.lineTo(w * 0.7, midY);
    path.lineTo(w, midY);

    // PathMetric을 사용하여 경로의 일부만 그림
    final pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      final length = metric.length;
      // 비트가 '지나가는' 효과
      final start = length * (progress - 0.3); 
      final end = length * progress; 
      
      final extractPath = metric.extractPath(
        start < 0 ? 0 : start,
        end > length ? length : end,
      );
      
      // Glow 그리기
      canvas.drawPath(extractPath, glowPaint);
      // 메인 라인 그리기
      canvas.drawPath(extractPath, mainPaint..shader = null);
    }
  }

  @override
  bool shouldRepaint(covariant BeatLinePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
