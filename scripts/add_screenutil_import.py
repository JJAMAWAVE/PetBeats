import os
import re

# .r 사용하는 파일에 flutter_screenutil import 추가

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # .r 사용 체크
    if '.r)' not in content and '.r,' not in content:
        return False
    
    # 이미 import가 있는지 체크
    if "import 'package:flutter_screenutil/flutter_screenutil.dart';" in content:
        return False
    
    # 첫 번째 import 문 찾기
    match = re.search(r"import 'package:flutter/material\.dart';", content)
    if match:
        new_import = "import 'package:flutter/material.dart';\nimport 'package:flutter_screenutil/flutter_screenutil.dart';"
        content = content.replace("import 'package:flutter/material.dart';", new_import, 1)
        
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
                print(f'Added import: {filepath}')
                modified += 1

print(f'\nTotal modified: {modified} files')
