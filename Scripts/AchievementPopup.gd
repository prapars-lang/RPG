extends Control

@onready var icon_label = $Panel/HBox/Icon
@onready var title_label = $Panel/HBox/VBox/Title
@onready var desc_label = $Panel/HBox/VBox/Desc

func setup(id: String):
	var data = Global.get_achievement_info(id)
	icon_label.text = data.get("icon", "🏆")
	title_label.text = data.get("name", "Achievement Unlocked!")
	desc_label.text = data.get("desc", "")
	
	# Animate In
	var tween = create_tween()
	tween.tween_property(self, "position:y", 20.0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_interval(3.0)
	tween.tween_property(self, "position:y", -150.0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)

func _ready():
	# Initial position off-screen
	position.y = -150
