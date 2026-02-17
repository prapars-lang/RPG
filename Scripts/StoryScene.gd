extends Control

@onready var background = $Background
@onready var hero_sprite = $Characters/HeroSprite
@onready var other_sprite = $Characters/OtherSprite
@onready var dialogue_system = $DialogueSystem

var current_chunk_data = {}
var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null

func _ready():
	# Track current scene
	Global.current_scene = "res://Scenes/StoryScene.tscn"
	
	# Apply theme styling
	_apply_theme()
	
	# Add PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	# Load current story chunk
	load_chunk()
	
	# Connect Dialogue Signals
	if dialogue_system:
		if not dialogue_system.dialogue_finished.is_connected(_on_dialogue_finished):
			dialogue_system.dialogue_finished.connect(_on_dialogue_finished)
	
	# AI Advice Button (Specific for Path of Wisdom)
	if Global.current_path == "wisdom":
		var ai_help_btn = Button.new()
		ai_help_btn.text = "ขอคำแนะนำจากวิญญาณ (AI Help)"
		ai_help_btn.position = Vector2(1000, 50) # Top Right-ish
		ai_help_btn.size = Vector2(250, 50)
		ai_help_btn.pressed.connect(_on_ai_help_pressed)
		UIThemeManager.apply_button_theme(ai_help_btn)
		add_child(ai_help_btn)

func _apply_theme():
	"""Apply premium UI theme to story scene"""
	# Style any title/text labels in the scene
	for label in find_children("*", "Label", true):
		if label is Label and label.name not in ["NameLabel", "TextLabel"]:
			label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
			label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)

func _on_ai_help_pressed():
	if dialogue_system:
		dialogue_system.start_ai_dialogue("วิญญาณแห่งปัญญา", "ในฐานะผู้กล้าที่กำลังเดินทางในเส้นทางแห่งปัญญา ข้าควรมีแนวคิดอย่างไรในการรับมือกับอุปสรรค?")

func load_chunk():
	var chunk_idx = Global.story_progress
	var path_name = Global.current_path
	
	print("=== LOADING CHUNK ===")
	print("Path: ", path_name, " | Chunk Index: ", chunk_idx)
	
	# Fallback if empty (Testing)
	if path_name == "": path_name = "exercise"
	
	current_chunk_data = StoryData.get_story_chunk(path_name, chunk_idx)
	
	if current_chunk_data == null:
		push_error("ERROR: Story chunk not found for path '" + path_name + "' index " + str(chunk_idx))
		push_error("Returning to Crossroads...")
		get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")
		return
		
	print("Chunk loaded successfully! Type: ", current_chunk_data.get("type", "unknown"))
		
	# Play Story BGM if not already playing
	if not AudioManager.is_bgm_playing() or AudioManager.current_bgm_key != "story":
		AudioManager.play_bgm("story")
		
	# Automatic Quest Activation (at start of chapter)
	if chunk_idx == 0:
		var quest_id = path_name + "_start"
		QuestManager.activate_quest(quest_id)
		
	# Setup Visuals
	if current_chunk_data.has("background"):
		var bg_path = current_chunk_data["background"]
		if ResourceLoader.exists(bg_path):
			background.texture = load(bg_path)
			
	# Check type
	if current_chunk_data.get("type") == "dialogue":
		setup_dialogue_mode()
	elif current_chunk_data.get("type") == "battle":
		start_battle_transition()
	elif current_chunk_data.get("type") == "end_chapter":
		end_chapter()

func setup_dialogue_mode():
	# ===== HERO SPRITE =====
	# Build key: e.g. "นักล่า_เด็กชาย"
	var icon_key = Global.player_class + "_" + Global.player_gender
	print("[StoryScene] Looking for hero icon: key='%s'" % icon_key)
	
	var hero_path = Global.class_icons.get(icon_key, "")
	print("[StoryScene] Hero icon path from class_icons: '%s'" % hero_path)
	
	if hero_path != "":
		# Try ResourceLoader first, then fallback to FileAccess
		if ResourceLoader.exists(hero_path):
			hero_sprite.texture = load(hero_path)
			print("[StoryScene] Hero sprite loaded successfully via ResourceLoader!")
		elif FileAccess.file_exists(hero_path):
			hero_sprite.texture = load(hero_path)
			print("[StoryScene] Hero sprite loaded successfully via FileAccess!")
		else:
			push_warning("[StoryScene] Hero PNG not found at: " + hero_path)
	else:
		push_warning("[StoryScene] No icon key found for: " + icon_key)
	
	# ===== GUIDE SPRITE =====
	# Check if story chunk specifies a custom NPC sprite
	var guide_path = current_chunk_data.get("npc_sprite", "res://Assets/forest_spirit.png")
	print("[StoryScene] Guide sprite path: '%s'" % guide_path)
	
	if ResourceLoader.exists(guide_path) or FileAccess.file_exists(guide_path):
		other_sprite.texture = load(guide_path)
		print("[StoryScene] Guide sprite loaded successfully!")
	
	# Start Dialogue
	var lines = current_chunk_data.get("dialogue", [])
	dialogue_system.start_dialogue(lines)

func _on_dialogue_finished():
	# Dialogue ended, check what's next
	if current_chunk_data == null:
		push_error("ERROR: current_chunk_data is null! Cannot proceed to next chunk.")
		push_error("Current path: " + str(Global.current_path))
		push_error("Current progress: " + str(Global.story_progress))
		return
	
	var next_chunk = current_chunk_data.get("next_chunk", Global.story_progress + 1)
	Global.story_progress = next_chunk
	
	call_deferred("load_chunk")

func start_battle_transition():
	var enemy_id = current_chunk_data.get("enemy_id", "virus")
	Global.is_story_mode = true
	
	# Set the monster for the battle
	# We might need to override get_monster_for_path in Battle.gd or Global.gd
	# For now, let's pass the enemy_id via Global to be picked up
	Global.queued_story_enemy_id = enemy_id
	
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

func end_chapter():
	# Mark Quest as Complete
	var path_name = Global.current_path
	if path_name == "": path_name = "exercise"
	var quest_id = path_name + "_start"
	QuestManager.complete_quest(quest_id)
	
	var next = current_chunk_data.get("next_scene", "res://Scenes/Crossroads.tscn")
	get_tree().change_scene_to_file(next)
