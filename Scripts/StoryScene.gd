extends Control

@onready var background = $Background
@onready var hero_sprite = $Characters/HeroSprite
@onready var other_sprite = $Characters/OtherSprite
@onready var dialogue_system = $DialogueSystem

var current_chunk_data = {}
var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null
var _part2_data = null # Cached Part 2 story data

func _ready():
	# Track current scene
	Global.current_scene = "res://Scenes/StoryScene.tscn"
	
	print("=== StoryScene _ready() ===")
	print("  is_part2_story: ", Global.is_part2_story)
	print("  current_story_key: ", Global.current_story_key)
	print("  story_progress: ", Global.story_progress)
	print("  current_path: ", Global.current_path)
	
	# Apply theme styling
	_apply_theme()
	
	# Add PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	# Connect Dialogue Signals FIRST (before load_chunk)
	if dialogue_system:
		if not dialogue_system.dialogue_finished.is_connected(_on_dialogue_finished):
			dialogue_system.dialogue_finished.connect(_on_dialogue_finished)
	
	# Load current story chunk (AFTER signal connection)
	load_chunk()
	
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
	
	# --- Part 2 Logic ---
	if Global.is_part2_story:
		var key = Global.current_story_key
		var idx = Global.story_progress
		print("=== LOADING PART 2 STORY ===")
		print("Key: ", key, " | Index: ", idx)
		
		# Load Part 2 Data (cached for reuse)
		if _part2_data == null:
			var script_res = load("res://Scripts/Part2/StoryDataPart2.gd")
			if script_res:
				_part2_data = script_res.new()
				print("[Part2] Script loaded OK: ", _part2_data)
			else:
				print("[Part2] FAILED to load StoryDataPart2.gd!")
				current_chunk_data = null
		
		var chapter_data = _part2_data.chapter_1 if _part2_data else null
		print("[Part2] chapter_data: ", typeof(chapter_data), " | null?: ", chapter_data == null)
		
		if chapter_data and chapter_data.has(key):
			var dialog_chain = chapter_data[key]
			print("[Part2] dialog_chain for '", key, "' loaded. Keys: ", dialog_chain.keys())
			
			if dialog_chain.has(idx):
				current_chunk_data = dialog_chain[idx]
				print("[Part2] Chunk ", idx, " loaded OK. Type: ", current_chunk_data.get("type", "unknown"))
			else:
				print("[Part2] No chunk at index ", idx, " for key: ", key)
				current_chunk_data = null
		else:
			print("[Part2] ERROR: No dialog_chain found for key: ", key)
			current_chunk_data = null
		
		if current_chunk_data == null:
			print("End of dialogue chain for key: ", key)
			# Return to MainMenu (no overworld)
			get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
			return
	# --------------------
	else:
		# --- Part 1 Logic (Original) ---
		print("=== LOADING CHUNK ===")
		print("Path: ", path_name, " | Chunk Index: ", chunk_idx)
		
		# Fallback if empty (Testing)
		if path_name == "": path_name = "exercise"
		
		current_chunk_data = StoryData.get_story_chunk(path_name, chunk_idx)
	
	if current_chunk_data == null:
		push_error("ERROR: Story chunk not found!")
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
		print("[StoryScene] Loading background: ", bg_path, " | Exists: ", ResourceLoader.exists(bg_path))
		if ResourceLoader.exists(bg_path):
			background.texture = load(bg_path)
			print("[StoryScene] Background loaded OK!")
		else:
			push_warning("[StoryScene] Background NOT found: " + bg_path)
	else:
		print("[StoryScene] No background key in chunk data!")
			
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
	# Use Part 2 NPC sprite when in Part 2 mode, otherwise Part 1 default
	var default_guide = "res://Assets/Part2/NPC_Aetherion.png" if Global.is_part2_story else "res://Assets/forest_spirit.png"
	var guide_path = current_chunk_data.get("npc_sprite", default_guide)
	print("[StoryScene] Guide sprite path: '%s' | Exists: %s" % [guide_path, ResourceLoader.exists(guide_path)])
	
	if ResourceLoader.exists(guide_path) or FileAccess.file_exists(guide_path):
		other_sprite.texture = load(guide_path)
		print("[StoryScene] Guide sprite loaded successfully!")
	
	# Start Dialogue
	var lines = current_chunk_data.get("dialogue", [])
	print("[StoryScene] Starting dialogue with ", lines.size(), " lines")
	if lines.size() > 0:
		dialogue_system.start_dialogue(lines)
	else:
		push_warning("[StoryScene] Empty dialogue lines! Skipping...")
		_on_dialogue_finished()

func _on_dialogue_finished():
	# Dialogue ended, check what's next
	if current_chunk_data == null:
		push_error("ERROR: current_chunk_data is null! Cannot proceed to next chunk.")
		return
	
	# --- Part 2 scene chain logic ---
	if Global.is_part2_story:
		var next_scene = current_chunk_data.get("next_scene", "continue")
		print("[Part2] Dialogue finished. next_scene = ", next_scene)
		
		if next_scene == "continue":
			# Move to next chunk in current chain
			Global.story_progress += 1
			call_deferred("load_chunk")
		elif next_scene == "battle":
			# Enter battle
			var enemy_id = current_chunk_data.get("enemy_id", "unstable_slime")
			Global.is_story_mode = true
			Global.queued_story_enemy_id = enemy_id
			# After battle, advance to next chunk
			Global.story_progress += 1
			get_tree().change_scene_to_file("res://Scenes/Battle.tscn")
		elif next_scene == "companion_select":
			# Go to companion selection
			get_tree().change_scene_to_file("res://Scenes/Part2/CompanionSelection.tscn")
		elif next_scene == "end":
			# End of chapter — return to main menu
			Global.is_part2_story = false
			get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
		else:
			# next_scene is a story key (e.g., "meet_aetherion", "the_corruption")
			# Jump to new scene chain
			Global.current_story_key = next_scene
			Global.story_progress = 0
			call_deferred("load_chunk")
		return
	
	# --- Part 1 logic (original) ---
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
