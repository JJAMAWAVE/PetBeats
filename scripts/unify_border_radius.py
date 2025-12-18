import os
import re

# 카드 borderRadius를 20.r로, 내부 카드를 12.r로 통일
# 8, 8.r -> 12.r (내부 카드/버튼)
# 12 without .r -> 12.r

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    
    # 8 -> 12.r (내부 카드/버튼)
    content = re.sub(r'BorderRadius\.circular\(8\)', 'BorderRadius.circular(12.r)', content)
    content = re.sub(r'BorderRadius\.circular\(8\.r\)', 'BorderRadius.circular(12.r)', content)
    
    # 12 without .r -> 12.r
    content = re.sub(r'BorderRadius\.circular\(12\)(?!\.)', 'BorderRadius.circular(12.r)', content)
    
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
