import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../premium/controllers/subscription_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../services/ai_playlist_generator_service.dart';
import '../models/ai_scenario.dart';
import '../../../data/models/track_model.dart';

/// AI 플레이리스트 결과 화면
class AIPlaylistResultView extends StatefulWidget {
  const AIPlaylistResultView({super.key});

  @override
  State<AIPlaylistResultView> createState() => _AIPlaylistResultViewState();
}

class _AIPlaylistResultViewState extends State<AIPlaylistResultView> {
  late final AIScenario scenario;
  List<Track>? _tracks;
  bool _isLoading = true;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // 문자열 또는 AIScenario 타입 모두 처리
    final arg = Get.arguments['scenario'];
    if (arg is AIScenario) {
      scenario = arg;
    } else if (arg is String) {
      scenario = _parseScenarioFromString(arg);
    } else {
      scenario = AIScenario.afterWalk; // 기본값
    }
    _generatePlaylist();
  }
  
  AIScenario _parseScenarioFromString(String str) {
    switch (str) {
      case 'afterWalk': return AIScenario.afterWalk;
      case 'napTime': return AIScenario.napTime;
      case 'hospital': return AIScenario.hospital;
      case 'grooming': return AIScenario.grooming;
      case 'thunder': return AIScenario.thunder;
      case 'anxiety': return AIScenario.anxiety;
      default: return AIScenario.afterWalk;
    }
  }

  Future<void> _generatePlaylist() async {
    try {
      if (!Get.isRegistered<AIPlaylistGeneratorService>()) {
        Get.put(AIPlaylistGeneratorService());
      }
      final service = Get.find<AIPlaylistGeneratorService>();
      final tracks = await service.generatePlaylist(scenario);
      
      // 총 재생 시간 계산
      Duration total = Duration.zero;
      for (final track in tracks) {
        if (track.duration != null) {
          final parts = track.duration!.split(':');
          if (parts.length == 2) {
            total += Duration(
              minutes: int.tryParse(parts[0]) ?? 0,
              seconds: int.tryParse(parts[1]) ?? 0,
            );
          }
        }
      }
      
      setState(() {
        _tracks = tracks;
        _totalDuration = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playAll() {
    if (_tracks == null || _tracks!.isEmpty) return;
    
    try {
      final homeController = Get.find<HomeController>();
      
      // 현재 플레이리스트 설정 (skip next/previous가 작동하도록)
      homeController.currentPlaylist.value = List<Track>.from(_tracks!);
      
      // 첫 번째 트랙 재생
      homeController.playTrack(_tracks!.first);
      
      // 상태 업데이트하여 UI 갱신
      setState(() {});
      
      Get.snackbar(
        '✅ 재생 시작',
        '${scenario.title} 플레이리스트 (${_tracks!.length}곡)',
        backgroundColor: scenario.color,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
      );
      
      // 홈으로 이동하지 않고 현재 페이지 유지
    } catch (e) {
      Get.snackbar('오류', '재생을 시작할 수 없습니다');
    }
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    }
    return '${minutes}분 ${seconds}초';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(scenario.title),
        backgroundColor: scenario.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading ? _buildLoadingView() : _buildResultView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: scenario.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              scenario.icon,
              size: 48.w,
              color: scenario.color,
            ),
          ),
          SizedBox(height: 24.h),
          CircularProgressIndicator(color: scenario.color),
          SizedBox(height: 16.h),
          Text(
            'AI가 맞춤 플레이리스트를\n생성하고 있어요...',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    if (_tracks == null || _tracks!.isEmpty) {
      return Center(
        child: Text('플레이리스트를 생성할 수 없습니다'),
      );
    }

    return Column(
      children: [
        // 헤더
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: scenario.color,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              Icon(
                scenario.icon,
                size: 48.w,
                color: Colors.white,
              ),
              SizedBox(height: 12.h),
              Text(
                scenario.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.music_note, color: Colors.white, size: 16.w),
                    SizedBox(width: 6.w),
                    Text(
                      '${_tracks!.length}곡  •  ${_formatDuration(_totalDuration)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 트랙 리스트
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: _tracks!.length,
            itemBuilder: (context, index) => _buildTrackItem(_tracks![index], index),
          ),
        ),
        
        // 하단 미니 플레이어 (재생 중일 때) 또는 재생 버튼
        SafeArea(
          child: _buildBottomPlayer(),
        ),
      ],
    );
  }

  Widget _buildBottomPlayer() {
    HomeController? homeController;
    Track? currentTrack;
    bool isPlaying = false;
    
    try {
      homeController = Get.find<HomeController>();
      currentTrack = homeController.currentTrack.value;
      isPlaying = homeController.isPlaying.value;
    } catch (e) {
      // ignore
    }
    
    // 재생 중이 아니면 "전체 재생" 버튼 표시
    if (currentTrack == null) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _playAll,
            icon: const Icon(Icons.play_circle_filled),
            label: const Text('전체 재생'),
            style: ElevatedButton.styleFrom(
              backgroundColor: scenario.color,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ),
      );
    }
    
    // 재생 중인 트랙이 있으면 미니 플레이어 표시
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: scenario.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 트랙 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentTrack.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (currentTrack.description != null)
                  Text(
                    currentTrack.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          
          // 이전 곡
          IconButton(
            icon: Icon(Icons.skip_previous, color: Colors.white, size: 28.w),
            onPressed: () {
              homeController?.skipPrevious();
              setState(() {});
            },
          ),
          
          // 재생/일시정지
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.white,
              size: 40.w,
            ),
            onPressed: () {
              homeController?.togglePlay();
              setState(() {});
            },
          ),
          
          // 다음 곡
          IconButton(
            icon: Icon(Icons.skip_next, color: Colors.white, size: 28.w),
            onPressed: () {
              homeController?.skipNext();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
  Widget _buildTrackItem(Track track, int index) {
    // 현재 재생 중인 트랙인지 확인
    HomeController? homeController;
    bool isCurrentTrack = false;
    bool isPlaying = false;
    
    try {
      homeController = Get.find<HomeController>();
      isCurrentTrack = homeController.currentTrack.value?.id == track.id;
      isPlaying = homeController.isPlaying.value && isCurrentTrack;
    } catch (e) {
      // ignore
    }
    
    return GestureDetector(
      onTap: () {
        if (homeController != null && _tracks != null) {
          // 플레이리스트 설정 후 트랙 재생
          homeController.currentPlaylist.value = List<Track>.from(_tracks!);
          homeController.playTrack(track);
          setState(() {});
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isCurrentTrack 
              ? scenario.color.withOpacity(0.15) 
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: isCurrentTrack 
              ? Border.all(color: scenario.color, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // 재생 중 아이콘 또는 번호
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isCurrentTrack 
                    ? scenario.color 
                    : scenario.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: isPlaying
                    ? Icon(Icons.volume_up, color: Colors.white, size: 18.w)
                    : isCurrentTrack
                        ? Icon(Icons.pause, color: Colors.white, size: 18.w)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: scenario.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCurrentTrack ? scenario.color : null,
                    ),
                  ),
                  if (track.description != null)
                    Text(
                      track.description!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isCurrentTrack 
                            ? scenario.color.withOpacity(0.7)
                            : AppColors.textGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Text(
              track.duration ?? '-:--',
              style: AppTextStyles.bodySmall.copyWith(
                color: isCurrentTrack ? scenario.color : AppColors.textGrey,
                fontWeight: isCurrentTrack ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
