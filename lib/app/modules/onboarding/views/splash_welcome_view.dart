import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;
import '../../../../core/widgets/background_decoration.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import 'onboarding_view.dart';

class SplashWelcomeView extends StatefulWidget {
  const SplashWelcomeView({super.key});

  @override
  State<SplashWelcomeView> createState() => _SplashWelcomeViewState();
}

class _SplashWelcomeViewState extends State<SplashWelcomeView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textFlowController;
  late AnimationController _transitionController; // 전환 애니메이션
  late AnimationController _scaleController; // 터치 반응 스케일 애니메이션
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool _isTransitioning = false; // 전환 중 플래그

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _textFlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 3초로 늘려 부드럽게
    );

    // 터치 반응을 위한 스케일 컨트롤러 (점성 느낌)
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // 끈적하게 복귀하는 시간
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // 끈적한 탄성 효과 (눌렸다가 띠용~ 하고 돌아오는 느낌)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _scaleController, 
        curve: Curves.elasticOut, // 탄성 있는 커브
        reverseCurve: Curves.easeOutQuad, // 눌릴 때는 빠르게
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textFlowController.dispose();
    _transitionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _navigateToNext() async {
    if (_isTransitioning) return;
    
    setState(() {
      _isTransitioning = true;
    });

    _transitionController.forward();
    
    Future.delayed(const Duration(milliseconds: 1800), () {
      Get.offNamed(Routes.ONBOARDING);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 메인 컨텐츠
          GestureDetector(
            onTapDown: (_) {
              if (!_isTransitioning) {
                _scaleController.forward(); // 누르면 끈적하게 들어감
              }
            },
            onTapUp: (_) {
              if (!_isTransitioning) {
                _scaleController.reverse(); // 떼면 띠용~ 하고 나옴
                _navigateToNext();
              }
            },
            onTapCancel: () {
              if (!_isTransitioning) {
                _scaleController.reverse();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: BackgroundDecoration(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      
                      const Spacer(flex: 2),
                      
                      // 텍스트 진동 효과 적용
                      AnimatedBuilder(
                        animation: _transitionController,
                        builder: (context, child) {
                          // 진동 효과 (0~1 사이에서만 적용)
                          final shake = _isTransitioning 
                              ? (math.sin(_transitionController.value * 20) * 3 * (1 - _transitionController.value))
                              : 0.0;
                          
                          return Transform.translate(
                            offset: Offset(shake, 0),
                            child: AnimatedBuilder(
                              animation: _textFlowController,
                              builder: (context, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildAnimatedHeroText("Relax", 0),
                                    const SizedBox(height: 8),
                                    _buildAnimatedHeroText("Sleep", 1),
                                    const SizedBox(height: 24),
                                    _buildAnimatedHeroText("Heal", 2),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                
                      const Spacer(flex: 5),
                      
                      Column(
                        children: [
                          Text(
                            "PetBeats",
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.primaryBlue,
                              fontSize: 28,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          IgnorePointer( // 배지 전체의 터치 무시
                            child: _ShimmerBadge(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppColors.primaryBlue,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "FREE EDITION",
                                  style: GoogleFonts.notoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                    letterSpacing: 3.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          Text(
                            AppLocalizations.of(context)!.subtitle.replaceAll('\n', ' '),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 48),
                          
                          AnimatedBuilder(
                            animation: _opacityAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _opacityAnimation.value,
                                child: Text(
                                  AppLocalizations.of(context)!.tapToStart,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 진동파 애니메이션 레이어
          if (_isTransitioning)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _transitionController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RippleWavePainter(
                        animationValue: _transitionController.value,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHeroText(String text, int index) {
    final double value = _textFlowController.value;
    
    final double targetPos = (index * 0.33) + 0.16;
    double dist = (value - targetPos).abs();
    if (dist > 0.5) dist = 1.0 - dist;
    
    double opacity = 1.0 - (dist * 2.5); 
    opacity = opacity.clamp(0.3, 1.0);
    
    final double t = (opacity - 0.3) / 0.7;
    
    Color color;
    if (t < 0.5) {
      color = Color.lerp(AppColors.secondarySoftBlue, AppColors.secondaryBlue, t * 2)!;
    } else {
      color = Color.lerp(AppColors.secondaryBlue, AppColors.primaryBlue, (t - 0.5) * 2)!;
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSans(
          fontSize: 84,
          fontWeight: FontWeight.w900,
          color: color.withOpacity(opacity),
          height: 0.9,
          letterSpacing: -3.0,
        ),
      ),
    );
  }
}

class _ShimmerBadge extends StatefulWidget {
  final Widget child;
  const _ShimmerBadge({super.key, required this.child});

  @override
  State<_ShimmerBadge> createState() => _ShimmerBadgeState();
}

class _ShimmerBadgeState extends State<_ShimmerBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        
        return Stack(
          children: [
            // 기본 배지 (흰색 배경 + 파란색 텍스트)
            widget.child,
            
            // 움직이는 빛 효과
            Positioned.fill(
              child: IgnorePointer( // 터치 이벤트 통과시키기
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      // -1.0에서 2.0까지 이동
                      final position = -1.0 + (progress * 3.0);
                      
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              0.0,
                              (position - 0.2).clamp(0.0, 1.0),
                              (position - 0.05).clamp(0.0, 1.0),
                              position.clamp(0.0, 1.0),
                              (position + 0.05).clamp(0.0, 1.0),
                              (position + 0.2).clamp(0.0, 1.0),
                              1.0,
                            ],
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.7), // 최대 opacity 증가
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// 진동파 애니메이션 Painter
class RippleWavePainter extends CustomPainter {
  final double animationValue;

  RippleWavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // 화면 대각선 길이의 1.5배로 설정하여 확실하게 화면 밖까지 나감
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height) * 1.5;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 파동 개수 8개
    final int waveCount = 8;

    // 두께 베리에이션 (점점 두꺼워지도록)
    final List<double> baseThicknesses = [2.0, 10.0, 5.0, 30.0, 15.0, 50.0, 20.0, 100.0];
    
    // 속도 베리에이션
    final List<double> speedMultipliers = [1.0, 0.8, 1.1, 0.9, 1.2, 0.7, 1.0, 0.6];

    // 힐링/테라피 느낌의 은은한 파스텔 톤 색상 팔레트 (채도를 낮추고 명도를 높임)
    final List<Color> colors = [
      const Color(0xFFB0E0E6), // PowderBlue (은은한 하늘색)
      const Color(0xFFE6E6FA), // Lavender (연한 보라색)
      const Color(0xFFAFEEEE), // PaleTurquoise (연한 청록색)
      const Color(0xFFB0C4DE), // LightSteelBlue (차분한 블루)
      const Color(0xFFE0FFFF), // LightCyan (맑은 느낌)
      const Color(0xFFD8BFD8), // Thistle (연한 분홍보라)
      const Color(0xFF87CEFA).withOpacity(0.5), // LightSkyBlue (맑은 하늘, 투명도 추가)
      Colors.white, // 마지막은 흰색으로 화면을 덮음
    ];

    for (int i = 0; i < waveCount; i++) {
      double normalizedIndex = i / waveCount;
      
      // 시간차
      double startDelay = normalizedIndex * 0.2; 
      
      // 속도 적용
      double speed = speedMultipliers[i % speedMultipliers.length];
      
      // 진행률
      double progress = (animationValue - startDelay) * (1.2 * speed);
      
      if (progress < 0.0) continue;

      // 점성 느낌의 커브 (초반에 끈적하게 느리게 출발했다가 퍼짐)
      // Cubic Ease InOut과 유사한 곡선 사용
      double t = progress.clamp(0.0, 1.0);
      double easeProgress = t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
      
      final radius = maxRadius * easeProgress;
      
      // 투명도: 전체적으로 훨씬 은은하게 수정
      double opacity = 1.0;
      if (progress < 0.1) {
        opacity = progress * 10.0; 
      } else if (progress > 0.8) {
        if (i == waveCount - 1) {
          opacity = 1.0; 
        } else {
          opacity = (1.0 - progress) * 5.0; 
        }
      }
      
      // 일반 파동은 최대 0.4로 제한하여 강한 느낌 제거 (기존 0.8)
      if (i != waveCount - 1) {
        opacity = opacity.clamp(0.0, 0.4);
      } else {
        // 마지막 흰색 파동은 화면을 덮어야 하므로 1.0까지 허용
        opacity = opacity.clamp(0.0, 1.0);
      }
      
      // 마지막 파동은 전환을 위해 불투명하게 유지
      if (i == waveCount - 1 && progress > 0.5) {
        opacity = 1.0;
      }

      // 두께: 퍼질수록 매우 두꺼워짐
      double currentBaseThickness = baseThicknesses[i % baseThicknesses.length];
      double strokeWidth = currentBaseThickness + (maxRadius * 0.5 * progress); 

      // 마지막 파동은 Fill 스타일
      if (i == waveCount - 1) {
        paint.style = PaintingStyle.fill;
      } else {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = strokeWidth;
      }

      paint.color = colors[i % colors.length].withOpacity(opacity);

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(RippleWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
