import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../../app/data/services/haptic_service.dart';
import 'dart:async';
import 'dart:math' as math;

/// 프리미엄 시네마틱 스플래시 스크린
/// "침묵 속에서 피어나는 치유의 빛과 소리"
/// 
/// 핵심 연출:
/// 1. 물리 기반 이징 (Elastic, Back, Cubic)
/// 2. 로고 드로잉 애니메이션 (선이 그려지는 효과)
/// 3. 블룸 폭발 + 펄스 임팩트
/// 4. 배경 연동 조명
class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with TickerProviderStateMixin {
  // 메인 시퀀스 컨트롤러 (전체 5초)
  late AnimationController _mainSequenceController;
  
  // 임팩트 효과 컨트롤러 (블룸 폭발 + 펄스)
  late AnimationController _impactController;
  
  // 개별 애니메이션
  late Animation<double> _particleAppear;    // Scene 1: 파티클 등장
  late Animation<double> _rippleExpand;      // Scene 2: 파동 확산
  late Animation<double> _logoDrawStroke;    // Scene 3a: 로고 선 그리기
  late Animation<double> _logoDrawFill;      // Scene 3b: 로고 채우기
  late Animation<double> _bloomEffect;       // Scene 4: 블룸 효과
  late Animation<double> _textAppear;        // Scene 5: 텍스트 등장
  late Animation<double> _backgroundGlow;    // 배경 연동 조명
  
  // 임팩트 애니메이션
  late Animation<double> _bloomFlash;        // 블룸 폭발
  late Animation<double> _logoPulse;         // 펄스 (크기 바운스)
  
  // 배경 파티클 시스템
  late AnimationController _particleController;
  final List<_Particle> _particles = [];
  
  bool _isTransitioning = false;
  bool _impactTriggered = false;
  
  // 색상 정의 - 프리미엄 시네마틱 테마
  static const Color _nightSkyColor = Color(0xFF0a0a2a);
  static const Color _deepSpaceColor = Color(0xFF050510);
  static const Color _particleBlue = Color(0xFF4A90E2);
  static const Color _auroraBlue = Color(0xFF2196F3);
  static const Color _auroraPurple = Color(0xFF9C27B0);
  static const Color _glowBlue = Color(0xFF64B5F6);
  static const Color _bloomWhite = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    
    // 메인 시퀀스 (3초 - 프로덕션 속도)
    _mainSequenceController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // 임팩트 컨트롤러 (0.5초)
    _impactController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Scene 1: 고요한 시작 → 파티클 등장 (0-0.12)
    _particleAppear = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.0, 0.12, curve: Curves.easeOutQuint),
      ),
    );
    
    // Scene 2: 빛의 파동 (0.10-0.35) - 부드러운 확산
    _rippleExpand = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.10, 0.35, curve: Curves.easeOutQuint),
      ),
    );
    
    // Scene 3a: 로고 스트로크 드로잉 (0.30-0.50)
    _logoDrawStroke = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.30, 0.50, curve: Curves.easeInOutCubic),
      ),
    );
    
    // Scene 3b: 로고 채우기 + 등장 (0.48-0.62) - Elastic Out 효과
    _logoDrawFill = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.48, 0.62, curve: _ElasticOutCurve()),
      ),
    );
    
    // Scene 4: 블룸 효과 (0.60-0.75)
    _bloomEffect = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.60, 0.75, curve: Curves.easeOut),
      ),
    );
    
    // 배경 글로우 연동 (로고와 함께)
    _backgroundGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.55, 0.80, curve: Curves.easeInOut),
      ),
    );
    
    // Scene 5: 텍스트 등장 (0.72-0.88) - Ease Out Cubic
    _textAppear = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.72, 0.88, curve: Curves.easeOutCubic),
      ),
    );
    
    // 임팩트 애니메이션 - 블룸 폭발
    _bloomFlash = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 80),
    ]).animate(CurvedAnimation(
      parent: _impactController,
      curve: Curves.easeOut,
    ));
    
    // 임팩트 애니메이션 - 펄스 (1.0 → 1.08 → 1.0)
    _logoPulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 0.98), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.98, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(
      parent: _impactController,
      curve: Curves.easeInOut,
    ));
    
    // 파티클 컨트롤러
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    
    // 파티클 생성
    _initParticles();
    
    // 햅틱 피드백
    try { Get.find<HapticService>().lightImpact(); } catch(_) {}
    
    // 애니메이션 시작
    _mainSequenceController.forward();
    
    // 임팩트 트리거 (로고 완성 시점)
    _mainSequenceController.addListener(() {
      if (_mainSequenceController.value >= 0.60 && !_impactTriggered) {
        _impactTriggered = true;
        _impactController.forward();
        try { Get.find<HapticService>().mediumImpact(); } catch(_) {}
      }
    });
    
    // 전환 예약 (4초 후)
    Timer(const Duration(milliseconds: 4000), () {
      _startTransition();
    });
  }
  
  void _initParticles() {
    final random = math.Random();
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 1.5 + random.nextDouble() * 3.5,
        speed: 0.2 + random.nextDouble() * 0.5,
        delay: random.nextDouble(),
        brightness: 0.3 + random.nextDouble() * 0.7,
      ));
    }
  }
  
  void _startTransition() {
    if (_isTransitioning) return;
    
    setState(() {
      _isTransitioning = true;
    });
    
    try { Get.find<HapticService>().mediumImpact(); } catch(_) {}
    
    Future.delayed(const Duration(milliseconds: 800), () {
      Get.offAllNamed(Routes.WELCOME);
    });
  }

  @override
  void dispose() {
    _mainSequenceController.dispose();
    _particleController.dispose();
    _impactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _deepSpaceColor,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainSequenceController,
          _particleController,
          _impactController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Layer 1: 밤하늘 배경 + 연동 조명
              _buildNightSkyBackground(),
              
              // Layer 2: 떠다니는 파티클들
              _buildFloatingParticles(),
              
              // Layer 3: 중앙 빛의 파동 (Ripple)
              _buildCentralRipple(),
              
              // Layer 4: 로고 드로잉 + 블룸 + 펄스
              _buildLogoWithEffects(),
              
              // Layer 5: 텍스트
              _buildBrandingText(),
              
              // Layer 6: 전환 효과
              if (_isTransitioning) _buildTransitionOverlay(),
            ],
          );
        },
      ),
    );
  }
  
  /// 밤하늘 배경 (로고와 연동되어 밝아짐)
  Widget _buildNightSkyBackground() {
    final glowIntensity = _backgroundGlow.value;
    final flashIntensity = _impactTriggered ? _bloomFlash.value * 0.4 : 0.0;
    final combinedGlow = (glowIntensity * 0.3 + flashIntensity).clamp(0.0, 0.6);
    
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2 + (glowIntensity * 0.5),
            colors: [
              Color.lerp(_nightSkyColor, _auroraBlue, combinedGlow)!,
              Color.lerp(_deepSpaceColor, _nightSkyColor, glowIntensity * 0.3)!,
              _deepSpaceColor,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
      ),
    );
  }
  
  /// 떠다니는 파티클들
  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ParticlePainter(
          particles: _particles,
          animationValue: _particleController.value,
          opacity: _particleAppear.value,
          color: _glowBlue,
          bloomIntensity: _impactTriggered ? _bloomFlash.value : 0.0,
        ),
      ),
    );
  }
  
  /// 중앙 빛의 파동
  Widget _buildCentralRipple() {
    return Center(
      child: SizedBox(
        width: 350,
        height: 350,
        child: CustomPaint(
          painter: _CinematicRipplePainter(
            rippleProgress: _rippleExpand.value,
            particleOpacity: _particleAppear.value,
            baseColor: _particleBlue,
            glowColor: _glowBlue,
            impactFlash: _impactTriggered ? _bloomFlash.value : 0.0,
          ),
        ),
      ),
    );
  }
  
  /// 로고 + 블룸 + 펄스 효과
  Widget _buildLogoWithEffects() {
    final strokeProgress = _logoDrawStroke.value;
    final fillProgress = _logoDrawFill.value;
    final bloomIntensity = _bloomEffect.value;
    final pulseScale = _impactTriggered ? _logoPulse.value : 1.0;
    final flashIntensity = _impactTriggered ? _bloomFlash.value : 0.0;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 펄스 스케일 + 블룸 박스 쉐도우
          Transform.scale(
            scale: pulseScale,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  // 블룸 폭발 플래시
                  if (flashIntensity > 0)
                    BoxShadow(
                      color: _bloomWhite.withOpacity(flashIntensity * 0.8),
                      blurRadius: 80 * flashIntensity,
                      spreadRadius: 40 * flashIntensity,
                    ),
                  // 오로라 블룸 효과
                  BoxShadow(
                    color: _auroraBlue.withOpacity(0.5 * bloomIntensity),
                    blurRadius: 50 * bloomIntensity,
                    spreadRadius: 25 * bloomIntensity,
                  ),
                  BoxShadow(
                    color: _auroraPurple.withOpacity(0.3 * bloomIntensity),
                    blurRadius: 70 * bloomIntensity,
                    spreadRadius: 35 * bloomIntensity,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _PremiumLogoPainter(
                  strokeProgress: strokeProgress,
                  fillProgress: fillProgress,
                  strokeColor: _glowBlue,
                  fillColor: Colors.white,
                  glowColor: _auroraBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  /// 브랜딩 텍스트 (Ease-Out-Cubic으로 부드럽게)
  Widget _buildBrandingText() {
    final textOpacity = _textAppear.value;
    // Back Out 커브로 약간 오버슈트 후 제자리
    final translateY = 30 * (1 - _BackOutCurve().transform(textOpacity.clamp(0.0, 1.0)));
    
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.22,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: textOpacity,
        child: Transform.translate(
          offset: Offset(0, translateY),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PetBeats 로고 텍스트
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [_auroraBlue, _glowBlue, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'PetBeats',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // 슬로건
              Text(
                'Bio-Acoustic Therapy for Pets',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.75),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 전환 오버레이
  Widget _buildTransitionOverlay() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.95),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 커스텀 이징 곡선
// ============================================================

/// Elastic Out 곡선 - 튕기는 듯한 오버슈트 효과
class _ElasticOutCurve extends Curve {
  const _ElasticOutCurve();
  
  @override
  double transformInternal(double t) {
    if (t == 0 || t == 1) return t;
    return math.pow(2, -10 * t) * math.sin((t - 0.075) * (2 * math.pi) / 0.3) + 1;
  }
}

/// Back Out 곡선 - 오버슈트 후 돌아오는 효과
class _BackOutCurve extends Curve {
  const _BackOutCurve();
  
  @override
  double transformInternal(double t) {
    const c1 = 1.70158;
    const c3 = c1 + 1;
    return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2);
  }
}

// ============================================================
// 파티클 시스템
// ============================================================

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;
  final double brightness;
  
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
    required this.brightness,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;
  final double opacity;
  final Color color;
  final double bloomIntensity;
  
  _ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.opacity,
    required this.color,
    required this.bloomIntensity,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final adjustedValue = (animationValue + particle.delay) % 1.0;
      
      // 사인파로 자연스러운 밝기 변화
      final twinkle = math.sin(adjustedValue * math.pi * 2) * 0.3 + 0.7;
      final particleOpacity = twinkle * opacity * particle.brightness * 0.7;
      
      // 블룸 시 파티클들도 반응
      final bloomBoost = 1.0 + bloomIntensity * 0.5;
      
      if (particleOpacity <= 0) continue;
      
      final x = particle.x * size.width;
      final y = (particle.y + adjustedValue * particle.speed * 0.2) % 1.0 * size.height;
      
      final paint = Paint()
        ..color = color.withOpacity((particleOpacity * bloomBoost).clamp(0.0, 1.0))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 + bloomIntensity * 2);
      
      canvas.drawCircle(Offset(x, y), particle.size * bloomBoost, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
           opacity != oldDelegate.opacity ||
           bloomIntensity != oldDelegate.bloomIntensity;
  }
}

// ============================================================
// 시네마틱 리플 페인터
// ============================================================

class _CinematicRipplePainter extends CustomPainter {
  final double rippleProgress;
  final double particleOpacity;
  final Color baseColor;
  final Color glowColor;
  final double impactFlash;
  
  _CinematicRipplePainter({
    required this.rippleProgress,
    required this.particleOpacity,
    required this.baseColor,
    required this.glowColor,
    required this.impactFlash,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    
    // 중앙 코어 (파티클 등장)
    if (particleOpacity > 0) {
      // 임팩트 플래시 시 더 밝게
      final coreIntensity = particleOpacity + impactFlash * 0.5;
      
      final corePaint = Paint()
        ..color = glowColor.withOpacity((coreIntensity * 0.9).clamp(0.0, 1.0))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15 + impactFlash * 10);
      
      final coreSize = 10 + (particleOpacity * 15) + (impactFlash * 20);
      canvas.drawCircle(center, coreSize, corePaint);
      
      // 더 밝은 중심점
      final brightCorePaint = Paint()
        ..color = Colors.white.withOpacity((particleOpacity * 0.9 + impactFlash * 0.3).clamp(0.0, 1.0));
      canvas.drawCircle(center, coreSize * 0.35, brightCorePaint);
    }
    
    // 파동 (Ripple) - 여러 개의 동심원
    if (rippleProgress > 0) {
      for (int i = 0; i < 5; i++) {
        final waveDelay = i * 0.15;
        final waveProgress = ((rippleProgress - waveDelay) / (1 - waveDelay)).clamp(0.0, 1.0);
        
        if (waveProgress <= 0) continue;
        
        // Ease Out Quint 적용
        final easedProgress = 1 - math.pow(1 - waveProgress, 5);
        final waveOpacity = (1 - easedProgress) * 0.4;
        final waveRadius = easedProgress * maxRadius;
        
        final wavePaint = Paint()
          ..color = baseColor.withOpacity(waveOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 + (1 - easedProgress) * 4
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        
        canvas.drawCircle(center, waveRadius, wavePaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant _CinematicRipplePainter oldDelegate) {
    return rippleProgress != oldDelegate.rippleProgress ||
           particleOpacity != oldDelegate.particleOpacity ||
           impactFlash != oldDelegate.impactFlash;
  }
}

// ============================================================
// 프리미엄 로고 페인터 (드로잉 애니메이션)
// ============================================================

class _PremiumLogoPainter extends CustomPainter {
  final double strokeProgress;  // 선 그리기 진행률
  final double fillProgress;    // 채우기 진행률
  final Color strokeColor;
  final Color fillColor;
  final Color glowColor;
  
  _PremiumLogoPainter({
    required this.strokeProgress,
    required this.fillProgress,
    required this.strokeColor,
    required this.fillColor,
    required this.glowColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final heartSize = 35.0;
    
    // 하트 패스 생성
    final heartPath = _createHeartPath(center, heartSize);
    
    // 1단계: 선 그리기 (strokeProgress에 따라)
    if (strokeProgress > 0) {
      final pathMetrics = heartPath.computeMetrics().first;
      final drawLength = pathMetrics.length * strokeProgress;
      final extractedPath = pathMetrics.extractPath(0, drawLength);
      
      // 글로우 효과
      final glowPaint = Paint()
        ..color = glowColor.withOpacity(0.6 * strokeProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
      canvas.drawPath(extractedPath, glowPaint);
      
      // 메인 스트로크
      final strokePaint = Paint()
        ..color = strokeColor.withOpacity(strokeProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      
      canvas.drawPath(extractedPath, strokePaint);
      
      // 선 끝에 밝은 점 (드로잉 포인트)
      if (strokeProgress < 1.0) {
        final tangent = pathMetrics.getTangentForOffset(drawLength);
        if (tangent != null) {
          final pointPaint = Paint()
            ..color = Colors.white
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
          canvas.drawCircle(tangent.position, 4, pointPaint);
        }
      }
    }
    
    // 2단계: 채우기 (fillProgress에 따라)
    if (fillProgress > 0) {
      // 글로우
      final glowPaint = Paint()
        ..color = glowColor.withOpacity(0.4 * fillProgress)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      
      canvas.drawPath(heartPath, glowPaint);
      
      // 채우기
      final fillPaint = Paint()
        ..color = fillColor.withOpacity(fillProgress)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(heartPath, fillPaint);
    }
    
    // 3단계: 사운드 웨이브 아이콘 (fillProgress > 0.3)
    if (fillProgress > 0.3) {
      final waveProgress = ((fillProgress - 0.3) / 0.7).clamp(0.0, 1.0);
      _drawSoundWaves(canvas, center, waveProgress);
    }
  }
  
  Path _createHeartPath(Offset center, double size) {
    final path = Path();
    
    path.moveTo(center.dx, center.dy - size * 0.25);
    
    // 왼쪽 곡선
    path.cubicTo(
      center.dx - size * 0.8, center.dy - size * 0.9,
      center.dx - size * 1.0, center.dy + size * 0.2,
      center.dx, center.dy + size * 0.9,
    );
    
    // 오른쪽 곡선
    path.cubicTo(
      center.dx + size * 1.0, center.dy + size * 0.2,
      center.dx + size * 0.8, center.dy - size * 0.9,
      center.dx, center.dy - size * 0.25,
    );
    
    path.close();
    return path;
  }
  
  void _drawSoundWaves(Canvas canvas, Offset center, double progress) {
    final wavePaint = Paint()
      ..color = strokeColor.withOpacity(0.8 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 3; i++) {
      final waveDelay = i * 0.2;
      final waveProgress = ((progress - waveDelay) / (1 - waveDelay)).clamp(0.0, 1.0);
      
      if (waveProgress <= 0) continue;
      
      final waveRadius = 48 + i * 12.0;
      final rect = Rect.fromCircle(center: center, radius: waveRadius);
      
      // Ease Out으로 부드럽게
      final easedProgress = 1 - math.pow(1 - waveProgress, 3);
      
      canvas.drawArc(
        rect,
        -math.pi / 3.5,
        math.pi / 1.75 * easedProgress,
        false,
        wavePaint..color = strokeColor.withOpacity(0.7 * easedProgress),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant _PremiumLogoPainter oldDelegate) {
    return strokeProgress != oldDelegate.strokeProgress ||
           fillProgress != oldDelegate.fillProgress;
  }
}
