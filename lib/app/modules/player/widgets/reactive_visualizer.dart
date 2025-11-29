import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/audio_analyzer_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../player/models/visualizer_theme.dart';
import '../../../data/models/midi_note_event.dart';

class ReactiveVisualizer extends StatefulWidget {
  final bool isPlaying;
  final VisualizerTheme theme;
  final int barCount;

  const ReactiveVisualizer({
    Key? key,
    required this.isPlaying,
    required this.theme,
    this.barCount = 30, // Increased bar count for smoother look
  }) : super(key: key);

  @override
  State<ReactiveVisualizer> createState() => _ReactiveVisualizerState();
}

class _ReactiveVisualizerState extends State<ReactiveVisualizer>
    with TickerProviderStateMixin {
  // Services
  final AudioAnalyzerService _audioAnalyzer = Get.find<AudioAnalyzerService>();
  final HapticService _hapticService = Get.find<HapticService>();

  // Controllers & Subscriptions
  late AnimationController _pulseController;
  StreamSubscription? _audioSubscription;
  StreamSubscription? _midiSubscription;

  // State Data
  final List<double> _barHeights = [];
  double _currentBass = 0.0;
  double _currentMid = 0.0;
  double _pulseScale = 1.0;

  // Random for particles
  final Random _random = Random();
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _initializeBars();
    
    // Pulse animation for MIDI hits
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 1.0,
      upperBound: 1.2,
    )..addListener(() {
        setState(() {
          _pulseScale = _pulseController.value;
        });
      });

    if (widget.isPlaying) {
      _startListening();
    }
  }

  void _initializeBars() {
    _barHeights.clear();
    for (int i = 0; i < widget.barCount; i++) {
      _barHeights.add(0.1);
    }
  }

  void _startListening() {
    // 1. Audio Frequency Listener
    _audioSubscription = _audioAnalyzer.frequencyStream.listen((data) {
      if (!mounted) return;
      setState(() {
        _currentBass = data.bassIntensity;
        _currentMid = data.midIntensity;
        _updateBars(data);
        _updateParticles();
      });
    });

    // 2. MIDI Haptic Listener
    _midiSubscription = _hapticService.midiNoteStream.listen((event) {
      if (!mounted) return;
      _onMidiEvent(event);
    });
  }

  void _stopListening() {
    _audioSubscription?.cancel();
    _midiSubscription?.cancel();
    _pulseController.stop();
    setState(() {
      _initializeBars(); // Reset bars
      _pulseScale = 1.0;
    });
  }

  void _updateBars(AudioFrequencyData data) {
    // Center-out visualization
    final center = widget.barCount ~/ 2;
    
    for (int i = 0; i < widget.barCount; i++) {
      // Distance from center (0.0 to 1.0)
      final dist = (i - center).abs() / center;
      
      // Wave shape
      final wave = sin(DateTime.now().millisecondsSinceEpoch * 0.005 * widget.theme.rippleSpeed + i * 0.5);
      
      // Target height based on frequency and wave
      double target = 0.1;
      if (dist < 0.3) {
        target += data.bassIntensity * 0.8; // Bass at center
      } else {
        target += data.midIntensity * 0.6 * (1 - dist); // Mid spreading out
      }
      
      // Add wave movement
      target += wave * 0.1;

      // Smooth transition
      _barHeights[i] = (_barHeights[i] * 0.7) + (target * 0.3);
    }
  }

  void _onMidiEvent(MidiNoteEvent event) {
    // Trigger visual pulse on strong beats
    if (event.velocity > 60) {
      _pulseController.forward(from: 1.0).then((_) => _pulseController.reverse());
      
      // Spawn particles
      if (widget.theme.particleType != ParticleEffect.none) {
        _spawnParticles(5);
      }
    }
  }

  void _spawnParticles(int count) {
    for (int i = 0; i < count; i++) {
      _particles.add(_Particle(
        x: 0.5, // Center
        y: 0.5,
        dx: (_random.nextDouble() - 0.5) * 0.05,
        dy: (_random.nextDouble() - 0.5) * 0.05,
        life: 1.0,
        color: widget.theme.colorPalette[_random.nextInt(widget.theme.colorPalette.length)],
      ));
    }
  }

  void _updateParticles() {
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.x += p.dx;
      p.y += p.dy;
      p.life -= 0.02;
      if (p.life <= 0) {
        _particles.removeAt(i);
      }
    }
  }

  @override
  void didUpdateWidget(ReactiveVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startListening();
      } else {
        _stopListening();
      }
    }
  }

  @override
  void dispose() {
    _stopListening();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Particles Layer
        CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(_particles),
        ),

        // 2. Bars Layer
        Center(
          child: Transform.scale(
            scale: _pulseScale,
            child: Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(widget.barCount, (index) {
                  return Flexible(
                    child: FractionallySizedBox(
                      heightFactor: _barHeights[index].clamp(0.05, 1.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: widget.theme.colorPalette[index % widget.theme.colorPalette.length]
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: widget.theme.colorPalette[index % widget.theme.colorPalette.length]
                                  .withOpacity(0.5),
                              blurRadius: widget.theme.blurIntensity,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  double x, y, dx, dy, life;
  Color color;
  _Particle({required this.x, required this.y, required this.dx, required this.dy, required this.life, required this.color});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(p.life)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        3 * p.life,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
