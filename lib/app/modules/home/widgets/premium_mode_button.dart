import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/beat_animation.dart';
import 'dart:math' as math;
import 'package:petbeats/core/widgets/mode_animator.dart';

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
      duration: const Duration(milliseconds: 2000),
    );

    // 먼저 기본값으로 초기화 (LateInitializationError 방지)
    _effectAnimation = ConstantTween(1.0).animate(_effectController);
    
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
    // Reference Style: White Container (Glassy), Rounded Square, Inner Gradient Circle with Icon
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
              Container(
                width: 110, // Large enough for ~3.8 items visible
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color?.withOpacity(0.12) ?? AppColors.primaryBlue.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: widget.isActive 
                        ? (widget.color ?? AppColors.primaryBlue)
                        : Colors.grey.shade200,
                    width: widget.isActive ? 2 : 1,
                  ),
                ),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      // Inner Icon Circle
                      Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              (widget.color ?? AppColors.primaryBlue).withOpacity(0.1),
                              (widget.color ?? AppColors.primaryBlue).withOpacity(0.25),
                            ],
                          ),
                        ),
                        child: widget.isPlaying
                              ? BeatAnimation(color: widget.color ?? AppColors.primaryBlue)
                              : _buildAnimatedIcon(widget.color ?? AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          widget.title,
                           style: AppTextStyles.bodyMedium.copyWith(
                              color: widget.isActive 
                                 ? (widget.color ?? AppColors.primaryBlue)
                                 : AppColors.textDarkNavy,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                           ),
                           textAlign: TextAlign.center,
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                   ],
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
      width: 42,  // Larger icon for 110px button
      height: 42,
      fit: BoxFit.contain,
      color: activeColor, // Tint icon to match mode color
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
