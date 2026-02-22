# 🚀 QUICK START: Phase 2 Testing Guide

**วันที่:** 22 กุมภาพันธ์ 2026  
**เวลาประมาณ:** 45-60 นาที  
**สถานะ:** ✅ พร้อมทำการทดสอบ

---

## 📋 ขั้นตอนด่วน (Quick Steps)

### STEP 0: ตรวจสอบความพร้อม (1 min)

```bash
# เปิด PowerShell และเข้าไปยังโฟลเดอร์โปรเจค
cd d:\Project\final\RPG

# รันสคริปต์ตรวจสอบ .env
python verify_env_setup.py
```

**สิ่งที่ต้องเห็น:**
```
✅ SYSTEM READY FOR TESTING
   Run: ConfigTester.tscn in Godot Editor (F5)
```

หากไม่พร้อม ให้สร้างไฟล์ .env ตามที่ระบุ

---

### STEP 1️⃣: Configuration Test (5 นาที)

**ในโปรแกรม Godot Editor:**

1. **เปิด Godot 4.4**
2. File → Open Project → `d:\Project\final\RPG`
3. ค้นหา `Scenes` → คลิก `ConfigTester.tscn`
4. **กด F5** (หรือคลิก Play)

**ที่คอนโซลล่างสุดต้องเห็น:**
```
✅ ALL TESTS PASSED - Game is ready to play!
```

**ถ้าไม่เห็น ✅:**
- ตรวจสอบข้อความ error ในคอนโซล
- ดู PHASE2_TESTING_MANUAL.md ส่วน Troubleshooting

✅ **หลังจากผ่าน Test 1** → ไปขั้นตอนที่ 2

---

### STEP 2️⃣: Game Flow Test (30 นาที)

**ยังอยู่ใน Godot Editor:**

1. **ปิด ConfigTester** (กด Stop หรือ Esc)
2. ค้นหา `Scenes` → คลิก `MainMenu.tscn`
3. **กด F5**
4. **เล่นเกมตามลำดับนี้:**

#### 2A: เมนูหลัก
- [ ] เห็นปุ่ม [New Game], [Continue], [Options], [Credits], [Quit]
- [ ] ไม่มี error ในคอนโซล

#### 2B: การเลือกตัวละคร
- [ ] คลิก [New Game]
- [ ] ใส่ชื่อ (ภาษาไทยได้ ✅) เช่น "หมาป่า"
- [ ] เลือกเพศ (ชาย/หญิง)
- [ ] เลือกอาชีพ (Knight/Mage/Ranger/Paladin)
- [ ] คลิก [Start]

#### 2C: ฉาก Story
- [ ] เห็นเรื่องราว (Thai Text)
- [ ] มีภาพประกอบ
- [ ] คลิก [Next] ไปเรื่อยๆ

#### 2D: เลือก Path
- [ ] เห็น 3 ตัวเลือก (Exercise/Nutrition/Hygiene)
- [ ] เลือกหนึ่งตัวเลือก

#### 2E: ฉาก Battle
```
┌──────────────────────────────────┐
│  Hero     vs     Monster         │
│  ████████░░     ████████░░       │
│  [Attack] [Skill] [Item] [Flee]  │
└──────────────────────────────────┘
```

**ระหว่าง Battle:**
- [ ] คลิก [Attack]
- [ ] คำถาม 4 ตัวเลือกปรากฏ
- [ ] เลือกคำตอบ
- [ ] ดูการต่อสู้ย่างต่อ
- [ ] ชนะหรือแพ้

✅ **หลังจากจบ Test 2** → ไปขั้นตอนที่ 3

---

### STEP 3️⃣: Save/Load Test (10 นาที)

**ระหว่างการต่อสู้:**

```
1. กด ESC → Pause Menu
2. คลิก [Save Game]
3. ตรวจสอบ save file สร้างขึ้น
4. ออกจากเกม
```

**โหลดเกม:**
```
1. F5 → MainMenu
2. [Continue] ปุ่ม (ควรถูกเปิดใช้งาน)
3. คลิก [Continue]
4. เกมควรโหลดจากจุดที่บันทึก
5. ตรวจสอบทุกค่า:
   - [ ] ชื่อผู้เล่น
   - [ ] ระดับ
   - [ ] เวลา
   - [ ] HP/MP
```

✅ **หลังจากจบ Test 3** → ไปขั้นตอนที่ 4

---

### STEP 4️⃣: Performance Check (5 นาที)

**ระหว่างเล่น สังเกตการณ์:**

| สิ่งที่ตรวจสอบ | ที่คาดหวัง | ผลจริง | ✅/❌ |
|---|---|---|---|
| FPS stable | 60 FPS | ___ | --- |
| Avg loading | <2 sec | ___ | --- |
| Memory usage | <500 MB | ___ | --- |
| Crashes | 0 | ___ | --- |
| Errors (red) | 0 | ___ | --- |

---

## 📝 บันทึกผล (Test Report)

สร้างไฟล์นี้ด้วยชื่อ `TEST_RESULT_022226.md`:

```markdown
# Test Results - February 22, 2026

## Test 1: Configuration
- Status: ✅ PASS / ❌ FAIL
- Notes: _____________________

## Test 2: Game Flow
- Status: ✅ PASS / ❌ FAIL
- Completed: Loop to: ___
- Issues: _____________________

## Test 3: Save/Load
- Status: ✅ PASS / ❌ FAIL
- Save working: ✅ Yes / ❌ No
- Load working: ✅ Yes / ❌ No
- Issues: _____________________

## Test 4: Performance
- Status: ✅ Good / ⚠️ OK / ❌ Bad
- Avg FPS: ___
- Issues: _____________________

## Overall Result
Phase 2: ✅ READY FOR PHASE 3 / ❌ NEEDS FIXES

**Found Issues:**
1. _____________________
2. _____________________
3. _____________________
```

---

## ⚠️ Common Issues & Fixes

| ปัญหา | วิธีแก้ |
|------|--------|
| .env file not found | สร้าง .env ใน `%APPDATA%\Godot\app_userdata\Educational Fantasy RPG\` |
| API key error | ตรวจสอบว่า .env มี `api_key = ...` |
| Thai text shows boxes | ตรวจสอบไฟล์ฟอนต์ `NotoSansThai_*.woff2` ใน Assets/ |
| Battle crashes | รัน ConfigTester ให้สำเร็จก่อน |
| Save not working | ตรวจสอบ Pause Menu มีปุ่ม [Save] |

---

## 🎯 สิ่งที่ต้องสังเกต

✅ **ตรวจสอบให้แน่ใจ:**
- [ ] Thai text แสดงผลถูกต้อง
- [ ] Images ทั้งหมดโหลดได้
- [ ] ไม่มี error (สีแดง) ในคอนโซล
- [ ] ปุ่มทแั้งหมดคลิกได้
- [ ] Battle logic ทำงานสำเร็จ
- [ ] Save/Load ทำงานสำเร็จ

---

## 📞 Detailed Guide

สำหรับ step-by-step ที่เต็มไปด้วยรายละเอียด:  
👉 ดู `PHASE2_TESTING_MANUAL.md`

---

**สำเร็จแล้ว!** 🎮✨

