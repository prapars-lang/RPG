extends Control

@onready var chapter_list = $ScrollContainer/ChapterList
@onready var skill_tree_btn = $BottomControls/SkillTreeBtn
@onready var back_btn = $BottomControls/BackBtn
@onready var save_btn = $BottomControls/SaveBtn
@onready var path_line = $ScrollContainer/ChapterList/PathLine

var save_load_menu_scene = preload("res://Scenes/SaveLoadMenu.tscn")

func _ready():
	# Track current scene for Save/Load system
	Global.current_scene = "res://Scenes/Part2/WorldMap.tscn"
	Global.save_game()
	
	print("--- WorldMap _ready() ---")
	_setup_ui()
	print("UI Setup Done")
	_populate_chapters()
	print("Chapters Populated")
	
	# Small delay to ensure layout is ready
	await get_tree().process_frame
	_draw_path()

func _setup_ui():
	UIThemeManager.apply_button_theme(skill_tree_btn)
	UIThemeManager.apply_button_theme(back_btn)
	UIThemeManager.apply_button_theme(save_btn)

func _populate_chapters(): 	# Clear old nodes (except the PathLine)
	for child in chapter_list.get_children():
		if child is Line2D or child.name == "PathLine": continue
		child.queue_free()
	
	# (Using class constants directly)
	
	for i in range(1, Global.max_chapters + 1):
		var chapter_key = "chapter_" + str(i)
		var chapter_data = StoryDataPart2.CHAPTERS.get(chapter_key)
		
		var holder = VBoxContainer.new()
		holder.custom_minimum_size = Vector2(200, 250)
		holder.alignment = BoxContainer.ALIGNMENT_CENTER
		
		# Icon/Circle for Chapter
		var icon = Panel.new()
		icon.custom_minimum_size = Vector2(100, 100)
		var style = StyleBoxFlat.new()
		style.set_corner_radius_all(50)
		
		# Colors based on state
		if i == 1 or i in Global.unlocked_chapters:
			style.bg_color = Color(0.2, 0.8, 0.6, 1.0) # Unlocked
			style.set_border_width_all(4)
			style.border_color = Color(1, 1, 1, 0.8)
		else:
			style.bg_color = Color(0.3, 0.3, 0.3, 0.8) # Locked
			style.set_border_width_all(2)
			style.border_color = Color(0.5, 0.5, 0.5, 0.5)
			
		icon.add_theme_stylebox_override("panel", style)
		holder.add_child(icon)
		
		# Chapter Number Label
		var num_lbl = Label.new()
		num_lbl.text = "Chapter " + str(i)
		num_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		num_lbl.add_theme_font_size_override("font_size", 20)
		icon.add_child(num_lbl)
		num_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		
		# Chapter Name
		var name_lbl = Label.new()
		name_lbl.text = chapter_data.get("name", "Coming Soon") if chapter_data else "Coming Soon"
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_lbl.custom_minimum_size = Vector2(180, 0)
		holder.add_child(name_lbl)
		
		# Play Button
		var play_btn = Button.new()
		play_btn.text = "เริ่มบทเรียน" if (i == 1 or i in Global.unlocked_chapters) else "ล็อคอยู่"
		play_btn.disabled = not (i == 1 or i in Global.unlocked_chapters)
		UIThemeManager.apply_button_theme(play_btn)
		play_btn.pressed.connect(_on_chapter_selected.bind(i))
		holder.add_child(play_btn)
		
		chapter_list.add_child(holder)

func _on_chapter_selected(id):
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	
	Global.current_chapter = id
	Global.story_progress = 0
	Global.current_story_key = "" # Fallback to numeric scenes
	Global.is_part2_story = true
	
	# Save before entering story
	Global.save_game()
	
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/StoryScene.tscn")

func _on_skill_tree_pressed():
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/Part2/SkillTree.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_save_pressed():
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	
	# Ensure current scene is updated
	Global.current_scene = "res://Scenes/Part2/WorldMap.tscn"
	
	var menu = save_load_menu_scene.instantiate()
	add_child(menu)

func _draw_path():
	if path_line == null or not is_instance_valid(path_line):
		push_warning("[WorldMap] PathLine is not valid.")
		return
		
	path_line.clear_points()
	
	var holders = []
	for child in chapter_list.get_children():
		if child is VBoxContainer:
			holders.append(child)
	
	if holders.size() < 2: return
	
	# Calculate points based on holder positions
	var points = []
	for h in holders:
		# Center of the icon (first child of holder)
		var icon = h.get_child(0)
		var center = h.position + icon.position + icon.size / 2
		points.append(center)
		path_line.add_point(center)
	
	# Animation Effect: Make the line glow or pulse
	var tween = create_tween().set_loops()
	tween.tween_property(path_line, "default_color:a", 0.8, 1.5)
	tween.tween_property(path_line, "default_color:a", 0.3, 1.5)
