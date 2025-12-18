import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import '../../../../core/theme/app_colors.dart';
import '../../../data/services/sound_mixer_service.dart';

/// Premium Mix Panel Bottom Sheet with beautiful UI/UX
class MixPanelBottomSheet extends StatelessWidget {
  const MixPanelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Lazy get or register
    final mixerService = Get.isRegistered<SoundMixerService>()
        ? Get.find<SoundMixerService>()
        : Get.put(SoundMixerService());
    
    return Container(
      constraints: BoxConstraints(maxHeight: 0.75.sh),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1A1B3A),
            const Color(0xFF0D0E1F),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withOpacity(0.3),
                        Colors.blue.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'mix_panel_title'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'mix_panel_desc'.tr,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          
          // Master Volume
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _buildMasterVolumeSlider(mixerService),
          ),
          SizedBox(height: 20.h),
          
          // Sound Layers Grid
          Expanded(
            child: Obx(() => GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.85,
              ),
              itemCount: mixerService.layers.length,
              itemBuilder: (context, index) {
                final layer = mixerService.layers[index];
                return _buildLayerCard(layer, mixerService);
              },
            )),
          ),
          
          // Active layers indicator
          Obx(() {
            final count = mixerService.activeLayerCount;
            if (count == 0) return SizedBox(height: 16.h);
            
            return Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.graphic_eq, color: Colors.green, size: 20.w),
                  SizedBox(width: 8.w),
                  Text(
                    'mix_layers_active'.trParams({'count': count.toString()}),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildMasterVolumeSlider(SoundMixerService mixerService) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.volume_up, color: Colors.white70, size: 20.w),
              SizedBox(width: 12.w),
              Text(
                'master_volume'.tr,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Obx(() => Text(
                '${(mixerService.masterVolume.value * 100).round()}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() => SliderTheme(
            data: SliderThemeData(
              trackHeight: 6.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
              activeTrackColor: AppColors.primaryBlue,
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: Colors.white,
              overlayColor: AppColors.primaryBlue.withOpacity(0.2),
            ),
            child: Slider(
              value: mixerService.masterVolume.value,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                mixerService.setMasterVolume(value);
              },
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildLayerCard(MixableSound layer, SoundMixerService mixerService) {
    return Obx(() {
      final isActive = layer.isActive.value;
      
      return GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          mixerService.toggleLayer(layer.type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getLayerColor(layer.type).withOpacity(0.4),
                      _getLayerColor(layer.type).withOpacity(0.2),
                    ],
                  )
                : null,
            color: isActive ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isActive 
                  ? _getLayerColor(layer.type).withOpacity(0.6)
                  : Colors.white.withOpacity(0.1),
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _getLayerColor(layer.type).withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: isActive 
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getLayerIcon(layer.type),
                  color: isActive 
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  size: 24.w,
                ),
              ),
              SizedBox(height: 10.h),
              
              // Name
              Text(
                layer.name,
                style: TextStyle(
                  color: isActive 
                      ? Colors.white
                      : Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              
              // Volume indicator (only when active)
              if (isActive)
                Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: layer.volume.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
  
  Color _getLayerColor(SoundLayer type) {
    switch (type) {
      case SoundLayer.rain:
        return Colors.blue;
      case SoundLayer.thunder:
        return Colors.purple;
      case SoundLayer.ocean:
        return Colors.cyan;
      case SoundLayer.forest:
        return Colors.green;
      case SoundLayer.fireplace:
        return Colors.orange;
      case SoundLayer.wind:
        return Colors.teal;
      case SoundLayer.birds:
        return Colors.lime;
      case SoundLayer.whitenoise:
        return Colors.grey;
    }
  }
  
  IconData _getLayerIcon(SoundLayer type) {
    switch (type) {
      case SoundLayer.rain:
        return Icons.water_drop;
      case SoundLayer.thunder:
        return Icons.bolt;
      case SoundLayer.ocean:
        return Icons.waves;
      case SoundLayer.forest:
        return Icons.forest;
      case SoundLayer.fireplace:
        return Icons.local_fire_department;
      case SoundLayer.wind:
        return Icons.air;
      case SoundLayer.birds:
        return Icons.flutter_dash;
      case SoundLayer.whitenoise:
        return Icons.graphic_eq;
    }
  }
}
