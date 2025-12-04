import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class WeatherService extends GetxService {
  // Replace with your OpenWeatherMap API Key
  static const String _apiKey = '69bb5b896f02481527e34546b0c358d9'; 
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  final RxString weatherCondition = 'Clear'.obs; // Clear, Rain, Clouds, Snow, etc.
  final RxDouble temperature = 20.0.obs;
  final RxString locationName = 'Unknown'.obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchCurrentWeather() async {
    isLoading.value = true;
    try {
      /*
      // 1. Get Location Permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoading.value = false;
          return;
        }
      }

      // 2. Get Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      */
      
      // Mock Position (Seoul)
      double lat = 37.5665;
      double lon = 126.9780;

      // 3. Call API
      if (_apiKey == 'YOUR_OPENWEATHER_API_KEY') {
        // Simulation Mode if no key provided
        // await _simulateWeather(position);
      } else {
        final url = Uri.parse(
          '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'
        );
        
        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          weatherCondition.value = data['weather'][0]['main'];
          temperature.value = (data['main']['temp'] as num).toDouble();
          locationName.value = data['name'];
        } else {
          debugPrint('Weather API Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error fetching weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /*
  Future<void> _simulateWeather(Position position) async {
    await Future.delayed(const Duration(seconds: 1));
    // Randomly pick a weather for testing
    final conditions = ['Clear', 'Rain', 'Clouds', 'Thunderstorm'];
    conditions.shuffle();
    weatherCondition.value = conditions.first;
    temperature.value = 22.5;
    locationName.value = 'Seoul (Simulated)';
    debugPrint('Simulated Weather: ${weatherCondition.value}');
  }
  */
}
