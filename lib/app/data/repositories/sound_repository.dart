import '../models/sound_model.dart';

class SoundRepository {
  // 더미 데이터
  final List<SoundModel> _allSounds = [
    // 강아지 무료
    SoundModel(
      id: 'd1',
      title: 'Deep Sleep',
      category: 'Dog',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      defaultBpm: 60,
      isPremium: false,
    ),
    // 강아지 유료
    SoundModel(
      id: 'd2',
      title: 'Noise Masking',
      category: 'Dog',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      defaultBpm: 60,
      isPremium: true,
    ),
    // 고양이 무료
    SoundModel(
      id: 'c1',
      title: 'Purr Healing',
      category: 'Cat',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      defaultBpm: 50,
      isPremium: false,
    ),
    // 고양이 유료
    SoundModel(
      id: 'c2',
      title: 'New Environment',
      category: 'Cat',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      defaultBpm: 50,
      isPremium: true,
    ),
  ];

  List<SoundModel> getSoundsBySpecies(String species) {
    // species: 'Dog', 'Cat', 'Owner'
    // 간단한 매핑 로직 (실제로는 더 복잡할 수 있음)
    String category = 'Dog';
    if (species == '고양이') category = 'Cat';
    if (species == '보호자') category = 'Owner';

    return _allSounds.where((s) => s.category == category).toList();
  }
}
