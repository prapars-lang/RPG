extends Control

# --- Cinematic Intro for Part 2: Terra Nova ---
# Sequence: Black screen → BG fade in → Title zoom → Subtitle typewriter
# → Narration typewriter → Start button fade in

@onready var dark_overlay = $DarkOverlay
@onready var title_label = $CenterContainer/TitleLabel
@onready var subtitle_label = $CenterContainer/SubtitleLabel
@onready var narration_label = $CenterContainer/NarrationLabel
@onready var start_btn = $CenterContainer/StartBtn
@onready var particles = $Particles

var subtitle_text = "500 ปีถัดมา... เมื่อผนึกแห่งอดีตเริ่มแตกร้าว"
var narration_lines = [
	"ในดินแดนที่ครั้งหนึ่งเคยสงบสุข...",
	"เงามืดจากใต้โลกกำลังตื่นขึ้นอีกครั้ง",
	"และเจ้า... ผู้สืบทอดสายเลือดผู้กล้า",
	"ถูกเรียกให้มาสร้างสมดุลใหม่ให้โลกนี้"
]

var is_animating = false

func _ready():
	# Play atmospheric BGM
	if AudioManager.has_method("play_bgm"):
		AudioManager.play_bgm("story")
	
	# Ensure everything starts hidden
	dark_overlay.modulate.a = 1.0
	title_label.modulate.a = 0.0
	subtitle_label.text = ""
	narration_label.text = ""
	start_btn.modulate.a = 0.0
	start_btn.disabled = true
	particles.emitting = false
	
	# Style the start button
	_style_start_button()
	
	# Begin cinematic sequence after a brief pause
	await get_tree().create_timer(0.8).timeout
	_play_cinematic()

func _style_start_button():
	"""Apply premium glassmorphism styling to start button"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.3, 0.2, 0.8)
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.4, 1.0, 0.6, 0.7)
	style.shadow_color = Color(0.2, 0.8, 0.4, 0.3)
	style.shadow_size = 10
	
	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(0.15, 0.4, 0.3, 0.95)
	style_hover.corner_radius_top_left = 15
	style_hover.corner_radius_top_right = 15
	style_hover.corner_radius_bottom_left = 15
	style_hover.corner_radius_bottom_right = 15
	style_hover.border_width_left = 3
	style_hover.border_width_top = 3
	style_hover.border_width_right = 3
	style_hover.border_width_bottom = 3
	style_hover.border_color = Color(1.0, 0.85, 0.3, 0.9)
	style_hover.shadow_color = Color(0.4, 1.0, 0.6, 0.5)
	style_hover.shadow_size = 15
	
	start_btn.add_theme_stylebox_override("normal", style)
	start_btn.add_theme_stylebox_override("hover", style_hover)
	start_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	start_btn.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95, 1.0))
	start_btn.add_theme_color_override("font_hover_color", Color(1.0, 0.85, 0.3, 1.0))

func _play_cinematic():
	"""Main cinematic sequence"""
	is_animating = true
	
	# Phase 1: Fade background in (dark overlay fades out partially)
	var bg_tween = create_tween()
	bg_tween.tween_property(dark_overlay, "modulate:a", 0.6, 2.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await bg_tween.finished
	
	# Start particles
	particles.emitting = true
	
	await get_tree().create_timer(0.5).timeout
	
	# Phase 2: Title appears with scale + fade
	title_label.scale = Vector2(0.5, 0.5)
	title_label.pivot_offset = title_label.size / 2
	var title_tween = create_tween().set_parallel(true)
	title_tween.tween_property(title_label, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	title_tween.tween_property(title_label, "scale", Vector2(1.0, 1.0), 1.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await title_tween.finished
	
	# Title glow pulse
	var glow_tween = create_tween().set_loops()
	glow_tween.tween_property(title_label, "modulate", Color(1.2, 1.1, 0.9, 1.0), 2.0).set_trans(Tween.TRANS_SINE)
	glow_tween.tween_property(title_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.8).timeout
	
	# Phase 3: Subtitle typewriter
	await _typewriter(subtitle_label, subtitle_text, 0.04)
	
	await get_tree().create_timer(1.0).timeout
	
	# Phase 4: Darken more for narration
	var darken_tween = create_tween()
	darken_tween.tween_property(dark_overlay, "modulate:a", 0.45, 1.0)
	await darken_tween.finished
	
	# Phase 5: Narration lines (typewriter one by one)
	for i in range(narration_lines.size()):
		var line = narration_lines[i]
		if i == 0:
			await _typewriter(narration_label, line, 0.05)
		else:
			narration_label.text += "\n"
			await _typewriter_append(narration_label, line, 0.05)
		await get_tree().create_timer(0.6).timeout
	
	await get_tree().create_timer(1.0).timeout
	
	# Phase 6: Start button fade in
	start_btn.disabled = false
	var btn_tween = create_tween()
	btn_tween.tween_property(start_btn, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await btn_tween.finished
	
	# Button pulse animation
	var pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(start_btn, "modulate:a", 0.7, 1.5).set_trans(Tween.TRANS_SINE)
	pulse_tween.tween_property(start_btn, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	
	is_animating = false

func _typewriter(label: Label, full_text: String, delay: float):
	"""Typewriter effect — sets label text one character at a time"""
	label.text = ""
	for i in range(full_text.length()):
		label.text += full_text[i]
		await get_tree().create_timer(delay).timeout

func _typewriter_append(label: Label, full_text: String, delay: float):
	"""Typewriter effect — appends to existing label text"""
	for i in range(full_text.length()):
		label.text += full_text[i]
		await get_tree().create_timer(delay).timeout

func _on_start_btn_pressed():
	if is_animating:
		return
	
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	
	# Fade to black then start story
	var fade_tween = create_tween()
	fade_tween.tween_property(dark_overlay, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await fade_tween.finished
	
	# Start Part 2 Story
	Global.is_part2_story = true
	Global.current_story_key = "part2_intro"
	Global.story_progress = 0
	
	print("=== IntroPart2: Starting Part 2 Story ===")
	print("  is_part2_story: ", Global.is_part2_story)
	print("  current_story_key: ", Global.current_story_key)
	print("  story_progress: ", Global.story_progress)
	
	get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")

func _input(event):
	"""Allow skipping cinematic with any key/click"""
	if is_animating and event is InputEventKey and event.pressed:
		_skip_cinematic()
	elif is_animating and event is InputEventMouseButton and event.pressed:
		_skip_cinematic()

func _skip_cinematic():
	"""Skip to the end state of cinematic"""
	is_animating = false
	
	# Show everything immediately
	dark_overlay.modulate.a = 0.45
	title_label.modulate.a = 1.0
	title_label.scale = Vector2(1.0, 1.0)
	subtitle_label.text = subtitle_text
	
	var full_narration = ""
	for i in range(narration_lines.size()):
		if i > 0:
			full_narration += "\n"
		full_narration += narration_lines[i]
	narration_label.text = full_narration
	
	particles.emitting = true
	start_btn.modulate.a = 1.0
	start_btn.disabled = false
