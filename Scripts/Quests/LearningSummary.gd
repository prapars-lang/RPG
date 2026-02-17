extends Control

# LearningSummary.gd - Displays a summary of achievements after clearing all 4 paths

func _ready():
	_apply_theme()
	_animate_show()

func _apply_theme():
	"""Apply premium UI theme to the summary"""
	# Panel style
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = UIThemeManager.COLOR_DARK_BG
	panel_style.border_width_left = 3
	panel_style.border_width_top = 3
	panel_style.border_width_right = 3
	panel_style.border_width_bottom = 3
	panel_style.border_color = UIThemeManager.COLOR_ACCENT # Gold border for mastery
	panel_style.corner_radius_top_left = 20
	panel_style.corner_radius_top_right = 20
	panel_style.corner_radius_bottom_left = 20
	panel_style.corner_radius_bottom_right = 20
	panel_style.shadow_size = 20
	panel_style.shadow_color = Color(0, 0, 0, 0.5)
	
	$Panel.add_theme_stylebox_override("panel", panel_style)
	
	# Title
	$Panel/VBox/Header/Title.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	
	# Style the boxes in the grid
	for box in $Panel/VBox/Scroll/Grid.get_children():
		if box is VBoxContainer:
			var box_style = StyleBoxFlat.new()
			box_style.bg_color = Color(0.2, 0.2, 0.2, 0.4)
			box_style.corner_radius_top_left = 15
			box_style.corner_radius_top_right = 15
			box_style.corner_radius_bottom_left = 15
			box_style.corner_radius_bottom_right = 15
			box_style.content_margin_left = 20
			box_style.content_margin_top = 20
			box_style.content_margin_right = 20
			box_style.content_margin_bottom = 20
			
			# Add a dummy panel to wrap the box if needed, but for now just style the labels
			for label in box.get_children():
				if label.name == "PathTitle":
					label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
				elif label.name == "SummaryText":
					label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	
	# Close button
	UIThemeManager.apply_button_theme($Panel/VBox/Footer/CloseBtn)

func _animate_show():
	"""Smooth entry animation"""
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	var panel = $Panel
	panel.scale = Vector2(0.8, 0.8)
	tween.parallel().tween_property(panel, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_close_pressed():
	AudioManager.play_sfx("button_click")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.3)
	await tween.finished
	queue_free()
