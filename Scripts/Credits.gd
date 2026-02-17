extends Control

@onready var scroll_container = $ScrollContainer
@onready var credits_label = $ScrollContainer/VBox/CreditsLabel

var scroll_speed = 50.0

func _ready():
	_apply_theme()
	scroll_container.get_v_scroll_bar().modulate.a = 0 # Hide scrollbar

func _apply_theme():
	"""Apply premium UI theme to credits"""
	# Style credits label with theme
	credits_label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	credits_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
func _process(delta):
	scroll_container.scroll_vertical += scroll_speed * delta
	
	# Reset or stop when reached end
	if scroll_container.scroll_vertical >= 1000: # Adjust based on content
		_on_back_btn_pressed()

func _input(event):
	if event.is_action_pressed("ui_cancel") or event is InputEventMouseButton:
		_on_back_btn_pressed()

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
