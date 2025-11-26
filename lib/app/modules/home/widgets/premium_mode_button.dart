import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/beat_animation.dart';

class PremiumModeButton extends StatefulWidget {
  final String title;
  final String iconPath;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback onTap;
  final Color? color;
  final bool isSpecial;

  const PremiumModeButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isActive,
    required this.isPlaying,
    required this.onTap,
    this.color,
    this.isSpecial = false,
  });

  @override
  State<PremiumModeButton> createState() => _PremiumModeButtonState();
}

class _PremiumModeButtonState extends State<PremiumModeButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

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
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
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
        animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Blinking Glow Effect (Behind)
                  if (widget.isActive)
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withOpacity(_glowAnimation.value * 0.6),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),

                  // Main Button Container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white,
                      // Removed border completely as requested
                      boxShadow: [
                        // Subtle shadow for depth
                        BoxShadow(
                          color: const Color(0xFFA6ABBD).withOpacity(0.1),
                          offset: const Offset(0, 8),
                          blurRadius: 16,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background Gradient (Internal - very subtle)
                          if (widget.isActive)
                            Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment.center,
                                  radius: 1.0,
                                  colors: [
                                    Colors.white,
                                    activeColor.withOpacity(0.05),
                                  ],
                                ),
                              ),
                            ),
                          
                          // Icon
                          Center(
                            child: widget.isPlaying
                                ? SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: BeatAnimation(color: activeColor),
                                  )
                                : Image.asset(
                                    widget.iconPath,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    colorBlendMode: BlendMode.multiply,
                                    color: Colors.white.withOpacity(0.0),
                                  ),
                          ),
                          
                          // Shine effect overlay (Subtle)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Text with Effect
              Text(
                widget.title,
                style: AppTextStyles.labelSmall.copyWith(
                  color: widget.isActive ? AppColors.textDarkNavy : AppColors.textGrey,
                  fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  shadows: widget.isActive ? [
                    Shadow(
                      color: activeColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ] : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
