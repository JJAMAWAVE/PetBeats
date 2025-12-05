#!/usr/bin/env python3
"""
Orchestrated vs Reduced MIDI 비교 분석
"""

from pathlib import Path
from mido import MidiFile

# General MIDI Instrument Names
GM_INSTRUMENTS = {
    0: "Acoustic Grand Piano", 1: "Bright Acoustic Piano", 2: "Electric Grand Piano",
    3: "Honky-tonk Piano", 4: "Electric Piano 1", 5: "Electric Piano 2",
    6: "Harpsichord", 7: "Clavinet", 8: "Celesta", 9: "Glockenspiel",
    10: "Music Box", 11: "Vibraphone", 12: "Marimba", 13: "Xylophone",
    14: "Tubular Bells", 15: "Dulcimer", 16: "Drawbar Organ", 17: "Percussive Organ",
    18: "Rock Organ", 19: "Church Organ", 20: "Reed Organ", 21: "Accordion",
    22: "Harmonica", 23: "Tango Accordion", 24: "Acoustic Guitar (nylon)",
    25: "Acoustic Guitar (steel)", 26: "Electric Guitar (jazz)", 27: "Electric Guitar (clean)",
    28: "Electric Guitar (muted)", 29: "Overdriven Guitar", 30: "Distortion Guitar",
    31: "Guitar Harmonics", 32: "Acoustic Bass", 33: "Electric Bass (finger)",
    34: "Electric Bass (pick)", 35: "Fretless Bass", 36: "Slap Bass 1",
    37: "Slap Bass 2", 38: "Synth Bass 1", 39: "Synth Bass 2",
    40: "Violin", 41: "Viola", 42: "Cello", 43: "Contrabass",
    44: "Tremolo Strings", 45: "Pizzicato Strings", 46: "Orchestral Harp",
    47: "Timpani", 48: "String Ensemble 1", 49: "String Ensemble 2",
    50: "Synth Strings 1", 51: "Synth Strings 2", 52: "Choir Aahs",
    53: "Voice Oohs", 54: "Synth Voice", 55: "Orchestra Hit",
    56: "Trumpet", 57: "Trombone", 58: "Tuba", 59: "Muted Trumpet",
    60: "French Horn", 61: "Brass Section", 62: "Synth Brass 1",
    63: "Synth Brass 2", 64: "Soprano Sax", 65: "Alto Sax",
    66: "Tenor Sax", 67: "Baritone Sax", 68: "Oboe", 69: "English Horn",
    70: "Bassoon", 71: "Clarinet", 72: "Piccolo", 73: "Flute",
    74: "Recorder", 75: "Pan Flute", 76: "Blown Bottle", 77: "Shakuhachi",
    78: "Whistle", 79: "Ocarina", 80: "Lead 1 (square)", 81: "Lead 2 (sawtooth)",
    82: "Lead 3 (calliope)", 83: "Lead 4 (chiff)", 84: "Lead 5 (charang)",
    85: "Lead 6 (voice)", 86: "Lead 7 (fifths)", 87: "Lead 8 (bass + lead)",
    88: "Pad 1 (new age)", 89: "Pad 2 (warm)", 90: "Pad 3 (polysynth)",
    91: "Pad 4 (choir)", 92: "Pad 5 (bowed)", 93: "Pad 6 (metallic)",
    94: "Pad 7 (halo)", 95: "Pad 8 (sweep)", 96: "FX 1 (rain)",
    97: "FX 2 (soundtrack)", 98: "FX 3 (crystal)", 99: "FX 4 (atmosphere)",
    100: "FX 5 (brightness)", 101: "FX 6 (goblins)", 102: "FX 7 (echoes)",
    103: "FX 8 (sci-fi)", 104: "Sitar", 105: "Banjo", 106: "Shamisen",
    107: "Koto", 108: "Kalimba", 109: "Bagpipe", 110: "Fiddle",
    111: "Shanai", 112: "Tinkle Bell", 113: "Agogo", 114: "Steel Drums",
    115: "Woodblock", 116: "Taiko Drum", 117: "Melodic Tom", 118: "Synth Drum",
    119: "Reverse Cymbal", 120: "Guitar Fret Noise", 121: "Breath Noise",
    122: "Seashore", 123: "Bird Tweet", 124: "Telephone Ring",
    125: "Helicopter", 126: "Applause", 127: "Gunshot"
}

def analyze_midi_instruments(filepath: Path):
    """MIDI 파일에서 악기 정보 추출"""
    midi = MidiFile(filepath)
    
    instruments = {}  # channel -> (program, track_name)
    tempo = None
    
    for track in midi.tracks:
        track_name = track.name if hasattr(track, 'name') else None
        
        for msg in track:
            if msg.type == 'program_change':
                instruments[msg.channel] = {
                    'program': msg.program,
                    'instrument': GM_INSTRUMENTS.get(msg.program, f"Unknown ({msg.program})"),
                    'track': track_name
                }
            
            if msg.type == 'set_tempo':
                tempo = round(60_000_000 / msg.tempo, 1)
    
    return {
        'instruments': instruments,
        'tempo': tempo,
        'tracks': len(midi.tracks)
    }

def compare_midi_pair(orchestrated_path: Path, reduced_path: Path):
    """Orchestrated와 Reduced MIDI 비교"""
    orch = analyze_midi_instruments(orchestrated_path)
    reduced = analyze_midi_instruments(reduced_path)
    
    return {
        'orchestrated': orch,
        'reduced': reduced
    }

def main():
    project_root = Path(__file__).parent.parent
    sound_dir = project_root / 'assets' / 'sound'
    
    # 샘플 트랙들 분석
    test_tracks = [
        '1_1_스탠다드 자장가',
        '1_7_맑은 아침',  # Harp 예정
        '2_1_묵직한 위로',  # Cello 예정
        '4_1_리드미컬 산책',  # Jazz
    ]
    
    print("🎵 MIDI 파일 비교 분석\n")
    print(f"{'='*100}\n")
    
    for track_name in test_tracks:
        track_dir = sound_dir / track_name
        
        if not track_dir.exists():
            print(f"⚠️  {track_name} 폴더 없음\n")
            continue
        
        # Orchestrated와 Reduced 파일 찾기
        orch_files = list(track_dir.glob('*Orchestrated.mid'))
        reduced_files = list(track_dir.glob('*Reduced.mid'))
        
        if not orch_files or not reduced_files:
            print(f"⚠️  {track_name}: MIDI 파일 없음\n")
            continue
        
        print(f"\n{'─'*100}")
        print(f"📁 {track_name}")
        print(f"{'─'*100}\n")
        
        result = compare_midi_pair(orch_files[0], reduced_files[0])
        
        # Orchestrated 분석
        print("🎼 Orchestrated.mid:")
        print(f"   Tempo: {result['orchestrated']['tempo']} BPM")
        print(f"   Tracks: {result['orchestrated']['tracks']}")
        print(f"   악기 구성:")
        for ch, info in result['orchestrated']['instruments'].items():
            print(f"      Ch{ch}: [{info['program']:3d}] {info['instrument']:30s} (Track: {info['track']})")
        
        # Reduced 분석
        print(f"\n🎹 Reduced.mid:")
        print(f"   Tempo: {result['reduced']['tempo']} BPM")
        print(f"   Tracks: {result['reduced']['tracks']}")
        print(f"   악기 구성:")
        for ch, info in result['reduced']['instruments'].items():
            print(f"      Ch{ch}: [{info['program']:3d}] {info['instrument']:30s} (Track: {info['track']})")
        
        print()

if __name__ == '__main__':
    main()
