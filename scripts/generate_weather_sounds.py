import numpy as np
import scipy.io.wavfile as wav
import os
import random

def save_wav(filename, data, sr=44100):
    # Normalize to 16-bit PCM range
    data = data / np.max(np.abs(data)) * 32767
    wav.write(filename, sr, data.astype(np.int16))
    print(f"Generated: {filename}")

def generate_white_noise(duration, sr=44100):
    return np.random.uniform(-1, 1, int(sr * duration))

def generate_pink_noise(duration, sr=44100):
    white = generate_white_noise(duration, sr)
    # Simple 1/f filter approximation
    X = np.fft.rfft(white)
    S = np.sqrt(np.arange(len(X)) + 1.)  # +1 to avoid division by zero
    Y = X / S
    pink = np.fft.irfft(Y)
    if len(pink) > len(white):
        pink = pink[:len(white)]
    return pink

def generate_brown_noise(duration, sr=44100):
    white = generate_white_noise(duration, sr)
    # 1/f^2 filter
    X = np.fft.rfft(white)
    S = np.arange(len(X)) + 1.  # +1 to avoid zero
    Y = X / S
    brown = np.fft.irfft(Y)
    if len(brown) > len(white):
        brown = brown[:len(white)]
    return brown

def generate_rain(duration=10, sr=44100):
    # Pink noise base
    noise = generate_pink_noise(duration, sr)
    # Add random droplets (high freq pops)
    droplets = np.zeros_like(noise)
    for _ in range(int(duration * 20)): # 20 drops per second
        idx = random.randint(0, len(noise)-1000)
        droplets[idx:idx+100] += np.random.uniform(-0.5, 0.5, 100)
    
    return noise * 0.7 + droplets * 0.3

def generate_wind(duration=10, sr=44100, intensity='strong'):
    # Brown noise with amplitude modulation
    noise = generate_brown_noise(duration, sr)
    t = np.linspace(0, duration, len(noise))
    
    # Slow modulation for wind gusts
    if intensity == 'strong':
        mod = 0.5 + 0.5 * np.sin(2 * np.pi * 0.2 * t + np.random.normal(0, 0.1, len(t)))
    else: # snow/gentle
        mod = 0.7 + 0.3 * np.sin(2 * np.pi * 0.1 * t)
        
    return noise * mod

def generate_crickets(duration=10, sr=44100):
    t = np.linspace(0, duration, int(duration*sr))
    # Carrier frequency ~4kHz
    carrier = np.sin(2 * np.pi * 4000 * t)
    # Modulation (chirp pattern)
    mod = (np.sin(2 * np.pi * 30 * t) + 1) / 2 # Fast chirp
    mod[mod < 0.8] = 0 # Gate
    
    # Add silence gaps
    envelope = np.zeros_like(t)
    chirp_len = int(0.1 * sr)
    gap_len = int(0.5 * sr)
    cursor = 0
    while cursor < len(envelope):
        # 3 chirps
        for _ in range(3):
            if cursor + chirp_len < len(envelope):
                envelope[cursor:cursor+chirp_len] = 1
            cursor += chirp_len + int(0.05*sr)
        cursor += gap_len
        
    return carrier * mod * envelope * 0.1

def generate_birds(duration=10, sr=44100):
    # Very simple synthetic bird chirp using FM synthesis
    output = np.zeros(int(duration * sr))
    num_chirps = int(duration * 0.5) # 1 chirp every 2 secs approx
    
    for _ in range(num_chirps):
        start = random.randint(0, len(output) - sr)
        chirp_dur = random.uniform(0.1, 0.3)
        t = np.linspace(0, chirp_dur, int(chirp_dur * sr))
        
        # FM Chirp: rapid frequency slide
        f_start = random.uniform(2000, 4000)
        f_end = random.uniform(1000, 2000)
        freq = np.linspace(f_start, f_end, len(t))
        phase = 2 * np.pi * np.cumsum(freq) / sr
        chirp = np.sin(phase) * np.linspace(0, 1, len(t)) # Fade in
        chirp *= np.linspace(1, 0, len(t)) # Fade out
        
        output[start:start+len(chirp)] += chirp * 0.2
        
    # Add light background wind
    bg = generate_brown_noise(duration, sr) * 0.05
    return output + bg

def main():
    base_dir = r"c:\PetBeats\assets\sound\weather"
    os.makedirs(base_dir, exist_ok=True)
    
    print("Generating weather sounds...")
    
    # 1. Rain
    save_wav(os.path.join(base_dir, "rain_ambient.wav"), generate_rain())
    
    # 2. Sunny (Birds)
    save_wav(os.path.join(base_dir, "sunny_birds.wav"), generate_birds())
    
    # 3. Night (Crickets)
    save_wav(os.path.join(base_dir, "night_crickets.wav"), generate_crickets())
    
    # 4. Snow (Gentle Wind)
    save_wav(os.path.join(base_dir, "snow_wind.wav"), generate_wind(intensity='gentle'))
    
    # 5. Strong Wind
    save_wav(os.path.join(base_dir, "strong_wind.wav"), generate_wind(intensity='strong'))
    
    # 6. Cloudy (White/Pink Mix)
    save_wav(os.path.join(base_dir, "cloudy_ambient.wav"), generate_pink_noise(10) * 0.5)
    
    print("Done!")

if __name__ == "__main__":
    main()
