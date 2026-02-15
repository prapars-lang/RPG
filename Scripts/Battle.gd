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

func _on_level_up(new_level, old_stats, new_stats):
	battle_log.text = "LEVEL UP! เลเวล " + str(new_level) + "!"
	await get_tree().create_timer(1.0).timeout
	battle_log.text = "พลังเพิ่มขึ้น! HP/MP ฟื้นฟูเต็ม!"
	update_ui()
	
	# Create a visual pop-up logic (to be implemented more fully later)
	var popup = Label.new()
	popup.text = "LEVEL UP!"
	popup.add_theme_font_size_override("font_size", 48)
	popup.add_theme_color_override("font_color", Color.YELLOW)
	popup.position = Vector2(400, 300)
	$UI.add_child(popup)
	
	await get_tree().create_timer(1.5).timeout
	popup.queue_free()

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
	
	# Set Monster Sprite
	var monster_path = current_monster_data.texture
	if ResourceLoader.exists(monster_path) or FileAccess.file_exists(monster_path):
		monster_sprite_ui.texture = load(monster_path)
	
	battle_log.text = current_monster_data.name + " ปรากฏตัวออกมาแล้ว!"
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
	
	var my_skills = Global.skills[Global.player_class]
	for skill in my_skills:
		var btn = Button.new()
		btn.text = skill.name + " (" + str(skill.cost) + " MP)"
		btn.disabled = player_mp < skill.cost
		btn.pressed.connect(_on_skill_selected.bind(skill))
		skill_list.add_child(btn)
	
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
		execute_player_action(true)
		return
	
	question_label.text = "[" + grade + "] " + current_question.q
	
	for child in options_container.get_children():
		child.queue_free()
		
	for option in current_question.options:
		var btn = Button.new()
		btn.text = option
		btn.custom_minimum_size = Vector2(0, 80)
		btn.add_theme_font_size_override("font_size", 24)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(answer_question.bind(option))
		options_container.add_child(btn)
	
	question_box.visible = true

func answer_question(answer):
	if current_state != BattleState.QUESTION_TIME: return
	
	question_box.visible = false
	if answer == current_question.a:
		execute_player_action(true)
	else:
		execute_player_action(false)
	
	update_ui()
	check_battle_end()

func execute_player_action(success):
	if success:
		if pending_skill:
			battle_log.text = "สำเร็จ! ใช้สกิล " + pending_skill.name
			await play_anim(hero_sprite_ui, "attack")
			
			# Skill damage scales with player_atk
			var total_dmg = pending_skill.value + int(player_atk * 0.5)
			
			BattleEffectManager.shake_camera(battle_camera, 8.0, 0.4)
			BattleEffectManager.flash_sprite(monster_sprite_ui)
			BattleEffectManager.show_damage_number($UI, total_dmg, monster_sprite_ui.position + Vector2(200, 100))
			
			await play_anim(monster_sprite_ui, "damage")
			
			player_mp -= pending_skill.cost
			if pending_skill.type == "dmg":
				enemy_hp -= total_dmg
			elif pending_skill.type == "buff":
				battle_log.text += " (เพิ่มความแข็งแกร่ง!)"
		else:
			# Normal Attack: ATK + Random(0-5)
			var damage = player_atk + randi() % 6
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

func check_battle_end():
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
		
		await get_tree().create_timer(3.0).timeout
		
		# --- MODIFIED: Return to Story if in Story Mode ---
		if Global.is_story_mode:
			# Advance to next chunk (The Battle Chunk usually points to Next Dialogue)
			Global.story_progress += 1 
			get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/VictoryScene.tscn")
		# --------------------------------------------------
		
	elif player_hp <= 0:
		current_state = BattleState.LOST
		battle_log.text = "พ่ายแพ้... รักษาสุขภาพให้ดีกว่านี้ในครั้งหน้านะ!"
		# Might want a Game Over screen or Restart logic here later
	else:
		enemy_turn()

func enemy_turn():
	current_state = BattleState.ENEMY_TURN
	await get_tree().create_timer(1.0).timeout
	# Calculate mitigated damage
	var raw_atk = current_monster_data.get("atk", 10)
	var final_dmg = max(5, raw_atk - int(player_def * 0.5))
	
	battle_log.text = current_monster_data.name + " กำลังโจมตี!"
	await play_anim(monster_sprite_ui, "attack")
	
	# Premium FX
	BattleEffectManager.shake_camera(battle_camera, 6.0, 0.4)
	BattleEffectManager.flash_sprite(hero_sprite_ui)
	BattleEffectManager.show_damage_number($UI, final_dmg, hero_sprite_ui.position + Vector2(200, 100), Color.RED)
	
	await play_anim(hero_sprite_ui, "damage")
	player_hp -= final_dmg
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
