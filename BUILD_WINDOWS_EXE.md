# Build Windows EXE - Step by Step Guide

## ✅ Pre-Build Checklist

Before exporting, verify all systems are ready:

### 1. Configuration Check
```bash
# Run validation script to ensure all systems ready
python3 validate_setup.py
```

Expected output: ✅ All checks pass

### 2. Project Settings Verification
- [x] run/main_scene="res://Scenes/MainMenu.tscn" ✓
- [x] config/icon="res://Assets/hero_knight.png" ✓
- [x] All autoloads configured ✓
- [x] Export preset configured with Windows Desktop ✓

---

## 🔧 Build Steps (Manual via Godot Editor)

### Step 1: Open Godot Editor
```
1. Launch Godot 4.4
2. Open the project: d:\Project\final\RPG
3. Wait for project to load (see console "Godot Project loaded")
```

### Step 2: Configure Export Settings
```
In Godot Editor Menu:
1. Click "Project" → "Export" 
2. Select "Windows Desktop" preset (should be already there)
3. Click "Select Folder" for Export Path
4. Navigate to: d:\Project\final\RPG\build\Windows\
5. Name file: "Educational_Fantasy_RPG.exe"
6. Click "Save" or "Export"
```

### Step 3: Export the Game
```
In Export Dialog:
1. Export Path: build/Windows/Educational_Fantasy_RPG.exe
2. Preset: Windows Desktop
3. Resource Filter: "All Resources" (export_filter="all_resources")
4. Click "Export Desktop" button
5. Wait for build to complete (2-5 minutes)
```

### Step 4: Verify Export Completed
```
Expected output in console:
- "Exporting for Windows Desktop"
- "Exporting finished"
- Build folder shows: Educational_Fantasy_RPG.exe
```

---

## ✅ Post-Build Testing

After EXE is created, run the test suite:

### Step 1: Assets Loading Test
```bash
python3 test_export.py --test assets
```

Tests:
- ✓ All PNG images load from Assets/
- ✓ Sprites render correctly
- ✓ UI textures apply properly
- ✓ Character portraits show correctly

### Step 2: Save/Load System Test
```bash
python3 test_export.py --test save_load
```

Tests:
- ✓ Create character and save game
- ✓ Game data persists to disk
- ✓ Load game from previous save
- ✓ All stats/inventory preserved
- ✓ Save files location: C:\Users\User\AppData\Roaming\Godot\app_userdata\Educational Fantasy RPG\

### Step 3: Full Game Flow Test (Manual)
```
1. Run: build/Windows/Educational_Fantasy_RPG.exe
2. Start New Game → Select Character
3. Play through first battle
4. Check all UI renders correctly
5. Pause game (test pause menu)
6. Resume game
7. Save game (test save function)
8. Exit game
9. Launch EXE again and Load Game
10. Verify loaded data matches previous save
```

### Step 4: Error Logging Check
```bash
# After running EXE, check for error logs
Get-Content "$env:APPDATA\Godot\app_userdata\Educational Fantasy RPG\error.log" -Tail 20
```

---

## 📋 Build Verification Checklist

After successful export, verify:

| Check | Status | Notes |
|-------|--------|-------|
| EXE file exists | [ ] | Located at build/Windows/Educational_Fantasy_RPG.exe |
| EXE runs without crashing | [ ] | Opens MainMenu immediately |
| Character selection works | [ ] | Can select character/gender/class |
| Battle system functions | [ ] | Can enter battle, see enemies, take actions |
| Save game works | [ ] | Save file created in AppData/Roaming |
| Load game works | [ ] | Can reload previously saved game |
| Assets load correctly | [ ] | Sprites, UI, backgrounds all visible |
| No error logs | [ ] | Check error.log contains no critical errors |
| Audio (if implemented) | [ ] | Background music/effects play |
| Configuration loaded | [ ] | API key loaded from environment/config |

---

## 🐛 Troubleshooting

### Problem: "Missing DLL files" error
```
Solution:
1. Ensure Windows Runtime is installed
2. Check project.godot for missing resources
3. Re-export with "All Resources" filter included
```

### Problem: "Assets not loading" in EXE
```
Solution:
1. Check export to include Assets/ folder
2. Verify paths are relative (res://Assets/...)
3. Re-export with full resources
4. Check build folder has Assets/ subdirectory
```

### Problem: "Save files not found"
```
Solution:
1. Check AppData directory:
   C:\Users\{UserName}\AppData\Roaming\Godot\app_userdata\Educational Fantasy RPG\
2. Ensure user has write permissions
3. Check project name matches in game code
4. Verify Global.gd save/load paths
```

### Problem: "Configuration/API key error"
```
Solution:
1. Ensure .env file exists in:
   C:\Users\{UserName}\AppData\Roaming\Godot\app_userdata\Educational Fantasy RPG\.env
2. Validate API key is valid
3. Check ConfigManager.gd loads correctly
4. Run setup_env.bat to configure environment
```

---

## 📊 Export Size Expectations

After export completes, expected file sizes:

| File | Size | Notes |
|------|------|-------|
| Educational_Fantasy_RPG.exe | 40-60 MB | Main executable |
| Assets/ (in build) | 50-80 MB | Game images and resources |
| game.pck | 100-150 MB | All game data packed |
| **Total** | **190-290 MB** | Varies by asset optimization |

If significantly larger, delete any debug files or large test assets.

---

## 🚀 Distribution

Once verified, the EXE is ready for:
- ✅ Local testing
- ✅ Sharing with testers
- ✅ Uploading to itch.io / Game platforms
- ✅ Creating installer wrapper (NSIS, Inno Setup)

---

## 📝 Build Commands Reference

### Quick Export (after manual path setup)
```
Project → Export → "Windows Desktop" → "Export Desktop"
```

### Headless Export (requires Godot CLI)
```bash
# If Godot is in PATH:
godot --export-release "Windows Desktop" build/Windows/Educational_Fantasy_RPG.exe

# Or with full path:
"C:\Program Files\Godot\godot.exe" --export-release "Windows Desktop" build/Windows/Educational_Fantasy_RPG.exe
```

### Check Export Preset Status
```bash
# View current preset configuration
Get-Content export_presets.cfg | Select-String -Pattern "export_path|platform" | Head -20
```

---

**Last Updated**: February 15, 2026  
**Status**: Ready for Manual Export via Godot Editor UI  
**Next Step**: Follow "Build Steps" section above in Godot Editor

