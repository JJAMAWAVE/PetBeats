#!/usr/bin/env python3
"""
MP3 일괄 압축 스크립트 (128kbps CBR)
원본이 156kbps이므로 128kbps로 압축하면 약 18% 감소 가능
"""

import os
import subprocess
from pathlib import Path
import shutil

# 설정
SOUND_DIR = Path("assets/sound")
BITRATE = "128k"  # 128kbps CBR
BACKUP = False

def get_mp3_files():
    """모든 MP3 파일 찾기"""
    return list(SOUND_DIR.rglob("*.mp3"))

def compress_mp3(input_path):
    """단일 MP3 파일 압축"""
    output_path = input_path.with_suffix('.tmp.mp3')
    
    cmd = [
        'ffmpeg', '-y', '-i', str(input_path),
        '-codec:a', 'libmp3lame',
        '-b:a', BITRATE,
        str(output_path)
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
        
        if result.returncode == 0 and output_path.exists():
            original_size = input_path.stat().st_size
            new_size = output_path.stat().st_size
            
            # 원본 대체
            os.remove(input_path)
            shutil.move(str(output_path), str(input_path))
            return original_size, new_size
        else:
            if output_path.exists():
                os.remove(output_path)
            return None, None
            
    except Exception as e:
        print(f"  오류: {e}")
        if output_path.exists():
            os.remove(output_path)
        return None, None

def main():
    print("🎵 MP3 압축 시작 (128kbps CBR)")
    print("=" * 60)
    
    mp3_files = get_mp3_files()
    total = len(mp3_files)
    
    total_before = sum(f.stat().st_size for f in mp3_files)
    print(f"📊 총 파일 수: {total}개")
    print(f"📊 압축 전 용량: {total_before / 1024 / 1024:.1f} MB")
    print("=" * 60)
    
    success = 0
    failed = 0
    saved_bytes = 0
    
    for i, mp3_file in enumerate(mp3_files, 1):
        rel_path = mp3_file.relative_to(SOUND_DIR)
        print(f"[{i}/{total}] {str(rel_path)[:50]}...", end=" ", flush=True)
        
        orig_size, new_size = compress_mp3(mp3_file)
        
        if orig_size and new_size:
            reduction = (1 - new_size / orig_size) * 100
            saved_bytes += orig_size - new_size
            print(f"✓ {orig_size/1024:.0f}KB → {new_size/1024:.0f}KB ({reduction:.0f}%↓)")
            success += 1
        else:
            print("✗ 실패")
            failed += 1
    
    # 압축 후 총 용량
    mp3_files = get_mp3_files()
    total_after = sum(f.stat().st_size for f in mp3_files)
    
    print("=" * 60)
    print(f"✅ 완료: {success}/{total} 성공")
    print(f"📊 압축 전: {total_before / 1024 / 1024:.1f} MB")
    print(f"📊 압축 후: {total_after / 1024 / 1024:.1f} MB")
    print(f"📊 절감량: {saved_bytes / 1024 / 1024:.1f} MB ({(1 - total_after/total_before)*100:.1f}% 감소)")

if __name__ == '__main__':
    main()
