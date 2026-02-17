#!/usr/bin/env python3
"""
Audio Generator - Creates actual audio files with sound
Generates sine wave tones for testing and placeholder audio
"""

import struct
import os
import math
from pathlib import Path

def create_wav_tone(filepath: str, frequency: float, duration_ms: int, volume: float = 0.5):
    """Create a WAV file with a sine wave tone"""
    
    sample_rate = 44100  # 44.1 kHz
    num_channels = 2  # Stereo
    bits_per_sample = 16
    
    # Calculate samples
    num_samples = int(sample_rate * duration_ms / 1000)
    
    # WAV header
    byte_rate = sample_rate * num_channels * bits_per_sample // 8
    block_align = num_channels * bits_per_sample // 8
    
    wav_header = bytearray()
    wav_header.extend(b'RIFF')
    wav_header.extend(struct.pack('<I', 36 + num_samples * block_align))
    wav_header.extend(b'WAVE')
    
    # fmt subchunk
    wav_header.extend(b'fmt ')
    wav_header.extend(struct.pack('<I', 16))  # Subchunk1Size
    wav_header.extend(struct.pack('<H', 1))   # AudioFormat (1 = PCM)
    wav_header.extend(struct.pack('<H', num_channels))
    wav_header.extend(struct.pack('<I', sample_rate))
    wav_header.extend(struct.pack('<I', byte_rate))
    wav_header.extend(struct.pack('<H', block_align))
    wav_header.extend(struct.pack('<H', bits_per_sample))
    
    # data subchunk
    wav_header.extend(b'data')
    wav_header.extend(struct.pack('<I', num_samples * block_align))
    
    # Generate sine wave audio data
    audio_data = bytearray()
    max_amplitude = (2 ** (bits_per_sample - 1)) - 1  # 32767 for 16-bit
    
    for i in range(num_samples):
        # Sine wave: A * sin(2π * f * t)
        t = i / sample_rate
        sample_value = int(max_amplitude * volume * math.sin(2 * math.pi * frequency * t))
        
        # Clamp to valid range
        sample_value = max(-32768, min(32767, sample_value))
        
        # Convert to 16-bit signed integer (little-endian)
        sample_bytes = struct.pack('<h', sample_value)
        
        # Stereo: duplicate for both channels
        audio_data.extend(sample_bytes)
        audio_data.extend(sample_bytes)
    
    # Write WAV file
    wav_file = wav_header + audio_data
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    
    with open(filepath, 'wb') as f:
        f.write(wav_file)
    
    return filepath

def main():
    """Generate all game audio files with actual sound"""
    
    audio_dir = Path("d:/Project/final/RPG/Audio")
    os.makedirs(audio_dir, exist_ok=True)
    
    print("=" * 70)
    print("🎵 AUDIO GENERATOR - Creating Audio Files with Sound")
    print("=" * 70)
    
    # BGM Configuration: (filename, frequency, duration_ms, volume)
    bgm_specs = [
        ("bgm_menu.ogg", 440, 30000, 0.3),            # A4, 30 sec loop, quiet background
        ("bgm_battle.ogg", 523, 30000, 0.4),          # C5, 30 sec loop, energetic
        ("bgm_story.ogg", 392, 30000, 0.3),           # G4, 30 sec loop, mysterious
        ("bgm_forest.ogg", 349, 30000, 0.25),         # F4, 30 sec loop, ambient
        ("bgm_boss.ogg", 293, 30000, 0.45),           # D4, 30 sec loop, intense
        ("bgm_victory.ogg", 659, 12000, 0.5),         # E5, 12 sec, uplifting
    ]
    
    # SFX Configuration: (filename, frequency, duration_ms, volume)
    sfx_specs = [
        ("sfx_button.ogg", 880, 500, 0.6),            # A5, short, bright
        ("sfx_hover.ogg", 784, 200, 0.5),             # G5, very short, light
        ("sfx_attack.ogg", 587, 800, 0.7),            # D5, medium, aggressive
        ("sfx_hit.ogg", 440, 600, 0.65),              # A4, medium, impactful
        ("sfx_heal.ogg", 659, 1000, 0.6),             # E5, longer, healing
        ("sfx_levelup.ogg", 784, 2000, 0.6),          # G5, chime-like
        ("sfx_victory.ogg", 659, 3000, 0.6),          # E5, fanfare-like
        ("sfx_defeat.ogg", 246, 2000, 0.4),           # B3, sad, low
        ("sfx_menu_open.ogg", 987, 400, 0.5),         # B5, whoosh
        ("sfx_menu_close.ogg", 659, 300, 0.4),        # E5, close sound
    ]
    
    print("\n🎵 BACKGROUND MUSIC (BGM)")
    print("-" * 70)
    for filename, freq, duration, volume in bgm_specs:
        filepath = str(audio_dir / filename)
        create_wav_tone(filepath, freq, duration, volume)
        duration_sec = duration / 1000
        print(f"✓ {filename:20} | {freq:6.0f} Hz | {duration_sec:6.1f}s | vol: {volume:.1f}")
    
    print("\n🔊 SOUND EFFECTS (SFX)")
    print("-" * 70)
    for filename, freq, duration, volume in sfx_specs:
        filepath = str(audio_dir / filename)
        create_wav_tone(filepath, freq, duration, volume)
        print(f"✓ {filename:20} | {freq:6.0f} Hz | {duration:5}ms  | vol: {volume:.1f}")
    
    print("\n" + "=" * 70)
    print("✅ AUDIO FILES GENERATED SUCCESSFULLY!")
    print("=" * 70)
    print(f"\nLocation: {audio_dir}")
    print(f"Total files: {len(bgm_specs) + len(sfx_specs)}")
    print("\n📝 Generated Audio Properties:")
    print("   • Format: WAV (will be auto-converted by Godot)")
    print("   • Sample Rate: 44,100 Hz")
    print("   • Channels: Stereo")
    print("   • Bit Depth: 16-bit")
    print("   • Audio Type: Pure sine wave tones (for testing)")
    print("\n💡 NEXT STEPS:")
    print("   1. Godot will auto-import these files as .ogg")
    print("   2. Reload Godot to see import updates")
    print("   3. Run game and test audio")
    print("   4. Later replace with real music/SFX")
    print("\n" + "=" * 70)

if __name__ == "__main__":
    main()
