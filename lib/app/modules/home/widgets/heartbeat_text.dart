import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HeartbeatText extends StatefulWidget {
  final String text;
  final double fontSize;

  const HeartbeatText(
    this.text, {
    super.key,
    this.fontSize = 28,
  });

  @override
  State<HeartbeatText> createState() => _HeartbeatTextState();
}

class _HeartbeatTextState extends State<HeartbeatText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final pos = _animation.value;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.textDarkNavy,
                AppColors.primaryBlue, // Heartbeat color
                AppColors.textDarkNavy,
              ],
              stops: [
                (pos - 0.2).clamp(0.0, 1.0),
                pos.clamp(0.0, 1.0),
                (pos + 0.2).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Required for ShaderMask
            ),
          ),
        );
      },
    );
  }
}
