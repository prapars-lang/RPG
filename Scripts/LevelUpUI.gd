extends CanvasLayer

@onready var level_text = $Panel/VBox/LevelText
@onready var hp_val = $Panel/VBox/Grid/HPValue
@onready var mp_val = $Panel/VBox/Grid/MPValue
@onready var atk_val = $Panel/VBox/Grid/ATKValue
@onready var def_val = $Panel/VBox/Grid/DEFValue

func _ready():
	Global.level_up_occurred.connect(_show_levelup)
	_apply_theme()

func _apply_theme():
	"""Apply premium UI theme to level up display"""
	# Style text labels with theme colors
	level_text.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	level_text.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_BIG)
	
	hp_val.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	hp_val.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	mp_val.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	mp_val.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	atk_val.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	atk_val.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	def_val.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	def_val.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	# Style close button
	var close_btn = $Panel/VBox/CloseBtn
	if close_btn:
		UIThemeManager.apply_button_theme(close_btn)

func _show_levelup(new_level, old_stats, new_stats):
	level_text.text = "เลเวล " + str(new_level)
	hp_val.text = str(old_stats.max_hp) + " -> " + str(new_stats.max_hp)
	mp_val.text = str(old_stats.max_mana) + " -> " + str(new_stats.max_mana)
	atk_val.text = str(old_stats.atk) + " -> " + str(new_stats.atk)
	def_val.text = str(old_stats.def) + " -> " + str(new_stats.def)
	
	visible = true
	get_tree().paused = true # Optional: pause game while showing level up

func _on_close_pressed():
	visible = false
	get_tree().paused = false
