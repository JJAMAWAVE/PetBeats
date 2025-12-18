import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/particle_text.dart';
import '../../../../core/widgets/circle_pulse_spinner.dart';

class ParticleTextDemoView extends StatelessWidget {
  const ParticleTextDemoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Effects Demo'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 40),
              // Circle Pulse Spinner
              const Text('#3 Circle Pulse Spinner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const CirclePulseSpinner(
                size: 80,
                color: Color(0xFF3D5AF1), // Blue
              ),
              const SizedBox(height: 40),
              _buildEffectSection("BUBBLES", ParticleType.bubbles),
              _buildEffectSection("CONFETTI", ParticleType.confetti),
              _buildEffectSection("HEARTS", ParticleType.hearts),
              _buildEffectSection("FIRE", ParticleType.fire),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEffectSection(String text, ParticleType type) {
    return Container(
      width: 300,
      height: 120,
      alignment: Alignment.center,
      // decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200)), // Helper to see bounds
      child: ParticleText(
        text: text,
        type: type,
        style: const TextStyle(
          fontFamily: 'Bebas', // Assuming Bebas or similar bold font is wanted based on CSS
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
