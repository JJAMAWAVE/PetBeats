import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../painters/waveform_painter.dart';
import '../../../core/theme/visualizer_themes.dart';
import '../../../data/services/audio_analyzer_service.dart';

/// 전체 화면 오디오 반응형 비주얼라이저
class AudioReactiveVisualizer extends StatefulWidget {
  final int bpm;
  final bool isPlaying;
  final Color color;
  final String mode;

  const AudioReactiveVisualizer({
    super.key,
    required this.bpm,
    required this.isPlaying,
    required this.color,
    this.mode = 'sleep',
  });

  @override
  State<AudioReactiveVisualizer> createState() => _AudioReactiveVisualizerState();
}

class _AudioReactiveVisualizerState extends State<AudioReactiveVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  
  final AudioAnalyzerService _analyzer = Get.find<AudioAnalyzerService>();
  
  // 웨이브폼 데이터 (3개 레이어)
  List<double> _outerWaveform = List.filled(64, 0.0); // 베이스
  List<double> _middleWaveform = List.filled(80, 0.0); // 미드
  List<double> _innerWaveform = List.filled(64, 0.0); // 트레블
  
  double _bassIntensity = 0.0;
  double _midIntensity = 0.0;
  double _highIntensity = 0.0;
  
  // 파티클 데이터
  final List<Particle> _particles = [];
  
  @override
  void initState() {
    super.initState();
    _setupControllers();
    _generateParticles();
    _setupAudioListener();
  }

  void _setupControllers() {
    // 회전 애니메이션 (레이어별 다른 속도)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    
    // 맥박 애니메이션 (BPM 동기화)
    final beatDuration = (60000 / widget.bpm).round();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: beatDuration),
    );
    
    // 파티클 애니메이션
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60 FPS
    );

    if (widget.isPlaying) {
      _rotationController.repeat();
      _pulseController.repeat();
      _particleController.repeat();
    }
  }

  void _setupAudioListener() {
    _analyzer.frequencyStream.listen((data) {
      if (!mounted || !widget.isPlaying) return;
      
      setState(() {
        _bassIntensity = data.bassIntensity;
        _midIntensity = data.midIntensity;
        _highIntensity = data.highIntensity;
        
        // 웨이브폼 데이터 생성 (시뮬레이션)
        _outerWaveform = _generateWaveformData(64, _bassIntensity);
        _middleWaveform = _generateWaveformData(80, _midIntensity);
        _innerWaveform = _generateWaveformData(64, _highIntensity);
      });
    });
  }

  List<double> _generateWaveformData(int count, double intensity) {
    final random = math.Random();
    return List.generate(count, (i) {
      // 기본 값 + 랜덤 변화
      final base = intensity * 0.7;
      final variation = intensity * 0.3 * random.nextDouble();
      return (base + variation).clamp(0.0, 1.0);
    });
  }

  void _generateParticles() {
    final random = math.Random();
    // 반딧불이 효과: 적은 개수, 느린 속도, 다양한 크기
    for (int i = 0; i < 150; i++) {  // 300→150으로 감소
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 3 + random.nextDouble() * 12, // 3-15px 범위로 다양성
        speed: 0.0002 + random.nextDouble() * 0.0006, // 2.5배 느리게 (차분한 느낌)
        phase: random.nextDouble() * math.pi * 2,
      ));
    }
  }

  @override
  void didUpdateWidget(AudioReactiveVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
        _pulseController.repeat();
        _particleController.repeat();
      } else {
        _rotationController.stop();
        _pulseController.stop();
        _particleController.stop();
      }
    }
    
    if (oldWidget.bpm != widget.bpm) {
      final beatDuration = (60000 / widget.bpm).round();
      _pulseController.duration = Duration(milliseconds: beatDuration);
      if (widget.isPlaying) {
        _pulseController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VisualizerTheme.getThemeForMode(widget.mode);
    final size = MediaQuery.of(context).size;
    
    return IgnorePointer(  // 터치 이벤트 무시 - UI 클릭 가능하게
      child: SizedBox(
        width: size.width,
        height: size.width, // Square aspect ratio
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _rotationController,
            _pulseController,
            _particleController,
          ]),
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: theme.backgroundGradient,
              ),
              child: Stack(
                children: [
                  // 파티클 필드
                  _buildParticleField(theme),
                  
                  // 3겹 웨이브폼
                  _buildWaveformLayer(
                    data: _outerWaveform,
                    theme: theme,
                    sizeRatio: 0.7,
                    rotation: _rotationController.value * 2 * math.pi * 0.1,
                  ),
                  _buildWaveformLayer(
                    data: _middleWaveform,
                    theme: theme,
                    sizeRatio: 0.5,
                    rotation: _rotationController.value * 2 * math.pi * 0.3,
                  ),
                  _buildWaveformLayer(
                    data: _innerWaveform,
                    theme: theme,
                    sizeRatio: 0.3,
                    rotation: _rotationController.value * 2 * math.pi * 0.5,
                  ),
                  
                  // 중앙 맥박 오브
                  _buildCentralOrb(theme),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildParticleField(VisualizerTheme theme) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: ParticlePainter(
          particles: _particles,
          color: theme.particleColor,
          time: _particleController.value,
        ),
      ),
    );
  }

  Widget _buildWaveformLayer({
    required List<double> data,
    required VisualizerTheme theme,
    required double sizeRatio,
    required double rotation,
  }) {
    final totalEnergy = (_bassIntensity + _midIntensity + _highIntensity) / 3;
    
    return Center(
      child: FractionallySizedBox(
        widthFactor: sizeRatio,
        heightFactor: sizeRatio,
        child: CustomPaint(
          painter: WaveformPainter(
            frequencyData: data,
            waveformGradient: theme.waveformGradient,
            glowColor: theme.glowColor,
            rotationAngle: rotation,
            energy: totalEnergy,
          ),
        ),
      ),
    );
  }

  Widget _buildCentralOrb(VisualizerTheme theme) {
    final scale = 0.8 + (_pulseController.value * 0.4); // Increased pulse range
    final totalEnergy = (_bassIntensity + _midIntensity + _highIntensity) / 3;
    final orbSize = 80.0 + (totalEnergy * 40); // Doubled base size and energy response
    
    return Center(
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: orbSize,
          height: orbSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                theme.glowColor.withOpacity(1.0), // Full opacity at center
                theme.glowColor.withOpacity(0.6),
                theme.glowColor.withOpacity(0.0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.glowColor.withOpacity(0.8), // Increased glow
                blurRadius: 60, // Doubled blur
                spreadRadius: 20, // Doubled spread
              ),
              // Additional glow layer
              BoxShadow(
                color: theme.glowColor.withOpacity(0.4),
                blurRadius: 100,
                spreadRadius: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 파티클 클래스
class Particle {
  double x; // 0.0-1.0 (화면 비율)
  double y; // 0.0-1.0
  final double size;
  final double speed;
  final double phase;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
}

/// 파티클 페인터
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double time;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // 반딧불이처럼 천천히 움직이기
      final offsetY = math.sin(particle.phase + time * 8) * particle.speed * size.height; // 느린 움직임
      final offsetX = math.cos(particle.phase + time * 8) * particle.speed * size.width;
      
      final x = (particle.x * size.width + offsetX) % size.width;
      final y = (particle.y * size.height + offsetY) % size.height;

      // 호흡하는 글로우 효과 (반딧불이 깜빡임)
      final breathe = (math.sin(time * 3 + particle.phase) + 1) / 2; // 0.0-1.0
      final alpha = 0.4 + (breathe * 0.5); // 0.4-0.9 범위로 깜빡임
      
      final paint = Paint()
        ..color = color.withOpacity(alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 + breathe * 5); // 글로우도 깜빡임

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.time != time;
  }
}
