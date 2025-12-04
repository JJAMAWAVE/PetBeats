class Track {
  final String id;
  final String title;
  final String target; // e.g., "공용", "대형", "중형", "소형"
  final String duration;
  final bool isPremium;
  final String audioUrl;
  final String? midiUrl;
  final String description; // AIVA settings or diversity point
  final String instrument;
  final String bpm;

  Track({
    required this.id,
    required this.title,
    required this.target,
    this.duration = '3:00',
    required this.isPremium,
    this.audioUrl = '',
    this.midiUrl,
    required this.description,
    this.instrument = 'Piano',
    this.bpm = '60 BPM',
  });
}
