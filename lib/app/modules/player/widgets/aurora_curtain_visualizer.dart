import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petbeats/app/data/services/haptic_pattern_player.dart';

/// 🌌 Celestial Symphony Aurora Visualizer
/// 
/// 핵심 기술:
/// 1. Perlin/Simplex Noise 기반 유기적 움직임
/// 2. MIDI 주파수 대역별 반응 (Bass→팽창, Mid→형태, High→쉬머링)
/// 3. 그라데이션 매핑으로 깊이감 있는 색채
/// 4. 별빛 배경과 글로우 효과
class AuroraCurtainVisualizer extends StatefulWidget {
  final bool isPlaying;
  final String mode;
  final int bpm;

  const AuroraCurtainVisualizer({
    super.key,
    required this.isPlaying,
    this.mode = 'sleep',
    this.bpm = 60,
  });

  @override
  State<AuroraCurtainVisualizer> createState() => _AuroraCurtainVisualizerState();
}

class _AuroraCurtainVisualizerState extends State<AuroraCurtainVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // MIDI 반응 변수 (주파수 대역별)
  double _bassEnergy = 0.0;   // 저음 → 전체 팽창/박동
  double _midEnergy = 0.0;    // 중음 → 형태 변화/흐름
  double _highEnergy = 0.0;   // 고음 → 쉬머링/반짝임
  double _overallEnergy = 0.0; // 전체 활동성
  
  StreamSubscription<MidiEventData>? _midiSubscription;
  
  // 노이즈 시드 (랜덤하지만 부드럽게 변화)
  double _noiseSeed = 0.0;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    
    _controller.addListener(_updateNoise);
    
    if (widget.isPlaying) {
      _setupMidiListener();
    }
  }
  
  void _updateNoise() {
    // 매 프레임마다 노이즈 시드를 조금씩 증가시켜 유기적 움직임 생성
    _noiseSeed += 0.020; // 속도 증가 (기존 0.008 → 0.020)
    
    // 에너지 감쇠 (자연스러운 페이드아웃) - 더 빠르게 감쇠
    if (mounted) {
      setState(() {
        _bassEnergy = (_bassEnergy * 0.88).clamp(0.0, 1.0);  // 기존 0.92 → 더 빠른 감쇠
        _midEnergy = (_midEnergy * 0.90).clamp(0.0, 1.0);    // 기존 0.94
        _highEnergy = (_highEnergy * 0.85).clamp(0.0, 1.0);  // 기존 0.90
        _overallEnergy = (_bassEnergy + _midEnergy + _highEnergy) / 3;
      });
    }
  }

  void _setupMidiListener() {
    try {
      final patternPlayer = Get.find<HapticPatternPlayer>();
      _midiSubscription = patternPlayer.midiEventStream.listen((event) {
        if (!mounted || !widget.isPlaying) return;
        
        // 강화된 반응성 (2.5배 부스트)
        final boost = (event.intensity * 2.5).clamp(0.0, 1.0);
        
        setState(() {
          switch (event.frequencyBand) {
            case 'bass':
              // 저음: 전체적인 팽창과 박동
              _bassEnergy = math.max(_bassEnergy, boost);
              break;
            case 'mid':
              // 중음: 형태 변화와 흐름
              _midEnergy = math.max(_midEnergy, boost);
              break;
            case 'high':
              // 고음: 쉬머링과 미세한 떨림
              _highEnergy = math.max(_highEnergy, boost);
              break;
          }
        });
      });
    } catch (e) {
      debugPrint('MIDI listener error: $e');
    }
  }

  @override
  void didUpdateWidget(AuroraCurtainVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
        _setupMidiListener();
      } else {
        _controller.stop();
        _midiSubscription?.cancel();
        _bassEnergy = 0;
        _midEnergy = 0;
        _highEnergy = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateNoise);
    _midiSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _getAuroraPalette(widget.mode);
    
    return IgnorePointer(
      child: Stack(
        children: [
          // Layer 1: 밤하늘 배경
          _NightSkyBackground(starCount: 120),
          
          // Layer 2: 메인 오로라 (CustomPaint)
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _CelestialAuroraPainter(
              time: _noiseSeed,
              bassEnergy: _bassEnergy,
              midEnergy: _midEnergy,
              highEnergy: _highEnergy,
              palette: palette,
            ),
          ),
          
          // Layer 3: 강화된 블룸 오버레이 (여러 레이어)
          // === 레이어 3-1: 메인 블룸 (강한 비트) ===
          if (_bassEnergy > 0.3)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: (_bassEnergy * 0.4).clamp(0.0, 0.5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.8,
                    colors: [
                      palette.primary.withOpacity(0.4),
                      palette.secondary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
          
          // === 레이어 3-2: 중음 블룸 (형태 강조) ===
          if (_midEnergy > 0.4)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: (_midEnergy * 0.35).clamp(0.0, 0.45),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3),
                    radius: 1.2,
                    colors: [
                      palette.secondary.withOpacity(0.35),
                      palette.accent.withOpacity(0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          
          // === 레이어 3-3: 고음 쉬머 (상단 빛 산란) ===
          if (_highEnergy > 0.25)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 80),
              opacity: (_highEnergy * 0.5).clamp(0.0, 0.6),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.white.withOpacity(0.25 + (_highEnergy * 0.2)),
                      palette.accent.withOpacity(0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  AuroraPalette _getAuroraPalette(String mode) {
    switch (mode) {
      case 'sleep':
      case 'senior':
        // 차분한 청록/보라 (이미지 2, 3번 스타일)
        return AuroraPalette(
          primary: const Color(0xFF00FFC8),     // 청록
          secondary: const Color(0xFF7B68EE),   // 보라
          accent: const Color(0xFFFF69B4),      // 핑크
          background: const Color(0xFF0A0A1E),  // 깊은 밤하늘
        );
      case 'anxiety':
        // 잔잔한 녹색 (이미지 4번 스타일)
        return AuroraPalette(
          primary: const Color(0xFF39FF14),     // 밝은 녹색
          secondary: const Color(0xFF00FF7F),   // 에메랄드
          accent: const Color(0xFFADFF2F),      // 라임
          background: const Color(0xFF0D1B2A),  // 어두운 청색
        );
      case 'energy':
        // 격정적인 핑크/마젠타 (이미지 1, 5번 스타일)
        return AuroraPalette(
          primary: const Color(0xFFFF1493),     // 딥 핑크
          secondary: const Color(0xFF00CED1),   // 청록
          accent: const Color(0xFFFFD700),      // 골드
          background: const Color(0xFF1A0A2E),  // 깊은 보라
        );
      default:
        return AuroraPalette(
          primary: const Color(0xFF00FFC8),
          secondary: const Color(0xFF7B68EE),
          accent: const Color(0xFFFF69B4),
          background: const Color(0xFF0A0A1E),
        );
    }
  }
}

/// 오로라 색상 팔레트
class AuroraPalette {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;

  const AuroraPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
  });
}

/// 천상의 오로라 페인터 (Perlin Noise 기반)
class _CelestialAuroraPainter extends CustomPainter {
  final double time;
  final double bassEnergy;
  final double midEnergy;
  final double highEnergy;
  final AuroraPalette palette;

  _CelestialAuroraPainter({
    required this.time,
    required this.bassEnergy,
    required this.midEnergy,
    required this.highEnergy,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 오로라 리본 3개 그리기 (각기 다른 색상과 움직임)
    _drawAuroraRibbon(
      canvas, size,
      color: palette.primary,
      baseY: size.height * 0.3,
      amplitude: 80 + (bassEnergy * 120),
      frequency: 1.5,
      phaseOffset: 0,
      thickness: 0.25 + (bassEnergy * 0.1),
    );
    
    _drawAuroraRibbon(
      canvas, size,
      color: palette.secondary,
      baseY: size.height * 0.4,
      amplitude: 60 + (midEnergy * 100),
      frequency: 2.0,
      phaseOffset: time * 0.5,
      thickness: 0.2 + (midEnergy * 0.08),
    );
    
    _drawAuroraRibbon(
      canvas, size,
      color: palette.accent,
      baseY: size.height * 0.35,
      amplitude: 40 + (highEnergy * 80),
      frequency: 2.5,
      phaseOffset: time * 0.8,
      thickness: 0.15,
    );
  }

  void _drawAuroraRibbon(
    Canvas canvas,
    Size size, {
    required Color color,
    required double baseY,
    required double amplitude,
    required double frequency,
    required double phaseOffset,
    required double thickness,
  }) {
    // 수직 주름이 있는 커튼 형태를 위한 개선된 알고리즘
    const segments = 150; // 세밀한 커튼 주름을 위해 증가
    final path = Path();
    final points = <Offset>[];
    
    for (int i = 0; i <= segments; i++) {
      final x = (i / segments) * size.width;
      final normalizedX = x / size.width;
      
      // === 1. 수평 굴곡 (기존) ===
      final horizontalWave = _fractalNoise(normalizedX, time + phaseOffset, frequency);
      
      // === 2. 수직 주름 (NEW!) ===
      // 각 X 위치마다 독립적인 수직 흔들림을 추가하여 커튼 효과 생성
      final verticalRipple = _perlinNoise(normalizedX * 8 + time * 0.3, time * 0.4) * 
                             (30 + bassEnergy * 50); // 저음에 반응하는 주름
      
      // === 3. 소용돌이 효과 (강한 비트 시) ===
      double swirl = 0;
      if (bassEnergy > 0.5) {
        // 강한 비트에서 소용돌이치듯 왜곡
        final swirlStrength = (bassEnergy - 0.5) * 2.0; // 0.5 이상일 때만 활성화
        swirl = math.sin(normalizedX * math.pi * 3 + time * 2) * 
                swirlStrength * 60;
      }
      
      // 최종 Y 좌표 = 기본 위치 + 수평 파동 + 수직 주름 + 소용돌이
      final y = baseY + 
                (horizontalWave * amplitude) + 
                verticalRipple + 
                swirl;
      
      points.add(Offset(x, y));
    }
    
    if (points.isEmpty) return;
    
    // === 커튼 형태 패스 생성 ===
    // 상단 경로
    path.moveTo(0, 0);
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.lineTo(points[i].dx, points[i].dy);
      } else {
        // 베지어 커브로 부드럽게 연결
        final prev = points[i - 1];
        final curr = points[i];
        final controlPoint = Offset(
          (prev.dx + curr.dx) / 2,
          (prev.dy + curr.dy) / 2,
        );
        path.quadraticBezierTo(prev.dx, prev.dy, controlPoint.dx, controlPoint.dy);
      }
    }
    path.lineTo(size.width, 0);
    path.close();
    
    // === 질감 있는 그라데이션 === 
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withOpacity(0.0),
        color.withOpacity(0.05),
        color.withOpacity(0.15 + (bassEnergy * 0.25)),
        color.withOpacity(0.35 + (midEnergy * 0.35)),
        color.withOpacity(0.55),
        Colors.white.withOpacity(0.35 + (highEnergy * 0.45)), // 핵심 밝은 부분
        color.withOpacity(0.45),
        color.withOpacity(0.25),
        color.withOpacity(0.1),
        Colors.transparent,
      ],
      stops: const [0.0, 0.1, 0.2, 0.35, 0.45, 0.5, 0.55, 0.65, 0.8, 1.0],
    );
    
    final rect = Rect.fromLTWH(0, 0, size.width, baseY + amplitude * 3);
    
    // === 메인 오로라 레이어 (강한 블러) ===
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal, 
        25 + (bassEnergy * 40), // 비트에 맞춰 블러 강도 변화
      );
    
    canvas.drawPath(path, paint);
    
    // === 빛의 결 (노이즈 텍스처 시뮬레이션) ===
    // 미세한 빛 알갱이를 위한 추가 레이어
    final grainPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5)
      ..color = Colors.white.withOpacity(0.08);
      
    // 미세한 노이즈 패턴 그리기
    for (int i = 0; i < points.length; i += 5) {
      final point = points[i];
      final noiseOffset = _perlinNoise(i * 0.1, time) * 10;
      canvas.drawCircle(
        Offset(point.dx, point.dy + noiseOffset),
        1 + (highEnergy * 2),
        grainPaint,
      );
    }
    
    // === 밝은 코어 라인 (쉬머링) ===
    if (highEnergy > 0.15 || midEnergy > 0.2) {
      final shimmerPaint = Paint()
        ..color = Colors.white.withOpacity(0.4 + (highEnergy * 0.6))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 + (highEnergy * 5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
      
      final shimmerPath = Path();
      shimmerPath.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        shimmerPath.lineTo(points[i].dx, points[i].dy);
      }
      
      canvas.drawPath(shimmerPath, shimmerPaint);
    }
  }
  
  /// 단순화된 Perlin Noise (수직 주름용)
  double _perlinNoise(double x, double t) {
    return math.sin(x + t) * 0.5 + 
           math.sin(x * 2.4 + t * 0.7) * 0.25 +
           math.sin(x * 5.2 - t * 1.3) * 0.125;
  }

  /// 다중 옥타브 노이즈 (Fractal Noise 근사)
  double _fractalNoise(double x, double t, double freq) {
    double value = 0;
    double amp = 1.0;
    double totalAmp = 0;
    
    // 4개의 옥타브 레이어
    for (int i = 0; i < 4; i++) {
      final f = freq * math.pow(2, i);
      value += math.sin(x * math.pi * f + t * (1 + i * 0.3)) * amp;
      value += math.cos(x * math.pi * f * 1.7 + t * (0.5 + i * 0.2)) * amp * 0.5;
      totalAmp += amp;
      amp *= 0.5;
    }
    
    return value / totalAmp;
  }

  @override
  bool shouldRepaint(_CelestialAuroraPainter oldDelegate) => true;
}

/// 별빛 배경 (애니메이션 추가)
class _NightSkyBackground extends StatefulWidget {
  final int starCount;
  
  const _NightSkyBackground({required this.starCount});

  @override
  State<_NightSkyBackground> createState() => _NightSkyBackgroundState();
}

class _NightSkyBackgroundState extends State<_NightSkyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Star> _stars;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // 별 데이터 초기화
    final random = math.Random(42);
    _stars = List.generate(widget.starCount, (i) {
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.7,
        baseSize: random.nextDouble() * 1.5 + 0.5,
        baseBrightness: random.nextDouble() * 0.5 + 0.3,
        twinkleSpeed: random.nextDouble() * 2 + 1,
        twinklePhase: random.nextDouble() * math.pi * 2,
        driftSpeed: random.nextDouble() < 0.1 ? random.nextDouble() * 0.001 : 0, // 10% 별만 이동
        driftDirection: random.nextDouble() * math.pi * 2,
      );
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A1E), // 깊은 밤하늘
            Color(0xFF0D1B2A), // 약간 밝은 하늘
            Color(0xFF1B263B), // 지평선 근처
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: _TwinklingStarfieldPainter(
              stars: _stars,
              time: _controller.value * 10,
            ),
          );
        },
      ),
    );
  }
}

/// 별 데이터 모델
class _Star {
  double x;
  double y;
  final double baseSize;
  final double baseBrightness;
  final double twinkleSpeed;
  final double twinklePhase;
  final double driftSpeed;
  final double driftDirection;
  
  _Star({
    required this.x,
    required this.y,
    required this.baseSize,
    required this.baseBrightness,
    required this.twinkleSpeed,
    required this.twinklePhase,
    required this.driftSpeed,
    required this.driftDirection,
  });
}

class _TwinklingStarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double time;
  
  _TwinklingStarfieldPainter({
    required this.stars,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // 별 위치 업데이트 (드리프트)
      if (star.driftSpeed > 0) {
        star.x += math.cos(star.driftDirection) * star.driftSpeed;
        star.y += math.sin(star.driftDirection) * star.driftSpeed;
        // 화면 밖으로 나가면 반대편에서 다시 나타남
        star.x = star.x % 1.0;
        star.y = star.y % 0.7;
      }
      
      // 반짝임 효과 계산
      final twinkle = math.sin(time * star.twinkleSpeed + star.twinklePhase);
      final brightness = (star.baseBrightness + twinkle * 0.3).clamp(0.1, 1.0);
      final currentSize = star.baseSize * (1 + twinkle * 0.3);
      
      final x = star.x * size.width;
      final y = star.y * size.height;
      
      // 메인 별
      final paint = Paint()
        ..color = Colors.white.withOpacity(brightness)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, currentSize * 0.5);
      
      canvas.drawCircle(Offset(x, y), currentSize, paint);
      
      // 밝은 별에는 광채 효과 추가
      if (brightness > 0.6 && star.baseSize > 1.0) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(brightness * 0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, currentSize * 2);
        canvas.drawCircle(Offset(x, y), currentSize * 1.5, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_TwinklingStarfieldPainter oldDelegate) => true;
}
