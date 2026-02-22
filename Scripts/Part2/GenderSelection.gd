extends Control

@onready var male_texture = $HBoxContainer/MaleOption/Texture
@onready var female_texture = $HBoxContainer/FemaleOption/Texture
@onready var male_btn = $HBoxContainer/MaleOption/MaleBtn
@onready var female_btn = $HBoxContainer/FemaleOption/FemaleBtn

func _ready():
	var male_pose = "res://Assets/Part2/Hero_TerraNova.png"
	var female_pose = "res://Assets/Part2/Hero_TerraNova_Female_Pixel.png"
	
	if ResourceLoader.exists(male_pose):
		male_texture.texture = load(male_pose)
	if ResourceLoader.exists(female_pose):
		female_texture.texture = load(female_pose)
	
	_apply_premium_style(male_btn)
	_apply_premium_style(female_btn)

func _apply_premium_style(btn):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.4, 0.3, 0.8)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.4, 1.0, 0.6, 0.7)
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_color_override("font_color", Color.WHITE)

func _on_male_pressed():
	Global.player_gender = "เด็กชาย"
	Global.player_class = "TerraNova"
	_start_game()

func _on_female_pressed():
	Global.player_gender = "เด็กหญิง"
	Global.player_class = "TerraNova"
	_start_game()

func _start_game():
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	
	# Start story
	Global.is_part2_story = true
	Global.current_chapter = 1
	Global.current_story_key = "part2_intro"
	Global.story_progress = 0
	
	get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")
