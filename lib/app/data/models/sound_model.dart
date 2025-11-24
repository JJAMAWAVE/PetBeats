class SoundModel {
  final String id;
  final String title;
  final String category; // 'Dog', 'Cat', 'Owner'
  final String audioUrl;
  final int defaultBpm;
  final bool isPremium;

  SoundModel({
    required this.id,
    required this.title,
    required this.category,
    required this.audioUrl,
    required this.defaultBpm,
    this.isPremium = false,
  });
}
