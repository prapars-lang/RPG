# 🧪 การทดสอบโปรเจค - Testing Guide

## ✅ เตรียมการเสร็จแล้ว

- ✅ API Key: ตั้งค่าในไฟล์ `.env`
- ✅ ConfigManager: สร้างและตั้งค่า autoload
- ✅ LLMService: อัดเดต to load from config
- ✅ Documentation: ครบถ้วน

---

## 🧪 Phase 1: Configuration Testing (5 นาที)

### ขั้นตอน:
1. เปิด Godot Editor
2. ไปที่ `Scenes/ConfigTester.tscn`
3. กด **F5** หรือ click "Play"
4. ดู Output console ที่ด้านล่าง

### คาดหวังผลลัพธ์:
```
============================================================
CONFIG MANAGER TEST
============================================================

[TEST 1] API Key Loading:
  ✅ PASSED: API key loaded
    Key (first 20 chars): sk-G0tmEjZjb6Tpl9bjK...

[TEST 2] API URL Loading:
  ✅ PASSED: API URL loaded
    URL: https://api.opencode.ai/v1/chat/completions

[TEST 3] Model Loading:
  ✅ PASSED: Model loaded
    Model: typhoon-v1.5x-70b-instruct

[TEST 4] LLMService Configuration:
  LLMService.api_key: ✅ Set
  LLMService.api_url: ✅ Set
  LLMService.model_name: ✅ Set

[TEST 5] Global State:
  Player name: ผู้กล้า
  Player class: อัศวิน
  Player level: 1
  ✅ PASSED: Global state accessible

============================================================
✅ ALL TESTS PASSED - Game is ready to play!
   Press F5 to start the game
============================================================
```

### ถ้า Test PASS:
✅ Configuration system ทำงานถูกต้อง
→ ไปขั้นตอนถัดไป

### ถ้า Test FAIL:
❌ ตรวจสอบ:
- [ ] ไฟล์ `.env` ถูกสร้างใน `C:\Users\[YourUsername]\AppData\Roaming\Godot\app_userdata\Educational Fantasy RPG\.env`
- [ ] ไฟล์มี content ถูกต้อง (ดูที่ `output.txt` ที่ created)
- [ ] Close Godot editor และเปิดใหม่ (รีโหลด autoload)

---

## 🎮 Phase 2: Game Flow Testing (30 นาที)

### ขั้นตอน:
1. กลับไปที่ `Scenes/MainMenu.tscn`
2. กด **F5** เพื่อเล่นเกม
3. ทดสอบตามรายการด้านล่าง

### Test Cases:

#### ✅ Test 1: Main Menu
```
Expected: 
- Menu ปรากฏด้วยปกติ
- Buttons: New Game, Continue, Options, Credits, Quit
- Continue button disabled (ไม่มี save file)
```

#### ✅ Test 2: Character Selection
```
Steps:
  1. Click "New Game"
  2. Enter player name (ค่าไทย)
  3. Select gender
  4. Select class
  5. Click "Start Game"

Expected:
- Scene เปลี่ยนไปเรื่อยๆ
- ไม่มี error ใน console
```

#### ✅ Test 3: Story Mode
```
Steps:
  1. ให้เกมแสดง story
  2. ทดสอบ Next/Previous buttons
  3. เลือก path หนึ่ง

Expected:
- Story text แสดงถูกต้อง
- Buttons ทำงาน
```

#### ✅ Test 4: Battle System
```
Steps:
  1. เข้าสู่การต่อสู้
  2. ตอบคำถาม (หรือเลือก action อื่น)
  3. ดูคะแนนความเสียหาย

Expected:
- คำถามแสดงถูกต้อง
- UI อัดเดต HP/MP อย่างถูกต้อง
- เม็นูการต่อสู้ทำงานปกติ
```

#### ✅ Test 5: AI Dialogue
```
Steps:
  1. ตรวจสอบการจะเห็น AI dialogue ในเกม
  2. ดู output console เพื่อดูว่า API requests ถูกส่ง

Expected:
- ไม่มี "Missing API Key" errors
- API calls ปรากฏใน console
- ข้อความจาก AI แสดงในเกม
```

#### ✅ Test 6: Save Game
```
Steps:
  1. ระหว่างเกม กด Pause
  2. Click "Save"
  3. เลือก slot save
  4. ยืนยัน

Expected:
- Save สำเร็จ (ข้อความยืนยัน)
- ไม่มี error
```

#### ✅ Test 7: Load Game
```
Steps:
  1. Return to Main Menu
  2. Click "Continue"
  3. เลือก save slot ที่บันทึก

Expected:
- Game โหลด progress เดิม
- Player stats เหมือนเดิม
```

---

## 📊 Checklist ขณะทดสอบ

ตรวจสอบประเด็นนี้ในขณะทดสอบ:

### Performance
- [ ] Game runs at 60 FPS (ส่วนใหญ่)
- [ ] No lag spikes เมื่อโหลด scene
- [ ] AI responses มา ภายใน 5 วินาที

### Functionality
- [ ] ทุก buttons ทำงาน
- [ ] Questions โหลดถูกต้อง
- [ ] Battle mechanics ถูก
- [ ] Save/Load ทำงาน

### UI/UX
- [ ] Text อ่านง่าย
- [ ] Layout สวยงาม
- [ ] ไม่มี text cutoff
- [ ] Colors สะดวกสายตา

### Data
- [ ] Player stats ถูก
- [ ] Equipment อัดเดต
- [ ] Inventory งาน
- [ ] Quest progress บันทึก

### Errors
- [ ] ไม่มี push_error messages
- [ ] Console clean (warning ที่ยอมรับได้)
- [ ] ไม่มี null reference errors

---

## 🐛 Bug Reporting Format

ถ้าพบ bug ให้บันทึก:

```
Bug Title: [ชื่อปัญหา]
Severity: Critical / High / Medium / Low
Steps to Reproduce:
  1. ...
  2. ...
  3. ...
Expected Result: ...
Actual Result: ...
Console Errors: [paste console output]
Screenshot: [if applicable]
```

---

## 📝 Test Results Log

ให้ update ตรงนี้เมื่อทำการทดสอบ:

```
Date: [วันที่]
Tester: [ชื่อ]
Environment: Windows / macOS / Linux

Phase 1: Configuration Testing
- Status: ✅ PASS / ❌ FAIL
- Notes: [หน้าตาบันทึก]

Phase 2: Game Flow Testing
- Main Menu: ✅ / ❌
- Character Selection: ✅ / ❌
- Story Mode: ✅ / ❌
- Battle System: ✅ / ❌
- AI Dialogue: ✅ / ❌
- Save Game: ✅ / ❌
- Load Game: ✅ / ❌

Issues Found:
- None / [list issues]

Performance:
- FPS Average: ___
- Slowest Area: ___

Overall Status: ✅ Ready / ⚠️ Minor Issues / ❌ Major Issues
```

---

## 🚀 ขั้นตอนต่อไป

### ถ้า Testing ผ่าน ✅
1. Build Windows executable
2. Test export version
3. Get user feedback

### ถ้า Testing มี Issues ⚠️
1. Log all issues
2. Fix high-priority bugs
3. Re-test affected areas
4. Document solutions

---

## 📞 Help

- ดู Output console ถ้ามี error
- Check SETUP_GUIDE.md สำหรับการตั้งค่า
- Review API_DOCUMENTATION.md สำหรับ API details
- Check CONTRIBUTING.md สำหรับ code style

---

**Testing Start Date**: February 15, 2026
**Godot Version**: 4.4
**Platform**: Windows
