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
  late AnimationController _snowController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _rainController.dispose();
    _sunController.dispose();
    _snowController.dispose();
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
          opacity: 0.6 + 0.4 * _sunController.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _SunPainter(),
          ),
        );
      },
    );
  }

  /// ☁️ 흐림 - 구름 좌우 움직임
  Widget _buildCloudy() {
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        return Stack(
          children: [
            // 뒤쪽 회색 구름 (반대로 움직임)
            Positioned(
              right: 0,
              top: 0,
              child: Transform.translate(
                offset: Offset(-3 * _cloudController.value, 0),
                child: CustomPaint(
                  size: Size(widget.size * 0.6, widget.size * 0.4),
                  painter: _CloudPainter(const Color(0xFFB0BEC5)),
                ),
              ),
            ),
            // 앞쪽 흰색 구름
            Positioned(
              left: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(5 * _cloudController.value, 0),
                child: CustomPaint(
                  size: Size(widget.size * 0.9, widget.size * 0.6),
                  painter: _CloudPainter(const Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🌧️ 비 - 구름 + 빗방울 내림
  Widget _buildRainy() {
    return Stack(
      children: [
        // 구름
        Positioned(
          left: 0,
          top: 0,
          child: CustomPaint(
            size: Size(widget.size * 0.9, widget.size * 0.5),
            painter: _CloudPainter(const Color(0xFF90A4AE)),
          ),
        ),
        // 빗방울들
        AnimatedBuilder(
          animation: _rainController,
          builder: (context, child) {
            return Opacity(
              opacity: 1 - _rainController.value,
              child: Transform.translate(
                offset: Offset(0, 10 * _rainController.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRainDrop(widget.size * 0.25),
                    SizedBox(width: widget.size * 0.1),
                    _buildRainDrop(widget.size * 0.45),
                    SizedBox(width: widget.size * 0.1),
                    _buildRainDrop(widget.size * 0.65),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRainDrop(double leftOffset) {
    return Positioned(
      left: leftOffset,
      top: widget.size * 0.5,
      child: Container(
        width: 6,
        height: 10,
        decoration: BoxDecoration(
          color: const Color(0xFF64B5F6),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  /// ❄️ 눈 - 구름 + 눈송이 내림
  Widget _buildSnowy() {
    return Stack(
      children: [
        // 구름
        Positioned(
          left: 0,
          top: 0,
          child: CustomPaint(
            size: Size(widget.size * 0.9, widget.size * 0.5),
            painter: _CloudPainter(const Color(0xFFCFD8DC)),
          ),
        ),
        // 눈송이들
        AnimatedBuilder(
          animation: _snowController,
          builder: (context, child) {
            final offset = _snowController.value;
            return Stack(
              children: [
                _buildSnowflake(widget.size * 0.2, widget.size * (0.5 + offset * 0.3)),
                _buildSnowflake(widget.size * 0.45, widget.size * (0.55 + offset * 0.3)),
                _buildSnowflake(widget.size * 0.7, widget.size * (0.6 + offset * 0.3)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSnowflake(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF81D4FA),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// ⛈️ 천둥 - 구름 + 번개 깜빡임
  Widget _buildThunder() {
    return AnimatedBuilder(
      animation: _sunController,
      builder: (context, child) {
        return Stack(
          children: [
            // 구름
            _buildCloudy(),
            // 번개
            Positioned(
              right: widget.size * 0.2,
              bottom: widget.size * 0.1,
              child: Opacity(
                opacity: _sunController.value,
                child: Icon(
                  Icons.bolt,
                  color: Colors.amber,
                  size: widget.size * 0.4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🌙 밤 - 달
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
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        return Stack(
          children: [
            // 태양
            Positioned(
              right: 0,
              top: 0,
              child: Opacity(
                opacity: 0.6 + 0.4 * _sunController.value,
                child: CustomPaint(
                  size: Size(widget.size * 0.5, widget.size * 0.5),
                  painter: _SunPainter(),
                ),
              ),
            ),
            // 바람 선들
            Positioned(
              left: 0,
              bottom: widget.size * 0.2,
              child: Transform.translate(
                offset: Offset(3 * _cloudController.value, 0),
                child: Opacity(
                  opacity: 0.3 + 0.6 * _cloudController.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWindLine(widget.size * 0.6),
                      SizedBox(height: 4),
                      _buildWindLine(widget.size * 0.7),
                      SizedBox(height: 4),
                      _buildWindLine(widget.size * 0.5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWindLine(double width) {
    return Container(
      width: width,
      height: 2,
      decoration: BoxDecoration(
        color: const Color(0xFF90A4AE),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  /// 🌙☁️ 구름 낀 밤
  Widget _buildCloudyWithMoon() {
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        return Stack(
          children: [
            // 달
            Positioned(
              left: widget.size * 0.1,
              top: 0,
              child: CustomPaint(
                size: Size(widget.size * 0.5, widget.size * 0.5),
                painter: _MoonPainter(),
              ),
            ),
            // 구름들
            Positioned(
              right: 0,
              top: widget.size * 0.1,
              child: Transform.translate(
                offset: Offset(-3 * _cloudController.value, 0),
                child: CustomPaint(
                  size: Size(widget.size * 0.6, widget.size * 0.35),
                  painter: _CloudPainter(const Color(0xFFB0BEC5)),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(5 * _cloudController.value, 0),
                child: CustomPaint(
                  size: Size(widget.size * 0.85, widget.size * 0.5),
                  painter: _CloudPainter(const Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 태양 페인터
class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFEB3B);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    // 중심 원
    canvas.drawCircle(center, radius, paint);

    // 햇살
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final startRadius = radius * 1.4;
      final endRadius = radius * 1.8;
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

/// 구름 페인터
class _CloudPainter extends CustomPainter {
  final Color color;

  _CloudPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // 구름 형태 - 여러 원의 조합
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.6), size.height * 0.35, paint);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.5), size.height * 0.45, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.45),
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
    final paint = Paint()..color = const Color(0xFFFFEB3B);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // 달 - 원에서 작은 원을 빼서 초승달 모양
    canvas.drawCircle(center, radius, paint);
    
    // 어두운 부분 (배경색으로 덮음)
    final darkPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.5, center.dy - radius * 0.2),
      radius * 0.85,
      darkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
