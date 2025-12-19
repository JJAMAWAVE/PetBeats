import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

/// CSS 스타일 프리미엄 볼륨 슬라이더
/// - 원형 핸들에 퍼센트 표시
/// - 드래그 시 핸들 위에 값이 올라오는 애니메이션
/// - 연기(smoke) 효과
class PremiumVolumeSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final Color? activeColor;
  final Color? handleColor;
  final bool showLabel;

  const PremiumVolumeSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
    this.activeColor,
    this.handleColor,
    this.showLabel = true,
  }) : super(key: key);

  @override
  State<PremiumVolumeSlider> createState() => _PremiumVolumeSliderState();
}

class _PremiumVolumeSliderState extends State<PremiumVolumeSlider>
    with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  late AnimationController _smokeController;
  late Animation<double> _smokeAnimation;

  // 색상 정의
  Color get _activeColor => widget.activeColor ?? const Color(0xFF275EFE);
  Color get _handleColor => widget.handleColor ?? const Color(0xFF275EFE);
  Color get _lineBackground => Colors.white.withOpacity(0.6);
  Color get _lineActive => Colors.white;
  Color get _handleBorder => Colors.white;
  Color get _handleTextColor => Colors.white;

  @override
  void initState() {
    super.initState();
    _smokeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _smokeAnimation = CurvedAnimation(
      parent: _smokeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _smokeController.dispose();
    super.dispose();
  }

  void _startDrag() {
    setState(() => _isDragging = true);
    _smokeController.forward();
  }

  void _endDrag() {
    setState(() => _isDragging = false);
    _smokeController.reverse();
    widget.onChangeEnd?.call(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackWidth = constraints.maxWidth;
          final handleSize = 36.w;
          final handlePosition = (trackWidth - handleSize) * widget.value;

          return GestureDetector(
            onHorizontalDragStart: (details) {
              _startDrag();
              _updateValue(details.localPosition.dx, trackWidth);
            },
            onHorizontalDragUpdate: (details) {
              _updateValue(details.localPosition.dx, trackWidth);
            },
            onHorizontalDragEnd: (details) {
              _endDrag();
            },
            onTapDown: (details) {
              _startDrag();
              _updateValue(details.localPosition.dx, trackWidth);
            },
            onTapUp: (details) {
              _endDrag();
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  // 배경 트랙
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: _lineBackground,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // 활성 트랙 (채워진 부분)
                  Positioned(
                    left: 0,
                    child: Container(
                      width: handlePosition + handleSize / 2,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: _lineActive,
                        borderRadius: BorderRadius.circular(2.r),
                        boxShadow: [
                          BoxShadow(
                            color: _activeColor.withOpacity(0.3),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 스모크 효과
                  AnimatedBuilder(
                    animation: _smokeAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: handlePosition - 4.w,
                        child: Transform.scale(
                          scale: _smokeAnimation.value,
                          child: Container(
                            width: handleSize + 8.w,
                            height: handleSize + 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2 * _smokeAnimation.value),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE1E6F9).withOpacity(0.3 * _smokeAnimation.value),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(3, 3),
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
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // 핸들 원
                        Container(
                          width: handleSize,
                          height: handleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _handleColor,
                            border: Border.all(
                              color: _handleBorder,
                              width: 3.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _handleColor.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),

                        // 값 표시 (드래그 시 위로 올라옴)
                        if (widget.showLabel)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            top: _isDragging ? -35.h : 6.h,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: _isDragging ? 1.0 : 0.7,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _isDragging ? 1.0 : 0.8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: _isDragging
                                      ? BoxDecoration(
                                          color: _handleColor,
                                          borderRadius: BorderRadius.circular(8.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _handleColor.withOpacity(0.3),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        )
                                      : null,
                                  child: Text(
                                    '${(widget.value * 100).round()}',
                                    style: TextStyle(
                                      color: _handleTextColor,
                                      fontSize: _isDragging ? 14.sp : 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
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

  void _updateValue(double localX, double trackWidth) {
    final handleSize = 36.w;
    final clampedX = localX.clamp(handleSize / 2, trackWidth - handleSize / 2);
    final newValue = (clampedX - handleSize / 2) / (trackWidth - handleSize);
    widget.onChanged(newValue.clamp(0.0, 1.0));
  }
}
