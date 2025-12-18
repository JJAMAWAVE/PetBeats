import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/services/weather_service.dart';
import '../../../data/services/weather_sound_manager.dart';
import '../../../data/services/sound_mixer_service.dart';  // ✨ For volume control
import '../../../data/services/rhythm_care_service.dart';  // ✨ For time simulation
import '../../invite/controllers/invite_controller.dart';  // ✨ For invite simulation
import '../../../data/services/coupon_service.dart';  // ✨ For subscription reset
import '../controllers/home_controller.dart';
import 'dart:ui';

/// Debug Bottom Sheet for Testing
/// Allows quick switching between premium/free modes and weather conditions
class DebugBottomSheet extends StatefulWidget {
  const DebugBottomSheet({super.key});

  @override
  State<DebugBottomSheet> createState() => _DebugBottomSheetState();
}

class _DebugBottomSheetState extends State<DebugBottomSheet> {
  final List<String> _testConditions = ['Clear', 'Clouds', 'Rain', 'Snow', 'Thunderstorm', 'Mist'];
  String? _selectedTestCondition;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A3A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
            ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bug_report, color: Colors.orange, size: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    'Debug Panel',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              
              // Premium Toggle
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Obx(() {
                  final isPremium = homeController.isPremiumUser.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '프리미엄 상태',
                            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isPremium ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              isPremium ? '👑 PRO' : '🆓 FREE',
                              style: TextStyle(
                                color: isPremium ? Colors.amber : Colors.grey,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isPremium,
                        activeColor: Colors.amber,
                        onChanged: (value) {
                          homeController.isPremiumUser.value = value;
                          
                          // OFF로 전환 시 모든 구독 데이터 초기화
                          if (!value) {
                            // 쿠폰/구독 정보 초기화
                            if (Get.isRegistered<CouponService>()) {
                              Get.find<CouponService>().resetAll();
                            }
                            // 친구 초대 진행 상황 초기화
                            if (Get.isRegistered<InviteController>()) {
                              Get.find<InviteController>().resetProgress();
                            }
                          }
                          
                          Get.snackbar(
                            '🧪 테스트',
                            value ? '프리미엄 모드 ON' : '무료 모드 + 구독 데이터 초기화',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: value ? Colors.amber : Colors.blueGrey,
                            duration: const Duration(seconds: 2),
                          );
                        },
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 16.h),
              
              // Weather Test
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '날씨 시뮬레이션',
                          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                        ),
                        // ✨ Sound Play/Stop Toggle Button
                        Obx(() {
                          final isPlaying = Get.isRegistered<WeatherSoundManager>() 
                              ? Get.find<WeatherSoundManager>().isWeatherMixActive.value 
                              : false;
                          return ElevatedButton.icon(
                            onPressed: () {
                              if (!Get.isRegistered<WeatherSoundManager>()) return;
                              final manager = Get.find<WeatherSoundManager>();
                              
                              if (isPlaying) {
                                // Stop sound
                                manager.disableWeatherMix();
                                Get.snackbar('🔇', '사운드 정지', 
                                  snackPosition: SnackPosition.BOTTOM, 
                                  backgroundColor: Colors.grey,
                                  duration: const Duration(seconds: 1),
                                );
                              } else {
                                // Play sound (need to select weather first)
                                if (_selectedTestCondition == null) {
                                  Get.snackbar('⚠️', '먼저 날씨를 선택하세요', 
                                    snackPosition: SnackPosition.BOTTOM, 
                                    backgroundColor: Colors.orange,
                                    duration: const Duration(seconds: 1),
                                  );
                                  return;
                                }
                                manager.enableWeatherMix();
                                Get.snackbar('🔊', '사운드 재생', 
                                  snackPosition: SnackPosition.BOTTOM, 
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 1),
                                );
                              }
                            },
                            icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow, size: 18.w),
                            label: Text(isPlaying ? '정지' : '재생', style: TextStyle(fontSize: 12.sp)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPlaying ? Colors.red : Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                              minimumSize: Size.zero,
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    
                    // ✨ Volume Slider
                    Obx(() {
                      final mixer = Get.isRegistered<SoundMixerService>() 
                          ? Get.find<SoundMixerService>() 
                          : null;
                      final volume = mixer?.masterVolume.value ?? 0.7;
                      
                      return Row(
                        children: [
                          Icon(Icons.volume_up, color: Colors.white70, size: 20.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Slider(
                              value: volume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: AppColors.primaryBlue,
                              inactiveColor: Colors.white24,
                              onChanged: (value) {
                                if (mixer != null) {
                                  mixer.setMasterVolume(value);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 40.w,
                            child: Text(
                              '${(volume * 100).toInt()}%',
                              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _testConditions.map((condition) {
                        final isSelected = _selectedTestCondition == condition;
                        IconData icon;
                        Color color;
                        
                        switch (condition) {
                          case 'Clear': icon = Icons.wb_sunny; color = Colors.orange; break;
                          case 'Clouds': icon = Icons.cloud; color = Colors.blueGrey; break;
                          case 'Rain': icon = Icons.water_drop; color = Colors.blue; break;
                          case 'Snow': icon = Icons.ac_unit; color = Colors.lightBlue; break;
                          case 'Thunderstorm': icon = Icons.flash_on; color = Colors.amber; break;
                          case 'Mist': icon = Icons.blur_on; color = Colors.grey; break;
                          default: icon = Icons.help; color = Colors.white;
                        }
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedTestCondition = condition);
                            // Update weather condition only (no auto-play)
                            if (Get.isRegistered<WeatherService>()) {
                              final ws = Get.find<WeatherService>();
                              ws.weatherCondition.value = condition;
                              ws.temperature.value = 15.0;
                            }
                            Get.snackbar('🌤️', '날씨: $condition (재생 버튼을 눌러 확인)', 
                              snackPosition: SnackPosition.BOTTOM, 
                              backgroundColor: color.withOpacity(0.8),
                              duration: const Duration(seconds: 1),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected ? color.withOpacity(0.3) : Colors.white10,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected ? color : Colors.white24,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, color: color, size: 16.w),
                                SizedBox(width: 6.w),
                                Text(
                                  condition,
                                  style: TextStyle(
                                    color: isSelected ? color : Colors.white70,
                                    fontSize: 12.sp,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              
              // ✨ Time Simulation (Rhythm Care Test)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '시간 시뮬레이션 (리듬 케어)',
                          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                        ),
                        // Reset Button
                        TextButton(
                          onPressed: () {
                            if (Get.isRegistered<RhythmCareService>()) {
                              Get.find<RhythmCareService>().clearDebugTime();
                              Get.snackbar('🕐', '실제 시간으로 복귀', 
                                snackPosition: SnackPosition.BOTTOM, 
                                backgroundColor: Colors.blue,
                                duration: const Duration(seconds: 1),
                              );
                            }
                          },
                          child: Text('리셋', style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Time Buttons
                    Obx(() {
                      final rhythmService = Get.isRegistered<RhythmCareService>()
                          ? Get.find<RhythmCareService>()
                          : null;
                      final currentZone = rhythmService?.currentTimeZone.value ?? 'sleep';
                      
                      return Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          _buildTimeButton('☀️', '오전', 8, currentZone == 'energy'),
                          _buildTimeButton('🌤️', '주간', 13, currentZone == 'anxiety'),
                          _buildTimeButton('🌅', '저녁', 19, currentZone == 'senior'),
                          _buildTimeButton('😴', '심야', 23, currentZone == 'sleep'),
                        ],
                      );
                    }),
                    SizedBox(height: 8.h),
                    // Current Status
                    Obx(() {
                      final rhythmService = Get.isRegistered<RhythmCareService>()
                          ? Get.find<RhythmCareService>()
                          : null;
                      if (rhythmService == null) return const SizedBox.shrink();
                      
                      return Row(
                        children: [
                          Text(
                            '현재: ${rhythmService.currentTimeZoneIcon.value} ${rhythmService.currentTimeZoneName.value}',
                            style: TextStyle(color: Colors.white54, fontSize: 11.sp),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: rhythmService.isEnabled.value ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              rhythmService.isEnabled.value ? 'ON' : 'OFF',
                              style: TextStyle(color: Colors.white, fontSize: 9.sp),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              
              // ✨ Friend Invite Simulation
              _buildInviteSimulator(),
              SizedBox(height: 16.h),
              
              // ✨ Subscription Expiry Test
              _buildSubscriptionExpiryTest(),
              SizedBox(height: 24.h),
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    '닫기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
  
  /// 시간 시뮬레이션 버튼 빌더
  Widget _buildTimeButton(String icon, String label, int hour, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<RhythmCareService>()) {
          Get.find<RhythmCareService>().setDebugTime(hour);
          Get.snackbar('🕐', '$icon $label (${hour}:00) 시뮬레이션', 
            snackPosition: SnackPosition.BOTTOM, 
            backgroundColor: Colors.purple,
            duration: const Duration(seconds: 1),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: 16.sp)),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.purple : Colors.white70,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 친구 초대 시뮬레이터 위젯
  Widget _buildInviteSimulator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '친구 초대 시뮬레이션',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              TextButton(
                onPressed: () {
                  if (Get.isRegistered<InviteController>()) {
                    Get.find<InviteController>().resetProgress();
                    setState(() {});
                    Get.snackbar('🔄', '초대 진행 상황 초기화됨', 
                      snackPosition: SnackPosition.BOTTOM, 
                      backgroundColor: Colors.blue,
                      duration: const Duration(seconds: 1),
                    );
                  }
                },
                child: Text('리셋', style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Current Status
          Builder(
            builder: (context) {
              if (!Get.isRegistered<InviteController>()) {
                return Text(
                  'InviteController 미등록',
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                );
              }
              
              final controller = Get.find<InviteController>();
              
              return Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '👥 ${controller.friendsJoined.value}명 가입',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Tier badges
                      if (controller.tier1Rewarded.value)
                        _buildTierBadge('1', Colors.blue),
                      if (controller.tier2Rewarded.value)
                        _buildTierBadge('3', Colors.purple),
                      if (controller.tier3Rewarded.value)
                        _buildTierBadge('5', Colors.amber),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Control Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.simulateFriendJoin();
                            setState(() {});
                          },
                          icon: Icon(Icons.person_add, size: 16.w),
                          label: Text('+1명', style: TextStyle(fontSize: 12.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Add 3 friends at once
                            for (int i = 0; i < 3; i++) {
                              controller.onFriendJoined();
                            }
                            setState(() {});
                            Get.snackbar('🧪', '친구 3명 가입! (총 ${controller.friendsJoined.value}명)',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 1),
                            );
                          },
                          icon: Icon(Icons.group_add, size: 16.w),
                          label: Text('+3명', style: TextStyle(fontSize: 12.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
            },
          ),
        ],
      ),
    );
  }

  /// 티어 배지 빌더
  Widget _buildTierBadge(String tier, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '✓$tier',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 구독 만료/테스트 시뮬레이터
  Widget _buildSubscriptionExpiryTest() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.subscriptions, color: Colors.amber, size: 18.w),
              SizedBox(width: 8.w),
              Text(
                '구독 테스트 시뮬레이션',
                style: TextStyle(color: Colors.amber, fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Current Status Display
          Obx(() {
            final couponService = Get.isRegistered<CouponService>() 
                ? Get.find<CouponService>() 
                : null;
            final expiryDate = couponService?.proExpiryDate.value;
            final isPro = couponService?.isPro ?? false;
            final remainingDays = couponService?.proRemainingDays ?? 0;
            
            String statusText;
            Color statusColor;
            if (isPro) {
              if (expiryDate != null) {
                final diff = expiryDate.difference(DateTime.now());
                if (diff.inMinutes <= 5) {
                  statusText = '⏰ 곧 만료 (${diff.inMinutes}분 ${diff.inSeconds % 60}초)';
                  statusColor = Colors.red;
                } else {
                  statusText = '✅ PRO ($remainingDays일 남음)';
                  statusColor = Colors.green;
                }
              } else {
                statusText = '✅ PRO 활성';
                statusColor = Colors.green;
              }
            } else {
              statusText = '❌ 무료 사용자';
              statusColor = Colors.grey;
            }
            
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(statusText, style: TextStyle(color: statusColor, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                  if (expiryDate != null)
                    Text('만료: ${expiryDate.toString().substring(0, 19)}', 
                      style: TextStyle(color: Colors.white54, fontSize: 10.sp)),
                ],
              ),
            );
          }),
          SizedBox(height: 12.h),
          
          // 테스트 시나리오 버튼들
          Text('📋 테스트 시나리오', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
          SizedBox(height: 8.h),
          
          // Row 1: 만료 시간 테스트
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              _buildTestButton('⏱️ 1분 후 만료', Colors.red, () {
                _setSubscriptionExpiry(Duration(minutes: 1), '1분 후 만료 테스트');
              }),
              _buildTestButton('⏱️ 5분 후 만료', Colors.orange, () {
                _setSubscriptionExpiry(Duration(minutes: 5), '5분 후 만료 테스트');
              }),
              _buildTestButton('📅 7일 체험', Colors.blue, () {
                _setSubscriptionExpiry(Duration(days: 7), '7일 무료 체험');
              }),
            ],
          ),
          SizedBox(height: 8.h),
          
          // Row 2: 구독 상태 시뮬레이션
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              _buildTestButton('🔄 갱신 성공', Colors.green, () {
                _simulateRenewal();
              }),
              _buildTestButton('❌ 갱신 실패', Colors.red, () {
                _simulateRenewalFailure();
              }),
              _buildTestButton('⏸️ 유예 기간', Colors.amber, () {
                _simulateGracePeriod();
              }),
            ],
          ),
          SizedBox(height: 8.h),
          
          // Row 3: 기타 시나리오
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              _buildTestButton('💳 환불', Colors.purple, () {
                _simulateRefund();
              }),
              _buildTestButton('📱 복원', Colors.teal, () {
                _simulateRestore();
              }),
              _buildTestButton('🗑️ 전체 초기화', Colors.grey, () {
                _resetAllSubscription();
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// 테스트 버튼 빌더
  Widget _buildTestButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// 구독 만료 시간 설정
  void _setSubscriptionExpiry(Duration duration, String description) {
    final couponService = Get.find<CouponService>();
    final homeController = Get.find<HomeController>();
    final now = DateTime.now();
    final expiry = now.add(duration);
    
    couponService.proExpiryDate.value = expiry;
    homeController.isPremiumUser.value = true;
    
    // 쿠폰 기록 추가
    couponService.registeredCoupons.insert(0, Coupon(
      code: 'TEST_${now.millisecondsSinceEpoch}',
      type: 'pro_days',
      value: duration.inDays > 0 ? duration.inDays : 1,
      description: '🧪 $description',
      registeredAt: now,
    ));
    
    Get.snackbar('🧪 테스트', description,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber,
      duration: const Duration(seconds: 2),
    );
    setState(() {});
  }

  /// 갱신 성공 시뮬레이션
  void _simulateRenewal() {
    final couponService = Get.find<CouponService>();
    final homeController = Get.find<HomeController>();
    final now = DateTime.now();
    
    // 30일 추가
    couponService.proExpiryDate.value = now.add(Duration(days: 30));
    homeController.isPremiumUser.value = true;
    
    couponService.registeredCoupons.insert(0, Coupon(
      code: 'RENEWAL_${now.millisecondsSinceEpoch}',
      type: 'pro_days',
      value: 30,
      description: '🔄 구독 자동 갱신',
      registeredAt: now,
    ));
    
    Get.snackbar('🔄 갱신 성공', '구독이 자동으로 갱신되었습니다 (+30일)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    );
    setState(() {});
  }

  /// 갱신 실패 시뮬레이션 (결제 실패)
  void _simulateRenewalFailure() {
    final couponService = Get.find<CouponService>();
    final homeController = Get.find<HomeController>();
    
    // 만료 처리
    couponService.proExpiryDate.value = DateTime.now().subtract(Duration(hours: 1));
    homeController.isPremiumUser.value = false;
    
    Get.snackbar('❌ 갱신 실패', '결제 수단에 문제가 있습니다. 결제 정보를 확인해주세요.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    );
    setState(() {});
  }

  /// 유예 기간 시뮬레이션 (Grace Period)
  void _simulateGracePeriod() {
    final couponService = Get.find<CouponService>();
    final homeController = Get.find<HomeController>();
    
    // 유예 기간 3일
    couponService.proExpiryDate.value = DateTime.now().add(Duration(days: 3));
    homeController.isPremiumUser.value = true;
    
    Get.snackbar('⏸️ 유예 기간', '결제 실패로 유예 기간 중입니다 (3일 내 결제 필요)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber,
      colorText: Colors.black,
      duration: const Duration(seconds: 3),
    );
    setState(() {});
  }

  /// 환불 시뮬레이션
  void _simulateRefund() {
    final couponService = Get.find<CouponService>();
    final homeController = Get.find<HomeController>();
    
    // 즉시 만료
    couponService.proExpiryDate.value = null;
    homeController.isPremiumUser.value = false;
    
    Get.snackbar('💳 환불 처리됨', '구독이 환불되어 프리미엄이 해제되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.purple,
      duration: const Duration(seconds: 2),
    );
    setState(() {});
  }

  /// 복원 시뮬레이션
  void _simulateRestore() {
    final couponService = Get.find<CouponService>();
    final homeController = Get.find<HomeController>();
    final now = DateTime.now();
    
    // 기존 구독 복원 (30일)
    couponService.proExpiryDate.value = now.add(Duration(days: 30));
    homeController.isPremiumUser.value = true;
    
    couponService.registeredCoupons.insert(0, Coupon(
      code: 'RESTORE_${now.millisecondsSinceEpoch}',
      type: 'pro_days',
      value: 30,
      description: '📱 구독 복원',
      registeredAt: now,
    ));
    
    Get.snackbar('📱 복원 완료', '기존 구독이 복원되었습니다 (+30일)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      duration: const Duration(seconds: 2),
    );
    setState(() {});
  }

  /// 전체 초기화
  void _resetAllSubscription() {
    final couponService = Get.find<CouponService>();
    final homeController = Get.find<HomeController>();
    
    couponService.resetAll();
    homeController.isPremiumUser.value = false;
    
    Get.snackbar('🗑️ 초기화', '모든 구독 데이터가 초기화되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey,
      duration: const Duration(seconds: 2),
    );
    setState(() {});
  }
}
