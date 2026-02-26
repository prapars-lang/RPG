extends Control

@onready var background = $Background
@onready var hero_sprite = $Characters/HeroSprite
@onready var other_sprite = $Characters/OtherSprite
@onready var dialogue_system = $DialogueSystem

var item_display: TextureRect # Dynamically created for rewards

var current_chunk_data = {}
var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null
# (Unused variable removed)

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
	
	# Initialize Item Display FIRST
	_setup_item_display()
	
	# Connect Dialogue Signals
	if dialogue_system:
		if not dialogue_system.dialogue_finished.is_connected(_on_dialogue_finished):
			dialogue_system.dialogue_finished.connect(_on_dialogue_finished)
		if not dialogue_system.line_changed.is_connected(_on_line_changed):
			dialogue_system.line_changed.connect(_on_line_changed)
	
	# Load current story chunk
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

func _setup_item_display():
	item_display = TextureRect.new()
	item_display.name = "RewardDisplay"
	item_display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item_display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	item_display.custom_minimum_size = Vector2(350, 350)
	
	# Center it
	item_display.set_anchors_preset(Control.PRESET_CENTER)
	item_display.set_anchor_and_offset(SIDE_LEFT, 0.5, -175)
	item_display.set_anchor_and_offset(SIDE_TOP, 0.5, -250)
	
	item_display.visible = false
	item_display.modulate.a = 0
	add_child(item_display)
	
	# Ensure it's above characters but below dialogue UI
	if dialogue_system:
		move_child(item_display, dialogue_system.get_index())

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
		
		# Removed old load().new() logic - using class constants
		
		var chapter_key = "chapter_" + str(int(Global.current_chapter))
		var chapter_data = StoryDataPart2.CHAPTERS.get(chapter_key, {})
		print("[Part2] Using StoryDataPart2.CHAPTERS for '", chapter_key, "'. Empty?: ", chapter_data.is_empty())
		
		if not chapter_data.is_empty():
			# Format A: chain-based (key = "part2_intro", sub-dict with numbered scenes)
			# Only treat as chain if it DOES NOT have a "type" key (which would mean it's a single scene)
			if chapter_data.has(key) and typeof(chapter_data[key]) == TYPE_DICTIONARY and not chapter_data[key].has("type"):
				var dialog_chain = chapter_data[key]
				print("[Part2] dialog_chain for '", key, "' loaded. Keys: ", dialog_chain.keys())
				
				if dialog_chain.has(str(idx)):
					current_chunk_data = dialog_chain[str(idx)]
					print("[Part2] Chunk ", idx, " loaded OK. Type: ", current_chunk_data.get("type", "unknown"))
				else:
					print("[Part2] No chunk at index ", idx, " for key: ", key)
					current_chunk_data = null
			# Format B: flat numeric (scenes stored directly as "0", "1", "2"... in chapter)
			elif chapter_data.has(str(idx)):
				current_chunk_data = chapter_data[str(idx)]
				print("[Part2] Direct scene ", idx, " loaded OK. Type: ", current_chunk_data.get("type", "unknown"))
			else:
				print("[Part2] No scene found for key='", key, "' idx=", idx, " in ", chapter_key)
				current_chunk_data = null
		
		if current_chunk_data == null:
			if idx == 0 and key == "":
				push_error("[StoryScene] ERROR: Could not find START of chapter %d. Data might be missing." % Global.current_chapter)
				get_tree().call_deferred("change_scene_to_file", "res://Scenes/Part2/WorldMap.tscn")
				return

			print("End of dialogue chain for key: ", key)
			if Global.current_chapter < 30: 
				var next_ch = Global.current_chapter + 1
				if not next_ch in Global.unlocked_chapters:
					Global.unlocked_chapters.append(next_ch)
				
				# Instead of auto-advancing, go to World Map
				print("[Part2] Chapter Complete. Moving to World Map. Next unlocked: ", next_ch)
				get_tree().call_deferred("change_scene_to_file", "res://Scenes/Part2/WorldMap.tscn")
			else:
				print("[Part2] Final Chapter Complete! Moving to Ending Scene.")
				get_tree().call_deferred("change_scene_to_file", "res://Scenes/Part2/EndingScenePart2.tscn")
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
		if Global.is_part2_story:
			push_error("Returning to World Map...")
			get_tree().change_scene_to_file("res://Scenes/Part2/WorldMap.tscn")
		else:
			push_error("Returning to Crossroads...")
			get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")
		return
		
	print("Chunk loaded successfully! Type: ", current_chunk_data.get("type", "unknown"))
		
	# Play Story BGM if not already playing
	if not AudioManager.is_bgm_playing() or AudioManager.current_bgm_key != "story":
		AudioManager.play_bgm("story")
		
	# Automatic Quest Activation (at start of chapter)
	if chunk_idx == 0 and not Global.is_part2_story:
		var quest_id = path_name + "_start"
		QuestManager.activate_quest(quest_id)
		
	# Manual Quest Activation (from story data)
	if current_chunk_data.has("quest_id"):
		QuestManager.activate_quest(current_chunk_data["quest_id"])
		
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

func _on_line_changed(data):
	var focus = data.get("focus", "none")
	
	match focus:
		"hero":
			hero_sprite.modulate = Color(1, 1, 1, 1)
			other_sprite.modulate = Color(0.5, 0.5, 0.5, 0.8)
		"guide", "other":
			hero_sprite.modulate = Color(0.5, 0.5, 0.5, 0.8)
			other_sprite.modulate = Color(1, 1, 1, 1)
		"none":
			hero_sprite.modulate = Color(1, 1, 1, 1)
			other_sprite.modulate = Color(1, 1, 1, 1)
		_:
			# Fallback: highlight based on name
			var speaker_name = data.get("name", "").to_lower()
			if "hero" in speaker_name or Global.player_name.to_lower() in speaker_name:
				hero_sprite.modulate = Color(1, 1, 1, 1)
				other_sprite.modulate = Color(0.5, 0.5, 0.5, 0.8)
			else:
				hero_sprite.modulate = Color(0.5, 0.5, 0.5, 0.8)
				other_sprite.modulate = Color(1, 1, 1, 1)
	
	# --- Reward Detection ---
	var text = data.get("text", "")
	var speaker = data.get("name", "")
	
	if "ได้รับ" in text or "received" in text.to_lower():
		_show_reward_item(text)
	elif speaker != "System" and item_display != null and item_display.visible:
		# Hide reward when someone else speaks
		_hide_reward_item()

func _show_reward_item(text: String):
	var reward_path = ""
	
	if "Vitality Gem" in text or "อัญมณีพลังชีวิต" in text:
		reward_path = "res://Assets/items/vitality_gem.png"
	elif "Wisdom Emblem" in text or "เหรียญตราแห่งปัญญา" in text or "ตราแห่งปัญญา" in text:
		reward_path = "res://Assets/items/wisdom_emblem.png"
	elif "Hygiene Emblem" in text or "เหรียญตราแห่งความสะอาด" in text or "ตราแห่งความสะอาด" in text:
		reward_path = "res://Assets/items/hygiene_emblem.png"
	elif "Nutrition Emblem" in text or "เหรียญตราแห่งโภชนาการ" in text or "ตราแห่งโภชนาการ" in text:
		reward_path = "res://Assets/items/nutrition_emblem.png"
	
	if reward_path != "" and ResourceLoader.exists(reward_path):
		item_display.texture = load(reward_path)
		item_display.visible = true
		
		# Animation
		item_display.scale = Vector2(0.5, 0.5)
		item_display.modulate.a = 0
		
		var tween = create_tween().set_parallel(true)
		tween.tween_property(item_display, "modulate:a", 1.0, 0.5)
		tween.tween_property(item_display, "scale", Vector2(1.2, 1.2), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		# Add floating effect after entry
		tween.chain().set_parallel(false)
		UIThemeManager.animate_floating(item_display, 20.0, 2.0)
		
		# Play victory SFX
		AudioManager.play_sfx("level_up") # or a specific reward SFX if available

func _hide_reward_item():
	var tween = create_tween()
	tween.tween_property(item_display, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func(): item_display.visible = false)

func _on_dialogue_finished():
	# Dialogue ended, check what's next
	if current_chunk_data == null:
		push_error("ERROR: current_chunk_data is null! Cannot proceed to next chunk.")
		return
	
	# --- Part 2 scene chain logic ---
	if Global.is_part2_story:
		var next_scene = current_chunk_data.get("next_scene", "continue")
		# Manual Quest Activation (from story data) - if not already activated by load_chunk
		if current_chunk_data.has("quest_id"):
			QuestManager.activate_quest(current_chunk_data["quest_id"])
		print("[Part2] Dialogue finished. next_scene = ", next_scene)
		
		if next_scene == "continue":
			# Move to next chunk in current chain
			Global.story_progress += 1
			Global.save_game() # Save progress
			call_deferred("load_chunk")
		elif next_scene == "battle":
			# Enter battle
			var enemy_id = current_chunk_data.get("enemy_id", "unstable_slime")
			var bg_path = current_chunk_data.get("background", "")
			Global.is_story_mode = true
			Global.queued_story_enemy_id = enemy_id
			Global.queued_battle_background = bg_path
			
			get_tree().change_scene_to_file("res://Scenes/Battle.tscn")
		elif next_scene == "companion_select":
			# Go to companion selection
			get_tree().change_scene_to_file("res://Scenes/Part2/CompanionSelection.tscn")
		elif next_scene == "end":
			# End of chapter - Update unlocked chapters and go to World Map
			var earned_sp = 2 # Fixed reward or dynamic? Let's say 2 for now
			Global.skill_points += earned_sp
			
			# Trigger Summary logic (could be a popup or dedicated scene)
			print("[Part2] Chapter Clear! Earned ", earned_sp, " SP. Total: ", Global.skill_points)
			
			if Global.current_chapter < Global.max_chapters:
				var next_ch = Global.current_chapter + 1
				if not next_ch in Global.unlocked_chapters:
					Global.unlocked_chapters.append(next_ch)
				
				# Advance chapter for progress, but reset chunk index
				Global.current_chapter = next_ch
				Global.story_progress = 0
				Global.current_story_key = "" 
				
				print("[Part2] Chapter Complete. Moving to Summary. Next unlocked: ", next_ch)
				Global.save_game()
				get_tree().call_deferred("change_scene_to_file", "res://Scenes/Part2/ChapterSummary.tscn")
			else:
				print("[Part2] Final Chapter Complete!")
				Global.save_game()
				get_tree().call_deferred("change_scene_to_file", "res://Scenes/Part2/ChapterSummary.tscn")
			return
		else:
			# If it's a numeric jump (e.g., "0")
			if next_scene.is_valid_int():
				Global.story_progress = next_scene.to_int()
				Global.current_story_key = "" # Reset to flat numeric mode
			else:
				# It's a new story key within the same chapter
				Global.current_story_key = next_scene
				Global.story_progress = 0
		
		# Proactively save progress
		Global.save_game()
		call_deferred("load_chunk")
		return
	
	# --- Part 1 logic (original) ---
	var next_chunk = current_chunk_data.get("next_chunk", Global.story_progress + 1)
	Global.story_progress = next_chunk
	
	call_deferred("load_chunk")

func start_battle_transition():
	var enemy_id = current_chunk_data.get("enemy_id", "virus")
	var bg_path = current_chunk_data.get("background", "")
	
	Global.is_story_mode = true
	Global.queued_story_enemy_id = enemy_id
	Global.queued_battle_background = bg_path
	
	if get_tree():
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Battle.tscn")
	else:
		push_error("[StoryScene] Error: SceneTree is null, cannot change scene to Battle.")

func end_chapter():
	# Mark Quest as Complete
	var path_name = Global.current_path
	if path_name == "": path_name = "exercise"
	var quest_id = path_name + "_start"
	QuestManager.complete_quest(quest_id)
	
	var next = current_chunk_data.get("next_scene", "res://Scenes/Crossroads.tscn")
	get_tree().change_scene_to_file(next)
