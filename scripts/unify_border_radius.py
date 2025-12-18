import os
import re

# 카드 borderRadius를 20.r로 통일
# 16, 16.r -> 20.r
# 24, 24.r -> 20.r (카드용)
# 12, 12.r -> 12.r (버튼용, 유지)
# 40 -> 그대로 (pill 형태)

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    
    # 16 -> 20.r (카드용)
    content = re.sub(r'BorderRadius\.circular\(16\)', 'BorderRadius.circular(20.r)', content)
    content = re.sub(r'BorderRadius\.circular\(16\.r\)', 'BorderRadius.circular(20.r)', content)
    
    # 24 -> 20.r (카드용)  
    content = re.sub(r'BorderRadius\.circular\(24\)', 'BorderRadius.circular(20.r)', content)
    content = re.sub(r'BorderRadius\.circular\(24\.r\)', 'BorderRadius.circular(20.r)', content)
    
    # 20 without .r -> 20.r
    content = re.sub(r'BorderRadius\.circular\(20\)(?!\.)', 'BorderRadius.circular(20.r)', content)
    
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

# lib 폴더 내 모든 dart 파일 처리
lib_path = r'c:\PetBeats\lib'
modified = 0

for root, dirs, files in os.walk(lib_path):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            if process_file(filepath):
                print(f'Modified: {filepath}')
                modified += 1

print(f'\nTotal modified: {modified} files')
