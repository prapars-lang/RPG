#!/usr/bin/env python3
"""
Audio Placeholder Generator
Creates minimal audio files for development purposes
"""

import os
import struct
from pathlib import Path

def create_minimal_ogg(filepath: str, duration_ms: int = 2000):
    """
    Create a minimal OGG file (tone signal)
    This is a very simple implementation for placeholder purposes
    Note: In production, use proper OGG encoding libraries
    """
    # For now, create empty OGG file marker
    # Full OGG encoding requires external libraries (not available by default)
    # We'll create a minimal WAV file instead as fallback
    
    # Create a minimal WAV file
    # WAV header structure for simple generation
    create_minimal_wav(filepath.replace('.ogg', '.wav'), duration_ms)

def create_minimal_wav(filepath: str, duration_ms: int = 2000):
    """Create a minimal valid WAV file (silence or simple tone)"""
    
    sample_rate = 44100  # 44.1 kHz
    num_channels = 2  # Stereo
    bits_per_sample = 16
    
    num_samples = int(sample_rate * duration_ms / 1000)
    
    # WAV file header
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
    
    # Add silence (zeros)
    wav_data = wav_header + b'\x00' * (num_samples * block_align)
    
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, 'wb') as f:
        f.write(wav_data)
    
    print(f"✓ Created: {filepath} ({duration_ms}ms)")

def main():
    audio_dir = Path("d:/Project/final/RPG/Audio")
    
    bgm_files = {
        "bgm_menu.ogg": 120000,      # 2 minute menu loop
        "bgm_battle.ogg": 180000,    # 3 minute battle loop
        "bgm_story.ogg": 240000,     # 4 minute story music
        "bgm_forest.ogg": 300000,    # 5 minute forest ambience
        "bgm_boss.ogg": 240000,      # 4 minute boss battle
        "bgm_victory.ogg": 12000,    # 12 second victory fanfare
    }
    
    sfx_files = {
        "sfx_button.ogg": 500,       # 500ms button click
        "sfx_hover.ogg": 200,        # 200ms hover effect
        "sfx_attack.ogg": 800,       # 800ms attack sound
        "sfx_hit.ogg": 600,          # 600ms hit sound
        "sfx_heal.ogg": 1000,        # 1000ms heal sound
        "sfx_levelup.ogg": 2000,     # 2000ms level up chime
        "sfx_victory.ogg": 3000,     # 3000ms victory sound
        "sfx_defeat.ogg": 2000,      # 2000ms defeat sound
        "sfx_menu_open.ogg": 400,    # 400ms menu open
        "sfx_menu_close.ogg": 300,   # 300ms menu close
    }
    
    print("Creating audio placeholder files...")
    print("=" * 60)
    
    # Create BGM files
    print("\n🎵 Background Music (BGM)")
    print("-" * 60)
    for filename, duration in bgm_files.items():
        filepath = audio_dir / filename
        create_minimal_wav(str(filepath), duration)
    
    # Create SFX files
    print("\n🔊 Sound Effects (SFX)")
    print("-" * 60)
    for filename, duration in sfx_files.items():
        filepath = audio_dir / filename
        create_minimal_wav(str(filepath), duration)
    
    print("\n" + "=" * 60)
    print("✅ Audio placeholders created successfully!")
    print(f"\nLocation: {audio_dir}")
    print(f"Total files: {len(bgm_files) + len(sfx_files)}")
    print("\n⚠️  NOTE: These are placeholder silence files for development.")
    print("         Replace with actual audio files for final game.")
    print("\n📝 To use real audio:")
    print("   1. Record or source audio files")
    print("   2. Convert to OGG Vorbis (recommended) or MP3 format")
    print("   3. Replace the placeholder .wav files with actual audio")
    print("   4. Ensure files have the correct names and paths")
    print("\nRecommended tools:")
    print("   - Audacity (free) for audio editing")
    print("   - ffmpeg for format conversion")
    print("   - Freesound.org for free SFX")

if __name__ == "__main__":
    main()
