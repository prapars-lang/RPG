extends Node2D

# Battle States
enum BattleState { START, PLAYER_TURN, QUESTION_TIME, ENEMY_TURN, WON, LOST }
var current_state = BattleState.START

# Stats (Loaded from Global)
var player_hp = 100
var player_max_hp = 100
var player_mp = 100
var player_max_mp = 100
var enemy_hp = 50
var enemy_max_hp = 50

var player_atk = 10
var player_def = 5
var player_shield = 0 # Added for Earth skills

var current_question = {}
var pending_skill = null # Store skill while answering question

var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null

const BattleEffectManager = preload("res://Scripts/Battle/BattleEffectManager.gd")
@onready var battle_camera = $BattleCamera

@onready var battle_log = $UI/BattleLog
@onready var player_hp_bar = $UI/Stats/PlayerHP
@onready var player_mp_bar = $UI/Stats/PlayerMP
@onready var enemy_hp_bar = $UI/EnemyStatContainer/EnemyHP
@onready var hero_sprite_ui = $UI/HeroSprite
@onready var companion_sprite_ui = $UI/CompanionSprite
@onready var monster_sprite_ui = $UI/MonsterSprite
@onready var question_box = $UI/QuestionBox
@onready var question_label = $UI/QuestionBox/VBox/QuestionLabel
@onready var options_container = $UI/QuestionBox/VBox/Options

@onready var skill_menu = $UI/SkillMenu
@onready var skill_list = $UI/SkillMenu/VBox/SkillList
@onready var item_menu = $UI/ItemMenu
@onready var item_list = $UI/ItemMenu/VBox/ItemList

# Using Global.class_icons now

func _ready():
	# Track current scene
	Global.current_scene = "res://Scenes/Battle.tscn"
	
	# Add PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	load_player_stats()
	setup_battle()
	Global.level_up_occurred.connect(_on_level_up)
	
	# --- Visual Polish: Battle HUD ---
	_apply_hud_styles()
	
	# Connect hover signals and apply styles for buttons
	for btn in [$UI/Controls/AttackBtn, $UI/Controls/SkillBtn, $UI/Controls/ItemBtn, $UI/SkillMenu/VBox/CloseSkillBtn, $UI/ItemMenu/VBox/CloseItemBtn]:
		btn.pivot_offset = btn.size / 2
		btn.mouse_entered.connect(_on_btn_mouse_entered.bind(btn))
		btn.mouse_exited.connect(_on_btn_mouse_exited.bind(btn))
	
	# Idle Animation for Sprites (Breathing effect)
	_start_idle_animations()
	
	# Play Battle Music
	AudioManager.play_bgm("battle")

func _apply_hud_styles():
	# Style HP Bar with theme colors
	var hp_bg = StyleBoxFlat.new()
	hp_bg.bg_color = UIThemeManager.COLOR_DARK_BG
	hp_bg.corner_radius_top_left = 5
	hp_bg.corner_radius_bottom_left = 5
	
	var hp_fill = StyleBoxFlat.new()
	hp_fill.bg_color = Color(0.8, 0.2, 0.2) # Red for damage
	hp_fill.corner_radius_top_left = 5
	hp_fill.corner_radius_bottom_left = 5
	hp_fill.border_width_right = 2
	hp_fill.border_color = Color(1, 0.5, 0.5, 0.5)
	
	player_hp_bar.add_theme_stylebox_override("background", hp_bg)
	player_hp_bar.add_theme_stylebox_override("fill", hp_fill)
	
	# Style MP Bar
	var mp_fill = hp_fill.duplicate()
	mp_fill.bg_color = Color(0.2, 0.5, 0.9) # Blue for mana
	player_mp_bar.add_theme_stylebox_override("background", hp_bg)
	player_mp_bar.add_theme_stylebox_override("fill", mp_fill)
	
	# Style Enemy Bar
	enemy_hp_bar.add_theme_stylebox_override("background", hp_bg)
	enemy_hp_bar.add_theme_stylebox_override("fill", hp_fill)
	
	# Style Actions Panel with UIThemeManager colors
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = UIThemeManager.COLOR_PRIMARY_DARK
	btn_style.corner_radius_top_left = 12
	btn_style.corner_radius_top_right = 12
	btn_style.corner_radius_bottom_left = 12
	btn_style.corner_radius_bottom_right = 12
	btn_style.border_width_left = 2
	btn_style.border_width_top = 2
	btn_style.border_width_right = 2
	btn_style.border_width_bottom = 2
	btn_style.border_color = UIThemeManager.COLOR_PRIMARY

	for btn in [$UI/Controls/AttackBtn, $UI/Controls/SkillBtn, $UI/Controls/ItemBtn]:
		btn.add_theme_stylebox_override("normal", btn_style)
		btn.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
		btn.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
		
		var h_style = btn_style.duplicate()
		h_style.bg_color = UIThemeManager.COLOR_PRIMARY
		h_style.border_color = UIThemeManager.COLOR_ACCENT
		h_style.shadow_color = UIThemeManager.COLOR_PRIMARY
		h_style.shadow_size = 8
		btn.add_theme_stylebox_override("hover", h_style)
		btn.add_theme_color_override("font_hover_color", UIThemeManager.COLOR_ACCENT)

func _start_idle_animations():
	# Hero Idle
	var h_tween = create_tween().set_loops()
	h_tween.tween_property(hero_sprite_ui, "position:y", hero_sprite_ui.position.y - 12, 2.5).set_trans(Tween.TRANS_SINE)
	h_tween.tween_property(hero_sprite_ui, "position:y", hero_sprite_ui.position.y, 2.5).set_trans(Tween.TRANS_SINE)
	
	# Monster Idle
	var m_tween = create_tween().set_loops()
	m_tween.tween_property(monster_sprite_ui, "scale", Vector2(1.05, 1.05), 3.0).set_trans(Tween.TRANS_SINE)
	m_tween.tween_property(monster_sprite_ui, "scale", Vector2(1.0, 1.0), 3.0).set_trans(Tween.TRANS_SINE)

func _on_level_up(new_level, old_stats, new_stats, new_skills):
	# Calculate gains
	var hp_gain = new_stats.max_hp - old_stats.max_hp
	var mp_gain = new_stats.max_mana - old_stats.max_mana
	var atk_gain = new_stats.atk - old_stats.atk
	var def_gain = new_stats["def"] - old_stats["def"]
	
	battle_log.text = "LEVEL UP! เลเวล " + str(new_level) + "!"
	AudioManager.play_sfx("levelup")
	
	# Show Stat Gains
	await get_tree().create_timer(1.2).timeout
	battle_log.text = "ค่าพลัง: HP+%d MP+%d ATK+%d DEF+%d" % [hp_gain, mp_gain, atk_gain, def_gain]
	
	if new_skills.size() > 0:
		await get_tree().create_timer(2.0).timeout
		var skills_text = ", ".join(new_skills)
		battle_log.text = "เรียนรู้สกิลใหม่: " + skills_text + "!"
		
	await get_tree().create_timer(2.0).timeout
	battle_log.text = "ฟื้นฟูพลังชีวิตและมานาเต็มเปี่ยม!"
	update_ui()

func load_player_stats():
	var stats = Global.get_current_stats()
	player_hp = stats.hp
	player_max_hp = stats.max_hp
	player_mp = stats.mana
	player_max_mp = stats.max_mana
	player_atk = stats.atk
	player_def = stats["def"]
	
	# Update bars max values
	player_hp_bar.max_value = player_max_hp
	player_mp_bar.max_value = player_max_mp

# Monster Data
var current_monster_id = "virus"
var current_monster_data = {}

func setup_battle():
	current_state = BattleState.START
	player_shield = 0 # Reset shield at start of battle
	
	# Determine monster: Story Override OR Random Encounters
	if Global.is_story_mode and Global.queued_story_enemy_id != "":
		current_monster_id = Global.queued_story_enemy_id
		Global.queued_story_enemy_id = "" # Clear after use
	elif Global.current_path != "":
		current_monster_id = Global.get_monster_for_path(Global.current_path)
	else:
		current_monster_id = "virus" # Default
		
	current_monster_data = Global.monster_db.get(current_monster_id, Global.monster_db["virus"])
	enemy_hp = current_monster_data.hp
	enemy_max_hp = current_monster_data.hp
	enemy_hp_bar.max_value = enemy_max_hp
	
	print("Battle setup. Monster: ", current_monster_data.name)
	
	# Set Hero Sprite
	var icon_key = Global.player_class + "_" + Global.player_gender
	var img_path = Global.class_icons.get(icon_key, "")
	if img_path != "" and (ResourceLoader.exists(img_path) or FileAccess.file_exists(img_path)):
		hero_sprite_ui.texture = load(img_path)
	
	# Set Companion Sprite
	if Global.current_companion_id != "":
		# Load Companion Data (Lazy load or via Part2 script)
		var comp_path = "res://Scripts/Part2/CompanionData.gd"
		if FileAccess.file_exists(comp_path):
			var CompDB = load(comp_path).new()
			var comp_data = CompDB.get_companion(Global.current_companion_id)
			if comp_data:
				if ResourceLoader.exists(comp_data.sprite):
					companion_sprite_ui.texture = load(comp_data.sprite)
					battle_log.text += "\n" + comp_data.name + " ร่วมต่อสู้!"
	
	# Set Monster Sprite
	var monster_path = current_monster_data.texture
	if ResourceLoader.exists(monster_path) or FileAccess.file_exists(monster_path):
		monster_sprite_ui.texture = load(monster_path)
	
	battle_log.text = current_monster_data.name + " ปรากฏตัวออกมาแล้ว!"
	$UI/Controls.show()
	update_ui()
	player_turn()

func update_ui():
	player_hp_bar.value = player_hp
	player_mp_bar.value = player_mp
	enemy_hp_bar.value = enemy_hp

func player_turn():
	current_state = BattleState.PLAYER_TURN
	battle_log.text = "ตาของคุณแล้ว! เลือกแผนการต่อสู้"

func _on_attack_pressed():
	if current_state == BattleState.PLAYER_TURN:
		pending_skill = null
		show_question()

func _on_skill_btn_pressed():
	if current_state == BattleState.PLAYER_TURN:
		show_skill_menu()

func show_skill_menu():
	# Clear old list
	for child in skill_list.get_children():
		child.queue_free()
	
	var all_class_skills = Global.skills.get(Global.player_class, [])
	for skill in all_class_skills:
		if skill.level > Global.player_level:
			continue
			
		var btn = Button.new()
		btn.text = skill.name + " (" + str(skill.cost) + " MP)"
		btn.disabled = player_mp < skill.cost
		btn.pressed.connect(_on_skill_selected.bind(skill))
		skill_list.add_child(btn)
	
	# --- ADDED: Companion Skill ---
	if Global.current_companion_id != "":
		var comp_path = "res://Scripts/Part2/CompanionData.gd"
		if FileAccess.file_exists(comp_path):
			var CompDB = load(comp_path).new()
			var comp_data = CompDB.get_companion(Global.current_companion_id)
			if comp_data and comp_data.has("skill"):
				var skill = comp_data.skill
				var btn = Button.new()
				btn.text = "[คู่หู] " + skill.name + " (" + str(skill.cost) + " MP)"
				btn.disabled = player_mp < skill.cost
				
				# Ensure styling
				UIThemeManager.apply_button_theme(btn)
				
				btn.pressed.connect(_on_skill_selected.bind(skill))
				skill_list.add_child(btn)
	# ------------------------------
	
	# --- ADDED: Elemental Skills (Skill Tree) ---
	var SkillDB = load("res://Scripts/Part2/SkillTreeData.gd")
	for skill_id in Global.unlocked_skills:
		var skill = SkillDB.SKILLS.get(skill_id)
		if skill:
			var btn = Button.new()
			btn.text = skill.name + " (" + str(skill.cost) + " MP)"
			btn.disabled = player_mp < skill.cost
			
			# Ensure styling
			UIThemeManager.apply_button_theme(btn)
			
			btn.pressed.connect(_on_skill_selected.bind(skill))
			skill_list.add_child(btn)
	# ------------------------------------------
	
	skill_menu.visible = true

func _on_skill_selected(skill):
	skill_menu.visible = false
	pending_skill = skill
	show_question()

func _on_close_skill_pressed():
	skill_menu.visible = false

# --- Inventory System ---
func _on_item_btn_pressed():
	if current_state == BattleState.PLAYER_TURN:
		show_item_menu()

func show_item_menu():
	# Clear old list
	for child in item_list.get_children():
		child.queue_free()
	
	var has_items = false
	for item_id in Global.inventory:
		var count = Global.inventory[item_id]
		if count > 0:
			var item_data = Global.item_db.get(item_id, {})
			# Only show consumable items in battle (not equipment)
			if item_data.get("type", "") != "consumable":
				continue
			has_items = true
			var btn = Button.new()
			btn.text = item_data.name + " ( x" + str(count) + " )"
			btn.pressed.connect(_on_item_selected.bind(item_id))
			item_list.add_child(btn)
	
	if not has_items:
		var lbl = Label.new()
		lbl.text = "ไม่มีไอเทมที่ใช้ได้"
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_list.add_child(lbl)
	
	item_menu.visible = true

func _on_item_selected(item_id):
	item_menu.visible = false
	use_item_in_battle(item_id)

func _on_close_item_pressed():
	item_menu.visible = false

func use_item_in_battle(item_id):
	if Global.use_item(item_id):
		var item_data = Global.item_db[item_id]
		battle_log.text = "ใช้ " + item_data.name + "! " + item_data.desc
		
		# Apply Effect — supports new consumable type structure
		var subtype = item_data.get("subtype", item_data.get("type", ""))
		if subtype == "hp":
			player_hp = min(player_hp + item_data.value, player_max_hp)
			battle_log.text += " (HP +" + str(item_data.value) + ")"
		elif subtype == "mp":
			player_mp = min(player_mp + item_data.value, player_max_mp)
			battle_log.text += " (MP +" + str(item_data.value) + ")"
			
		update_ui()
		
		# End Turn
		await get_tree().create_timer(1.5).timeout
		enemy_turn()
	else:
		BattleEffectManager.show_damage_number($UI, 0, hero_sprite_ui.position + Vector2(200, 100), Color.GRAY)
		battle_log.text = "ไอเทมหมด!"

func show_question():
	current_state = BattleState.QUESTION_TIME
	
	var grade = Global.get_current_grade()
	
	# Use centralized unique question logic
	current_question = Global.get_unique_question(grade, Global.current_path)
	
	if current_question.is_empty():
		await execute_player_action(true)
		return
	
	# Show question with counter (e.g. "ข้อ 10/85 [P1] คำถาม...")
	var total_q = Global.question_data.get(grade, []).size()
	var used_count = Global.used_questions.size()
	question_label.text = "ข้อ " + str(used_count) + "/" + str(total_q) + "  " + current_question.q
	
	for child in options_container.get_children():
		child.queue_free()
		
	for option in current_question.options:
		var btn = Button.new()
		btn.text = option
		btn.custom_minimum_size = Vector2(0, 60) # Slightly taller
		
		# Apply Premium Theme
		UIThemeManager.apply_button_theme(btn, 20)
		
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.mouse_filter = Control.MOUSE_FILTER_STOP
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.pressed.connect(answer_question.bind(option))
		options_container.add_child(btn)
	
	# Hide action buttons to prevent overlapping click areas
	$UI/Controls.visible = false
	
	question_box.visible = true
	question_box.z_index = 10
	question_box.move_to_front()

func answer_question(answer):
	if current_state != BattleState.QUESTION_TIME: return
	# Prevent double-click by immediately changing state
	current_state = BattleState.ENEMY_TURN
	
	question_box.visible = false
	# Re-show action buttons
	$UI/Controls.visible = true
	
	if answer == current_question.a:
		# Try to unlock a Knowledge Card (20% chance)
		var unlocked_id = Global.try_unlock_random_card(Global.current_path, 0.20)
		if unlocked_id != "":
			_show_card_unlock_popup(unlocked_id)
		await execute_player_action(true)
	else:
		await execute_player_action(false)

func _show_card_unlock_popup(card_id: String):
	var card_data = Global.card_database.get(card_id, {})
	if card_data.is_empty(): return
	
	var popup = Panel.new()
	popup.custom_minimum_size = Vector2(420, 140)
	popup.anchors_preset = Control.PRESET_CENTER
	popup.anchor_left = 0.5; popup.anchor_top = 0.0
	popup.anchor_right = 0.5; popup.anchor_bottom = 0.0
	popup.offset_left = -210; popup.offset_top = 20
	popup.offset_right = 210; popup.offset_bottom = 160
	popup.z_index = 20
	
	var vbox = VBoxContainer.new()
	vbox.anchors_preset = Control.PRESET_FULL_RECT
	vbox.offset_left = 15; vbox.offset_top = 10
	vbox.offset_right = -15; vbox.offset_bottom = -10
	popup.add_child(vbox)
	
	var title = Label.new()
	title.text = "✨ การ์ดความรู้ใหม่! ✨"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	var rarity_colors = {"common": Color(0.7, 0.9, 1.0), "rare": Color(0.6, 0.4, 1.0)}
	var name_label = Label.new()
	name_label.text = card_data.get("name", card_id)
	name_label.add_theme_font_size_override("font_size", 26)
	name_label.add_theme_color_override("font_color", rarity_colors.get(card_data.get("rarity", "common"), Color.WHITE))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(name_label)
	
	var desc_label = Label.new()
	desc_label.text = card_data.get("description", "")
	desc_label.add_theme_font_size_override("font_size", 16)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(desc_label)
	
	$UI.add_child(popup)
	popup.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(popup, "modulate:a", 1.0, 0.3)
	tween.tween_interval(3.0)
	tween.tween_property(popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(popup.queue_free)

func execute_player_action(success):
	if success:
		if pending_skill:
			battle_log.text = "สำเร็จ! ใช้สกิล " + pending_skill.name
			await play_anim(hero_sprite_ui, "attack")
			
			# --- Skill Handling by Type ---
			var skill_type = pending_skill.get("type", "active")
			
			if skill_type == "heal":
				var heal_amount = pending_skill.value + int(player_atk * 0.2)
				player_hp = min(player_hp + heal_amount, player_max_hp)
				BattleEffectManager.show_damage_number($UI, "+" + str(heal_amount), hero_sprite_ui.position + Vector2(0, -50), Color.GREEN)
				battle_log.text += " ฟื้นฟู " + str(heal_amount) + " HP!"
				
			elif skill_type == "shield":
				var shield_amount = pending_skill.value + int(player_def * 0.5)
				player_shield += shield_amount
				BattleEffectManager.show_damage_number($UI, "+" + str(shield_amount) + " Shield", hero_sprite_ui.position + Vector2(0, -50), Color.CYAN)
				battle_log.text += " สร้างเกราะป้องกัน " + str(shield_amount) + " หน่วย!"
				
			elif skill_type == "buff":
				# Simple buff implementation (permanent for battle or temp?)
				# For prototype, let's make it simple: 3 turns? Or just add to stat?
				var stat = pending_skill.get("stat", "def")
				var val = pending_skill.value
				if stat == "def":
					player_def += val
					battle_log.text += " เพิ่มพลังป้องกัน " + str(val) + "!"
				elif stat == "atk": # If exists
					player_atk += val
					battle_log.text += " เพิ่มพลังโจมตี " + str(val) + "!"
				elif stat == "evasion":
					# specialized logic needed, skipping for now or adding dummy
					battle_log.text += " เพิ่มค่าหลบหลีก!"
					
			else: # "active" / "dmg"
				# --- Elemental System Logic (Damage) ---
				var atk_element = pending_skill.get("element", "neutral")
				var def_element = current_monster_data.get("element", "neutral")
				var weakness_mult = Global.get_elemental_weakness(atk_element, def_element)
				
				# Skill damage scales with player_atk
				var raw_dmg = pending_skill.value + int(player_atk * 0.5)
				var total_dmg = int(raw_dmg * weakness_mult)
				
				var feedback_text = ""
				if weakness_mult > 1.0:
					feedback_text = " (Weakness!)"
					BattleEffectManager.show_damage_number($UI, "Effective!", monster_sprite_ui.position + Vector2(0, -50), Color.YELLOW)
				elif weakness_mult < 1.0:
					feedback_text = " (Resisted)"
				
				# Apply Damage
				enemy_hp -= total_dmg
				BattleEffectManager.show_damage_number($UI, total_dmg, monster_sprite_ui.position + Vector2(200, 100))
					
				# --- Elemental Instability (Environment) ---
				var env_interaction = Global.get_elemental_weakness(atk_element, Global.current_map_element)
				if env_interaction > 1.0:
					battle_log.text = "Elemental Instability! ศัตรูแข็งแกร่งขึ้น!"
					BattleEffectManager.shake_camera(battle_camera, 5.0, 0.5)
					# Buff Enemy
					enemy_hp = min(enemy_hp + 20, enemy_max_hp) # Heal Enemy
					BattleEffectManager.show_damage_number($UI, "+Instability", monster_sprite_ui.position + Vector2(0, -80), Color.PURPLE)
					await get_tree().create_timer(1.0).timeout
				# -------------------------------------------
			# ------------------------------
			
			player_mp -= pending_skill.cost
		else:
			# Normal Attack: ATK + Random(0-5)
			var damage = player_atk + randi() % 6
			
			# --- Weakness Logic ---
			if current_monster_data.has("weakness") and current_question.has("topic"):
				# Weakness can be a specific topic string or an array of strings
				var weaknesses = current_monster_data.weakness
				var is_weak = false
				
				# Special Case: Boss weak to EVERYTHING
				if weaknesses is String and weaknesses == "all":
					is_weak = true
				elif weaknesses is Array:
					is_weak = current_question.topic in weaknesses
				elif weaknesses is String:
					is_weak = current_question.topic == weaknesses
					
				if is_weak:
					damage *= 2
					battle_log.text = "จุดอ่อน! ความรู้คือพลัง โจมตี %d หน่วย!" % damage
				else:
					battle_log.text = "ถูกต้อง! คุณโจมตี %d หน่วย!" % damage
			else:
				battle_log.text = "ถูกต้อง! คุณโจมตี %d หน่วย!" % damage
			
			await play_anim(hero_sprite_ui, "attack")
			
			BattleEffectManager.shake_camera(battle_camera, 5.0, 0.3)
			BattleEffectManager.flash_sprite(monster_sprite_ui)
			BattleEffectManager.show_damage_number($UI, damage, monster_sprite_ui.position + Vector2(200, 100))
			
			await play_anim(monster_sprite_ui, "damage")
			enemy_hp -= damage
	else:
		# Attack Failed: Monster Counters
		var enemy_dmg = max(5, current_monster_data.atk - int(player_def * 0.5))
		battle_log.text = "ผิด! สมาธิของคุณหลุดไป... มอนสเตอร์โจมตีสวนกลับ!"
		await play_anim(monster_sprite_ui, "attack")
		
		BattleEffectManager.shake_camera(battle_camera, 10.0, 0.5)
		BattleEffectManager.flash_sprite(hero_sprite_ui, Color(1, 1, 1, 1))
		BattleEffectManager.show_damage_number($UI, enemy_dmg, hero_sprite_ui.position + Vector2(200, 100), Color.YELLOW)
		
		await play_anim(hero_sprite_ui, "damage")
		player_hp -= enemy_dmg
	
	pending_skill = null
	update_ui()
	
	# If correct answer -> Attack -> Next is Enemy Turn (true)
	# If wrong answer -> Counter Attack -> Next is Player Turn (false)
	check_battle_end(success)

func check_battle_end(trigger_enemy_turn: bool = true):
	if enemy_hp <= 0:
		current_state = BattleState.WON
		var xp_gain = current_monster_data.xp
		
		# Randomized Gold Reward (supports both min_gold/max_gold and single gold key)
		var min_g = current_monster_data.get("min_gold", current_monster_data.get("gold", 10))
		var max_g = current_monster_data.get("max_gold", min_g)
		var gold_gain = randi_range(min_g, max_g)
		
		battle_log.text = "ชัยชนะ! ได้รับ " + str(xp_gain) + " XP และ " + str(gold_gain) + " Gold!"
		Global.gain_xp(xp_gain)
		Global.add_gold(gold_gain)
		
		# --- Quest Update ---
		if QuestManager.has_method("on_enemy_killed"):
			QuestManager.on_enemy_killed(current_monster_id)
		# --------------------
		
		$UI/Controls.hide()
		
		await get_tree().create_timer(3.0).timeout
		
		# --- Return to Story if in Story Mode ---
		if Global.is_story_mode:
			# Advance to next chunk
			Global.story_progress += 1 
			get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/VictoryScene.tscn")
		# --------------------------------------------------
		
	elif player_hp <= 0:
		current_state = BattleState.LOST
		$UI/Controls.hide()
		skill_menu.hide()
		item_menu.hide()
		question_box.hide()
		
		battle_log.text = "พ่ายแพ้... รักษาสุขภาพให้ดีกว่านี้ในครั้งหน้านะ!"
		
		# Wait then return to Menu
		await get_tree().create_timer(4.0).timeout
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	else:
		if trigger_enemy_turn:
			enemy_turn()
		else:
			# Counter-attack finished, return to player turn
			await get_tree().create_timer(1.0).timeout
			player_turn()

func enemy_turn():
	current_state = BattleState.ENEMY_TURN
	await get_tree().create_timer(1.0).timeout
	# Calculate mitigated damage
	var raw_atk = current_monster_data.get("atk", 10)
	var final_dmg = max(5, raw_atk - int(player_def * 0.5))
	
	# --- Shield Logic ---
	var blocked_amount = 0
	if player_shield > 0:
		if player_shield >= final_dmg:
			blocked_amount = final_dmg
			player_shield -= final_dmg
			final_dmg = 0
		else:
			blocked_amount = player_shield
			final_dmg -= player_shield
			player_shield = 0
			
		battle_log.text = current_monster_data.name + " โจมตี! (เกราะรับไว้ " + str(blocked_amount) + ")"
	else:
		battle_log.text = current_monster_data.name + " โจมตี!"
	# --------------------
	
	await play_anim(monster_sprite_ui, "attack")
	
	# Premium FX
	BattleEffectManager.shake_camera(battle_camera, 6.0, 0.4)
	BattleEffectManager.flash_sprite(hero_sprite_ui)
	
	if final_dmg > 0:
		BattleEffectManager.show_damage_number($UI, final_dmg, hero_sprite_ui.position + Vector2(200, 100), Color.RED)
		await play_anim(hero_sprite_ui, "damage")
		player_hp -= final_dmg
	else:
		BattleEffectManager.show_damage_number($UI, "Blocked!", hero_sprite_ui.position + Vector2(200, 100), Color.CYAN)
		
	update_ui()
	
	if player_hp > 0:
		await get_tree().create_timer(1.0).timeout
		player_turn()
	else:
		check_battle_end()

func play_anim(target, type):
	var tween = create_tween()
	if type == "attack":
		# Lunge forward
		var original_pos = target.position
		var lunge_dist = Vector2(50, 0)
		if target == monster_sprite_ui: lunge_dist = Vector2(-50, 0)
		
		tween.tween_property(target, "position", original_pos + lunge_dist, 0.1)
		tween.tween_property(target, "position", original_pos, 0.1)
		await tween.finished
	elif type == "damage":
		# Flash Red and Shake
		var original_pos = target.position
		
		# Flash — always reset to WHITE, not original_modulate (which may be tinted)
		target.modulate = Color(2, 0.3, 0.3) # Red flash
		var t_flash = create_tween()
		t_flash.tween_property(target, "modulate", Color.WHITE, 0.3)
		
		# Shake
		for i in range(5):
			var offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
			tween.tween_property(target, "position", original_pos + offset, 0.05)
		
		tween.tween_property(target, "position", original_pos, 0.05)
		await tween.finished
		
		# Safety: guarantee modulate is WHITE after animation completes
		target.modulate = Color.WHITE

# --- UI Juice ---
func _on_btn_mouse_entered(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.1)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_btn_mouse_exited(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
