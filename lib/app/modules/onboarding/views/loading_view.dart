import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../../app/data/services/haptic_service.dart';
import 'dart:async';
import 'dart:math' as math;

/// 시네마틱 스플래시 스크린 - "침묵 속에서 피어나는 치유의 빛과 소리"
class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with TickerProviderStateMixin {
  // 메인 시퀀스 컨트롤러 (전체 3초)
  late AnimationController _mainSequenceController;
  
  // 개별 애니메이션
  late Animation<double> _particleAppear;    // 0-0.15: 파티클 등장
  late Animation<double> _rippleExpand;      // 0.15-0.5: 파동 확산
  late Animation<double> _logoAppear;        // 0.5-0.75: 로고 그려짐
  late Animation<double> _bloomEffect;       // 0.75-0.9: 블룸 효과
  late Animation<double> _textAppear;        // 0.85-1.0: 텍스트 등장
  late Animation<double> _sceneTransition;   // 홈 화면 전환
  
  // 배경 파티클 시스템
  late AnimationController _particleController;
  final List<_Particle> _particles = [];
  
  // 로고 라인 그리기 애니메이션
  late AnimationController _logoDrawController;
  
  bool _isTransitioning = false;
  
  // 색상 정의 - 시네마틱 테마
  static const Color _nightSkyColor = Color(0xFF0a0a2a);
  static const Color _particleBlue = Color(0xFF4A90E2);
  static const Color _auroraBlue = Color(0xFF2196F3);
  static const Color _auroraPurple = Color(0xFF9C27B0);
  static const Color _glowBlue = Color(0xFF64B5F6);

  @override
  void initState() {
    super.initState();
    
    // 메인 시퀀스 (3초)
    _mainSequenceController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Scene 1: 고요한 시작 → 파티클 등장 (0-0.15)
    _particleAppear = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
      ),
    );
    
    // Scene 2: 빛의 파동 (0.15-0.5)
    _rippleExpand = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.15, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    
    // Scene 3: 로고 개화 (0.5-0.75)
    _logoAppear = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.5, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    
    // Scene 3.5: 블룸 효과 (0.75-0.9)
    _bloomEffect = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.75, 0.9, curve: Curves.easeOut),
      ),
    );
    
    // Scene 4: 텍스트 등장 (0.85-1.0)
    _textAppear = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // 전환 애니메이션
    _sceneTransition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainSequenceController,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    // 파티클 컨트롤러
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    // 로고 그리기 컨트롤러
    _logoDrawController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // 파티클 생성
    _initParticles();
    
    // 햅틱 피드백
    try { Get.find<HapticService>().lightImpact(); } catch(_) {}
    
    // 애니메이션 시작
    _mainSequenceController.forward();
    
    // 로고 그리기는 Scene 3에서 시작
    Future.delayed(const Duration(milliseconds: 1500), () {
      _logoDrawController.forward();
    });
    
    // 전환 예약 (3.5초 후)
    Timer(const Duration(milliseconds: 3500), () {
      _startTransition();
    });
  }
  
  void _initParticles() {
    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 4,
        speed: 0.3 + random.nextDouble() * 0.7,
        delay: random.nextDouble(),
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
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void dispose() {
    _mainSequenceController.dispose();
    _particleController.dispose();
    _logoDrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _nightSkyColor,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainSequenceController,
          _particleController,
          _logoDrawController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Layer 1: 밤하늘 배경 + 점진적 밝아짐
              _buildNightSkyBackground(),
              
              // Layer 2: 떠다니는 파티클들
              _buildFloatingParticles(),
              
              // Layer 3: 중앙 빛의 파동 (Ripple)
              _buildCentralRipple(),
              
              // Layer 4: 로고 + 블룸 효과
              _buildLogoWithBloom(),
              
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
  
  /// 밤하늘 배경 (점진적으로 밝아짐)
  Widget _buildNightSkyBackground() {
    final brightness = _bloomEffect.value * 0.3;
    
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color.lerp(_nightSkyColor, _particleBlue, brightness)!,
              _nightSkyColor,
            ],
            stops: const [0.0, 1.0],
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
        ),
      ),
    );
  }
  
  /// 중앙 빛의 파동
  Widget _buildCentralRipple() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: _CinematicRipplePainter(
            rippleProgress: _rippleExpand.value,
            particleOpacity: _particleAppear.value,
            baseColor: _particleBlue,
            glowColor: _glowBlue,
          ),
        ),
      ),
    );
  }
  
  /// 로고 + 블룸 효과
  Widget _buildLogoWithBloom() {
    final logoOpacity = _logoAppear.value;
    final bloomIntensity = _bloomEffect.value;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 로고 컨테이너 with 블룸
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                // 오로라 블룸 효과
                BoxShadow(
                  color: _auroraBlue.withOpacity(0.4 * bloomIntensity),
                  blurRadius: 40 * bloomIntensity,
                  spreadRadius: 20 * bloomIntensity,
                ),
                BoxShadow(
                  color: _auroraPurple.withOpacity(0.2 * bloomIntensity),
                  blurRadius: 60 * bloomIntensity,
                  spreadRadius: 30 * bloomIntensity,
                ),
              ],
            ),
            child: Opacity(
              opacity: logoOpacity,
              child: CustomPaint(
                painter: _LogoPainter(
                  drawProgress: _logoDrawController.value,
                  color: Colors.white,
                  glowColor: _glowBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
  
  /// 브랜딩 텍스트
  Widget _buildBrandingText() {
    final textOpacity = _textAppear.value;
    
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.25,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: textOpacity,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - textOpacity)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PetBeats 로고 텍스트
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_auroraBlue, _glowBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'PetBeats',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 슬로건
              Text(
                'Bio-Acoustic Therapy for Pets',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 1.5,
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
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}

/// 파티클 클래스
class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;
  
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

/// 파티클 페인터
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;
  final double opacity;
  final Color color;
  
  _ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.opacity,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final adjustedValue = (animationValue + particle.delay) % 1.0;
      final particleOpacity = math.sin(adjustedValue * math.pi) * opacity * 0.6;
      
      if (particleOpacity <= 0) continue;
      
      final x = particle.x * size.width;
      final y = (particle.y + adjustedValue * particle.speed * 0.3) % 1.0 * size.height;
      
      final paint = Paint()
        ..color = color.withOpacity(particleOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
           opacity != oldDelegate.opacity;
  }
}

/// 시네마틱 리플 페인터
class _CinematicRipplePainter extends CustomPainter {
  final double rippleProgress;
  final double particleOpacity;
  final Color baseColor;
  final Color glowColor;
  
  _CinematicRipplePainter({
    required this.rippleProgress,
    required this.particleOpacity,
    required this.baseColor,
    required this.glowColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    
    // 중앙 코어 (파티클 등장)
    if (particleOpacity > 0) {
      final corePaint = Paint()
        ..color = glowColor.withOpacity(particleOpacity * 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      
      final coreSize = 8 + (particleOpacity * 12);
      canvas.drawCircle(center, coreSize, corePaint);
      
      // 더 밝은 중심점
      final brightCorePaint = Paint()
        ..color = Colors.white.withOpacity(particleOpacity * 0.8);
      canvas.drawCircle(center, coreSize * 0.4, brightCorePaint);
    }
    
    // 파동 (Ripple) - 여러 개의 동심원
    if (rippleProgress > 0) {
      for (int i = 0; i < 4; i++) {
        final waveDelay = i * 0.2;
        final waveProgress = ((rippleProgress - waveDelay) / (1 - waveDelay)).clamp(0.0, 1.0);
        
        if (waveProgress <= 0) continue;
        
        final waveOpacity = (1 - waveProgress) * 0.5;
        final waveRadius = waveProgress * maxRadius;
        
        final wavePaint = Paint()
          ..color = baseColor.withOpacity(waveOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 + (1 - waveProgress) * 3
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        
        canvas.drawCircle(center, waveRadius, wavePaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant _CinematicRipplePainter oldDelegate) {
    return rippleProgress != oldDelegate.rippleProgress ||
           particleOpacity != oldDelegate.particleOpacity;
  }
}

/// 로고 페인터 (하트 + 발바닥 심볼)
class _LogoPainter extends CustomPainter {
  final double drawProgress;
  final Color color;
  final Color glowColor;
  
  _LogoPainter({
    required this.drawProgress,
    required this.color,
    required this.glowColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // 글로우 효과
    final glowPaint = Paint()
      ..color = glowColor.withOpacity(0.5 * drawProgress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    canvas.drawCircle(center, 35 * drawProgress, glowPaint);
    
    // 하트 형태 (간단화)
    final heartPath = Path();
    final heartSize = 30 * drawProgress;
    
    heartPath.moveTo(center.dx, center.dy - heartSize * 0.3);
    heartPath.cubicTo(
      center.dx - heartSize, center.dy - heartSize,
      center.dx - heartSize, center.dy + heartSize * 0.3,
      center.dx, center.dy + heartSize,
    );
    heartPath.cubicTo(
      center.dx + heartSize, center.dy + heartSize * 0.3,
      center.dx + heartSize, center.dy - heartSize,
      center.dx, center.dy - heartSize * 0.3,
    );
    
    final heartPaint = Paint()
      ..color = color.withOpacity(drawProgress)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(heartPath, heartPaint);
    
    // 소리 파동 아이콘 (3개의 arc)
    if (drawProgress > 0.5) {
      final waveProgress = (drawProgress - 0.5) * 2;
      final wavePaint = Paint()
        ..color = color.withOpacity(0.8 * waveProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      
      for (int i = 0; i < 3; i++) {
        final waveRadius = 40 + i * 10.0;
        final arcProgress = ((waveProgress - i * 0.15) / 0.7).clamp(0.0, 1.0);
        
        if (arcProgress <= 0) continue;
        
        final rect = Rect.fromCircle(center: center, radius: waveRadius);
        canvas.drawArc(
          rect,
          -math.pi / 4,
          math.pi / 2 * arcProgress,
          false,
          wavePaint..color = color.withOpacity(0.6 * arcProgress),
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return drawProgress != oldDelegate.drawProgress;
  }
}
