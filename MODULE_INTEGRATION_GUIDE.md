# 🔗 Module Integration Guide

## วิธีการเชื่อมโยงโมดูลต่างๆ (How to Connect Modules)

คู่มือนี้อธิบายวิธีการใช้ `preload()`, `const`, และ method calling ให้ถูกต้อง

---

## 📦 Importing/Preloading Pattern

### Pattern 1: Static/Helper Classes (ไม่ต้อง instantiate)
```gdscript
# Right - ใช้ const เมื่อเป็น static
const UIThemeManager = preload("res://Scripts/UIThemeManager.gd")
const BattleCalculations = preload("res://Scripts/Battle/BattleCalculations.gd")

func _ready():
	# ใช้โดยตรง
	UIThemeManager.apply_button_theme(my_button)
	var damage = BattleCalculations.calculate_damage(10, 5)
```

### Pattern 2: Instance Classes (ต้อง instantiate)
```gdscript
# Right - ใช้ onready เมื่อเป็น instance
@onready var dialogue_system = $DialogueSystem

func _ready():
	# ใช้โดยตรง
	dialogue_system.start_dialogue(lines)
```

### Pattern 3: Global Autoload (ปกติคือ Global.gd)
```gdscript
# Right - ใช้ Global โดยตรง (มี autoload)
func _ready():
	Global.player_level += 1
	var question = Global.get_unique_question("P1")
	Global.save_game()
```

---

## 🎯 Common Integration Scenarios

### Scenario 1: Scene Script needs UIThemeManager

```gdscript
# CharacterSelection.gd
extends Control

const UIThemeManager = preload("res://Scripts/UIThemeManager.gd")

@onready var gender_label = $VBoxContainer/GenderHBox/GenderValue

func _apply_theme():
	"""Apply premium UI theme to all elements"""
	# Style text labels with theme colors
	gender_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	gender_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_TITLE)
	
	# Style buttons
	UIThemeManager.apply_button_theme($VBoxContainer/StartGame)
```

### Scenario 2: Battle.gd uses multiple helper modules

```gdscript
# Battle.gd
extends Node2D

const BattleEffectManager = preload("res://Scripts/Battle/BattleEffectManager.gd")
const BattleCalculations = preload("res://Scripts/Battle/BattleCalculations.gd")

@onready var battle_camera = $BattleCamera
@onready var hero_sprite = $UI/HeroSprite

func _on_player_attacks():
	# Use effect manager
	BattleEffectManager.shake_camera(battle_camera, 8.0, 0.4)
	BattleEffectManager.flash_sprite(hero_sprite)
	
	# Use calculations
	var damage = BattleCalculations.calculate_damage(player_atk, enemy_def)
	BattleEffectManager.show_damage_number($UI, damage, hero_sprite.position)

func answer_question(answer):
	# Use Global system
	if answer == Global.current_question.a:
		execute_player_action(true)
	else:
		execute_player_action(false)
```

### Scenario 3: Global.gd uses LLMService

```gdscript
# Global.gd
extends Node

const ConfigManager = preload("res://Scripts/ConfigManager.gd")
const LLMService = preload("res://Scripts/LLMService.gd")

func _ready():
	# Initialize services
	load_configuration()
	load_questions()

func get_ai_help(prompt: String):
	# Use LLMService
	LLMService.generate_response(prompt, "system_prompt")
```

### Scenario 4: Scene needs Global + UIThemeManager + DialogueSystem

```gdscript
# IntroStory.gd
extends Control

const UIThemeManager = preload("res://Scripts/UIThemeManager.gd")

@onready var dialogue_system = $DialogueSystem
@onready var hero_sprite = $HeroSprite

func _ready():
	# Get hero sprite path from Global
	var icon_key = Global.player_class + "_" + Global.player_gender
	var hero_path = Global.class_icons.get(icon_key, "")
	hero_sprite.texture = load(hero_path)
	
	# Use dialogue system (@onready)
	var story = [
		{"name": "จิตวิญญาณแห่งป่า", "text": "ยินดีต้อนรับ..."},
		{"name": Global.player_class, "text": "ข้าพร้อมแล้ว"}
	]
	dialogue_system.start_dialogue(story)
```

---

## 🔄 Method Calling Patterns

### Static Method (ไม่ต้อง create instance)
```gdscript
# Define in UIThemeManager.gd
static func apply_button_theme(btn: Button) -> void:
	"""Apply theme to button"""
	btn.add_theme_stylebox_override("normal", create_button_style())

# Use anywhere
UIThemeManager.apply_button_theme(my_button)
```

### Instance Method (ต้อง create instance หรือ @onready)
```gdscript
# Define in DialogueSystem.gd (extends Control)
func start_dialogue(lines: Array):
	"""Start dialogue sequence"""
	dialogue_queue = lines
	show_line()

# Use in scene
$DialogueSystem.start_dialogue(my_lines)

# Or with const/variable
var dialogue = load("res://Scenes/DialogueSystem.tscn").instantiate()
dialogue.start_dialogue(my_lines)
```

### Signal Pattern (Event-driven)
```gdscript
# Define in Global.gd
signal level_up_occurred(new_level, old_stats, new_stats)

# Emit from Battle.gd
func check_level_up():
	if earned_xp >= next_level_xp:
		Global.emit_signal("level_up_occurred", new_level, old_stats, new_stats)

# Listen in LevelUpUI.gd
func _ready():
	Global.level_up_occurred.connect(_on_level_up)

func _on_level_up(level, old_stats, new_stats):
	level_text.text = "เลเวล " + str(level)
```

---

## 🎯 Dependency Chain Example

**Complete flow: MainMenu → Battle → Question**

```gdscript
# 1. MainMenu.gd
extends Control

func _on_start_btn_pressed():
	Global.player_name = "Hero"
	Global.player_class = "อัศวิน"
	Global.player_level = 1
	Global.used_questions = []  # Reset
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

# 2. Battle.gd (when player turn)
func show_question():
	var grade = Global.get_current_grade()  # Get from Global
	
	# Get question with unused tracking
	current_question = Global.get_unique_question(grade, Global.current_path)
	
	# Display question
	question_label.text = current_question.q
	
	# Display options (with shuffled order)
	for option in current_question.options:
		var btn = Button.new()
		btn.text = option
		btn.add_theme_font_size_override("font_size", 24)  # UIThemeManager standard
		btn.pressed.connect(answer_question.bind(option))
		options_container.add_child(btn)

# 3. Global.gd (behind the scenes)
func get_unique_question(grade: String, topic: String = "") -> Dictionary:
	# Skip used questions
	var unused = []
	for q in question_data[grade]:
		if not q.q in used_questions:
			unused.append(q)
	
	# Shuffle options
	var final_question = unused.pick_random()
	final_question = shuffle_question_options(final_question)
	
	# Track as used
	used_questions.append(final_question.q)
	save_game()  # Auto-save
	
	return final_question
```

---

## ⚠️ Common Mistakes & Fixes

### ❌ Mistake 1: Circular dependency
```gdscript
# WRONG: Global.gd uses Battle.gd, Battle.gd uses Global.gd
# → Causes infinite loop

# FIX: Use signals instead
signal enemy_defeated(loot)
# Battle emits signal, other systems listen
```

### ❌ Mistake 2: Missing preload
```gdscript
# WRONG
var theme = UIThemeManager.apply_button_theme(btn)

# FIX - Add const at top
const UIThemeManager = preload("res://Scripts/UIThemeManager.gd")
UIThemeManager.apply_button_theme(btn)
```

### ❌ Mistake 3: Using instance methods as static
```gdscript
# WRONG - DialogueSystem is instance not static
DialogueSystem.start_dialogue(lines)  # Error!

# CORRECT - Use @onready
@onready var dialogue_system = $DialogueSystem
dialogue_system.start_dialogue(lines)
```

### ❌ Mistake 4: Forgetting to call Global methods
```gdscript
# WRONG - modifying local variable
var question = current_question
question.a = "wrong answer"  # Doesn't affect Global

# CORRECT - use Global directly
current_question = Global.get_unique_question(grade)
```

---

## 📋 Integration Checklist

ก่อนสร้าง feature ใหม่:

- [ ] ระบุ dependencies ที่จำเป็น
- [ ] ตรวจสอบ circular dependencies
- [ ] ใช้ `const` สำหรับ static classes
- [ ] ใช้ `@onready` สำหรับ instance nodes
- [ ] ใช้ `signal` สำหรับ events
- [ ] เขียน integration example ในจดหมายเหนือ (docstring)
- [ ] ทดสอบให้แน่ใจว่า compile ได้
- [ ] Update CORE_WORKING_GUIDELINES.md ถ้า pattern ใหม่

---

## 🚀 Adding New Module

**Template สำหรับเพิ่มโมดูลใหม่:**

```gdscript
# MyNewModule.gd
extends Node
"""
Purpose: [WHAT THIS DOES]

Dependencies:
  - Global.gd
  - UIThemeManager.gd

Example usage:
	const MyNewModule = preload("res://Scripts/MyNewModule.gd")
	MyNewModule.do_something()
"""

const SOME_CONSTANT = "value"

static func do_something() -> void:
	"""Main function"""
	pass

static func helper_function() -> String:
	"""Supporting function"""
	return "result"
```

---

**Keep integration clean and dependency-aware! 🔗**
