#!/usr/bin/env python3
"""
강아지 트랙 40곡의 제목을 재구성된 버전으로 업데이트하는 스크립트
JSON 파일의 title을 track_data.dart에 반영
"""
import json

# 재구성된 제목 매핑
UPDATED_TITLES = {
    'sleep_01': '온화한 밤',
    'sleep_02': '따뜻한 오후',  # 유지
    'sleep_03': '깊은 안정',
    'sleep_04': '부드러운 포옹', 
    'sleep_05': '깊은 울림',  # 유지
    'sleep_06': '포근한 선율',
    'sleep_07': '맑은 아침',  # 유지
    'sleep_08': '맑은 울림',
    
    'separation_01': '묵직한 위로',  # 유지
    'separation_02': '따뜻한 공명',  # 유지
    'separation_03': '평온한 균형',
    'separation_04': '포근한 쉼',
    'separation_05': '산뜻한 안정',  # 유지
    'separation_06': '밝은 위로',
    'separation_07': '평온한 오후',  # 유지
    'separation_08': '평화로운 쉼터',
    
    'noise_01': '부드러운 장막',  # 유지
    'noise_02': '깊은 방패',  # 유지
    'noise_03': '일상의 평온',  # 유지
    'noise_04': '든든한 보호',
    'noise_05': '산뜻한 보호막',  # 유지
    'noise_06': '포근한 담요',  # 유지
    'noise_07': '고요한 공간',
    'noise_08': '깊은 고요',
    
    'energy_01': '리드미컬 산책',  # 유지
    'energy_02': '활기찬 움직임',
    'energy_03': '경쾌한 발걸음',
    'energy_04': '신나는 놀이',
    'energy_05': '가벼운 발걸음',
    'energy_06': '신나는 질주',
    'energy_07': '밝은 나들이',
    'energy_08': '리드미컬한 박자',
    
    'senior_01': '치유의 선율',
    'senior_02': '깊은 안정',  # 유지
    'senior_03': '부드러운 공명',  # 유지
    'senior_04': '편안한 휴식',  # 유지
    'senior_05': '포근한 온기',  # 유지
    'senior_06': '산뜻한 평온',  # 유지
    'senior_07': '깊은 안식',
    'senior_08': '평온한 품',
}

# MIDI 분석 JSON 읽기
with open('midi_analysis_full.json', 'r', encoding='utf-8') as f:
    midi_data = json.load(f)

# 변경사항 출력
print("## 강아지 트랙 제목 업데이트 가이드\n")
for track_id, new_title in UPDATED_TITLES.items():
    midi_info = midi_data.get(track_id, {})
    old_title = midi_info.get('title', 'Unknown')
    
    if old_title != new_title:
        print(f"// {track_id}")
        print(f"title: '{new_title}',  // 변경: '{old_title}' -> '{new_title}'")
        print()
    else:
        print(f"// {track_id}: '{old_title}' (유지)")

print(f"\n총 {len([t for t_id, new in UPDATED_TITLES.items() if midi_data.get(t_id, {}).get('title') != new])}개 트랙 제목 변경 필요")
