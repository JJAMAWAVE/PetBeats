import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/beat_animation.dart';
import 'dart:math' as math;

enum ModeAnimationType {
  none,
  pulse,
  sway,
  breathe,
  wave,
  heartbeat,
}

class PremiumModeButton extends StatefulWidget {
  final String title;
  final String iconPath;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback onTap;
  final Color? color;
  final bool isSpecial;
  final ModeAnimationType animationType;

  const PremiumModeButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isActive,
    required this.isPlaying,
    required this.onTap,
    this.color,
    this.isSpecial = false,
    this.animationType = ModeAnimationType.none,
  });

  @override
  State<PremiumModeButton> createState() => _PremiumModeButtonState();
}

class _PremiumModeButtonState extends State<PremiumModeButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  late AnimationController _effectController;
  late Animation<double> _effectAnimation;

  @override
  void initState() {
    super.initState();
    // Scale Animation (Press effect)
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Glow Animation (Blinking effect for active state)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Specific Effect Animation
    _effectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Base duration
    );

    if (widget.animationType != ModeAnimationType.none) {
      _startEffectAnimation();
    }
  }

  void _startEffectAnimation() {
    switch (widget.animationType) {
      case ModeAnimationType.pulse:
      case ModeAnimationType.heartbeat:
        _effectAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 10),
          TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 10),
          TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
        ]).animate(CurvedAnimation(parent: _effectController, curve: Curves.easeInOut));
        _effectController.repeat();
        break;
      case ModeAnimationType.sway:
        _effectAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 50),
          TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 25),
        ]).animate(CurvedAnimation(parent: _effectController, curve: Curves.easeInOut));
        _effectController.repeat();
        break;
      case ModeAnimationType.breathe:
        _effectController.duration = const Duration(milliseconds: 3000);
        _effectAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
          CurvedAnimation(parent: _effectController, curve: Curves.easeInOut),
        );
        _effectController.repeat(reverse: true);
        break;
      case ModeAnimationType.wave:
         // Simple rotation for wave effect representation
        _effectAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.05), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 50),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 25),
        ]).animate(CurvedAnimation(parent: _effectController, curve: Curves.easeInOut));
        _effectController.repeat();
        break;
      default:
        _effectAnimation = ConstantTween(0.0).animate(_effectController);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    _effectController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? AppColors.primaryBlue;
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _glowAnimation, _effectController]),
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glow Effect (Behind) - Keep for active state
                  if (widget.isActive)
                    Container(
                      width: 100 * _glowAnimation.value,
                      height: 100 * _glowAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color?.withOpacity(0.3) ?? AppColors.primaryBlue.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color?.withOpacity(0.4) ?? AppColors.primaryBlue.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  
                  // Simple Button (No individual layering)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        // Subtle shadow for depth
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: widget.isPlaying
                          ? SizedBox(
                              width: 50,
                              height: 50,
                              child: BeatAnimation(color: activeColor),
                            )
                          : _buildAnimatedIcon(activeColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: widget.isActive ? (widget.color ?? AppColors.primaryBlue) : AppColors.textGrey,
                  fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                  shadows: widget.isActive ? [
                    Shadow(
                      color: (widget.color ?? AppColors.primaryBlue).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : [],
                ),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(Color activeColor) {
    Widget icon = Image.asset(
      widget.iconPath,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      colorBlendMode: BlendMode.multiply,
      color: Colors.white, // Background is White
    );

    if (widget.animationType == ModeAnimationType.sway || widget.animationType == ModeAnimationType.wave) {
      return Transform.rotate(
        angle: _effectAnimation.value,
        child: icon,
      );
    } else if (widget.animationType == ModeAnimationType.pulse || widget.animationType == ModeAnimationType.heartbeat || widget.animationType == ModeAnimationType.breathe) {
      return Transform.scale(
        scale: _effectAnimation.value,
        child: icon,
      );
    }

    return icon;
  }
}
