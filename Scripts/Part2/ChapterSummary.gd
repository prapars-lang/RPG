extends Control

# ChapterSummary.gd - Summarizes the health lessons learned after a chapter

@onready var title_label = $Panel/VBox/TitleLabel
@onready var overview_label = $Panel/VBox/OverviewLabel
@onready var lesson_label = $Panel/VBox/LessonLabel
@onready var reward_label = $Panel/VBox/RewardLabel
@onready var continue_btn = $Panel/VBox/ContinueBtn

func _ready():
	# Track current scene for Save/Load
	Global.current_scene = "res://Scenes/Part2/ChapterSummary.tscn"
	
	_apply_theme()
	_populate_data()
	
	continue_btn.pressed.connect(_on_continue_pressed)

func _apply_theme():
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = UIThemeManager.COLOR_DARK_BG
	panel_style.set_corner_radius_all(20)
	panel_style.border_width_left = 4
	panel_style.border_width_top = 4
	panel_style.border_width_right = 4
	panel_style.border_width_bottom = 4
	panel_style.border_color = UIThemeManager.COLOR_ACCENT
	$Panel.add_theme_stylebox_override("panel", panel_style)
	
	UIThemeManager.apply_button_theme(continue_btn)
	
	title_label.add_theme_font_size_override("font_size", 36)
	title_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	
	lesson_label.add_theme_color_override("font_color", UIThemeManager.COLOR_PRIMARY)
	
	# Animate entry
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _populate_data():
	var ch_key = "chapter_" + str(Global.current_chapter)
	var ch_data = StoryDataPart2.CHAPTERS.get(ch_key, {})
	
	title_label.text = "บทเรียนสมบูรณ์: " + ch_data.get("name", "Unknown Chapter")
	
	# Fallback summary if not defined in data
	var summary = ch_data.get("summary", "ยินดีด้วย! ท่านได้ผ่านการทดสอบสุขภาพในบทนี้แล้ว")
	lesson_label.text = summary
	
	reward_label.text = "รางวัลที่ได้รับ: +2 แต้มทักษะ (Skill Points)"

func _on_continue_pressed():
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	
	# Progression logic already mostly handled in StoryScene.gd
	# We just move back to the Map now
	get_tree().change_scene_to_file("res://Scenes/Part2/WorldMap.tscn")
