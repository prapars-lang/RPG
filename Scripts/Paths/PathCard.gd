extends Control

# PathCard.gd - Controller for a single path selection card
# Part of the Complete Path Expansion System

signal selected(path_id)

@onready var icon_rect = $VBox/Icon
@onready var title_label = $VBox/Title
@onready var subtitle_label = $VBox/Subtitle
@onready var desc_label = $VBox/Description
@onready var bg_rect = $Background

var path_id = ""

func setup(data: Dictionary):
	path_id = data.id
	title_label.text = data.title
	subtitle_label.text = data.subtitle
	desc_label.text = data.description
	bg_rect.color = data.bg_color
	
	if ResourceLoader.exists(data.icon):
		icon_rect.texture = load(data.icon)

func _on_btn_pressed():
	emit_signal("selected", path_id)

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
	bg_rect.color.a = 1.0

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	bg_rect.color.a = 0.8
