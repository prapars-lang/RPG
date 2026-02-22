extends Node

# BattleEffectManager.gd - Specialized module for visual combat effects
# Part of the Premium Battle Polish system

static func shake_camera(camera: Camera2D, intensity: float, duration: float):
	if not is_instance_valid(camera) or not camera.is_inside_tree(): return
	
	var original_pos = camera.offset
	var elapsed = 0.0
	var scene_tree = camera.get_tree()
	
	while elapsed < duration:
		if not is_instance_valid(camera) or not camera.is_inside_tree(): break
		
		var offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		camera.offset = original_pos + offset
		
		# Robust timer await
		if is_instance_valid(scene_tree):
			await scene_tree.create_timer(0.02).timeout
		else:
			break
		elapsed += 0.02
	
	if is_instance_valid(camera):
		camera.offset = original_pos

static func show_damage_number(parent: Node, amount: Variant, position: Vector2, color: Color = Color.RED):
	if not is_instance_valid(parent) or not parent.is_inside_tree(): return
	
	var label = Label.new()
	label.text = str(amount)
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	label.position = position
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	parent.add_child(label)
	
	var tween = label.create_tween()
	# Jump up and fade out
	tween.set_parallel(true)
	tween.tween_property(label, "position", position + Vector2(randf_range(-50, 50), -150), 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.8).set_delay(0.4)
	
	tween.finished.connect(func(): if is_instance_valid(label): label.queue_free())

static func flash_sprite(sprite: CanvasItem, color: Color = Color(1.5, 0.5, 0.5), duration: float = 0.2):
	if not is_instance_valid(sprite) or not sprite.is_inside_tree(): return
	
	# To avoid "sticking" if called multiple times, we'll assume 
	# the target is always Color.WHITE (normal) in this game's context.
	var target_color = Color.WHITE
	sprite.modulate = color
	
	var tween = sprite.create_tween()
	if tween:
		tween.tween_property(sprite, "modulate", target_color, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
