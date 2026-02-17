extends Node
# UIThemeManager.gd - Centralized UI theme and styling system
# Usage: Use this from any scene to create consistent, premium-looking UIs

class_name UIThemeManager

# Color Palette (Constants)
const COLOR_PRIMARY = Color(0.4, 1.0, 0.6, 1.0)           # Green
const COLOR_PRIMARY_DARK = Color(0.2, 0.6, 0.4, 1.0)      # Dark Green
const COLOR_PRIMARY_DARKER = Color(0.15, 0.25, 0.2, 0.75) # Very Dark Green
const COLOR_ACCENT = Color(1.0, 0.8, 0.3, 1.0)            # Gold
const COLOR_TEXT = Color(0.95, 0.95, 0.95, 1.0)           # Light
const COLOR_TEXT_DARK = Color(0.2, 0.2, 0.2, 1.0)         # Dark text
const COLOR_DARK_BG = Color(0.05, 0.05, 0.1, 0.85)        # Dark background
const COLOR_ERROR = Color(1.0, 0.2, 0.2, 1.0)             # Red
const COLOR_SUCCESS = Color(0.2, 1.0, 0.4, 1.0)           # Green variant
const COLOR_WARNING = Color(1.0, 0.7, 0.2, 1.0)           # Orange

# Font Sizes
const FONT_SIZE_HUGE = 72
const FONT_SIZE_LARGE = 48
const FONT_SIZE_BIG = 36
const FONT_SIZE_TITLE = 28
const FONT_SIZE_NORMAL = 24
const FONT_SIZE_SMALL = 18
const FONT_SIZE_TINY = 14

# Animations
const ANIM_DURATION_QUICK = 0.1
const ANIM_DURATION_SHORT = 0.15
const ANIM_DURATION_NORMAL = 0.3
const ANIM_DURATION_LONG = 0.5
const ANIM_DURATION_VERY_LONG = 1.0

# ==================== BUTTON STYLES ====================

static func create_button_normal() -> StyleBoxFlat:
	"""Create normal state button style"""
	var style = StyleBoxFlat.new()
	style.bg_color = COLOR_PRIMARY_DARKER
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15
	style.border_width_left = 2.5
	style.border_width_top = 2.5
	style.border_width_right = 2.5
	style.border_width_bottom = 2.5
	style.border_color = Color(0.4, 1.0, 0.6, 0.6)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.4)
	style.shadow_size = 8
	return style

static func create_button_hover() -> StyleBoxFlat:
	"""Create hover state button style"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.25, 0.35, 0.3, 0.95)
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = COLOR_ACCENT
	style.shadow_color = COLOR_PRIMARY
	style.shadow_size = 15
	return style

static func create_button_pressed() -> StyleBoxFlat:
	"""Create pressed state button style"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.35, 0.5, 0.4, 1.0)
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = COLOR_ACCENT
	style.shadow_color = COLOR_PRIMARY
	style.shadow_size = 12
	return style

static func apply_button_theme(btn: Button, size: int = FONT_SIZE_TITLE) -> void:
	"""Apply complete premium button theme"""
	btn.add_theme_stylebox_override("normal", create_button_normal())
	btn.add_theme_stylebox_override("hover", create_button_hover())
	btn.add_theme_stylebox_override("pressed", create_button_pressed())
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	
	btn.add_theme_color_override("font_color", COLOR_TEXT)
	btn.add_theme_color_override("font_hover_color", COLOR_ACCENT)
	btn.add_theme_color_override("font_pressed_color", COLOR_ACCENT)
	btn.add_theme_font_size_override("font_size", size)

# ==================== LABEL STYLES ====================

static func apply_title_theme(label: Label) -> void:
	"""Apply title label styling"""
	label.add_theme_color_override("font_color", COLOR_ACCENT)
	label.add_theme_font_size_override("font_size", FONT_SIZE_HUGE)

static func apply_subtitle_theme(label: Label) -> void:
	"""Apply subtitle label styling"""
	label.add_theme_color_override("font_color", COLOR_TEXT)
	label.add_theme_font_size_override("font_size", FONT_SIZE_NORMAL)

static func apply_text_theme(label: Label, size: int = FONT_SIZE_NORMAL) -> void:
	"""Apply body text styling"""
	label.add_theme_color_override("font_color", COLOR_TEXT)
	label.add_theme_font_size_override("font_size", size)

# ==================== BOX STYLES ====================

static func create_panel_style() -> StyleBoxFlat:
	"""Create panel/container background"""
	var style = StyleBoxFlat.new()
	style.bg_color = COLOR_PRIMARY_DARKER
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = COLOR_PRIMARY
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.shadow_size = 8
	return style

static func apply_panel_theme(panel: PanelContainer) -> void:
	"""Apply panel styling"""
	panel.add_theme_stylebox_override("panel", create_panel_style())

# ==================== ANIMATIONS ====================

static func animate_button_hover(btn: Button, target_scale: float = 1.08) -> Tween:
	"""Animate button on hover"""
	var tween = btn.create_tween()
	tween.set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(target_scale, target_scale), ANIM_DURATION_SHORT)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	var glow = btn.create_tween()
	glow.tween_property(btn, "modulate", Color(1.2, 1.2, 1.2, 1.0), ANIM_DURATION_SHORT)
	
	return tween

static func animate_button_exit(btn: Button) -> Tween:
	"""Animate button exit hover"""
	var tween = btn.create_tween()
	tween.set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), ANIM_DURATION_SHORT)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	var glow = btn.create_tween()
	glow.tween_property(btn, "modulate", Color(1.0, 1.0, 1.0, 1.0), ANIM_DURATION_SHORT)
	
	return tween

static func animate_fade_in(node: CanvasItem, duration: float = ANIM_DURATION_NORMAL) -> void:
	"""Fade in animation"""
	node.modulate.a = 0.0
	var tween = node.create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

static func animate_fade_out(node: CanvasItem, duration: float = ANIM_DURATION_LONG) -> void:
	"""Fade out animation"""
	var tween = node.create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

static func animate_floating(node: Node, offset_y: float = 15.0, duration: float = 2.5) -> void:
	"""Floating animation (up and down) for both Node2D and Control nodes"""
	var start_y = node.position.y
	var tween = node.create_tween().set_loops()
	tween.tween_property(node, "position:y", start_y - offset_y, duration)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "position:y", start_y, duration)
	tween.set_trans(Tween.TRANS_SINE)

static func animate_glow(label: Label) -> void:
	"""Glow pulsing animation for labels"""
	var tween = label.create_tween().set_loops()
	tween.tween_property(label, "modulate:a", 0.6, 1.5)
	tween.tween_property(label, "modulate:a", 1.0, 1.5)

static func play_transition_fade(tree: SceneTree) -> void:
	"""Play scene transition effect"""
	var root = tree.root
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.modulate.a = 0.0
	root.add_child(overlay)
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	
	var tween = overlay.create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, ANIM_DURATION_LONG)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

# ==================== SCREEN EFFECTS ====================

static func create_dark_overlay(alpha: float = 0.35) -> ColorRect:
	"""Create dark overlay for readability"""
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, alpha)
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	return overlay

static func create_gradient_overlay() -> ColorRect:
	"""Create gradient overlay (dark bottom)"""
	var overlay = ColorRect.new()
	var gradient = GradientTexture2D.new()
	var grad = Gradient.new()
	grad.set_color(0, Color(0, 0, 0, 0))
	grad.set_color(1, Color(0, 0, 0, 0.6))
	gradient.gradient = grad
	overlay.texture = gradient
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	return overlay

# ==================== GREEN GLASS STYLES (Village) ====================

static func create_green_glass_normal() -> StyleBoxFlat:
	"""Create green glassmorphism button style for village"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.45, 0.2, 0.75)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.3, 0.8, 0.4, 0.6)
	style.shadow_color = Color(0.1, 0.5, 0.2, 0.3)
	style.shadow_size = 6
	style.content_margin_left = 20
	style.content_margin_top = 15
	style.content_margin_right = 20
	style.content_margin_bottom = 15
	return style

static func create_green_glass_hover() -> StyleBoxFlat:
	"""Create hover state for green glass button"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.55, 0.25, 0.85)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = Color(0.4, 1.0, 0.5, 0.8)
	style.shadow_color = Color(0.2, 0.8, 0.3, 0.5)
	style.shadow_size = 12
	style.content_margin_left = 20
	style.content_margin_top = 15
	style.content_margin_right = 20
	style.content_margin_bottom = 15
	return style

static func create_green_glass_pressed() -> StyleBoxFlat:
	"""Create pressed state for green glass button"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.35, 0.15, 0.9)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = COLOR_ACCENT
	style.shadow_color = Color(0.1, 0.6, 0.2, 0.4)
	style.shadow_size = 8
	style.content_margin_left = 20
	style.content_margin_top = 15
	style.content_margin_right = 20
	style.content_margin_bottom = 15
	return style

static func apply_green_glass_theme(btn: Button, size: int = FONT_SIZE_TITLE) -> void:
	"""Apply green glassmorphism theme to a button"""
	btn.add_theme_stylebox_override("normal", create_green_glass_normal())
	btn.add_theme_stylebox_override("hover", create_green_glass_hover())
	btn.add_theme_stylebox_override("pressed", create_green_glass_pressed())
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	
	btn.add_theme_color_override("font_color", COLOR_TEXT)
	btn.add_theme_color_override("font_hover_color", Color(1.0, 1.0, 1.0, 1.0))
	btn.add_theme_color_override("font_pressed_color", COLOR_ACCENT)
	btn.add_theme_font_size_override("font_size", size)

# ==================== UTILITY ====================

static func hex_to_color(hex: String) -> Color:
	"""Convert hex color string to Color"""
	hex = hex.trim_prefix("#")
	return Color.html(hex)

static func create_color_from_theme(color_type: String) -> Color:
	"""Create color based on type"""
	match color_type:
		"primary":
			return COLOR_PRIMARY
		"primary_dark":
			return COLOR_PRIMARY_DARK
		"accent":
			return COLOR_ACCENT
		"text":
			return COLOR_TEXT
		"error":
			return COLOR_ERROR
		"success":
			return COLOR_SUCCESS
		_:
			return COLOR_TEXT
