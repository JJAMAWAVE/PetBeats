#!/usr/bin/env python3
"""
MIDI 파일에서 추출한 템포 정보로 track_data.dart 업데이트

사용법:
    python scripts/update_track_tempo.py
"""

from pathlib import Path
from mido import MidiFile

# MIDI 파일 -> 트랙 ID 매핑 (강아지만)
MIDI_TRACK_MAPPING = {
    # Sleep Tracks (1_X)
    '1_1.mid': ('sleep_01', '스탠다드 자장가'),
    '1_2.mid': ('sleep_02', '따뜻한 오후'),
    '1_3.mid': ('sleep_03', '깊은 밤의 꿈'),
    '1_4.mid': ('sleep_04', '엄마의 요람'),
    '1_5.mid': ('sleep_05', '깊은 울림'),
    '1_6.mid': ('sleep_06', '포근한 왈츠'),
    '1_7.mid': ('sleep_07', '맑은 아침'),
    '1_8.mid': ('sleep_08', '사뿐한 왈츠'),
    
    # Separation Tracks (2_X)
    '2_1.mid': ('separation_01', '묵직한 위로'),
    '2_2.mid': ('separation_02', '따뜻한 공명'),
    '2_3.mid': ('separation_03', '균형 잡힌 안정'),
    '2_4.mid': ('separation_04', '포근한 공기'),
    '2_5.mid': ('separation_05', '산뜻한 안정'),
    '2_6.mid': ('separation_06', '밝은 공기'),
    '2_7.mid': ('separation_07', '평온한 오후'),
    '2_8.mid': ('separation_08', '숲속의 쉼터'),
    
    # Noise Masking (3_X)
    '3_1.mid': ('noise_01', '부드러운 장막'),
    '3_2.mid': ('noise_02', '깊은 방패'),
    '3_3.mid': ('noise_03', '일상의 평온'),
    '3_4.mid': ('noise_04', '든든한 방음벽'),
    '3_5.mid': ('noise_05', '산뜻한 보호막'),
    '3_6.mid': ('noise_06', '포근한 담요'),
    '3_7.mid': ('noise_07', '우주 여행'),
    '3_8.mid': ('noise_08', '깊은 바다'),
    
    # Energy Tracks (4_X)
    '4_1.mid': ('energy_01', '리드미컬 산책'),
    '4_2.mid': ('energy_02', '활기찬 터그'),
    '4_3.mid': ('energy_03', '경쾌한 총총'),
    '4_4.mid': ('energy_04', '신나는 술래'),
    '4_5.mid': ('energy_05', '사뿐한 총총'),
    '4_6.mid': ('energy_06', '신나는 우다다'),
    '4_7.mid': ('energy_07', '피크닉'),
    '4_8.mid': ('energy_08', '댄스 타임'),
    
    # Senior Care (5_X)
    '5_1.mid': ('senior_01', '치유의 주파수'),
    '5_2.mid': ('senior_02', '깊은 안정'),
    '5_3.mid': ('senior_03', '부드러운 공명'),
    '5_4.mid': ('senior_04', '편안한 휴식'),
    '5_5.mid': ('senior_05', '포근한 온기'),
    '5_6.mid': ('senior_06', '산뜻한 평온'),
    '5_7.mid': ('senior_07', '영혼의 안식'),
    '5_8.mid': ('senior_08', '자연의 품'),
}


def extract_tempo_from_midi(filepath: Path) -> float:
    """MIDI 파일에서 BPM 추출"""
    try:
        midi = MidiFile(filepath)
        
        for track in midi.tracks:
            for msg in track:
                if msg.type == 'set_tempo':
                    bpm = 60_000_000 / msg.tempo
                    return round(bpm, 1)
        
        return None
    except Exception as e:
        print(f"❌ {filepath.name} 처리 중 오류: {e}")
        return None


def main():
    """메인 함수"""
    project_root = Path(__file__).parent.parent
    sound_dir = project_root / 'assets' / 'sound'
    
    # 실제 MIDI에서 템포 추출
    print("🎵 MIDI 파일에서 템포 정보 추출 중...\n")
    
    tempo_data = {}
    
    for midi_filename, (track_id, track_title) in MIDI_TRACK_MAPPING.items():
        midi_path = sound_dir / midi_filename
        
        if not midi_path.exists():
            print(f"⚠️  {midi_filename} 파일 없음")
            continue
        
        bpm = extract_tempo_from_midi(midi_path)
        
        if bpm:
            tempo_data[track_id] = {
                'midi_file': midi_filename,
                'title': track_title,
                'bpm': bpm
            }
            print(f"✓ {midi_filename:12s} → {track_title:20s} = {bpm} BPM")
        else:
            print(f"✗ {midi_filename:12s} → 템포 정보 없음")
    
    # 결과 요약
    print(f"\n{'='*80}")
    print("📊 추출된 템포 정보 요약")
    print(f"{'='*80}\n")
    
    # 카테고리별로 정리
    categories = {
        'Deep Sleep (수면 유도)': [f'sleep_0{i}' for i in range(1, 9)],
        'Calm Shelter (분리불안)': [f'separation_0{i}' for i in range(1, 9)],
        'Noise Masking (소음 차단)': [f'noise_0{i}' for i in range(1, 9)],
        'Energy Boost (활력 증진)': [f'energy_0{i}' for i in range(1, 9)],
        'Senior Care (시니어 케어)': [f'senior_0{i}' for i in range(1, 9)],
    }
    
    for category, track_ids in categories.items():
        print(f"\n## {category}")
        for track_id in track_ids:
            if track_id in tempo_data:
                data = tempo_data[track_id]
                print(f"   {data['title']:25s} - {data['bpm']:5.1f} BPM")
    
    # Dart 코드 업데이트 제안
    print(f"\n{'='*80}")
    print("💡 track_data.dart 업데이트 제안")
    print(f"{'='*80}\n")
    
    print("현재 Tempo 필드를 다음과 같이 업데이트하세요:\n")
    
    for track_id, data in tempo_data.items():
        bpm_str = f"{int(data['bpm'])} BPM" if data['bpm'] == int(data['bpm']) else f"{data['bpm']} BPM"
        print(f"  // {data['title']}")
        print(f"  'Tempo': '{bpm_str}',  // {data['midi_file']}")
        print()


if __name__ == '__main__':
    main()
