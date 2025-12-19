import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 버블 효과가 있는 슬라이더
/// 드래그 시 핸들 주변에 버블(연기) 효과가 나타남
class BubbleSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final Color? activeColor;
  final Color? inactiveColor;

  const BubbleSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  State<BubbleSlider> createState() => _BubbleSliderState();
}

class _BubbleSliderState extends State<BubbleSlider>
    with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

  Color get _activeColor => widget.activeColor ?? const Color(0xFF275EFE);
  Color get _inactiveColor => widget.inactiveColor ?? Colors.white.withOpacity(0.3);

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bubbleAnimation = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  void _startDrag() {
    setState(() => _isDragging = true);
    _bubbleController.forward();
  }

  void _endDrag() {
    setState(() => _isDragging = false);
    _bubbleController.reverse();
    widget.onChangeEnd?.call(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackWidth = constraints.maxWidth;
          final handleSize = 28.w;
          final handlePosition = (trackWidth - handleSize) * widget.value;

          return GestureDetector(
            onHorizontalDragStart: (details) {
              _startDrag();
              _updateValue(details.localPosition.dx, trackWidth, handleSize);
            },
            onHorizontalDragUpdate: (details) {
              _updateValue(details.localPosition.dx, trackWidth, handleSize);
            },
            onHorizontalDragEnd: (details) {
              _endDrag();
            },
            onTapDown: (details) {
              _startDrag();
              _updateValue(details.localPosition.dx, trackWidth, handleSize);
            },
            onTapUp: (details) {
              _endDrag();
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // 배경 트랙
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: _inactiveColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  // 활성 트랙
                  Container(
                    width: handlePosition + handleSize / 2,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: _activeColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  // 버블(Smoke) 효과 - 드래그 시에만 나타남
                  AnimatedBuilder(
                    animation: _bubbleAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: handlePosition - 6.w,
                        child: Transform.scale(
                          scale: _bubbleAnimation.value,
                          child: Container(
                            width: handleSize + 12.w,
                            height: handleSize + 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15 * _bubbleAnimation.value),
                              boxShadow: [
                                BoxShadow(
                                  color: _activeColor.withOpacity(0.2 * _bubbleAnimation.value),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // 핸들
                  Positioned(
                    left: handlePosition,
                    child: Container(
                      width: handleSize,
                      height: handleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _activeColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 3.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _activeColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateValue(double localX, double trackWidth, double handleSize) {
    final clampedX = localX.clamp(handleSize / 2, trackWidth - handleSize / 2);
    final newValue = (clampedX - handleSize / 2) / (trackWidth - handleSize);
    widget.onChanged(newValue.clamp(0.0, 1.0));
  }
}
