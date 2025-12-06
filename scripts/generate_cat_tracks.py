#!/usr/bin/env python3
"""
고양이 트랙 32곡을 TrackData Dart 코드로 생성하는 스크립트
"""
import json
from pathlib import Path

# MIDI 분석 결과 로드
with open('midi_analysis_full.json', 'r', encoding='utf-8') as f:
    midi_data = json.load(f)

# 고양이 트랙 카테고리별 정의
CAT_CATEGORIES = {
    'cat_separation': {
        'title': 'Cat Separation (고양이 분리불안)',
        'tracks': [
            ('cat_separation_01', '7_1_안전 가옥', '263'),
            ('cat_separation_02', '7_2_창가 자리', '264'),
            ('cat_separation_03', '7_3_숨숨집의 평화', '265'),
            ('cat_separation_04', '7_4_부드러운 공기', '266'),
            ('cat_separation_05', '7_5_친구의 목소리', '267'),
            ('cat_separation_06', '7_6_오후의 햇살', '268'),
            ('cat_separation_07', '7_7_그루밍 타임', '269'),
            ('cat_separation_08', '7_8_평온한 관찰', '270'),
        ],
        'cover': 'cat_sep_cover.jpg',
        'premium_start': 2  # 3번째부터 premium
    },
    'cat_noise': {
        'title': 'Cat Noise Masking (고양이 소음 차단)',
        'tracks': [
            ('cat_noise_01', '8_1_빗소리 커튼', '271'),
            ('cat_noise_02', '8_2_바람의 노래', '272'),
            ('cat_noise_03', '8_3_두꺼운 담요', '273'),
            ('cat_noise_04', '8_4_심해의 고요', '274'),
            ('cat_noise_05', '8_5_새들의 정원', '275'),
            ('cat_noise_06', '8_6_흐르는 시내', '276'),
            ('cat_noise_07', '8_7_우주 방어막', '277'),
            ('cat_noise_08', '8_8_핑크 노이즈', '278'),
        ],
        'cover': 'cat_noise_cover.jpg',
        'premium_start': 2
    },
    'cat_energy': {
        'title': 'Cat Energy (고양이 활력 증진)',
        'tracks': [
            ('cat_energy_01', '9_1_우다다 타임', '279'),
            ('cat_energy_02', '9_2_잡아라 쥐돌이', '280'),
            ('cat_energy_03', '9_3_새 사냥', '281'),
            ('cat_energy_04', '9_4_점프 & 런', '282'),
            ('cat_energy_05', '9_5_수풀 속으로', '283'),
            ('cat_energy_06', '9_6_낚싯대 놀이', '284'),
            ('cat_energy_07', '9_7_캣닙 파티', '285'),
            ('cat_energy_08', '9_8_궁디 팡팡', '286'),
        ],
        'cover': 'cat_play_cover.jpg',
        'premium_start': 0  # 모두 premium
    },
    'cat_senior': {
        'title': 'Cat Senior Care (고양이 시니어 케어)',
        'tracks': [
            ('cat_senior_01', '10_1_치유의 골골송', '377'),
            ('cat_senior_02', '10_2_따뜻한 찜질', '378'),
            ('cat_senior_03', '10_3_느린 오후', '379'),
            ('cat_senior_04', '10_4_기억의 저편', '380'),
            ('cat_senior_05', '10_5_영혼의 공명', '381'),
            ('cat_senior_06', '10_6_엄마의 심장', '382'),
            ('cat_senior_07', '10_7_고요한 쉼터', '383'),
            ('cat_senior_08', '10_8_편안한 호흡', '384'),
        ],
        'cover': 'cat_senior_cover.jpg',
        'premium_start': 0
    }
}

def generate_track_dart_code(track_id, folder_name, composition_num, cover, is_premium, midi_info):
    """단일 트랙의 Dart 코드 생성"""
    title = midi_info['title']
    tempo = midi_info['tempo']
    instruments = ' / '.join(midi_info['instruments'])
    
    # Description 생성 (악기 기반)
    first_inst = midi_info['instruments'][0] if midi_info['instruments'] else '악기'
    description = f"{first_inst}의 {'빠른' if tempo >= 100 else '느린' if tempo <= 60 else '중간'} 템포"
    
    return f"""    Track(
      id: '{track_id}',
      title: '{title}',
      description: '{description}',
      audioUrl: 'assets/sound/{folder_name}/New Composition  {composition_num}.mp3',
      midiUrl: 'assets/sound/{folder_name}/New Composition  {composition_num} - Orchestrated.mid',
      coverUrl: 'assets/images/{cover}',
      bpm: '{tempo:.0f} BPM',
      technicalSpecs: {{
        'Key': 'Auto',
        'Tempo': '{tempo:.0f} BPM',
        'Harmony': 'Simple Chords II',
        'Instruments': '{instruments}',
      }},
      tags: ['Cat', '{track_id.split('_')[1].capitalize()}', '{midi_info["instruments"][0].split()[0] if midi_info["instruments"] else "Piano"}'],
      isPremium: {'true' if is_premium else 'false'},
    ),"""

def main():
    output_lines = []
    
    for cat_key, cat_info in CAT_CATEGORIES.items():
        output_lines.append(f"\n  // {cat_info['title']}")
        output_lines.append(f"  static final List<Track> {cat_key}Tracks = [")
        
        for idx, (track_id, folder_name, comp_num) in enumerate(cat_info['tracks']):
            is_premium = idx >= cat_info['premium_start']
            midi_info = midi_data.get(track_id, {
                'title': folder_name.split('_', 1)[1] if '_' in folder_name else folder_name,
                'tempo': 60.0,
                'instruments': ['Piano']
            })
            
            track_code = generate_track_dart_code(
                track_id, folder_name, comp_num,
                cat_info['cover'], is_premium, midi_info
            )
            output_lines.append(track_code)
        
        output_lines.append("  ];")
        output_lines.append("")
    
    # 파일 저장
    output_file = Path('cat_tracks_generated.dart')
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(output_lines))
    
    print(f"✅ 생성 완료: {output_file}")
    print(f"총 {sum(len(cat['tracks']) for cat in CAT_CATEGORIES.values())}개 트랙 생성됨")

if __name__ == '__main__':
    main()
