#!/usr/bin/env python3
"""
Audio System Debug Checker
Verifies AudioManager configuration and files
"""

import os
import json
from pathlib import Path

def check_audio_system():
    """Check audio system configuration"""
    
    print("\n" + "=" * 70)
    print("🎵 AUDIO SYSTEM DEBUG CHECK")
    print("=" * 70)
    
    # 1. Check AudioManager.gd exists
    print("\n1️⃣ AudioManager.gd Status")
    print("-" * 70)
    
    project_file = Path("d:/Project/final/RPG/project.godot")
    audio_manager = Path("d:/Project/final/RPG/Scripts/AudioManager.gd")
    if audio_manager.exists():
        size = audio_manager.stat().st_size
        print(f"✅ Found: {audio_manager} ({size} bytes)")
        
        # Check if it's in project.godot
        with open(project_file, 'r', encoding='utf-8') as f:
            content = f.read()
            if "AudioManager" in content:
                if 'AudioManager="*res://Scripts/AudioManager.gd"' in content:
                    print("✅ AudioManager registered in project.godot autoload")
                else:
                    print("⚠️  AudioManager mentioned but not properly registered")
            else:
                print("❌ AudioManager NOT found in project.godot autoload!")
                return False
    else:
        print(f"❌ AudioManager.gd NOT FOUND at {audio_manager}")
        return False
    
    # 2. Check Audio files
    print("\n2️⃣ Audio Files Status")
    print("-" * 70)
    audio_dir = Path("d:/Project/final/RPG/Audio")
    
    if audio_dir.exists():
        files = list(audio_dir.glob("*.ogg"))
        print(f"✅ Audio directory exists: {audio_dir}")
        print(f"   📁 Found {len(files)} .ogg files")
        
        # Check BGM
        bgm_files = [f for f in files if f.name.startswith("bgm_")]
        print(f"\n   🎵 BGM Files: {len(bgm_files)}")
        for f in sorted(bgm_files):
            size_kb = f.stat().st_size / 1024
            print(f"      ✓ {f.name:20} ({size_kb:.1f} KB)")
        
        # Check SFX
        sfx_files = [f for f in files if f.name.startswith("sfx_")]
        print(f"\n   🔊 SFX Files: {len(sfx_files)}")
        for f in sorted(sfx_files):
            size_kb = f.stat().st_size / 1024
            print(f"      ✓ {f.name:20} ({size_kb:.1f} KB)")
        
        if len(files) < 16:
            print(f"\n⚠️  Only {len(files)}/16 audio files found (missing some)")
        else:
            print(f"\n✅ All {len(files)} audio files present")
    else:
        print(f"❌ Audio directory NOT FOUND: {audio_dir}")
        return False
    
    # 3. Check Script Integration
    print("\n3️⃣ Script Integration Status")
    print("-" * 70)
    
    main_menu = Path("d:/Project/final/RPG/Scripts/MainMenu.gd")
    if main_menu.exists():
        with open(main_menu, 'r', encoding='utf-8') as f:
            content = f.read()
            # Check for AudioManager calls
            if "AudioManager.play_bgm" in content:
                count = content.count("AudioManager")
                print(f"✅ MainMenu.gd uses AudioManager ({count} references)")
            else:
                print("⚠️  MainMenu.gd does NOT use AudioManager!")
    
    options_menu = Path("d:/Project/final/RPG/Scripts/OptionsMenu.gd")
    if options_menu.exists():
        with open(options_menu, 'r', encoding='utf-8') as f:
            content = f.read()
            if "AudioManager" in content:
                print(f"✅ OptionsMenu.gd uses AudioManager")
            else:
                print("⚠️  OptionsMenu.gd does NOT use AudioManager!")
    
    # 4. Check Godot Compilation
    print("\n4️⃣ Godot Project Configuration")
    print("-" * 70)
    
    with open(project_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    in_autoload = False
    autoloads = []
    for line in lines:
        if "[autoload]" in line:
            in_autoload = True
        elif in_autoload and line.startswith("["):
            break
        elif in_autoload and "=" in line:
            autoloads.append(line.strip())
    
    print("Registered AutoLoads:")
    for autoload in autoloads:
        print(f"  • {autoload}")
        if "AudioManager" in autoload:
            print("    ✅ AudioManager autoload registered")
    
    # 5. Summary
    print("\n5️⃣ Summary & Next Steps")
    print("-" * 70)
    
    issues = []
    
    if not audio_manager.exists():
        issues.append("AudioManager.gd missing")
    
    if not audio_dir.exists() or len(list(audio_dir.glob("*.ogg"))) < 16:
        issues.append("Audio files incomplete")
    
    if issues:
        print("⚠️  ISSUES DETECTED:")
        for issue in issues:
            print(f"  ❌ {issue}")
        print("\n🔧 FIXES NEEDED:")
        print("  1. Ensure AudioManager.gd is in Scripts/")
        print("  2. Run generate_audio_tones.py to create audio")
        print("  3. Check project.godot has AudioManager in [autoload]")
        print("  4. Reload Godot editor")
        return False
    else:
        print("✅ ALL CHECKS PASSED!")
        print("\n📝 NEXT STEPS:")
        print("  1. Open Godot Editor")
        print("  2. If files changed, Godot will auto-reimport")
        print("  3. Press F5 to Play MainMenu.tscn")
        print("  4. Check console for Audio System debug messages")
        print("  5. Listen for beep sounds when clicking buttons")
        return True

if __name__ == "__main__":
    try:
        success = check_audio_system()
        print("\n" + "=" * 70)
        if success:
            print("✅ System appears healthy. Check Godot editor console for errors.")
        else:
            print("❌ System has issues. Address them above.")
        print("=" * 70 + "\n")
    except Exception as e:
        print(f"\n❌ Error during check: {e}\n")
