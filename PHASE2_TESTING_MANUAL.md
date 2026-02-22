# 🧪 PHASE 2: Game Testing Manual - ขั้นตอนการทดสอบ

**Date:** February 22, 2026  
**Status:** Ready to Execute  
**Estimated Time:** 45-60 minutes

---

## 📋 Prerequisite Checklist

Before starting testing, ensure:

- [ ] Godot 4.4 is installed
- [ ] Project opened in `d:\Project\final\RPG\`
- [ ] .env file is configured (see Setup Check section below)
- [ ] All console messages are visible in editor

### Setup Check: .env File Location

**ConfigManager** expects the .env file in Godot's user data directory:

**Windows Path:**
```
%APPDATA%\Godot\app_userdata\Educational Fantasy RPG\.env
```

**To find this folder:**
1. Press `Win + R`
2. Type: `%APPDATA%\Godot\app_userdata\Educational Fantasy RPG\`
3. Click OK

**What the .env file should contain:**
```ini
[llm]
api_key = YOUR_OPENCODE_API_KEY_HERE
api_url = https://api.opencode.ai/v1/chat/completions
model_name = gpt-4-turbo
```

> 💡 If .env file doesn't exist, copy from `.env.example` in project root and edit it

---

## 🎯 TEST 1: Configuration Test (5 minutes)

### Goal
Verify that API keys and configuration are loaded correctly before game starts.

### Steps

1. **Open Godot Editor**
   - File → Open Project
   - Select `d:\Project\final\RPG\`

2. **Navigate to ConfigTester Scene**
   - In Godot, open file system panel
   - Go to: `Scenes` folder
   - Double-click: `ConfigTester.tscn`

3. **Run the Test**
   - Press **F5** (or click Play button)
   - Watch Output console at bottom

4. **Expected Output**
   ```
   ============================================================
   CONFIG MANAGER TEST
   ============================================================

   [TEST 1] API Key Loading:
     ✅ PASSED: API key loaded
     Key (first 20 chars): YOUR_KEY_HERE...

   [TEST 2] API URL Loading:
     ✅ PASSED: API URL loaded
     URL: https://api.opencode.ai/v1/chat/completions

   [TEST 3] Model Loading:
     ✅ PASSED: Model loaded
     Model: gpt-4-turbo

   [TEST 4] LLMService Configuration:
     LLMService.api_key: ✅ Set
     LLMService.api_url: ✅ Set
     LLMService.model_name: ✅ Set

   [TEST 5] Global State:
     Player name: User
     Player class: Knight
     Player level: 1
     ✅ PASSED: Global state accessible

   ============================================================
   ✅ ALL TESTS PASSED - Game is ready to play!
      Press F5 to start the game
   ============================================================
   ```

### ✅ Test 1 Acceptance Criteria

- [ ] All 5 tests show **PASSED**
- [ ] Output contains **"ALL TESTS PASSED"**
- [ ] No error messages in console
- [ ] API key is visible (first 20 chars)
- [ ] URL is correct

### ❌ Troubleshooting Test 1

| Error | Solution |
|-------|----------|
| `.env file doesn't exist` | Create file in `%APPDATA%\Godot\app_userdata\Educational Fantasy RPG\.env` |
| `API Key is empty` | Check .env file contains correct api_key value |
| `API URL is empty` | Check .env file contains correct api_url value |
| `Model is empty` | Check .env file contains correct model_name value |

---

## 🎮 TEST 2: Game Flow Test (30 minutes)

### Goal
Verify complete game path from Main Menu → Character Select → Battle System

### TEST 2A: Main Menu Loading (5 min)

**Steps:**

1. **Stop previous test** (press Stop or Esc)
2. **Open MainMenu.tscn**
   - `Scenes` → `MainMenu.tscn`
3. **Press F5** to run
4. **Check Main Menu appears**

**Expected UI Elements:**
```
======= FANTASY RPG MENU =====
   [New Game] Button
   [Continue] Button (disabled if no save)
   [Options] Button
   [Credits] Button
   [Quit] Button
=======   Particles below =====
```

**✅ Acceptance:**
- [ ] Menu scene loads without errors
- [ ] All buttons visible and clickable
- [ ] Background image displays
- [ ] No console errors

---

### TEST 2B: Character Selection (5 min)

**Steps:**

1. **Click [New Game]**
2. **Character Creation Scene appears**
3. **Enter Player Name**
   - Thai text OK ✅
   - Example: "หมาป่า" (Wolf)
4. **Select Gender**
   - [ ] Male
   - [ ] Female
5. **Select Class**
   - [ ] Knight
   - [ ] Mage
   - [ ] Ranger
   - [ ] Paladin
6. **Click [Start Game]**

**✅ Acceptance:**
- [ ] Character selection works without errors
- [ ] Thai text input works
- [ ] Class selection updates stats display
- [ ] Game transitions to next scene

---

### TEST 2C: Story/Intro Scene (5 min)

**Steps:**

1. **Story scene loads**
2. **Read introduction text**
3. **Click [Next] button multiple times**
4. **Background story displays correctly**

**✅ Acceptance:**
- [ ] Story text renders (Thai font loads OK)
- [ ] Character portrait displays
- [ ] No missing images or text overflow
- [ ] Next button works

---

### TEST 2D: Path Selection (3 min)

**Steps:**

1. **"Choose Your Path" scene appears**
2. **You see 3 options:**
   - [ ] Exercise Path
   - [ ] Nutrition Path
   - [ ] Hygiene Path
3. **Click one path**
4. **Story continues**

**✅ Acceptance:**
- [ ] All 3 paths selectable
- [ ] Path selection registered
- [ ] Scene transitions smoothly

---

### TEST 2E: Battle Encounter (12 min)

**Steps:**

1. **Battle scene loads**
2. **You see:**
   - Hero character (left)
   - Monster enemy (right)
   - HP bars for both
   - Action buttons

3. **First Round - Your Turn:**
   - Click [Attack] button
   - A question appears
   - Answer the question
   - Correct = full damage
   - Wrong = reduced damage

4. **Question Format:**
   - Question text
   - 4 answer choices
   - Click correct answer

5. **Enemy Turn:**
   - Enemy attacks automatically
   - Your HP decreases
   - Battle log shows action

6. **Continue Until:**
   - [ ] Victory (enemy HP 0)
   - [ ] Defeat (your HP 0)

**✅ Acceptance Criteria:**

- [ ] Battle scene loads without errors
- [ ] HP bars display and update
- [ ] Attack button triggers question
- [ ] Questions appear correctly formatted
- [ ] Answer selection works
- [ ] Damage calculation works
- [ ] Battle ends (win or lose)
- [ ] Victory/Defeat message shows
- [ ] No console errors during battle

**Battle Stats to Note:**
- [ ] Record: Your HP vs Enemy HP
- [ ] Record: Questions answered (correct/total)
- [ ] Record: Damage taken
- [ ] Record: Win/Lose outcome

---

## 💾 TEST 3: Save/Load Functionality (10 minutes)

### Goal
Verify game state persistence and load functionality

### TEST 3A: Save During Battle

**Steps:**

1. **During a battle**, press **Esc**
2. **Pause Menu appears**
3. **Click [Save Game]**
4. **Confirmation message shows**
5. **Note the save file location** (will be in user:// directory)

**✅ Acceptance:**
- [ ] Pause menu opens
- [ ] Save button works
- [ ] No error messages
- [ ] Save file created (user://savegame.json)

---

### TEST 3B: Load Game

**Steps:**

1. **Return to Main Menu** (Quit game if needed)
2. **Open MainMenu.tscn**
3. **Press F5**
4. **Click [Continue]** button
5. **Game loads from saved state**
6. **Check all values restored:**
   - [ ] Player name same
   - [ ] Player class same
   - [ ] Battle state same
   - [ ] HP values same
   - [ ] Inventory same

**✅ Acceptance:**
- [ ] Load button works
- [ ] Correct save data loads
- [ ] Game state matches saved state
- [ ] Can continue from where you left off

---

## 📊 TEST 4: Performance & Issues Check (5 minutes)

### Performance Metrics

During gameplay, check:

| Metric | Expected | Actual | Status |
|--------|----------|--------|--------|
| Frame Rate | 60 FPS | ___ | ⏳ |
| Load Time (Battle) | <2 sec | ___ | ⏳ |
| Load Time (Menu) | <1 sec | ___ | ⏳ |
| Memory Usage | <500 MB | ___ | ⏳ |

### Console Check

- [ ] No **red ERROR** messages
- [ ] No **yellow WARNING** messages (OK if minor)
- [ ] No crashes or freezes

### Bug Report Template

If you find issues, fill out:

```
BUG REPORT:
- Name: ________________
- Severity: [Critical] [High] [Medium] [Low]
- How to reproduce: 
  1. _____________________
  2. _____________________
- Expected: ________________
- Actual: __________________
- Console error: __________
```

---

## 📝 FINAL TEST REPORT

### Test 1: Configuration Test
- Status: [ ] ✅ PASSED [ ] ❌ FAILED
- Errors: ________________________
- Date: __________________________

### Test 2: Game Flow Test
- Status: [ ] ✅ PASSED [ ] ❌ FAILED
- Issues: ___________________________
- Date: __________________________

### Test 3: Save/Load Test
- Status: [ ] ✅ PASSED [ ] ❌ FAILED
- Issues: ___________________________
- Date: __________________________

### Test 4: Performance Test
- Status: [ ] ✅ PASS [ ] ⚠️ NEEDS WORK [ ] ❌ FAIL
- Avg FPS: _______
- Issues: ___________________________
- Date: __________________________

### Overall Result
- **Phase 2 Status:** [ ] ✅ READY FOR PHASE 3 [ ] ⏳ NEEDS FIXES

---

## 🚀 Next Steps

### If all tests PASS ✅
- Proceed to **Phase 3: Build & Export**
- Goal: Export game as Windows .exe
- See: `BUILD_WINDOWS_EXE.md`

### If some tests FAIL ❌
- Document the specific failures
- Check console output for error details
- Refer to [TROUBLESHOOTING](#troubleshooting)

---

## 🔧 TROUBLESHOOTING

### Battle Scene Crashes
**Problem:** Game crashes when entering battle
**Solution:**
1. Check ConfigTester passes first (test 1)
2. Verify Battle.gd script has no syntax errors
3. Check console for specific error message

### Questions Don't Appear
**Problem:** Attack button clicked but no question shows
**Solution:**
1. Verify Data/ folder contains question files
2. Check StoryData.gd is properly loaded
3. Look for console errors

### Save File Issues
**Problem:** Can't save or load game
**Solution:**
1. Check user:// directory has write permissions
2. Verify savegame.json is being created
3. Look for file path errors in console

### Thai Text Display Issues
**Problem:** Thai characters show as boxes or weird symbols
**Solution:**
1. Verify NotoSansThai font files exist in Assets/
2. Check MainMenu.tscn has correct font reference
3. Ensure font file is imported correctly in Godot

### Performance Issues
**Problem:** FPS drops, stuttering, slow loading
**Solution:**
1. Check scene loading times
2. Reduce particle effects (if needed)
3. Monitor memory usage
4. Profile with Godot's profiler

---

## 📞 Support References

- **Setup Issues:** See `SETUP_GUIDE.md`
- **Testing Issues:** See `TESTING_GUIDE.md`
- **Technical Details:** See `API_DOCUMENTATION.md`
- **Project Overview:** See `PROJECT_HEART.md`

---

**Good luck with Phase 2 testing! 🎮✨**

