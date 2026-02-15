extends CanvasLayer

@onready var level_text = $Panel/VBox/LevelText
@onready var hp_val = $Panel/VBox/Grid/HPValue
@onready var mp_val = $Panel/VBox/Grid/MPValue
@onready var atk_val = $Panel/VBox/Grid/ATKValue
@onready var def_val = $Panel/VBox/Grid/DEFValue

func _ready():
	Global.level_up_occurred.connect(_show_levelup)

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
