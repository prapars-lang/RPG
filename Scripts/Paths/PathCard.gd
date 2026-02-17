extends Control

# PathCard.gd - Controller for a single path selection card
# Part of the Complete Path Expansion System

signal selected(path_id)

@onready var icon_rect = $CardPanel/VBox/MarginContainer/Icon
@onready var title_label = $CardPanel/VBox/Title
@onready var subtitle_label = $CardPanel/VBox/Subtitle
@onready var desc_label = $CardPanel/VBox/Description
@onready var card_panel = $CardPanel

var path_id = ""

func setup(data: Dictionary):
	path_id = data.id
	title_label.text = data.title
	subtitle_label.text = data.subtitle
	desc_label.text = data.description
	
	# Style the card based on path color
	var style = UIThemeManager.create_panel_style()
	style.bg_color = data.bg_color
	style.bg_color.a = 0.6 # Glassy look
	style.border_color = data.bg_color.lerp(Color.WHITE, 0.4)
	card_panel.add_theme_stylebox_override("panel", style)
	
	if ResourceLoader.exists(data.icon):
		icon_rect.texture = load(data.icon)
		_start_icon_animation()

func _start_icon_animation():
	icon_rect.pivot_offset = Vector2(icon_rect.size.x / 2, icon_rect.size.y / 2)
	var t = create_tween().set_loops()
	t.tween_property(icon_rect, "scale", Vector2(1.08, 1.08), 3.0).set_trans(Tween.TRANS_SINE)
	t.tween_property(icon_rect, "scale", Vector2(1.0, 1.0), 3.0).set_trans(Tween.TRANS_SINE)

func _on_btn_pressed():
	emit_signal("selected", path_id)

func _on_mouse_entered():
	AudioManager.play_sfx("button_hover", -15.0)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_panel, "modulate", Color(1.2, 1.2, 1.2, 1.0), 0.2)

func _on_mouse_exited():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card_panel, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
