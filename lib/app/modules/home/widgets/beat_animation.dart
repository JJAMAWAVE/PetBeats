import 'package:flutter/material.dart';

class BeatAnimation extends StatefulWidget {
  final Color color;
  final double size;

  const BeatAnimation({
    super.key, 
    this.color = Colors.white,
    this.size = 20,
  });

  @override
  State<BeatAnimation> createState() => _BeatAnimationState();
}

class _BeatAnimationState extends State<BeatAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBar(0),
          _buildBar(200),
          _buildBar(400),
        ],
      ),
    );
  }

  Widget _buildBar(int delay) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Create a slight phase shift for each bar
        final double value = _animation.value; 
        // Simple randomization simulation or phase shift
        final double height = widget.size * (delay == 0 ? value : (delay == 200 ? value * 0.8 : value * 0.6));
        
        return Container(
          width: widget.size / 4,
          height: height,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
