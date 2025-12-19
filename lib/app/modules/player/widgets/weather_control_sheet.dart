import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/premium_volume_slider.dart';
import '../../../data/services/weather_service.dart';
import '../../../data/services/weather_sound_manager.dart';
import '../../../data/services/sound_mixer_service.dart';
import 'dart:ui';

/// Simple Weather Control Sheet (Premium Users Only)
/// ON/OFF toggle + Volume slider only
class WeatherControlSheet extends StatefulWidget {
  const WeatherControlSheet({super.key});

  @override
  State<WeatherControlSheet> createState() => _WeatherControlSheetState();
}

class _WeatherControlSheetState extends State<WeatherControlSheet> {
  late final WeatherService _weatherService;
  late final GetStorage _storage;
  double _volume = 0.5;
  
  // Debug: Weather conditions for testing
  final List<String> _testConditions = ['Clear', 'Clouds', 'Rain', 'Snow', 'Thunderstorm', 'Mist'];
  String? _selectedTestCondition;

  @override
  void initState() {
    super.initState();
    _weatherService = Get.find<WeatherService>();
    _storage = GetStorage();
    
    // Load saved volume
    _volume = _storage.read('weather_sound_volume') ?? 0.5;
    
    // Apply saved volume to mixer
    if (Get.isRegistered<SoundMixerService>()) {
      Get.find<SoundMixerService>().setMasterVolume(_volume);
    }
  }
  
  void _saveVolume(double value) {
    _storage.write('weather_sound_volume', value);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_cloudy, color: Colors.lightBlueAccent, size: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    'weather_sound_title'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              // Current Weather Info Card
              Obx(() {
                final condition = _weatherService.weatherCondition.value;
                final temp = _weatherService.temperature.value;
                final location = _weatherService.locationName.value;
                final isLoading = _weatherService.isLoading.value;
                
                IconData weatherIcon = Icons.wb_sunny;
                Color weatherColor = Colors.orange;
                String weatherLabel = 'weather_clear'.tr;
                
                if (condition.contains('Rain') || condition.contains('Drizzle')) {
                  weatherIcon = Icons.water_drop;
                  weatherColor = Colors.blue;
                  weatherLabel = 'weather_rain'.tr;
                } else if (condition.contains('Snow')) {
                  weatherIcon = Icons.ac_unit;
                  weatherColor = Colors.lightBlue;
                  weatherLabel = 'weather_snow'.tr;
                } else if (condition.contains('Cloud')) {
                  weatherIcon = Icons.cloud;
                  weatherColor = Colors.blueGrey;
                  weatherLabel = 'weather_clouds'.tr;
                } else if (condition.contains('Thunder')) {
                  weatherIcon = Icons.flash_on;
                  weatherColor = Colors.amber;
                  weatherLabel = 'weather_thunder'.tr;
                }
                
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: weatherColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: weatherColor.withOpacity(0.3)),
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: weatherColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          children: [
                            Icon(weatherIcon, color: weatherColor, size: 40.w),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$weatherLabel · ${temp.toStringAsFixed(1)}°C',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    location,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Current sound layer indicator
                            if (_weatherService.isEnabled.value)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.graphic_eq, color: Colors.greenAccent, size: 14.w),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'weather_playing'.tr,
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                );
              }),
              SizedBox(height: 16.h),
              
              // ON/OFF Toggle
              Obx(() {
                final isEnabled = _weatherService.isEnabled.value;
                
                return GestureDetector(
                  onTap: () async {
                    HapticFeedback.selectionClick();
                    if (isEnabled) {
                      _weatherService.disableWeatherSync();
                      if (Get.isRegistered<WeatherSoundManager>()) {
                        Get.find<WeatherSoundManager>().disableWeatherMix();
                      }
                    } else {
                      await _weatherService.enableWeatherSync();
                      if (Get.isRegistered<WeatherSoundManager>()) {
                        Get.find<WeatherSoundManager>().enableWeatherMix();
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: isEnabled 
                          ? AppColors.primaryBlue.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isEnabled 
                            ? AppColors.primaryBlue
                            : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 48.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: isEnabled ? AppColors.primaryBlue : Colors.grey,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: isEnabled 
                                ? Alignment.centerRight 
                                : Alignment.centerLeft,
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              margin: EdgeInsets.symmetric(horizontal: 2.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEnabled ? 'weather_sync_on'.tr : 'weather_sync_off'.tr,
                                style: TextStyle(
                                  color: isEnabled ? Colors.white : Colors.white70,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                isEnabled 
                                    ? 'weather_sync_on_desc'.tr
                                    : 'weather_sync_off_desc'.tr,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 20.h),
              
              // Volume Slider (only when enabled)
              Obx(() {
                if (!_weatherService.isEnabled.value) {
                  return const SizedBox.shrink();
                }
                
                return Column(
                  children: [
                    // Volume percentage indicator
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF275EFE).withOpacity(0.2),
                            const Color(0xFF275EFE).withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF275EFE).withOpacity(0.5),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF275EFE).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${(_volume * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    
                    // Premium Volume Slider
                    Row(
                      children: [
                        Icon(Icons.volume_off, color: Colors.white38, size: 20.w),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: PremiumVolumeSlider(
                            value: _volume,
                            activeColor: const Color(0xFF275EFE),
                            handleColor: const Color(0xFF275EFE),
                            onChanged: (value) {
                              setState(() => _volume = value);
                              if (Get.isRegistered<SoundMixerService>()) {
                                Get.find<SoundMixerService>().setMasterVolume(value);
                              }
                              HapticFeedback.selectionClick();
                            },
                            onChangeEnd: (value) {
                              _saveVolume(value);
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(Icons.volume_up, color: Colors.white38, size: 20.w),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _volume == 0 ? 'volume_mute'.tr : _volume < 0.3 ? 'volume_low'.tr : _volume < 0.7 ? 'volume_medium'.tr : 'volume_high'.tr,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 16.h),
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: Colors.white30),
                    ),
                  ),
                  child: Text(
                    'common_close'.tr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
