#!/usr/bin/env python3
"""
MIDI 파일 상세 분석 - 모든 메시지 확인
"""

from pathlib import Path
from mido import MidiFile, MetaMessage

def deep_analyze_midi(filepath: Path):
    """MIDI 파일의 모든 메시지 상세 분석"""
    print(f"\n{'='*80}")
    print(f"📄 파일: {filepath.name}")
    print(f"{'='*80}\n")
    
    midi = MidiFile(filepath)
    
    print(f"Type: {midi.type}")
    print(f"Ticks per beat: {midi.ticks_per_beat}")
    print(f"Total tracks: {len(midi.tracks)}\n")
    
    for i, track in enumerate(midi.tracks):
        print(f"\n{'─'*80}")
        print(f"TRACK {i}: {track.name if hasattr(track, 'name') else 'Unnamed'}")
        print(f"{'─'*80}")
        
        # 모든 메시지 타입 수집
        msg_types = {}
        program_changes = []
        note_count = 0
        
        for msg in track:
            msg_type = msg.type
            msg_types[msg_type] = msg_types.get(msg_type, 0) + 1
            
            if msg.type == 'program_change':
                program_changes.append({
                    'channel': msg.channel,
                    'program': msg.program,
                    'time': msg.time
                })
            
            if msg.type == 'note_on':
                note_count += 1
            
            # Track name과 instrument name 확인
            if msg.type == 'track_name':
                print(f"  🏷️  Track Name: {msg.name}")
            
            if hasattr(msg, 'name') and 'instrument' in msg.type.lower():
                print(f"  🎹 Instrument Name: {msg.name}")
        
        print(f"\n  📊 메시지 타입 통계:")
        for msg_type, count in sorted(msg_types.items()):
            print(f"     - {msg_type}: {count}회")
        
        print(f"\n  🎵 노트 수: {note_count}")
        
        if program_changes:
            print(f"\n  🎹 Program Changes:")
            for pc in program_changes:
                print(f"     Channel {pc['channel']}: Program {pc['program']} (time: {pc['time']})")
        else:
            print(f"\n  ⚠️  Program Change 메시지 없음")

def main():
    project_root = Path(__file__).parent.parent
    
    # 여러 파일 샘플 분석
    test_files = [
        'assets/sound/1_1.mid',  # Sleep - Piano
        'assets/sound/1_7.mid',  # Sleep - Harp
        'assets/sound/2_1.mid',  # Separation - Cello
        'assets/sound/4_1.mid',  # Energy
    ]
    
    for file_path in test_files:
        full_path = project_root / file_path
        if full_path.exists():
            deep_analyze_midi(full_path)
        else:
            print(f"⚠️  {file_path} not found")

if __name__ == '__main__':
    main()
