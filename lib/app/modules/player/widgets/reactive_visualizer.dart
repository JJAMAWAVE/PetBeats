import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactiveVisualizer extends StatefulWidget {
  final bool isPlaying;
  final Color color;
  final int barCount;

  const ReactiveVisualizer({
    Key? key,
    required this.isPlaying,
    this.color = Colors.white,
    this.barCount = 20,
  }) : super(key: key);

  @override
  State<ReactiveVisualizer> createState() => _ReactiveVisualizerState();
}

class _ReactiveVisualizerState extends State<ReactiveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _heightFactors = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (widget.isPlaying) {
          _updateHeights();
        }
      });

    // Initialize heights
    for (int i = 0; i < widget.barCount; i++) {
      _heightFactors.add(_random.nextDouble());
    }

    if (widget.isPlaying) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _controller.repeat(reverse: true);
  }

  void _stopAnimation() {
    _controller.stop();
    // Reset to low levels when stopped
    setState(() {
      for (int i = 0; i < _heightFactors.length; i++) {
        _heightFactors[i] = 0.1;
      }
    });
  }

  void _updateHeights() {
    setState(() {
      for (int i = 0; i < _heightFactors.length; i++) {
        // Smooth random transition
        double target = _random.nextDouble();
        _heightFactors[i] =
            (_heightFactors[i] * 0.8) + (target * 0.2); // Simple smoothing
      }
    });
  }

  @override
  void didUpdateWidget(ReactiveVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(widget.barCount, (index) {
        return Flexible(
          child: FractionallySizedBox(
            heightFactor: widget.isPlaying
                ? 0.2 + (_heightFactors[index] * 0.8)
                : 0.1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
