#!/usr/bin/env python3
"""
모든 Orchestrated MIDI 파일 분석 및 track_data.dart 업데이트 가이드 생성
"""

from pathlib import Path
from mido import MidiFile
import json

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

# 트랙 번호 -> 트랙 ID 매핑 (제목 재구성 완료)
TRACK_MAPPING = {
    # 강아지 트랙 (1-5)
    '1_1': ('sleep_01', '온화한 밤'),
    '1_2': ('sleep_02', '따뜻한 오후'),
    '1_3': ('sleep_03', '깊은 안정'),
    '1_4': ('sleep_04', '부드러운 포옹'),
    '1_5': ('sleep_05', '깊은 울림'),
    '1_6': ('sleep_06', '포근한 선율'),
    '1_7': ('sleep_07', '맑은 아침'),
    '1_8': ('sleep_08', '맑은 울림'),
    '2_1': ('separation_01', '묵직한 위로'),
    '2_2': ('separation_02', '따뜻한 공명'),
    '2_3': ('separation_03', '평온한 균형'),
    '2_4': ('separation_04', '포근한 쉼'),
    '2_5': ('separation_05', '산뜻한 안정'),
    '2_6': ('separation_06', '밝은 위로'),
    '2_7': ('separation_07', '평온한 오후'),
    '2_8': ('separation_08', '평화로운 쉼터'),
    '3_1': ('noise_01', '부드러운 장막'),
    '3_2': ('noise_02', '깊은 방패'),
    '3_3': ('noise_03', '일상의 평온'),
    '3_4': ('noise_04', '든든한 보호'),
    '3_5': ('noise_05', '산뜻한 보호막'),
    '3_6': ('noise_06', '포근한 담요'),
    '3_7': ('noise_07', '고요한 공간'),
    '3_8': ('noise_08', '깊은 고요'),
    '4_1': ('energy_01', '리드미컬 산책'),
    '4_2': ('energy_02', '활기찬 움직임'),
    '4_3': ('energy_03', '경쾌한 발걸음'),
    '4_4': ('energy_04', '신나는 놀이'),
    '4_5': ('energy_05', '가벼운 발걸음'),
    '4_6': ('energy_06', '신나는 질주'),
    '4_7': ('energy_07', '밝은 나들이'),
    '4_8': ('energy_08', '리드미컬한 박자'),
    '5_1': ('senior_01', '치유의 선율'),
    '5_2': ('senior_02', '깊은 안정'),
    '5_3': ('senior_03', '부드러운 공명'),
    '5_4': ('senior_04', '편안한 휴식'),
    '5_5': ('senior_05', '포근한 온기'),
    '5_6': ('senior_06', '산뜻한 평온'),
    '5_7': ('senior_07', '깊은 안식'),
    '5_8': ('senior_08', '평온한 품'),
    
    # 고양이 트랙 (6-10)
    '6_1': ('cat_sleep_01', '편안한 리듬'),
    '6_2': ('cat_sleep_02', '맑은 별빛'),
    '6_3': ('cat_sleep_03', '깊은 휴식'),
    '6_4': ('cat_sleep_04', '고요한 밤'),
    '6_5': ('cat_sleep_05', '은은한 달빛'),
    '6_6': ('cat_sleep_06', '포근한 꿈'),
    '6_7': ('cat_sleep_07', '따뜻한 쉼터'),
    '6_8': ('cat_sleep_08', '부드러운 울림'),
    '7_1': ('cat_separation_01', '안전한 공간'),
    '7_2': ('cat_separation_02', '맑은 오후'),
    '7_3': ('cat_separation_03', '평온한 안식처'),
    '7_4': ('cat_separation_04', '부드러운 바람'),
    '7_5': ('cat_separation_05', '따뜻한 동행'),
    '7_6': ('cat_separation_06', '따스한 시간'),
    '7_7': ('cat_separation_07', '편안한 일상'),
    '7_8': ('cat_separation_08', '고요한 순간'),
    '8_1': ('cat_noise_01', '부드러운 차단'),
    '8_2': ('cat_noise_02', '자연의 속삭임'),
    '8_3': ('cat_noise_03', '따뜻한 보호막'),
    '8_4': ('cat_noise_04', '깊은 평온'),
    '8_5': ('cat_noise_05', '평화로운 정원'),
    '8_6': ('cat_noise_06', '흐르는 평온'),
    '8_7': ('cat_noise_07', '고요한 방어막'),
    '8_8': ('cat_noise_08', '부드러운 배경'),
    '9_1': ('cat_energy_01', '경쾌한 질주'),
    '9_2': ('cat_energy_02', '신나는 추격'),
    '9_3': ('cat_energy_03', '가벼운 도약'),
    '9_4': ('cat_energy_04', '활기찬 움직임'),
    '9_5': ('cat_energy_05', '모험의 시작'),
    '9_6': ('cat_energy_06', '즐거운 놀이'),
    '9_7': ('cat_energy_07', '신나는 파티'),
    '9_8': ('cat_energy_08', '리드미컬한 춤'),
    '10_1': ('cat_senior_01', '치유의 선율'),
    '10_2': ('cat_senior_02', '따뜻한 위로'),
    '10_3': ('cat_senior_03', '평온한 오후'),
    '10_4': ('cat_senior_04', '추억의 여운'),
    '10_5': ('cat_senior_05', '깊은 공명'),
    '10_6': ('cat_senior_06', '따스한 심박'),
    '10_7': ('cat_senior_07', '고요한 쉼터'),
    '10_8': ('cat_senior_08', '편안한 호흡'),
}

def extract_instruments_and_tempo(filepath: Path):
    """MIDI에서 악기와 템포 추출"""
    midi = MidiFile(filepath)
    
    instruments = []
    tempo = None
    
    for track in midi.tracks:
        track_name = track.name if hasattr(track, 'name') else None
        
        for msg in track:
            if msg.type == 'program_change':
                inst_name = GM_INSTRUMENTS.get(msg.program, f"Program{msg.program}")
                if inst_name not in instruments:
                    instruments.append(inst_name)
            
            if msg.type == 'set_tempo' and tempo is None:
                tempo = round(60_000_000 / msg.tempo, 1)
    
    return {
        'instruments': instruments,
        'tempo': tempo
    }

def main():
    project_root = Path(__file__).parent.parent
    sound_dir = project_root / 'assets' / 'sound'
    
    results = {}
    
    print("🎵 Orchestrated MIDI 분석 중...\n")
    
    for track_key, (track_id, track_title) in TRACK_MAPPING.items():
        # 폴더명 패턴 찾기
        track_folders = list(sound_dir.glob(f"{track_key}_*"))
        
        if not track_folders:
            print(f"⚠️  {track_key} 폴더 없음")
            continue
        
        track_folder = track_folders[0]
        orch_files = list(track_folder.glob('*Orchestrated.mid'))
        
        if not orch_files:
            print(f"⚠️  {track_key}: Orchestrated.mid 없음")
            continue
        
        data = extract_instruments_and_tempo(orch_files[0])
        
        results[track_id] = {
            'title': track_title,
            'tempo': data['tempo'],
            'instruments': data['instruments']
        }
        
        # 간소화된 악기 이름
        inst_str = ' / '.join(data['instruments'][:3])  # 최대 3개만
        
        print(f"✓ {track_key:5s} {track_title:20s} {data['tempo']:5.1f} BPM  [{inst_str}]")
    
    # JSON 저장
    output_file = project_root / 'midi_analysis_full.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ 분석 완료! 결과 저장: {output_file}")
    
    # track_data.dart 업데이트 가이드
    print(f"\n{'='*100}")
    print("📝 track_data.dart Instruments 업데이트")
    print(f"{'='*100}\n")
    
    for track_id, data in results.items():
        inst_str = ' / '.join(data['instruments'])
        print(f"// {data['title']}")
        print(f"'Instruments': '{inst_str}',")
        print()

if __name__ == '__main__':
    main()
