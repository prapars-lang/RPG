# 🎯 Core Working Guidelines - Educational Fantasy RPG

## หัวใจในการทำงาน (Project Development Principles)

Document นี้เป็น **หลักเกณฑ์การทำงานแน่นอน** ที่ต้องปฏิบัติตามเพื่อรักษาคุณภาพและความสนใจในการพัฒนาโปรเจค

---

## 📋 หลักการหลัก (Core Principles)

### ✅ หลักการที่ 1: การแก้ไขโค้ด - ห้ามลดทอนหรือย่อโค้ด

**กฎแน่นอน:**
- 🚫 **ห้าม** ลดทอน ย่อ หรือ refactor โค้ดโดยไม่จำเป็น
- ✅ **ต้อง** เขียนโค้ดให้ครบถ้วน และชัดเจน **100% ฉบับเต็ม**
- ✅ **ต้อง** เก็บบริบท (context) ทั้งหมด เพื่อหลีกเลี่ยงข้อผิดพลาด
- ✅ **ต้อง** ตรวจสอบการเขียนโค้ดใหม่เทียบกับโค้ดเดิม จึงค่อยปรับเปลี่ยน

**ตัวอย่างที่ถูก:**
```gdscript
# WRONG - ย่อโค้ด
func _ready():
	_apply_theme()

# CORRECT - เขียนเต็ม
func _ready():
	# Track current scene
	Global.current_scene = "res://Scenes/MainMenu.tscn"
	
	# Apply premium UI theme styling
	_apply_theme()
	
	# Load current story chunk
	load_chunk()
	
	# Connect Dialogue Signals
	if dialogue_system:
		if not dialogue_system.dialogue_finished.is_connected(_on_dialogue_finished):
			dialogue_system.dialogue_finished.connect(_on_dialogue_finished)
```

---

### ✅ หลักการที่ 2: การจัดการไฟล์ - Flower Mind Mapping Structure

**กฎแน่นอน:**
- 🚫 **ห้าม** ให้ไฟล์เดียวใหญ่เกินไป (300+ บรรทัด)
- ✅ **ต้อง** แยกลอจิกเป็นไฟล์ย่อย (Modular Architecture)
- ✅ **ต้อง** เชื่อมโยงไฟล์ผ่าน `preload()` หรือ class reference
- ✅ **ต้อง** สร้างโฟลเดอร์ย่อยตามความเชี่ยวชาญ

**Flower Mind Map Pattern:**
```
Scripts/
├── Core/
│   ├── Global.gd              (Main game state)
│   ├── ConfigManager.gd       (Configuration)
│   └── LLMService.gd          (AI Integration)
│
├── UI/
│   ├── UIThemeManager.gd      (Theme & Style)
│   ├── MainMenu.gd            (Menu logic)
│   └── DialogueSystem.gd      (Dialogue)
│
├── Battle/
│   ├── Battle.gd              (Battle controller)
│   ├── BattleEffectManager.gd (Visual effects)
│   └── BattleCalculations.gd  (Damage/XP logic)
│
├── Systems/
│   ├── QuestionSystem.gd      (Question logic)
│   ├── SaveSystem.gd          (Save/Load)
│   └── QuestSystem.gd         (Quest management)
│
├── Quests/
│   └── QuestManager.gd        (Quest data)
│
└── StoryData.gd              (Story chunks)
```

**เมื่อไฟล์เกิน 300 บรรทัด:**
1. ตรวจหา "Concern" ที่แยกได้
2. สร้างไฟล์ย่อยช่วยเหลือ (Helper file)
3. เชื่อมโยงผ่าน `preload()` และ `const`
4. เขียนเอกสาร (Comment) อธิบายความสัมพันธ์

**ตัวอย่างการแยก:**
```gdscript
# Battle.gd (400 บรรทัด) → แยกเป็น 3 ไฟล์

# Battle.gd (Controller - 150 บรรทัด)
extends Node2D
const BattleEffectManager = preload("res://Scripts/Battle/BattleEffectManager.gd")
const BattleCalculations = preload("res://Scripts/Battle/BattleCalculations.gd")

func _ready():
	battle_effects = BattleEffectManager.new()
	battle_calc = BattleCalculations.new()

# BattleEffectManager.gd (Visual Effects - 125 บรรทัด)
static func shake_camera(camera: Camera2D, intensity: float, duration: float):
	# Camera shake logic

# BattleCalculations.gd (Damage/XP - 125 บรรทัด)
static func calculate_damage(attacker_atk: int, defender_def: int) -> int:
	# Damage calculation logic
```

---

## 🎯 ขั้นตอนการทำงาน (Workflow Steps)

### ขั้นตอนที่ 1: วิเคราะห์ (Analysis)
- [ ] อ่านคำขอจากผู้ใช้อย่างชัดเจน
- [ ] ตรวจสอบไฟล์ที่เกี่ยวข้อง
- [ ] วิเคราะห์ผลกระทบต่อไฟล์อื่น
- [ ] หาโครงสร้างที่เหมาะสม

### ขั้นตอนที่ 2: ออกแบบ (Design)
- [ ] วางแผนตรรกะที่ชัดเจน
- [ ] ตรวจสอบว่าต้องแยกไฟล์หรือไม่
- [ ] เขียน pseudocode/comment แสดงส่วนหลัก
- [ ] วาด mind map ของไฟล์ที่จะแก้

### ขั้นตอนที่ 3: พัฒนา (Development)
- [ ] เขียนโค้ดแบบ full-form (ไม่ย่อ)
- [ ] รวมบริบท 3-5 บรรทัดก่อน-หลัง
- [ ] เพิ่ม comment อธิบายแต่ละส่วน
- [ ] ตรวจสอบไวยากรณ์ (syntax)

### ขั้นตอนที่ 4: ทดสอบ (Testing)
- [ ] รันคอมไพล์เพื่อตรวจสอบข้อผิดพลาด
- [ ] ตรวจสอบตรรกะหลัก
- [ ] ทดลองในเกม (ถ้าจำเป็น)
- [ ] บันทึกผลในเอกสาร

---

## 📝 Convention & Standards

### โครงสร้างโค้ด
```gdscript
# 1. Imports & Constants ที่ด้านบนสุด
extends Node
const BattleEffectManager = preload("res://Scripts/Battle/BattleEffectManager.gd")

# 2. Properties
var player_hp = 100
var player_max_hp = 100

# 3. Lifecycle (_ready, _process, etc.)
func _ready():
	_initialize_systems()
	_apply_theme()
	_load_data()

# 4. Public methods (ไม่มี underscore)
func start_battle():
	pass

# 5. Private methods (_underscore)
func _initialize_systems():
	pass

# 6. Signal handlers (_on_event_name)
func _on_button_pressed():
	pass
```

### Naming Convention
- **Files:** `PascalCase.gd` (MainMenu.gd, BattleEffectManager.gd)
- **Functions:** `snake_case()` (get_unique_question(), apply_button_theme())
- **Constants:** `CONSTANT_CASE` (COLOR_PRIMARY, FONT_SIZE_LARGE)
- **Private:** `_snake_case()` (_apply_theme(), _initialize())

### Comment Pattern
```gdscript
# === SECTION NAME ===

func important_function():
	"""Explain purpose of this function"""
	# Explain non-obvious logic here
	var result = calculate()
	
	# Why we do this specific operation
	return process(result)
```

---

## 🚀 การส่งมอบ Features

**ทุกครั้งก่อนส่งมอบ:**
1. ✅ ตรวจสอบ compilation errors: 0
2. ✅ เขียนโค้ดเต็มฉบับ (ไม่ย่อ)
3. ✅ Add comments ให้เพียงพอ
4. ✅ Test บนเกม (ถ้าจำเป็น)
5. ✅ Update เอกสารที่เกี่ยวข้อง

---

## 📚 Related Documents

- [Flower Mind Map - Architecture](./PROJECT_STRUCTURE.md)
- [API Documentation](./API_DOCUMENTATION.md)
- [Quality Checklist](./QUALITY_CHECKLIST.md)
- [Setup Guide](./SETUP_GUIDE.md)

---

## ✍️ เวอร์ชันประวัติ

| วันที่ | ผ่านการแก้ไข | หมายเหตุ |
|--------|-----------|--------|
| 2026-02-15 | v1.0 | สร้างเอกสารหลักครั้งแรก |

---

**ทำความเข้าใจและปฏิบัติตามเอกสารนี้อย่างเคร่งครัด เพื่อรักษาคุณภาพโปรเจค φ(๑•́ ▽ •̀๑)**
