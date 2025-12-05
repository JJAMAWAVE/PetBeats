#!/usr/bin/env python3
"""
MIDI 파일에서 사용된 악기 정보 추출 스크립트

사용법:
    python scripts/analyze_midi_instruments.py
    python scripts/analyze_midi_instruments.py --file assets/sound/1_1.mid
    python scripts/analyze_midi_instruments.py --all
"""

import os
import sys
from pathlib import Path
from typing import Dict, List, Set

try:
    from mido import MidiFile, MidiTrack
except ImportError:
    print("❌ mido 라이브러리가 설치되지 않았습니다.")
    print("다음 명령어로 설치하세요: pip install mido")
    sys.exit(1)


# General MIDI Instrument Names (Program Number 0-127)
GM_INSTRUMENTS = {
    # Piano (0-7)
    0: "Acoustic Grand Piano", 1: "Bright Acoustic Piano", 2: "Electric Grand Piano",
    3: "Honky-tonk Piano", 4: "Electric Piano 1", 5: "Electric Piano 2",
    6: "Harpsichord", 7: "Clavinet",
    
    # Chromatic Percussion (8-15)
    8: "Celesta", 9: "Glockenspiel", 10: "Music Box", 11: "Vibraphone",
    12: "Marimba", 13: "Xylophone", 14: "Tubular Bells", 15: "Dulcimer",
    
    # Organ (16-23)
    16: "Drawbar Organ", 17: "Percussive Organ", 18: "Rock Organ", 19: "Church Organ",
    20: "Reed Organ", 21: "Accordion", 22: "Harmonica", 23: "Tango Accordion",
    
    # Guitar (24-31)
    24: "Acoustic Guitar (nylon)", 25: "Acoustic Guitar (steel)", 26: "Electric Guitar (jazz)",
    27: "Electric Guitar (clean)", 28: "Electric Guitar (muted)", 29: "Overdriven Guitar",
    30: "Distortion Guitar", 31: "Guitar Harmonics",
    
    # Bass (32-39)
    32: "Acoustic Bass", 33: "Electric Bass (finger)", 34: "Electric Bass (pick)",
    35: "Fretless Bass", 36: "Slap Bass 1", 37: "Slap Bass 2",
    38: "Synth Bass 1", 39: "Synth Bass 2",
    
    # Strings (40-47)
    40: "Violin", 41: "Viola", 42: "Cello", 43: "Contrabass",
    44: "Tremolo Strings", 45: "Pizzicato Strings", 46: "Orchestral Harp", 47: "Timpani",
    
    # Ensemble (48-55)
    48: "String Ensemble 1", 49: "String Ensemble 2", 50: "Synth Strings 1", 51: "Synth Strings 2",
    52: "Choir Aahs", 53: "Voice Oohs", 54: "Synth Voice", 55: "Orchestra Hit",
    
    # Brass (56-63)
    56: "Trumpet", 57: "Trombone", 58: "Tuba", 59: "Muted Trumpet",
    60: "French Horn", 61: "Brass Section", 62: "Synth Brass 1", 63: "Synth Brass 2",
    
    # Reed (64-71)
    64: "Soprano Sax", 65: "Alto Sax", 66: "Tenor Sax", 67: "Baritone Sax",
    68: "Oboe", 69: "English Horn", 70: "Bassoon", 71: "Clarinet",
    
    # Pipe (72-79)
    72: "Piccolo", 73: "Flute", 74: "Recorder", 75: "Pan Flute",
    76: "Blown Bottle", 77: "Shakuhachi", 78: "Whistle", 79: "Ocarina",
    
    # Synth Lead (80-87)
    80: "Lead 1 (square)", 81: "Lead 2 (sawtooth)", 82: "Lead 3 (calliope)", 83: "Lead 4 (chiff)",
    84: "Lead 5 (charang)", 85: "Lead 6 (voice)", 86: "Lead 7 (fifths)", 87: "Lead 8 (bass + lead)",
    
    # Synth Pad (88-95)
    88: "Pad 1 (new age)", 89: "Pad 2 (warm)", 90: "Pad 3 (polysynth)", 91: "Pad 4 (choir)",
    92: "Pad 5 (bowed)", 93: "Pad 6 (metallic)", 94: "Pad 7 (halo)", 95: "Pad 8 (sweep)",
    
    # Synth Effects (96-103)
    96: "FX 1 (rain)", 97: "FX 2 (soundtrack)", 98: "FX 3 (crystal)", 99: "FX 4 (atmosphere)",
    100: "FX 5 (brightness)", 101: "FX 6 (goblins)", 102: "FX 7 (echoes)", 103: "FX 8 (sci-fi)",
    
    # Ethnic (104-111)
    104: "Sitar", 105: "Banjo", 106: "Shamisen", 107: "Koto",
    108: "Kalimba", 109: "Bagpipe", 110: "Fiddle", 111: "Shanai",
    
    # Percussive (112-119)
    112: "Tinkle Bell", 113: "Agogo", 114: "Steel Drums", 115: "Woodblock",
    116: "Taiko Drum", 117: "Melodic Tom", 118: "Synth Drum", 119: "Reverse Cymbal",
    
    # Sound Effects (120-127)
    120: "Guitar Fret Noise", 121: "Breath Noise", 122: "Seashore", 123: "Bird Tweet",
    124: "Telephone Ring", 125: "Helicopter", 126: "Applause", 127: "Gunshot"
}


def analyze_midi_file(filepath: Path) -> Dict:
    """MIDI 파일 분석하여 악기 및 템포 정보 추출"""
    try:
        midi = MidiFile(filepath)
        
        instruments: Set[int] = set()
        track_info: List[Dict] = []
        tempo_changes: List[Dict] = []
        
        # 템포 정보 추출
        for i, track in enumerate(midi.tracks):
            track_instruments: Set[int] = set()
            current_time = 0
            
            for msg in track:
                current_time += msg.time
                
                # Program Change 메시지에서 악기 정보 추출
                if msg.type == 'program_change':
                    instruments.add(msg.program)
                    track_instruments.add(msg.program)
                
                # Set Tempo 메타 메시지에서 템포 정보 추출
                elif msg.type == 'set_tempo':
                    # microseconds per beat -> BPM 변환
                    bpm = 60_000_000 / msg.tempo
                    tempo_changes.append({
                        'tick': current_time,
                        'microseconds_per_beat': msg.tempo,
                        'bpm': round(bpm, 2)
                    })
            
            if track_instruments:
                track_info.append({
                    'track_number': i,
                    'track_name': track.name if hasattr(track, 'name') else f'Track {i}',
                    'instruments': sorted(list(track_instruments))
                })
        
        # 평균 템포 계산 (가장 많이 사용된 템포)
        avg_tempo = None
        if tempo_changes:
            avg_tempo = tempo_changes[0]['bpm']  # 첫 번째 템포를 기본값으로
        
        return {
            'filepath': str(filepath),
            'filename': filepath.name,
            'all_instruments': sorted(list(instruments)),
            'tracks': track_info,
            'ticks_per_beat': midi.ticks_per_beat if hasattr(midi, 'ticks_per_beat') else None,
            'tempo_changes': tempo_changes,
            'bpm': avg_tempo,
            'num_tracks': len(midi.tracks)
        }
    
    except Exception as e:
        return {
            'filepath': str(filepath),
            'filename': filepath.name,
            'error': str(e)
        }


def print_analysis(result: Dict):
    """분석 결과 출력"""
    print(f"\n{'='*80}")
    print(f"📄 파일: {result['filename']}")
    print(f"{'='*80}")
    
    if 'error' in result:
        print(f"❌ 오류: {result['error']}")
        return
    
    print(f"📊 트랙 수: {result['num_tracks']}")
    
    # 템포 정보 출력
    if result.get('bpm'):
        print(f"🎵 템포: {result['bpm']} BPM")
        
        if result.get('tempo_changes'):
            tempo_changes = result['tempo_changes']
            if len(tempo_changes) > 1:
                print(f"   ⚠️  템포 변경 {len(tempo_changes)}회 발견:")
                for i, change in enumerate(tempo_changes, 1):
                    print(f"      #{i}: {change['bpm']} BPM (Tick: {change['tick']})")
            else:
                print(f"   ✓ 고정 템포 (변경 없음)")
    else:
        print(f"⚠️  템포 정보 없음")
    
    if result['all_instruments']:
        print(f"\n🎹 사용된 악기 (총 {len(result['all_instruments'])}개):")
        for program in result['all_instruments']:
            instrument_name = GM_INSTRUMENTS.get(program, f"Unknown ({program})")
            print(f"   [{program:3d}] {instrument_name}")
    else:
        print("\n⚠️  악기 정보를 찾을 수 없습니다. (드럼 전용 트랙이거나 프로그램 체인지가 없음)")
    
    if result['tracks']:
        print(f"\n📝 트랙별 상세 정보:")
        for track_data in result['tracks']:
            print(f"   Track {track_data['track_number']}: {track_data['track_name']}")
            for program in track_data['instruments']:
                instrument_name = GM_INSTRUMENTS.get(program, f"Unknown ({program})")
                print(f"      - [{program:3d}] {instrument_name}")


def analyze_all_midi_files(sound_dir: Path):
    """모든 MIDI 파일 분석"""
    midi_files = sorted(sound_dir.glob('*.mid'))
    
    if not midi_files:
        print(f"❌ {sound_dir}에서 MIDI 파일을 찾을 수 없습니다.")
        return
    
    print(f"\n🔍 총 {len(midi_files)}개의 MIDI 파일을 분석합니다...\n")
    
    # 악기별 사용 횟수 통계
    instrument_usage: Dict[int, int] = {}
    
    for midi_file in midi_files:
        result = analyze_midi_file(midi_file)
        print_analysis(result)
        
        # 통계 수집
        if 'all_instruments' in result:
            for program in result['all_instruments']:
                instrument_usage[program] = instrument_usage.get(program, 0) + 1
    
    # 통계 출력
    print(f"\n{'='*80}")
    print("📊 전체 악기 사용 통계")
    print(f"{'='*80}")
    
    sorted_instruments = sorted(instrument_usage.items(), key=lambda x: x[1], reverse=True)
    
    for program, count in sorted_instruments:
        instrument_name = GM_INSTRUMENTS.get(program, f"Unknown ({program})")
        print(f"[{program:3d}] {instrument_name:30s} - 사용 횟수: {count}회")


def main():
    """메인 함수"""
    import argparse
    
    parser = argparse.ArgumentParser(description='MIDI 파일 악기 정보 분석 도구')
    parser.add_argument('--file', '-f', type=str, help='분석할 MIDI 파일 경로')
    parser.add_argument('--all', '-a', action='store_true', help='모든 MIDI 파일 분석')
    
    args = parser.parse_args()
    
    project_root = Path(__file__).parent.parent
    sound_dir = project_root / 'assets' / 'sound'
    
    if args.file:
        # 특정 파일 분석
        filepath = Path(args.file)
        if not filepath.is_absolute():
            filepath = project_root / filepath
        
        if not filepath.exists():
            print(f"❌ 파일을 찾을 수 없습니다: {filepath}")
            sys.exit(1)
        
        result = analyze_midi_file(filepath)
        print_analysis(result)
    
    elif args.all:
        # 모든 파일 분석
        analyze_all_midi_files(sound_dir)
    
    else:
        # 기본: 대화형 모드
        print("🎵 MIDI 악기 분석 도구")
        print("\n옵션을 선택하세요:")
        print("1. 특정 파일 분석")
        print("2. 모든 파일 분석")
        print("3. 종료")
        
        choice = input("\n선택 (1-3): ").strip()
        
        if choice == '1':
            filename = input("파일명 입력 (예: 1_1.mid): ").strip()
            filepath = sound_dir / filename
            
            if not filepath.exists():
                print(f"❌ 파일을 찾을 수 없습니다: {filepath}")
                sys.exit(1)
            
            result = analyze_midi_file(filepath)
            print_analysis(result)
        
        elif choice == '2':
            analyze_all_midi_files(sound_dir)
        
        else:
            print("종료합니다.")


if __name__ == '__main__':
    main()
