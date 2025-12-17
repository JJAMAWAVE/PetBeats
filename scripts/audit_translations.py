import os
import re

def scan_keys_in_code(root_dir):
    keys = set()
    # Matches: 'key'.tr, "key".tr, 'key'.trParams, "key".trParams
    pattern = re.compile(r"(['\"])([\w\d_]+)\1\.(tr|trParams|trArgs)")
    
    for dirpath, _, filenames in os.walk(root_dir):
        for f in filenames:
            if f.endswith('.dart'):
                path = os.path.join(dirpath, f)
                try:
                    with open(path, 'r', encoding='utf-8') as file:
                        content = file.read()
                        matches = pattern.findall(content)
                        for match in matches:
                            keys.add(match[1])
                except Exception as e:
                    print(f"Error reading {path}: {e}")
    return keys

def load_keys_from_file(file_path):
    defined_keys = set()
    # Matches: 'key': 'value'
    # Simple regex, might miss some edge cases but good enough for map structure
    pattern = re.compile(r"(['\"])([\w\d_]+)\1\s*:\s*")
    
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
            matches = pattern.findall(content)
            for match in matches:
                defined_keys.add(match[1])
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    return defined_keys

def main():
    root_dir = r"c:\PetBeats\lib"
    ko_file = r"c:\PetBeats\lib\app\translations\ko_kr.dart"
    en_file = r"c:\PetBeats\lib\app\translations\en_us.dart"
    
    print("Scanning code for usage...")
    used_keys = scan_keys_in_code(root_dir)
    print(f"Found {len(used_keys)} unique keys used in code.")
    
    print("Loading defined keys...")
    ko_keys = load_keys_from_file(ko_file)
    en_keys = load_keys_from_file(en_file)
    print(f"Found {len(ko_keys)} keys in ko_kr.dart")
    print(f"Found {len(en_keys)} keys in en_us.dart")
    
    missing_ko = used_keys - ko_keys
    missing_en = used_keys - en_keys
    
    print("\n" + "="*50)
    print("MISSING KEYS REPORT")
    print("="*50)
    
    if missing_ko:
        print(f"\n[Missing in ko_kr.dart] ({len(missing_ko)})")
        for k in sorted(missing_ko):
            print(f"  - {k}")
    else:
        print("\n[ko_kr.dart] All used keys are defined! (Perfect)")

    if missing_en:
        print(f"\n[Missing in en_us.dart] ({len(missing_en)})")
        for k in sorted(missing_en):
            print(f"  - {k}")
    else:
        print("\n[en_us.dart] All used keys are defined! (Perfect)")

if __name__ == "__main__":
    main()
