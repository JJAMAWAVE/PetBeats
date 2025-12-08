#!/usr/bin/env python3
"""Extract duration from MP3 files in assets/sound directory."""

import os

try:
    from mutagen.mp3 import MP3
except ImportError:
    print("Installing mutagen...")
    os.system("pip install mutagen")
    from mutagen.mp3 import MP3

def format_duration(seconds):
    """Format seconds to M:SS format."""
    minutes = int(seconds // 60)
    secs = int(seconds % 60)
    return f"{minutes}:{secs:02d}"

def main():
    sound_dir = "assets/sound"
    
    # Get all MP3 files (not in subdirectories)
    mp3_files = []
    for f in os.listdir(sound_dir):
        full_path = os.path.join(sound_dir, f)
        if f.endswith('.mp3') and not os.path.isdir(full_path):
            mp3_files.append(f)
    
    mp3_files.sort()
    
    print("=" * 50)
    print("Track Duration List")
    print("=" * 50)
    
    for f in mp3_files:
        try:
            audio = MP3(os.path.join(sound_dir, f))
            duration = format_duration(audio.info.length)
            print(f"'{f}': '{duration}',")
        except Exception as e:
            print(f"Error processing {f}: {e}")
    
    print("=" * 50)

if __name__ == "__main__":
    main()
