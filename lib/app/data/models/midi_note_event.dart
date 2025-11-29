/// MIDI 노트 이벤트
class MidiNoteEvent {
  final int note;
  final int velocity;
  final DateTime timestamp;

  const MidiNoteEvent({
    required this.note,
    required this.velocity,
    required this.timestamp,
  });

  /// 강도 (0.0 ~ 1.0)
  double get intensity => velocity / 127.0;
}
