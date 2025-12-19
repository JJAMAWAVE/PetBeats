import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 애니메이션이 있는 날씨 아이콘 위젯
/// SVG 애니메이션을 Flutter AnimationController로 구현
enum WeatherType {
  sunny,
  cloudy,
  rainy,
  snowy,
  thunder,
  night,
  windySunny,
  cloudyWithMoon,
}

class AnimatedWeatherIcon extends StatefulWidget {
  final WeatherType type;
  final double size;

  const AnimatedWeatherIcon({
    Key? key,
    required this.type,
    this.size = 60,
  }) : super(key: key);

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late AnimationController _rainController;
  late AnimationController _sunController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _rainController.dispose();
    _sunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _buildWeatherIcon(),
    );
  }

  Widget _buildWeatherIcon() {
    switch (widget.type) {
      case WeatherType.sunny:
        return _buildSunny();
      case WeatherType.cloudy:
        return _buildCloudy();
      case WeatherType.rainy:
        return _buildRainy();
      case WeatherType.snowy:
        return _buildSnowy();
      case WeatherType.thunder:
        return _buildThunder();
      case WeatherType.night:
        return _buildNight();
      case WeatherType.windySunny:
        return _buildWindySunny();
      case WeatherType.cloudyWithMoon:
        return _buildCloudyWithMoon();
    }
  }

  /// ☀️ 맑음 - 태양 빛 깜빡임
  Widget _buildSunny() {
    return AnimatedBuilder(
      animation: _sunController,
      builder: (context, child) {
        return Opacity(
          opacity: 0.7 + 0.3 * _sunController.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _SunPainter(),
          ),
        );
      },
    );
  }

  /// ☁️ 흐림 - 구름
  Widget _buildCloudy() {
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(3 * _cloudController.value, 0),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CloudOnlyPainter(),
          ),
        );
      },
    );
  }

  /// 🌧️ 비 - 구름 + 빗방울
  Widget _buildRainy() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(widget.size * 0.9, widget.size * 0.45),
          painter: _CloudOnlyPainter(color: const Color(0xFF78909C)),
        ),
        SizedBox(height: 4),
        AnimatedBuilder(
          animation: _rainController,
          builder: (context, child) {
            return Opacity(
              opacity: 1 - _rainController.value,
              child: Transform.translate(
                offset: Offset(0, 8 * _rainController.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (_) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      width: 5,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF42A5F5),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  )),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// ❄️ 눈
  Widget _buildSnowy() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(widget.size * 0.9, widget.size * 0.45),
          painter: _CloudOnlyPainter(color: const Color(0xFFB0BEC5)),
        ),
        SizedBox(height: 4),
        AnimatedBuilder(
          animation: _rainController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 5 * _rainController.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF64B5F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                )),
              ),
            );
          },
        ),
      ],
    );
  }

  /// ⛈️ 천둥
  Widget _buildThunder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(widget.size * 0.9, widget.size * 0.45),
          painter: _CloudOnlyPainter(color: const Color(0xFF607D8B)),
        ),
        AnimatedBuilder(
          animation: _sunController,
          builder: (context, child) {
            return Opacity(
              opacity: _sunController.value,
              child: Icon(
                Icons.bolt,
                color: Colors.amber,
                size: widget.size * 0.35,
              ),
            );
          },
        ),
      ],
    );
  }

  /// 🌙 밤
  Widget _buildNight() {
    return Center(
      child: CustomPaint(
        size: Size(widget.size * 0.7, widget.size * 0.7),
        painter: _MoonPainter(),
      ),
    );
  }

  /// 💨 바람 + 태양
  Widget _buildWindySunny() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(widget.size * 0.5, widget.size * 0.5),
          painter: _SunPainter(),
        ),
        SizedBox(height: 2),
        AnimatedBuilder(
          animation: _cloudController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.4 + 0.5 * _cloudController.value,
              child: Transform.translate(
                offset: Offset(5 * _cloudController.value, 0),
                child: Column(
                  children: [
                    Container(width: widget.size * 0.7, height: 2, color: const Color(0xFF90A4AE)),
                    SizedBox(height: 3),
                    Container(width: widget.size * 0.5, height: 2, color: const Color(0xFF90A4AE)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 🌙☁️ 구름 낀 밤
  Widget _buildCloudyWithMoon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(widget.size * 0.35, widget.size * 0.35),
              painter: _MoonPainter(),
            ),
            SizedBox(width: 4),
            AnimatedBuilder(
              animation: _cloudController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(3 * _cloudController.value, 0),
                  child: CustomPaint(
                    size: Size(widget.size * 0.5, widget.size * 0.35),
                    painter: _CloudOnlyPainter(color: const Color(0xFFB0BEC5)),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// 태양 페인터
class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFD54F);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.28;

    // 중심 원
    canvas.drawCircle(center, radius, paint);

    // 햇살
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final startRadius = radius * 1.3;
      final endRadius = radius * 1.7;
      canvas.drawLine(
        Offset(center.dx + cos(angle) * startRadius, center.dy + sin(angle) * startRadius),
        Offset(center.dx + cos(angle) * endRadius, center.dy + sin(angle) * endRadius),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 구름 페인터 (단순화)
class _CloudOnlyPainter extends CustomPainter {
  final Color color;

  _CloudOnlyPainter({this.color = const Color(0xFFB0BEC5)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // 구름 형태 - 여러 원의 조합
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.6), size.height * 0.35, paint);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.45), size.height * 0.4, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.55), size.height * 0.3, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, size.height * 0.55, size.width * 0.8, size.height * 0.4),
        Radius.circular(size.height * 0.2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 달 페인터
class _MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFD54F);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // 달 - 원에서 작은 원을 빼서 초승달 모양
    canvas.drawCircle(center, radius, paint);
    
    // 어두운 부분 (진한 남색으로 덮음)
    final darkPaint = Paint()..color = const Color(0xFF2C3E50);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.5, center.dy - radius * 0.2),
      radius * 0.85,
      darkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
