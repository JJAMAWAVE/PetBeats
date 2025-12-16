import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../models/ai_scenario.dart';
import '../../../data/data_source/track_data.dart';
import '../../../data/models/track_model.dart';

/// AI 플레이리스트 생성 서비스
class AIPlaylistGeneratorService extends GetxService {
  static AIPlaylistGeneratorService get to => Get.find<AIPlaylistGeneratorService>();

  /// 시나리오별 플레이리스트 생성
  Future<List<Track>> generatePlaylist(AIScenario scenario) async {
    debugPrint('[AIPlaylist] Generating for: ${scenario.title}');
    
    // 시뮬레이션 딜레이 (AI 생성 효과)
    await Future.delayed(const Duration(seconds: 2));
    
    // 시나리오별 트랙 선택
    final tracks = _selectTracksForScenario(scenario);
    
    debugPrint('[AIPlaylist] Generated ${tracks.length} tracks');
    return tracks;
  }

  List<Track> _selectTracksForScenario(AIScenario scenario) {
    // 시나리오별 트랙 카테고리 선택
    switch (scenario) {
      case AIScenario.afterWalk:
        // 산책 후: Sleep + Senior 믹스 (진정)
        return _mixTracks(TrackData.sleepTracks, TrackData.seniorTracks, 4);
      
      case AIScenario.napTime:
        // 낮잠: Sleep 중심
        return _shuffleTake(TrackData.sleepTracks, 5);
      
      case AIScenario.hospital:
        // 병원: Senior + Separation (안정)
        return _mixTracks(TrackData.seniorTracks, TrackData.separationTracks, 4);
      
      case AIScenario.grooming:
        // 미용 후: Sleep + Senior 믹스
        return _mixTracks(TrackData.sleepTracks, TrackData.seniorTracks, 4);
      
      case AIScenario.thunder:
        // 천둥: Noise 중심 (마스킹)
        return _shuffleTake(TrackData.noiseTracks, 5);
      
      case AIScenario.anxiety:
        // 분리 불안: Separation 중심
        return _shuffleTake(TrackData.separationTracks, 5);
    }
  }

  /// 두 리스트에서 트랙을 섞어서 가져오기
  List<Track> _mixTracks(List<Track> list1, List<Track> list2, int total) {
    final result = <Track>[];
    final shuffled1 = List<Track>.from(list1)..shuffle();
    final shuffled2 = List<Track>.from(list2)..shuffle();
    
    final half = total ~/ 2;
    result.addAll(shuffled1.take(half));
    result.addAll(shuffled2.take(total - half));
    result.shuffle();
    
    return result;
  }

  /// 리스트를 셔플하고 n개 가져오기
  List<Track> _shuffleTake(List<Track> list, int n) {
    final shuffled = List<Track>.from(list)..shuffle();
    return shuffled.take(n).toList();
  }
}
