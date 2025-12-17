import 'package:flutter/material.dart';
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
                  // Glow Effect (Behind) - Rounded Rectangle
                  if (widget.isActive)
                    Container(
                      width: 95 * _glowAnimation.value,  // 사이즈 축소
                      height: 95 * _glowAnimation.value,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: widget.color?.withOpacity(0.3) ?? AppColors.primaryBlue.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color?.withOpacity(0.4) ?? AppColors.primaryBlue.withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  
                  // Main Button - Rounded Rectangle with 3D Effect
                  Container(
                    width: 85,  // 사이즈 축소: 130 → 85
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primaryBlue,
                        width: 2.5,
                      ),
                      boxShadow: [
                        // Deep outer shadow
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        // Mid shadow for depth
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                        // Inner highlight (simulated with lighter shadow on top)
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 4,
                          offset: const Offset(0, -1),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: widget.isPlaying
                          ? SizedBox(
                              width: 40,  // 애니메이션 크기 축소
                              height: 40,
                              child: BeatAnimation(color: activeColor),
                            )
                          : _buildAnimatedIcon(activeColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),  // 간격 축소
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: widget.isActive ? (widget.color ?? AppColors.primaryBlue) : AppColors.textGrey,
                  fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 11,  // 폰트 사이즈 축소
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
      width: 65,  // 아이콘 크기 조정: 80 → 65 (버튼에 가득 차게)
      height: 65,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      colorBlendMode: BlendMode.multiply,
      color: Colors.white,
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
