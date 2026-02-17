# 🎮 QUICK START: Game Testing

## ⏱️ Estimated Time: 45-60 minutes

---

## 📌 Before You Start

✅ Setup is VALIDATED and READY

What's done:
- API key configured (.env file created)
- ConfigManager system set up
- All scripts and scenes present
- Documentation complete

---

## 🔴 STEP 1: Configuration Test (5 min)

### In Godot Editor:

1. **Open Godot 4.4**
2. **Open Project** `d:\Project\final\RPG\`
3. **Navigate to:** Scenes → `ConfigTester.tscn`
4. **Press F5** to run the test

### What to Look For:

```
Output Console (bottom of screen) should show:

✅ ALL TESTS PASSED

[TEST 1] API Key Loading: ✅ PASSED
[TEST 2] API URL Loading: ✅ PASSED  
[TEST 3] Model Loading: ✅ PASSED
[TEST 4] LLMService Configuration: ✅ Set
[TEST 5] Global State: ✅ PASSED
```

### If You See This:
✅ **PASS** → Continue to Step 2
❌ **FAIL** → Check console for errors, see Troubleshooting below

---

## 🟡 STEP 2: Game Flow Test (30 min)

### In Godot Editor:

1. **Navigate to:** Scenes → `MainMenu.tscn`
2. **Press F5** to play the game

### Test Sequence:

```
1. Main Menu appears
   ├─ Click "New Game"
   
2. Character Selection
   ├─ Enter name (Thai OK)
   ├─ Select gender
   ├─ Select class
   └─ Click "Start"
   
3. Story/Intro Scene
   ├─ Watch story
   ├─ Click "Next"
   └─ Select a path

4. Crossroads/Story Scene
   ├─ Progress through story
   └─ Continue until battle

5. Battle Scene
   ├─ Fight enemy
   ├─ Answer quiz questions
   └─ Win or lose battle

6. Inventory Menu (if accessible)
   ├─ View items
   ├─ View equipment
   └─ Try equipping something

7. Save Game
   ├─ Press Escape (Pause)
   ├─ Click "Save"
   └─ Choose slot & confirm

8. Load Game
   ├─ Return to Main Menu
   ├─ Click "Continue"  
   ├─ Load your save
   └─ Verify game state
```

### ✅ Things to Check During Play:

- [ ] No error messages in console
- [ ] All buttons respond to clicks
- [ ] Scene transitions are smooth
- [ ] Text displays correctly (Thai OK)
- [ ] Game runs at reasonable speed (60 FPS ideal)
- [ ] UI is readable and not cutoff
- [ ] Save/Load works (data persists)

---

## 🟢 STEP 3: Quick Performance Check (5 min)

### Monitor While Playing:

1. **Open Godot Debugger:** Ctrl + Alt + I
2. **Go to "Profiler" tab**
3. **Watch metrics while playing:**
   - FPS (should be ~60)
   - Frame time (should be <16ms for 60 FPS)
   - Memory (note the peak value)

### Acceptable Ranges:
- 🟢 FPS: 50-60 (good)
- 🟡 FPS: 30-50 (playable)
- 🔴 FPS: <30 (needs optimization)

---

## 📋 Document Your Results

Create a simple text file with your findings:

```
TEST RESULTS - February 15, 2026
================================

Configuration Test: ✅ PASS / ❌ FAIL

Game Flow Tests:
  Main Menu: ✅ / ❌
  Character Selection: ✅ / ❌
  Story Mode: ✅ / ❌
  Battle System: ✅ / ❌
  Inventory: ✅ / ❌
  Save/Load: ✅ / ❌

Performance:
  Average FPS: ___
  Peak Memory: ___ MB

Issues Found:
  [None / List any problems]

Overall Status: ✅ READY / ⚠️ MINOR ISSUES / ❌ MAJOR ISSUES
```

Save this to: `TEST_RESULTS_[DATE].txt`

---

## 🐛 Troubleshooting

### "Missing API Key" Error

**Solution:**
1. Close Godot completely
2. Verify `.env` file exists:
   - Path: `C:\Users\[YourName]\AppData\Roaming\Godot\app_userdata\Educational Fantasy RPG\.env`
3. Open Godot again (will reload settings)
4. Try ConfigTester again

### Scene Won't Load / Crashes

**Solutions:**
1. Check if all image files exist in `Assets/`
2. Check console for specific error messages
3. Try opening a simpler scene first (MainMenu.tscn)
4. Look at SETUP_GUIDE.md for more help

### Slow Performance

**Solutions:**
1. Close other programs running in background
2. Check that assets are imported (no red imports)
3. Restart Godot editor
4. Check system resources (Task Manager)

### More Help

📖 **Detailed Guides:**
- TESTING_GUIDE.md - Comprehensive testing procedures
- SETUP_GUIDE.md - Configuration & setup issues
- API_DOCUMENTATION.md - Technical details
- QUALITY_CHECKLIST.md - Project status

---

## 📊 What's Being Tested

| Component | Purpose | Success Indicator |
|-----------|---------|-------------------|
| ConfigManager | Load API credentials | No "Missing Key" errors |
| LLMService | Connect to AI API | Dialogue appears in game |
| Battle System | Core gameplay | Questions & damage work |
| Save/Load | Data persistence | Game state preserved |
| UI/UX | User experience | All buttons work, readable |

---

## 🎯 Success Criteria

**You're DONE when:**
- ✅ ConfigTester shows "ALL TESTS PASSED"
- ✅ Can play through at least one full battle
- ✅ Save & Load works
- ✅ No crash or hang
- ✅ Game runs at acceptable speed

---

## ⏰ Time Breakdown

| Phase | Duration | Status |
|-------|----------|--------|
| Setup Validation | ✅ Done | 5 min |
| Config Test | ⏳ Next | 5 min |
| Game Flow Test | ⏳ Next | 30 min |
| Performance Check | ⏳ Next | 5 min |
| **Total** | | **45 min** |

---

## 🚀 Ready?

**Option A: Quick Test (20 min)**
- Run ConfigTester
- Play 1 battle
- Test save/load

**Option B: Full Test (60 min)**
- Run ConfigTester
- Play through multiple scenarios
- Monitor performance
- Document thoroughly

---

## ✨ Next After Testing

### If Tests Pass ✅
- Phase 3: Build Windows EXE
- Phase 4: Publish & Share

### If Issues Found ⚠️
- Document issues (PHASE2_TEST_EXECUTION.md)
- Fix problems
- Re-test until pass

---

**Let's Go! 🎮 Press F5 in Godot to start testing!**

For detailed procedures, see: [TESTING_GUIDE.md](TESTING_GUIDE.md)
For full test report, see: [PHASE2_TEST_EXECUTION.md](PHASE2_TEST_EXECUTION.md)
