import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:fftea/fftea.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:get/get.dart';

class AudioFrequencyData {
  final double bassIntensity; // 20-250Hz
  final double midIntensity;  // 250-2000Hz
  final double highIntensity; // 2000Hz+

  AudioFrequencyData({
    required this.bassIntensity,
    required this.midIntensity,
    required this.highIntensity,
  });
}

class AudioAnalyzerService extends GetxService {
  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  final StreamController<AudioFrequencyData> _dataController = StreamController.broadcast();
  
  Stream<AudioFrequencyData> get frequencyStream => _dataController.stream;
  
  bool _isCapturing = false;
  static const int _sampleRate = 44100;
  static const int _bufferSize = 2048; // FFT size

  Future<void> startAnalysis() async {
    if (_isCapturing) return;

    try {
      await _audioCapture.start(
        _onAudioData, 
        _onError, 
        sampleRate: _sampleRate, 
        bufferSize: _bufferSize
      );
      _isCapturing = true;
    } catch (e) {
      print('Error starting audio capture: $e');
    }
  }

  Future<void> stopAnalysis() async {
    if (!_isCapturing) return;

    try {
      await _audioCapture.stop();
      _isCapturing = false;
    } catch (e) {
      print('Error stopping audio capture: $e');
    }
  }

  void _onAudioData(dynamic data) {
    if (data is Float32List) {
      _processAudioData(data);
    } else if (data is List<double>) {
      _processAudioData(Float32List.fromList(data));
    }
  }

  void _processAudioData(Float32List samples) {
    if (samples.length < _bufferSize) return;

    // Apply window function (Hanning) manually
    final windowedSamples = Float64List(_bufferSize);
    for (int i = 0; i < _bufferSize; i++) {
      // Hanning window: 0.5 * (1 - cos(2 * pi * i / (N - 1)))
      final windowValue = 0.5 * (1 - cos(2 * pi * i / (_bufferSize - 1)));
      windowedSamples[i] = samples[i] * windowValue;
    }

    // Perform FFT
    final fft = FFT(_bufferSize);
    final spectrum = fft.realFft(windowedSamples);

    // Calculate intensities for frequency bands
    double bassSum = 0;
    double midSum = 0;
    double highSum = 0;

    // Frequency resolution = SampleRate / BufferSize (~21.5Hz per bin)
    final binWidth = _sampleRate / _bufferSize;

    // spectrum contains complex numbers (Float64x2). 
    // We need to calculate magnitude: sqrt(re^2 + im^2)
    // Note: fftea's realFft returns a list where each element is a complex number.
    // Depending on version, it might be Float64x2 (SIMD) or a custom Complex class.
    // If it's Float64x2, .x is real, .y is imaginary.
    
    for (int i = 0; i < spectrum.length; i++) {
      final frequency = i * binWidth;
      
      // Calculate magnitude from Float64x2
      final complex = spectrum[i];
      final magnitude = sqrt(complex.x * complex.x + complex.y * complex.y);

      if (frequency >= 20 && frequency < 250) {
        bassSum += magnitude;
      } else if (frequency >= 250 && frequency < 2000) {
        midSum += magnitude;
      } else if (frequency >= 2000) {
        highSum += magnitude;
      }
    }

    // Normalize (simplified)
    _dataController.add(AudioFrequencyData(
      bassIntensity: (bassSum / 100).clamp(0.0, 1.0),
      midIntensity: (midSum / 100).clamp(0.0, 1.0),
      highIntensity: (highSum / 100).clamp(0.0, 1.0),
    ));
  }

  void _onError(String message, int code) {
    print('Audio capture error: $message (Code: $code)');
  }

  @override
  void onClose() {
    stopAnalysis();
    _dataController.close();
    super.onClose();
  }
}
