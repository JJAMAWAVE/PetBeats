import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/mini_player.dart';
import '../../premium/controllers/subscription_controller.dart';
import '../../../routes/app_routes.dart';

class SitterSpecialView extends StatefulWidget {
  const SitterSpecialView({super.key});

  @override
  State<SitterSpecialView> createState() => _SitterSpecialViewState();
}

class _SitterSpecialViewState extends State<SitterSpecialView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _introSlides = [
    {
      'image': 'assets/images/sitter/intro_empathy.png',
      'title': 'sitter_slide1_title'.tr,
      'subtitle': 'sitter_slide1_desc'.tr,
    },
    {
      'image': 'assets/images/sitter/intro_solution.png',
      'title': 'sitter_slide2_title'.tr,
      'subtitle': 'sitter_slide2_desc'.tr,
    },
    {
      'image': 'assets/images/sitter/intro_active_care.png',
      'title': 'sitter_slide3_title'.tr,
      'subtitle': 'sitter_slide3_desc'.tr,
    },
    {
      'image': 'assets/images/sitter/intro_reassurance.png',
      'title': 'sitter_slide4_title'.tr,
      'subtitle': 'sitter_slide4_desc'.tr,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isPremium {
    try {
      final controller = Get.find<SubscriptionController>();
      return controller.isPremium.value;
    } catch (_) {
      return false;
    }
  }

  void _onCTAPressed() {
    if (_isPremium) {
      Get.toNamed(Routes.SITTER_SETUP);
    } else {
      Get.toNamed(Routes.SUBSCRIPTION);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('sitter_title'.tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 캐러셀 with Card Stack Effect
              Expanded(
                child: Stack(
                  children: [
                    // Background cards (stacked effect)
                    ...List.generate(2, (i) {
                      final bgIndex = _currentPage + i + 1;
                      if (bgIndex >= _introSlides.length) return const SizedBox.shrink();
                      return Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Transform.translate(
                            offset: Offset(0, (i + 1) * 10.0),
                            child: Transform.scale(
                              scale: 1.0 - ((i + 1) * 0.04),
                              alignment: Alignment.topCenter,
                              child: Opacity(
                                opacity: 0.25 - (i * 0.1),
                                child: Container(
                                  margin: EdgeInsets.only(top: 8.h, bottom: 24.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    // Main PageView
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _introSlides.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return _buildSlideWithEffect(index);
                      },
                    ),
                  ],
                ),
              ),
              
              // 페이지 인디케이터
              _buildPageIndicator(),
              
              SizedBox(height: 16.h),
              
              // CTA 버튼
              _buildCTAButton(),
              
              SizedBox(height: 100.h), // 미니플레이어 공간
            ],
          ),
          
          // 미니플레이어
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const MiniPlayer(),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideWithEffect(int index) {
    final slide = _introSlides[index];
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          // 이미지 카드 + 이펙트 오버레이
          Container(
            width: double.infinity,
            height: 260.h,
            margin: EdgeInsets.only(top: 8.h, bottom: 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 이미지
                  Image.asset(
                    slide['image']!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.pets,
                          size: 64.w,
                          color: AppColors.primaryBlue.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                  // 이펙트 오버레이
                  if (index == 0) _SadParticleOverlay(active: _currentPage == 0),
                  if (index == 1) _ProtectionWaveOverlay(active: _currentPage == 1),
                  if (index == 2) _MusicWaveOverlay(active: _currentPage == 2),
                  if (index == 3) _WarmHeartOverlay(active: _currentPage == 3),
                ],
              ),
            ),
          ),
          
          // 메인 카피
          Text(
            slide['title']!,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkNavy,
              height: 1.4,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // 서브 카피
          Text(
            slide['subtitle']!,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textGrey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _introSlides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: _currentPage == index ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primaryBlue
                : AppColors.primaryBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }

  Widget _buildCTAButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: GetBuilder<SubscriptionController>(
          init: Get.isRegistered<SubscriptionController>() 
              ? Get.find<SubscriptionController>()
              : Get.put(SubscriptionController()),
          builder: (controller) {
            final isPremium = controller.isPremium.value;
            return ElevatedButton(
              onPressed: () {
                if (isPremium) {
                  Get.toNamed(Routes.SITTER_SETUP);
                } else {
                  Get.toNamed(Routes.SUBSCRIPTION);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 4,
                shadowColor: AppColors.primaryBlue.withOpacity(0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isPremium ? Icons.shield_outlined : Icons.lock, size: 22.w),
                  SizedBox(width: 8.w),
                  Text(
                    isPremium ? 'sitter_start_btn'.tr : 'sitter_pro_btn'.tr,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ========================================
// 슬라이드 1: 쓸쓸한 파티클 효과 (공감)
// ========================================
class _SadParticleOverlay extends StatefulWidget {
  final bool active;
  const _SadParticleOverlay({required this.active});

  @override
  State<_SadParticleOverlay> createState() => _SadParticleOverlayState();
}

class _SadParticleOverlayState extends State<_SadParticleOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _SadParticlePainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _SadParticlePainter extends CustomPainter {
  final double progress;
  
  _SadParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5C6BC0).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // 떨어지는 작은 파티클들
    for (int i = 0; i < 8; i++) {
      final x = size.width * (0.1 + i * 0.12);
      final fallProgress = ((progress + i * 0.125) % 1.0);
      final y = size.height * fallProgress;
      final opacity = (1.0 - fallProgress) * 0.5;
      
      paint.color = const Color(0xFF5C6BC0).withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 2 + i % 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SadParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ========================================
// 슬라이드 2: 보호 파동 효과 (솔루션)
// ========================================
class _ProtectionWaveOverlay extends StatefulWidget {
  final bool active;
  const _ProtectionWaveOverlay({required this.active});

  @override
  State<_ProtectionWaveOverlay> createState() => _ProtectionWaveOverlayState();
}

class _ProtectionWaveOverlayState extends State<_ProtectionWaveOverlay> with SingleTickerProviderStateMixin {
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
    if (!widget.active) return const SizedBox();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ProtectionWavePainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _ProtectionWavePainter extends CustomPainter {
  final double progress;
  
  _ProtectionWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.4, size.height * 0.5);
    
    // 3개의 확산 원
    for (int i = 0; i < 3; i++) {
      final waveProgress = ((progress + i * 0.33) % 1.0);
      final radius = 20 + waveProgress * 60;
      final opacity = (1.0 - waveProgress) * 0.4;
      
      final paint = Paint()
        ..color = const Color(0xFF5C6BC0).withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProtectionWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ========================================
// 슬라이드 3: 음악 파동 효과 (케어)
// ========================================
class _MusicWaveOverlay extends StatefulWidget {
  final bool active;
  const _MusicWaveOverlay({required this.active});

  @override
  State<_MusicWaveOverlay> createState() => _MusicWaveOverlayState();
}

class _MusicWaveOverlayState extends State<_MusicWaveOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _MusicWavePainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _MusicWavePainter extends CustomPainter {
  final double progress;
  
  _MusicWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5C6BC0).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 음악 파형 (사인 웨이브)
    final path = Path();
    final centerY = size.height * 0.7;
    
    path.moveTo(0, centerY);
    for (double x = 0; x < size.width; x += 2) {
      final wave = 8 * (1 + 0.5 * (1 + (((progress * 4 + x / 30) % 1.0) - 0.5).abs()));
      final y = centerY + wave * (x / size.width > 0.5 ? -1 : 1) * 
          (0.5 + 0.5 * ((progress * 2 + x / 50) % 1.0)).clamp(0.3, 1.0);
      path.lineTo(x, y);
    }
    
    canvas.drawPath(path, paint);
    
    // 음표 아이콘 효과
    final noteProgress = (progress * 2) % 1.0;
    final noteY = size.height * 0.3 - noteProgress * 30;
    final noteOpacity = noteProgress < 0.7 ? 0.5 : (1.0 - noteProgress) / 0.3 * 0.5;
    
    final notePaint = Paint()
      ..color = const Color(0xFF5C6BC0).withOpacity(noteOpacity);
    
    canvas.drawCircle(Offset(size.width * 0.7, noteY), 4, notePaint);
  }

  @override
  bool shouldRepaint(covariant _MusicWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ========================================
// 슬라이드 4: 따뜻한 하트 효과 (안심)
// ========================================
class _WarmHeartOverlay extends StatefulWidget {
  final bool active;
  const _WarmHeartOverlay({required this.active});

  @override
  State<_WarmHeartOverlay> createState() => _WarmHeartOverlayState();
}

class _WarmHeartOverlayState extends State<_WarmHeartOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _WarmHeartPainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _WarmHeartPainter extends CustomPainter {
  final double progress;
  
  _WarmHeartPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.55);
    
    // 따뜻한 글로우 효과
    final glowRadius = 40 + progress * 20;
    final glowOpacity = 0.15 + progress * 0.1;
    
    final glowPaint = Paint()
      ..color = const Color(0xFFFF6B6B).withOpacity(glowOpacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 + progress * 10);
    
    canvas.drawCircle(center, glowRadius, glowPaint);
    
    // 작은 하트 파티클
    for (int i = 0; i < 3; i++) {
      final angle = (progress + i * 0.33) * 3.14159 * 2;
      final distance = 30 + progress * 20;
      final heartX = center.dx + distance * 0.5 * (i - 1);
      final heartY = center.dy - 20 - progress * 15 - i * 10;
      final heartOpacity = (1.0 - progress) * 0.4;
      
      final heartPaint = Paint()
        ..color = const Color(0xFFFF6B6B).withOpacity(heartOpacity);
      
      canvas.drawCircle(Offset(heartX, heartY), 3 - i * 0.5, heartPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WarmHeartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
