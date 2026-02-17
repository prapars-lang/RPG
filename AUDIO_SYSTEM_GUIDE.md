# 🎵 Audio System Integration Guide

## Overview

The game now has a comprehensive audio system with:
- ✅ Background Music (BGM) playback
- ✅ Sound Effects (SFX) pooling (8 simultaneous)
- ✅ Volume mixing (Music + SFX buses)
- ✅ Fade in/out effects
- ✅ Pause/resume controls
- ✅ Mute toggles

---

## Audio System Architecture

### AutoLoad: AudioManager.gd
```
Responsibilities:
- BGM playback and transitions
- SFX pooling and playback
- Volume control (dB conversion)
- Mute state management
- Audio bus management
```

### Audio Buses
```
Master (root)
├── Music (BGM) [default -5.0 dB]
└── SFX [default 0.0 dB]
```

---

## Usage Examples

### Playing Background Music
```gdscript
# Play main menu music (with 1.2 second fade-in)
AudioManager.play_bgm("main_menu", 1.2)

# Play battle music
AudioManager.play_bgm("battle", 0.8)

# Stop with fade-out
await AudioManager.stop_bgm(1.0)
```

### Playing Sound Effects
```gdscript
# Simple SFX play
AudioManager.play_sfx("button_click")

# With volume offset (quieter)
AudioManager.play_sfx("button_hover", -5.0)

# Attack sound (louder)
AudioManager.play_sfx("attack", 3.0)
```

### Volume Control
```gdscript
# Convert linear (0.0-1.0) to dB
var linear_vol = 0.8
var db = AudioManager.linear_to_db(linear_vol)
AudioManager.set_music_volume(db)

# Direct dB control
AudioManager.set_sfx_volume(-10.0)

# Get current volumes
var music_db = AudioManager.get_music_volume()  # Returns dB
var sfx_db = AudioManager.get_sfx_volume()
```

### Mute Controls
```gdscript
# Toggle mute
var was_muted = AudioManager.toggle_music_mute()

# Or set explicitly
AudioManager.set_music_mute(true)
AudioManager.set_sfx_mute(false)

# Check single BGM playing status
if AudioManager.is_bgm_playing():
	print("Music is playing!")
```

---

## Audio File Setup

### Directory Structure (Create if missing)
```
res://Audio/
├── bgm/
│   ├── bgm_menu.ogg          (Main menu background)
│   ├── bgm_battle.ogg        (Combat encounters)
│   ├── bgm_story.ogg         (Story/dialogue scenes)
│   ├── bgm_forest.ogg        (Forest path music)
│   ├── bgm_boss.ogg          (Boss battle music)
│   └── bgm_victory.ogg       (Victory/level up)
│
├── sfx/
│   ├── sfx_button.ogg        (Menu button click)
│   ├── sfx_hover.ogg         (Button hover)
│   ├── sfx_attack.ogg        (Battle attack action)
│   ├── sfx_hit.ogg           (Enemy hit/damage)
│   ├── sfx_heal.ogg          (Healing action)
│   ├── sfx_levelup.ogg       (Level up achieved)
│   ├── sfx_victory.ogg       (Battle victory)
│   ├── sfx_defeat.ogg        (Battle defeat)
│   ├── sfx_menu_open.ogg     (Menu open)
│   └── sfx_menu_close.ogg    (Menu close)
```

### Supported Audio Formats
- **OGG Vorbis** (.ogg) - Recommended for Godot
- **MP3** (.mp3) - Supported but larger size
- **WAV** (.wav) - Uncompressed, larger files

### Audio File Specifications
```
Recommended:
- Sample Rate: 44,100 Hz
- Channels: Stereo (2)
- Bitrate: 128-192 kbps (OGG)
- Format: OGG Vorbis or MP3
```

---

## Current Audio Paths

### BGM Paths (AudioManager.gd lines 30-37)
```gdscript
var bgm_paths = {
	"main_menu": "res://Audio/bgm_menu.ogg",
	"battle": "res://Audio/bgm_battle.ogg",
	"story": "res://Audio/bgm_story.ogg",
	"forest": "res://Audio/bgm_forest.ogg",
	"boss": "res://Audio/bgm_boss.ogg",
	"victory": "res://Audio/bgm_victory.ogg",
}
```

### SFX Paths (AudioManager.gd lines 38-50)
```gdscript
var sfx_paths = {
	"button_click": "res://Audio/sfx_button.ogg",
	"button_hover": "res://Audio/sfx_hover.ogg",
	"attack": "res://Audio/sfx_attack.ogg",
	"hit": "res://Audio/sfx_hit.ogg",
	"heal": "res://Audio/sfx_heal.ogg",
	"levelup": "res://Audio/sfx_levelup.ogg",
	"victory": "res://Audio/sfx_victory.ogg",
	"defeat": "res://Audio/sfx_defeat.ogg",
	"menu_open": "res://Audio/sfx_menu_open.ogg",
	"menu_close": "res://Audio/sfx_menu_close.ogg",
}
```

---

## Integration Points

### 1. MainMenu.gd (DONE ✅)
```gdscript
# Play BGM on ready
AudioManager.play_bgm("main_menu", 1.2)

# SFX on button interactions
AudioManager.play_sfx("button_click")          # _on_start_btn_pressed()
AudioManager.play_sfx("button_hover", -5.0)   # _on_btn_mouse_entered()
AudioManager.play_sfx("menu_open")            # _on_options_btn_pressed()
AudioManager.play_sfx("menu_close")           # _on_exit_btn_pressed()
```

### 2. OptionsMenu.gd (DONE ✅)
```gdscript
# Volume sliders connected to AudioManager buses
music_slider → AudioManager.set_music_volume(db)
sfx_slider → AudioManager.set_sfx_volume(db)

# Uses AudioManager.linear_to_db() and db_to_linear()
```

### 3. Battle.gd (TODO)
```gdscript
func _ready():
	AudioManager.play_bgm("battle", 0.8)

func _play_attack_animation():
	AudioManager.play_sfx("attack", 2.0)  # Louder attack sound
	AudioManager.play_sfx("hit")          # Enemy takes damage

func _on_victory():
	await AudioManager.stop_bgm(1.0)
	AudioManager.play_sfx("victory")
	AudioManager.play_bgm("victory", 0.5)
```

### 4. CharacterSelection.gd (TODO)
```gdscript
# SFX for character selections
AudioManager.play_sfx("button_click")

# Play story introduction music
AudioManager.play_bgm("story", 1.0)
```

### 5. PauseMenu.gd (TODO)
```gdscript
# Pause background music when menu opens
AudioManager.pause_bgm()

# Resume when closed
AudioManager.resume_bgm()

# Keep SFX playing for menu interactions
AudioManager.play_sfx("menu_open")
AudioManager.play_sfx("button_click")  # On resume/quit buttons
```

---

## Adding New Audio Files

### Step 1: Create Audio File
1. Use Audacity, FL Studio, or similar
2. Export as OGG Vorbis (128-192 kbps)
3. Save to appropriate folder (bgm/ or sfx/)

### Step 2: Register in AudioManager
```gdscript
# In AudioManager.gd, add to bgm_paths or sfx_paths:
var bgm_paths = {
	# ... existing entries ...
	"my_new_music": "res://Audio/bgm_my_new_music.ogg",
}

# Then use anywhere:
AudioManager.play_bgm("my_new_music", 1.0)
```

### Step 3: Use in Scene Scripts
```gdscript
# Example in Battle.gd
AudioManager.play_bgm("battle", 0.8)

# Example in any script
AudioManager.play_sfx("attack")
AudioManager.play_sfx("heal", 1.0)
```

---

## Testing Audio

### Test in Godot Editor
```gdscript
# In _ready() or _input():

# Play main menu music
AudioManager.play_bgm("main_menu")

# Test SFX
if Input.is_action_pressed("ui_accept"):
	AudioManager.play_sfx("button_click")

# Test volume
if Input.is_action_pressed("ui_up"):
	AudioManager.set_music_volume(AudioManager.get_music_volume() + 2.0)
```

### Debug Commands
```gdscript
# Print audio status
AudioManager.print_audio_status()

# Output shows:
# Music Volume: -5.0 dB
# SFX Volume: 0.0 dB
# Music Muted: false
# SFX Muted: false
# BGM Playing: true
# SFX Playing: 2/8
```

---

## Performance Considerations

### Background Music
- Only 1 BGM plays at a time
- Automatic fade transitions between songs
- Minimal CPU impact

### Sound Effects
- 8 simultaneous SFX pool
- Oldest SFX gets cut off if pool full
- Very low memory footprint

### Optimization Tips
```gdscript
# Don't spam SFX (causes performance issues)
# BAD - rapid clicks:
for i in range(100):
	AudioManager.play_sfx("button_click")

# GOOD - single click:
if event is InputEventMouseButton and event.pressed:
	AudioManager.play_sfx("button_click")
```

---

## Troubleshooting

### Problem: Audio not playing
```
✓ Check file paths in AudioManager.gd
✓ Verify OGG files exist in res://Audio/
✓ Check AudioServer buses are created (_setup_audio_buses)
✓ Ensure volume is not -80 dB (muted)
```

### Problem: Volume control not working
```
✓ Verify sliders are connected to _on_music/sfx_slider_value_changed()
✓ Check AudioManager buses exist
✓ Test with AudioManager.print_audio_status()
```

### Problem: SFX cut off too quickly
```
✓ Increase MAX_SFX_PLAYERS (currently 8)
✓ Reduce SFX spam frequency
✓ Use shorter audio files (< 2 seconds for SFX)
```

---

## Next Steps

### Phase 1: Audio Files (Current)
- [ ] Create res://Audio/ directory
- [ ] Add BGM files (6 tracks needed)
- [ ] Add SFX files (10 sounds needed)

### Phase 2: Scene Integration
- [ ] Integrate audio into Battle.gd
- [ ] Integrate audio into CharacterSelection.gd
- [ ] Integrate audio into PauseMenu.gd
- [ ] Integrate audio into VictoryScene.gd

### Phase 3: Polish
- [ ] Adjust volume levels and mix
- [ ] Add music transitions
- [ ] Test fade effects
- [ ] Optimize audio loading

---

## API Reference

### Main Functions
```gdscript
# BGM Control
play_bgm(key: String, fade_duration: float = 1.0)
stop_bgm(fade_duration: float = 1.0)
pause_bgm()
resume_bgm()

# SFX Control
play_sfx(key: String, volume_offset: float = 0.0)
stop_all_sfx()

# Volume Control
set_music_volume(volume_db: float)
set_sfx_volume(volume_db: float)
set_master_volume(volume_db: float)
get_music_volume() -> float
get_sfx_volume() -> float

# Mute Control
toggle_music_mute() -> bool
toggle_sfx_mute() -> bool
toggle_master_mute() -> bool
set_music_mute(muted: bool)
set_sfx_mute(muted: bool)

# Conversions
linear_to_db(linear: float) -> float
db_to_linear(db: float) -> float

# Management
add_bgm_path(key: String, path: String)
add_sfx_path(key: String, path: String)
is_bgm_playing() -> bool
print_audio_status()
```

---

**Last Updated**: February 15, 2026  
**Status**: AudioManager implemented, awaiting audio files  
**Next**: Create audio directory and placeholder files

