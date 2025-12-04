import pyautogui
import time
import json
import os
import random

# --- Configuration ---
# Load track data
DATA_FILE = r'c:\PetBeats\docs\optimization\aiva_tracks.json'

# Safety: Move mouse to upper-left corner to abort
pyautogui.FAILSAFE = True

def load_data():
    if not os.path.exists(DATA_FILE):
        print(f"Error: Data file not found at {DATA_FILE}")
        return None
    with open(DATA_FILE, 'r', encoding='utf-8') as f:
        return json.load(f)

def calibrate():
    print("--- Calibration Mode ---")
    print("We need to tell the script where the buttons are on your screen.")
    print("Hover over the specified element and press Enter.")
    
    locations = {}
    
    elements = [
        "Create Track Button (Green)",
        "From a Style Option (Dropdown)",
        "Style Search Input",
        "Key Signature Dropdown (Modal)",
        "Duration Dropdown (Modal)",
        "Num Compositions Input (Modal)",
        "Create Tracks Button (Blue)"
    ]
    
    for el in elements:
        input(f"Hover over [{el}] and press Enter...")
        pos = pyautogui.position()
        locations[el] = pos
        print(f"Recorded {el} at {pos}")
        time.sleep(0.5)
        
    print("Calibration complete!")
    return locations

def run_automation(data, locations):
    print("Starting automation in 5 seconds... Switch to AIVA window!")
    time.sleep(5)
    
    for category in data:
        print(f"Processing Category: {category['category']}")
        for track in category['tracks']:
            print(f"Creating Track: {track['title_en']}")
            
            # 1. Click Create Track Button
            pyautogui.click(locations["Create Track Button (Green)"])
            time.sleep(0.5)
            
            # 2. Click 'From a Style'
            pyautogui.click(locations["From a Style Option (Dropdown)"])
            time.sleep(2.0) # Wait for Style Library
            
            # 3. Search and Select Style
            pyautogui.click(locations["Style Search Input"])
            pyautogui.hotkey('ctrl', 'a')
            pyautogui.typewrite(track['style'])
            time.sleep(1.5) # Wait for search results
            pyautogui.press('enter') # Select style
            time.sleep(2.0) # Wait for Modal
            
            # 4. Set Key Signature (Modal)
            # Only set if not 'Auto' in JSON, or just leave as Auto if preferred.
            # Assuming we try to set it if provided.
            key_val = track.get('key', 'Auto')
            if key_val and key_val != 'Auto':
                pyautogui.click(locations["Key Signature Dropdown (Modal)"])
                time.sleep(0.5)
                pyautogui.typewrite(key_val)
                time.sleep(0.5)
                pyautogui.press('enter')
                time.sleep(0.5)
            
            # 5. Set Duration (Modal) -> "5:00 - 5:30"
            pyautogui.click(locations["Duration Dropdown (Modal)"])
            time.sleep(0.5)
            # Typing "5:00" usually filters or jumps to it
            pyautogui.typewrite("5:00") 
            time.sleep(0.5)
            pyautogui.press('enter')
            time.sleep(0.5)
            
            # 6. Set Number of Compositions (Modal) -> "2"
            pyautogui.click(locations["Num Compositions Input (Modal)"])
            pyautogui.hotkey('ctrl', 'a')
            pyautogui.typewrite("2")
            time.sleep(0.5)
            
            # 7. Final Create (Blue Button)
            pyautogui.click(locations["Create Tracks Button (Blue)"])
            
            print(f"Finished setup for {track['title_en']} (2 tracks, 5:00-5:30).")
            time.sleep(5) # Wait for creation to start
            
            # Safety pause
            # input("Press Enter to continue...")

if __name__ == "__main__":
    data = load_data()
    if data:
        print(f"Loaded {sum(len(c['tracks']) for c in data)} tracks.")
        
        choice = input("Run Calibration? (y/n): ")
        if choice.lower() == 'y':
            locs = calibrate()
            
            run_choice = input("Run Automation now? (y/n): ")
            if run_choice.lower() == 'y':
                run_automation(data, locs)
        else:
            print("Skipping calibration. Script needs locations to run.")
