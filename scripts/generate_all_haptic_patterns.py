#!/usr/bin/env python3
"""
모든 트랙(강아지 40곡 + 고양이 40곡)의 햅틱 패턴 JSON 자동 생성 스크립트
MIDI 파일에서 저음역 노트를 추출하여 햅틱 이벤트 생성
"""

from pathlib import Path
from mido import MidiFile
import json
import re

# 프로젝트 경로 설정
PROJECT_ROOT = Path(__file__).parent.parent
SOUND_DIR = PROJECT_ROOT / 'assets' / 'sound'
OUTPUT_DIR = PROJECT_ROOT / 'assets' / 'haptic_patterns'

# 강아지 트랙 매핑 (번호 기반)
DOG_TRACK_MAPPING = {
    '1_1': 'sleep_01', '1_2': 'sleep_02', '1_3': 'sleep_03', '1_4': 'sleep_04',
    '1_5': 'sleep_05', '1_6': 'sleep_06', '1_7': 'sleep_07', '1_8': 'sleep_08',
    '2_1': 'separation_01', '2_2': 'separation_02', '2_3': 'separation_03', '2_4': 'separation_04',
    '2_5': 'separation_05', '2_6': 'separation_06', '2_7': 'separation_07', '2_8': 'separation_08',
    '3_1': 'noise_01', '3_2': 'noise_02', '3_3': 'noise_03', '3_4': 'noise_04',
    '3_5': 'noise_05', '3_6': 'noise_06', '3_7': 'noise_07', '3_8': 'noise_08',
    '4_1': 'energy_01', '4_2': 'energy_02', '4_3': 'energy_03', '4_4': 'energy_04',
    '4_5': 'energy_05', '4_6': 'energy_06', '4_7': 'energy_07', '4_8': 'energy_08',
    '5_1': 'senior_01', '5_2': 'senior_02', '5_3': 'senior_03', '5_4': 'senior_04',
    '5_5': 'senior_05', '5_6': 'senior_06', '5_7': 'senior_07', '5_8': 'senior_08',
}

# 고양이 트랙 매핑 (폴더 기반)
CAT_TRACK_MAPPING = {
    '6_1': 'cat_sleep_01', '6_2': 'cat_sleep_02', '6_3': 'cat_sleep_03', '6_4': 'cat_sleep_04',
    '6_5': 'cat_sleep_05', '6_6': 'cat_sleep_06', '6_7': 'cat_sleep_07', '6_8': 'cat_sleep_08',
    '7_1': 'cat_separation_01', '7_2': 'cat_separation_02', '7_3': 'cat_separation_03', '7_4': 'cat_separation_04',
    '7_5': 'cat_separation_05', '7_6': 'cat_separation_06', '7_7': 'cat_separation_07', '7_8': 'cat_separation_08',
    '8_1': 'cat_noise_01', '8_2': 'cat_noise_02', '8_3': 'cat_noise_03', '8_4': 'cat_noise_04',
    '8_5': 'cat_noise_05', '8_6': 'cat_noise_06', '8_7': 'cat_noise_07', '8_8': 'cat_noise_08',
    '9_1': 'cat_energy_01', '9_2': 'cat_energy_02', '9_3': 'cat_energy_03', '9_4': 'cat_energy_04',
    '9_5': 'cat_energy_05', '9_6': 'cat_energy_06', '9_7': 'cat_energy_07', '9_8': 'cat_energy_08',
    '10_1': 'cat_senior_01', '10_2': 'cat_senior_02', '10_3': 'cat_senior_03', '10_4': 'cat_senior_04',
    '10_5': 'cat_senior_05', '10_6': 'cat_senior_06', '10_7': 'cat_senior_07', '10_8': 'cat_senior_08',
}


def ticks_to_ms(ticks, ticks_per_beat, tempo_us):
    """Ticks를 밀리초로 변환"""
    return int((ticks * tempo_us) / (ticks_per_beat * 1000))


def extract_haptic_events(midi_path):
    """MIDI에서 햅틱 이벤트 추출 (저음역 노트만)"""
    midi = MidiFile(str(midi_path))
    
    # 템포 추출 (첫 번째 set_tempo)
    tempo_us = 500000  # 기본 120 BPM
    for track in midi.tracks:
        for msg in track:
            if msg.type == 'set_tempo':
                tempo_us = msg.tempo
                break
        if tempo_us != 500000:
            break
    
    bpm = round(60_000_000 / tempo_us, 1)
    
    # 모든 트랙에서 저음역 노트 추출
    events = []
    
    for track in midi.tracks:
        current_time_ticks = 0
        
        for msg in track:
            current_time_ticks += msg.time
            
            # Note On 이벤트 처리
            if msg.type == 'note_on' and msg.velocity > 0:
                # 저음역만 (C2=36 ~ C4=60) - 베이스, 첼로 등
                if not (36 <= msg.note <= 60):
                    continue
                
                time_ms = ticks_to_ms(current_time_ticks, midi.ticks_per_beat, tempo_us)
                
                events.append({
                    'time': time_ms,
                    'note': msg.note,
                    'velocity': msg.velocity,
                })
    
    # 시간순 정렬 및 중복 제거 (100ms 이내 이벤트 병합)
    events.sort(key=lambda x: x['time'])
    
    # 중복 제거 (100ms 이내)
    filtered_events = []
    last_time = -200
    for event in events:
        if event['time'] - last_time >= 100:
            filtered_events.append(event)
            last_time = event['time']
    
    return {
        'bpm': bpm,
        'events': filtered_events,
    }


def process_dog_tracks():
    """강아지 트랙 처리 (번호.mid 형식)"""
    results = {}
    midi_files = list(SOUND_DIR.glob('*.mid'))
    
    for midi_path in midi_files:
        # 파일명에서 트랙 번호 추출 (예: 1_1.mid -> 1_1)
        match = re.match(r'^(\d+_\d+)\.mid$', midi_path.name)
        if not match:
            continue
        
        track_num = match.group(1)
        track_id = DOG_TRACK_MAPPING.get(track_num)
        
        if not track_id:
            continue
        
        print(f"📁 [DOG] {track_id} ({midi_path.name})")
        
        result = extract_haptic_events(midi_path)
        
        if not result['events']:
            print(f"   ⚠️  저음역 노트 없음\n")
            continue
        
        save_haptic_json(track_id, result)
        results[track_id] = result
    
    return results


def process_cat_tracks():
    """고양이 트랙 처리 (폴더/Orchestrated.mid 형식)"""
    results = {}
    
    for track_num, track_id in CAT_TRACK_MAPPING.items():
        # 폴더 찾기 (예: 6_1_골골송 자장가)
        folders = list(SOUND_DIR.glob(f'{track_num}_*'))
        
        if not folders:
            continue
        
        folder = folders[0]
        orch_files = list(folder.glob('*Orchestrated.mid'))
        
        if not orch_files:
            print(f"   ⚠️  [CAT] {track_id}: No Orchestrated.mid\n")
            continue
        
        print(f"📁 [CAT] {track_id} ({folder.name})")
        
        result = extract_haptic_events(orch_files[0])
        
        if not result['events']:
            print(f"   ⚠️  저음역 노트 없음\n")
            continue
        
        save_haptic_json(track_id, result)
        results[track_id] = result
    
    return results


def save_haptic_json(track_id, result):
    """햅틱 패턴 JSON 저장"""
    velocities = [e['velocity'] for e in result['events']]
    notes = [e['note'] for e in result['events']]
    
    stats = {
        'total_events': len(result['events']),
        'duration_ms': result['events'][-1]['time'] if result['events'] else 0,
        'avg_velocity': round(sum(velocities) / len(velocities)) if velocities else 0,
        'note_range': f"{min(notes)}-{max(notes)}" if notes else "N/A",
    }
    
    json_data = {
        'track_id': track_id,
        'haptic_enabled': True,
        'bpm': result['bpm'],
        'events': result['events'],
        'stats': stats,
    }
    
    output_file = OUTPUT_DIR / f"{track_id}.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(json_data, f, ensure_ascii=False, indent=2)
    
    print(f"   ✅ {stats['total_events']}개 이벤트 생성")
    print(f"   📊 BPM: {result['bpm']}, 평균 Velocity: {stats['avg_velocity']}\n")


def main():
    """메인 함수"""
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    print("🎵 모든 트랙(강아지 + 고양이)의 햅틱 패턴 JSON 생성 중...\n")
    print("=" * 60)
    print("🐕 강아지 트랙 처리")
    print("=" * 60)
    
    dog_results = process_dog_tracks()
    
    print("=" * 60)
    print("🐱 고양이 트랙 처리")
    print("=" * 60)
    
    cat_results = process_cat_tracks()
    
    total = len(dog_results) + len(cat_results)
    print(f"{'='*60}")
    print(f"✅ 완료! 총 {total}개 햅틱 패턴 JSON 생성")
    print(f"   - 강아지: {len(dog_results)}곡")
    print(f"   - 고양이: {len(cat_results)}곡")
    print(f"출력 경로: {OUTPUT_DIR}")


if __name__ == '__main__':
    main()
