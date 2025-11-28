import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class WeatherSpecialView extends StatefulWidget {
  const WeatherSpecialView({super.key});

  @override
  State<WeatherSpecialView> createState() => _WeatherSpecialViewState();
}

class _WeatherSpecialViewState extends State<WeatherSpecialView> {
  bool _autoAdjust = true;
  int _selectedWeatherIndex = 0; // 0: 맑음, 1: 비, 2: 눈, 3: 강풍
  bool _locationEnabled = false; // 위치 정보 사용 여부
  
  // 각 날씨별 레이어 강도 (0.0 ~ 1.0)
  Map<String, double> _layerIntensity = {
    '맑음': 0.0,
    '비': 0.2,
    '눈': 0.2,
    '강풍': 0.3,
  };

  final List<Map<String, dynamic>> _weatherModes = [
    {'title': '맑음', 'desc': '기본 BGM 유지', 'icon': Icons.wb_sunny, 'color': Colors.orange},
    {'title': '비', 'desc': '빗소리 레이어', 'icon': Icons.water_drop, 'color': Colors.blue},
    {'title': '눈', 'desc': '포근한 앰비언트', 'icon': Icons.ac_unit, 'color': Colors.lightBlue},
    {'title': '강풍', 'desc': '브라운 노이즈', 'icon': Icons.air, 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('날씨'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherHeader(),
            SizedBox(height: 24.h),
            Text(
              "눈, 비, 바람 등 날씨 변화에 맞춰\n사운드 질감을 자동으로 조절합니다.",
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < _weatherModes.length; i++)
                    _buildWeatherStateCard(i),
                  if (!_autoAdjust && _selectedWeatherIndex > 0) ...[
                    SizedBox(height: 24.h),
                    _buildIntensitySlider(),
                  ],
                ],
              ),
            ),
            _buildControlSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Row(
      children: [
        Icon(Icons.wb_sunny, size: 48.w, color: Colors.orange),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 날씨: 맑음', style: AppTextStyles.titleMedium),
            Text('서울, 24°C', style: AppTextStyles.bodyMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherStateCard(int index) {
    final mode = _weatherModes[index];
    final isActive = _autoAdjust ? index == 0 : _selectedWeatherIndex == index;
    
    return GestureDetector(
      onTap: _autoAdjust ? null : () {
        setState(() {
          _selectedWeatherIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? mode['color'].withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive ? mode['color'] : AppColors.textGrey.withOpacity(0.1),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(mode['icon'], color: isActive ? mode['color'] : AppColors.textGrey, size: 24.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode['title'],
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? AppColors.textDarkNavy : AppColors.textGrey,
                    ),
                  ),
                  Text(
                    '${mode['desc']}${index > 0 ? ' +${(_layerIntensity[mode['title']]! * 100).toInt()}%' : ''}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isActive ? AppColors.textDarkNavy.withOpacity(0.7) : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              Icon(Icons.check_circle, color: mode['color'], size: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensitySlider() {
    final currentMode = _weatherModes[_selectedWeatherIndex];
    final currentIntensity = _layerIntensity[currentMode['title']]!;
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.textGrey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '레이어 강도 조절',
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(currentMode['icon'], color: currentMode['color'], size: 20.w),
              SizedBox(width: 8.w),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: currentMode['color'],
                    inactiveTrackColor: currentMode['color'].withOpacity(0.2),
                    thumbColor: currentMode['color'],
                    overlayColor: currentMode['color'].withOpacity(0.2),
                  ),
                  child: Slider(
                    value: currentIntensity,
                    min: 0.0,
                    max: 0.5,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        _layerIntensity[currentMode['title']] = value;
                      });
                    },
                  ),
                ),
              ),
              Text(
                '+${(currentIntensity * 100).toInt()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: currentMode['color'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlSection() {
    return Column(
      children: [
        // 위치 정보 토글
        Container(
          padding: EdgeInsets.all(20.w),
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: _locationEnabled ? AppColors.primaryBlue : Colors.grey),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('위치 정보 사용', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      _locationEnabled ? '현재 위치의 날씨 반영 중' : '위치 기반 날씨 동기화',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _locationEnabled,
                onChanged: (val) {
                  setState(() {
                    _locationEnabled = val;
                    // 실제 구현 시 여기서 위치 권한 요청
                    // if (val) requestLocationPermission();
                  });
                },
                activeColor: AppColors.primaryBlue,
              ),
            ],
          ),
        ),
        // 자동 조절 스위치
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('자동 조절', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              Switch(
                value: _autoAdjust,
                onChanged: (val) {
                  setState(() {
                    _autoAdjust = val;
                    if (val) {
                      _selectedWeatherIndex = 0; // 자동 모드로 전환시 맑음으로 리셋
                    }
                  });
                },
                activeColor: AppColors.primaryBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
