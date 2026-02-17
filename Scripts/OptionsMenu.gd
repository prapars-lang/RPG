extends Control

@onready var music_slider = $Panel/VBox/MusicContainer/HSlider
@onready var sfx_slider = $Panel/VBox/SFXContainer/HSlider
@onready var resolution_btn = $Panel/VBox/ResolutionContainer/OptionButton

var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080)
]

func _ready():
	# Apply theme styling
	_apply_theme()
	
	# Initialize audio sliders
	# Convert dB to linear for display (0-100 range)
	var music_db = AudioManager.get_music_volume()
	var sfx_db = AudioManager.get_sfx_volume()
	
	music_slider.value = AudioManager.db_to_linear(music_db) * 100.0
	sfx_slider.value = AudioManager.db_to_linear(sfx_db) * 100.0
	
	# Connect slider signals
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	
	# Load current settings from config if exists
	setup_resolution_options()

func _apply_theme():
	"""Apply premium UI theme to options menu"""
	# Style resolution button
	for label in $Panel/VBox.find_children("*", "Label", true):
		label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
		label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	# Style buttons
	for btn in $Panel/VBox.find_children("*", "Button", true):
		UIThemeManager.apply_button_theme(btn)
	
	# Style sliders
	for slider in $Panel/VBox.find_children("*", "HSlider", true):
		slider.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	
	# Style option button
	resolution_btn.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	resolution_btn.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)

func setup_resolution_options():
	resolution_btn.clear()
	for res in resolutions:
		resolution_btn.add_item(str(res.x) + " x " + str(res.y))
	
	# Select current resolution
	var current_res = get_window().size
	for i in range(resolutions.size()):
		if resolutions[i] == current_res:
			resolution_btn.select(i)
			break

func _on_music_slider_value_changed(value):
	# Convert 0-100 to linear (0.0-1.0) to dB
	var linear = value / 100.0
	var db = AudioManager.linear_to_db(linear)
	AudioManager.set_music_volume(db)

func _on_sfx_slider_value_changed(value):
	# Convert 0-100 to linear (0.0-1.0) to dB
	var linear = value / 100.0
	var db = AudioManager.linear_to_db(linear)
	AudioManager.set_sfx_volume(db)

func _on_resolution_selected(index):
	var new_res = resolutions[index]
	get_window().size = new_res
	# Re-center window
	get_window().position = (DisplayServer.screen_get_size() / 2) - (new_res / 2)

func _on_back_btn_pressed():
	# If this was opened from MainMenu, go back there
	# If from PauseMenu, maybe just hide or queue_free
	if get_parent() == get_tree().root:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	else:
		hide()
		queue_free()
