#!/usr/bin/env python3
"""
햅틱 패턴 JSON 생성 스크립트 (3가지 모드용)

대상 트랙:
- sleep_03: 깊은 밤의 꿈 (Deep Sleep - Heartbeat)
- separation_01: 묵직한 위로 (Calm Shelter - Heartbeat)
- senior_02: 깊은 안정 (Senior Care - Purr)
"""

from pathlib import Path
from mido import MidiFile
import json

# General MIDI 악기 매핑
GM_INSTRUMENTS = {
    0: "Acoustic Grand Piano", 42: "Cello", 43: "Contrabass",
    32: "Acoustic Bass", 33: "Electric Bass (finger)", 34: "Electric Bass (pick)",
}

# 햅틱 대상 트랙 설정
HAPTIC_TRACKS = {
    'sleep_03': {
        'title': '깊은 밤의 꿈',
        'folder': '1_3_깊은 밤의 꿈',
        'pattern': 'heartbeat',
        'target_instruments': ['Cello', 'Contrabass'],
    },
    'separation_01': {
        'title': '묵직한 위로',
        'folder': '2_1_묵직한 위로',
        'pattern': 'heartbeat',
        'target_instruments': ['Cello', 'Contrabass'],
    },
    'senior_02': {
        'title': '깊은 안정',
        'folder': '5_2_깊은 안정',
        'pattern': 'purr',
        'target_instruments': ['Contrabass', 'Cello'],
    },
}


def ticks_to_ms(ticks, ticks_per_beat, tempo_us):
    """Ticks를 밀리초로 변환"""
    return int((ticks * tempo_us) / (ticks_per_beat * 1000))


def extract_haptic_events(midi_path, config):
    """MIDI에서 햅틱 이벤트 추출"""
    midi = MidiFile(midi_path)
    
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
    
    # 각 트랙별로 악기와 노트 추출
    events = []
    
    for track_idx, track in enumerate(midi.tracks):
        current_time_ticks = 0
        track_instrument = None
        
        for msg in track:
            current_time_ticks += msg.time
            
            # Program Change로 악기 확인
            if msg.type == 'program_change':
                track_instrument = GM_INSTRUMENTS.get(msg.program, f"Program{msg.program}")
            
            # Note On 이벤트 처리
            if msg.type == 'note_on' and msg.velocity > 0:
                # 타겟 악기만
                if track_instrument not in config['target_instruments']:
                    continue
                
                # 저음역만 (C2=36 ~ C4=60)
                if not (36 <= msg.note <= 60):
                    continue
                
                time_ms = ticks_to_ms(current_time_ticks, midi.ticks_per_beat, tempo_us)
                
                events.append({
                    'time': time_ms,
                    'note': msg.note,
                    'velocity': msg.velocity,
                })
    
    # 시간순 정렬
    events.sort(key=lambda x: x['time'])
    
    # 통계 계산
    velocities = [e['velocity'] for e in events]
    notes = [e['note'] for e in events]
    
    stats = {
        'total_events': len(events),
        'duration_ms': events[-1]['time'] if events else 0,
        'avg_velocity': round(sum(velocities) / len(velocities)) if velocities else 0,
        'note_range': f"{min(notes)}-{max(notes)}" if notes else "N/A",
    }
    
    return {
        'bpm': bpm,
        'events': events,
        'stats': stats,
    }


def main():
    """메인 함수"""
    project_root = Path(__file__).parent.parent
    sound_dir = project_root / 'assets' / 'sound'
    output_dir = project_root / 'assets' / 'haptic_patterns'
    
    # 출력 디렉토리 생성
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print("🎵 햅틱 패턴 JSON 생성 중...\n")
    
    results = {}
    
    for track_id, config in HAPTIC_TRACKS.items():
        print(f"📁 {track_id}: {config['title']}")
        
        # Orchestrated MIDI 파일 찾기
        track_folder = sound_dir / config['folder']
        orch_files = list(track_folder.glob('*Orchestrated.mid'))
        
        if not orch_files:
            print(f"   ⚠️  Orchestrated.mid 파일 없음\n")
            continue
        
        # 햅틱 이벤트 추출
        result = extract_haptic_events(orch_files[0], config)
        
        # JSON 데이터 구성
        json_data = {
            'track_id': track_id,
            'title': config['title'],
            'haptic_enabled': True,
            'pattern': config['pattern'],
            'bpm': result['bpm'],
            'events': result['events'],
            'stats': result['stats'],
        }
        
        # JSON 파일 저장
        output_file = output_dir / f"{track_id}.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(json_data, f, ensure_ascii=False, indent=2)
        
        print(f"   ✅ {result['stats']['total_events']}개 이벤트 생성")
        print(f"   📊 BPM: {result['bpm']}, 평균 Velocity: {result['stats']['avg_velocity']}")
        print(f"   💾 저장: {output_file.name}\n")
        
        results[track_id] = json_data
    
    print(f"{'='*60}")
    print("✅ 완료!")
    print(f"총 {len(results)}개 햅틱 패턴 JSON 생성")
    print(f"출력 경로: {output_dir}")


if __name__ == '__main__':
    main()
