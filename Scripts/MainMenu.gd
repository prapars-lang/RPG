extends Control

@onready var continue_btn = $MainContainer/ContinueBtn
@onready var profile_btn = $MainContainer/ProfileBtn
@onready var main_container = $MainContainer

# UI Theme Colors
const COLOR_PRIMARY = Color(0.4, 1.0, 0.6, 1.0)      # Greenish
const COLOR_PRIMARY_DARK = Color(0.2, 0.6, 0.4, 1.0) # Dark green
const COLOR_ACCENT = Color(1.0, 0.8, 0.3, 1.0)       # Gold
const COLOR_TEXT = Color(0.95, 0.95, 0.95, 1.0)      # Light white
const COLOR_DARK = Color(0.05, 0.05, 0.1, 0.85)      # Dark bg

func _ready():
	# UI Styling: Premium Glassmorphism with enhanced visuals
	_apply_button_styling()
	_apply_text_styling()
	
	# --- Gamification UI ---
	var streak_label = $MainContainer/GamificationInfo/StreakLabel
	var lp_label = $MainContainer/GamificationInfo/LPLabel
	
	if streak_label:
		streak_label.text = "🔥 " + str(Global.login_streak) + " Days"
	if lp_label:
		lp_label.text = "🎓 " + str(Global.learning_points) + " LP"
	
	# Play main menu background music
	AudioManager.play_bgm("main_menu", 1.2)
	
	# Check if save file exists and enable/disable Continue button
	if Global.has_save_file():
		continue_btn.disabled = false
		_show_welcome_message()
	else:
		continue_btn.disabled = true
	
	# Update Profile Button text
	if ProfileManager.active_profile_name != "":
		profile_btn.text = "โปรไฟล์: " + ProfileManager.active_profile_name
	else:
		profile_btn.text = "เลือกโปรไฟล์ผู้เล่น"
	
	# Animate Title
	var title = $TitleContainer/GameTitle
	var tween = create_tween().set_loops()
	tween.tween_property(title, "position:y", title.position.y - 15, 2.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title, "position:y", title.position.y, 2.5).set_trans(Tween.TRANS_SINE)
	
	# Animate Subtitle Glow
	var subtitle = $TitleContainer/SubTitle
	var s_tween = create_tween().set_loops()
	s_tween.tween_property(subtitle, "modulate:a", 0.6, 1.8)
	s_tween.tween_property(subtitle, "modulate:a", 1.0, 1.8)
	
	# --- Character Animation ---
	_animate_characters()

func _show_welcome_message():
	var label = Label.new()
	label.text = "ยินดีต้อนรับ, " + Global.player_name + "!"
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", COLOR_ACCENT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_container.add_child(label)
	main_container.move_child(label, 0) # Top of the menu
	
	# Fix pivot and scale animation to prevent overlap
	await get_tree().process_frame # Let Godot calculate the size
	label.pivot_offset = label.size / 2
	label.scale = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _apply_button_styling():
	"""Apply premium button styling to all menu buttons"""
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.15, 0.25, 0.2, 0.75)      # Dark green glass
	style_normal.corner_radius_top_left = 15
	style_normal.corner_radius_top_right = 15
	style_normal.corner_radius_bottom_left = 15
	style_normal.corner_radius_bottom_right = 15
	style_normal.border_width_left = 2.5
	style_normal.border_width_top = 2.5
	style_normal.border_width_right = 2.5
	style_normal.border_width_bottom = 2.5
	style_normal.border_color = Color(0.4, 1.0, 0.6, 0.6)
	style_normal.shadow_color = Color(0.0, 0.0, 0.0, 0.4)
	style_normal.shadow_size = 8
	
	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(0.25, 0.35, 0.3, 0.95)       # Lighter on hover
	style_hover.corner_radius_top_left = 15
	style_hover.corner_radius_top_right = 15
	style_hover.corner_radius_bottom_left = 15
	style_hover.corner_radius_bottom_right = 15
	style_hover.border_width_left = 3
	style_hover.border_width_top = 3
	style_hover.border_width_right = 3
	style_hover.border_width_bottom = 3
	style_hover.border_color = COLOR_ACCENT                   # Gold glow on hover
	style_hover.shadow_color = COLOR_PRIMARY
	style_hover.shadow_size = 15
	
	var style_pressed = StyleBoxFlat.new()
	style_pressed.bg_color = Color(0.35, 0.5, 0.4, 1.0)
	style_pressed.corner_radius_top_left = 15
	style_pressed.corner_radius_top_right = 15
	style_pressed.corner_radius_bottom_left = 15
	style_pressed.corner_radius_bottom_right = 15
	style_pressed.border_width_left = 3
	style_pressed.border_width_top = 3
	style_pressed.border_width_right = 3
	style_pressed.border_width_bottom = 3
	style_pressed.border_color = COLOR_ACCENT
	style_pressed.shadow_color = COLOR_PRIMARY
	style_pressed.shadow_size = 12
	
	# Apply to all buttons in MainContainer
	for btn in main_container.get_children():
		if btn is Button:
			btn.add_theme_stylebox_override("normal", style_normal)
			btn.add_theme_stylebox_override("hover", style_hover)
			btn.add_theme_stylebox_override("pressed", style_pressed)
			btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
			
			# Set text color
			btn.add_theme_color_override("font_color", COLOR_TEXT)
			btn.add_theme_color_override("font_hover_color", COLOR_ACCENT)
			btn.add_theme_color_override("font_pressed_color", COLOR_ACCENT)
			
			# Set font size
			btn.add_theme_font_size_override("font_size", 22)
			
			btn.pivot_offset = btn.size / 2
			btn.mouse_entered.connect(_on_btn_mouse_entered.bind(btn))
			btn.mouse_exited.connect(_on_btn_mouse_exited.bind(btn))

func _apply_text_styling():
	"""Apply premium text styling to title and subtitle"""
	var title = $TitleContainer/GameTitle
	if title:
		title.add_theme_color_override("font_color", COLOR_ACCENT)
		title.add_theme_font_size_override("font_size", 80)
		# Add shadow effect via modulate
	
	var subtitle = $TitleContainer/SubTitle
	if subtitle:
		subtitle.add_theme_color_override("font_color", COLOR_TEXT)
		subtitle.add_theme_font_size_override("font_size", 24)
	
	var english_subtitle = $TitleContainer/EnglishSubtitle
	if english_subtitle:
		english_subtitle.add_theme_color_override("font_color", COLOR_TEXT)
		english_subtitle.add_theme_font_size_override("font_size", 16)

func _animate_characters():
	"""Animate the two side characters with a gentle floating effect"""
	var left_char = $LeftCharacter
	var right_char = $RightCharacter
	
	if left_char and right_char:
		# Initial fade in
		left_char.modulate.a = 0
		right_char.modulate.a = 0
		
		var tween = create_tween().set_parallel(true)
		tween.tween_property(left_char, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(right_char, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_delay(0.3)
		
		# Floating animation (Left)
		var t_left = create_tween().set_loops()
		t_left.tween_property(left_char, "position:y", left_char.position.y - 15, 3.0).set_trans(Tween.TRANS_SINE)
		t_left.tween_property(left_char, "position:y", left_char.position.y, 3.0).set_trans(Tween.TRANS_SINE)
		
		# Floating animation (Right) - slightly offset timing
		var t_right = create_tween().set_loops()
		t_right.tween_property(right_char, "position:y", right_char.position.y - 15, 3.5).set_trans(Tween.TRANS_SINE)
		t_right.tween_property(right_char, "position:y", right_char.position.y, 3.5).set_trans(Tween.TRANS_SINE)

func _on_start_btn_pressed():
	"""New Game button - with transition effect"""
	print("Starting New Game...")
	AudioManager.play_sfx("button_click")
	_play_transition_out()
	
	Global.is_part2_story = false
	Global.current_companion_id = ""
	Global.unlocked_chapters = [1]
	Global.current_chapter = 1
	Global.story_progress = 0
	Global.unlocked_skills = []
	Global.skill_points = 0
	Global.learning_points = 0
	Global.is_story_mode = false
	Global.active_quests = []
	Global.completed_quests = []
	Global.quest_progress = {}
	Global.player_name = "ผู้กล้า"
	
	# Navigate with delay for effect
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/CharacterSelection.tscn")

func _on_profile_btn_pressed():
	"""Switch Profile button"""
	print("Opening Profile Selection...")
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/ProfileSelection.tscn")

func _on_continue_btn_pressed():
	"""Continue Game button"""
	print("Loading saved game...")
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	_play_transition_out()
	await get_tree().create_timer(0.5).timeout
	Global.load_and_start()

func _on_load_btn_pressed():
	"""Open Load Slot menu from Main Menu"""
	print("Opening Load Menu...")
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	
	var load_menu = load("res://Scenes/SaveLoadMenu.tscn").instantiate()
	add_child(load_menu)

func _on_options_btn_pressed():
	"""Options button"""
	print("Opening Options menu...")
	AudioManager.play_sfx("menu_open")
	_play_transition_out()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/OptionsMenu.tscn")

func _on_credits_btn_pressed():
	"""Credits button"""
	print("Opening Credits screen...")
	AudioManager.play_sfx("button_click")
	_play_transition_out()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")

func _on_exit_btn_pressed():
	"""Exit button - with fade out"""
	AudioManager.play_sfx("menu_close")
	_play_exit_animation()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

# --- UI Juice & Effects ---
func _on_btn_mouse_entered(btn: Button):
	"""Button hover effect with sound"""
	AudioManager.play_sfx("button_hover", -5.0)  # Slightly quieter hover sound
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.08, 1.08), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Glow effect
	var glow_tween = create_tween()
	glow_tween.tween_property(btn, "modulate", Color(1.2, 1.2, 1.2, 1.0), 0.15)

func _on_btn_mouse_exited(btn: Button):
	"""Button exit hover effect"""
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Remove glow
	var glow_tween = create_tween()
	glow_tween.tween_property(btn, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)

func _play_transition_out():
	"""Scene transition fade-out effect"""
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.modulate.a = 0.0
	add_child(overlay)
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.5)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _play_exit_animation():
	"""Exit animation"""
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.5)
