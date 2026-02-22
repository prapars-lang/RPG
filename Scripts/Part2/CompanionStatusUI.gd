extends Control

# CompanionStatusUI.gd - Displays details of the current companion

@onready var companion_sprite = $Panel/VBox/CompanionPreview
@onready var name_label = $Panel/VBox/NameLabel
@onready var level_label = $Panel/VBox/LevelLabel
@onready var desc_label = $Panel/VBox/DescLabel
@onready var skill_info = $Panel/VBox/SkillInfo
@onready var stat_info = $Panel/VBox/StatInfo

func _ready():
	_apply_theme()
	_update_display()
	_animate_entry()

func _apply_theme():
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = UIThemeManager.COLOR_DARK_BG
	panel_style.set_corner_radius_all(20)
	panel_style.border_width_left = 3
	panel_style.border_width_top = 3
	panel_style.border_width_right = 3
	panel_style.border_width_bottom = 3
	panel_style.border_color = UIThemeManager.COLOR_PRIMARY
	$Panel.add_theme_stylebox_override("panel", panel_style)
	
	UIThemeManager.apply_button_theme($Panel/CloseBtn)
	
	name_label.add_theme_font_size_override("font_size", 32)
	name_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _update_display():
	var comp_id = Global.current_companion_id
	if comp_id == "":
		name_label.text = "ไม่มีคู่หู"
		return
		
	var comp_db = load("res://Scripts/Part2/CompanionData.gd").new()
	var data = comp_db.get_companion(Global.current_companion_id, Global.companion_bond)
	
	if data:
		name_label.text = data.name
		desc_label.text = data.description
		
		# Evolution Indicator
		if data.get("is_evolved", false):
			name_label.text = "🌟 " + data.name + " (Evolved)"
			name_label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			name_label.add_theme_color_override("font_color", Color.WHITE)
		
		if ResourceLoader.exists(data.sprite):
			companion_sprite.texture = load(data.sprite)
		
		# Skill Info
		var s = data.skill
		skill_info.text = "ทักษะพิเศษ: %s\n(%s, พลัง: %d, มานา: %d)" % [s.name, s.element.capitalize(), s.value, s.cost]
		
		# Bond Info
		var bond = Global.companion_bond
		var bond_bonus = min(bond, 50)
		level_label.text = "ระดับ: %d | ความผูกพัน: %d" % [Global.companion_level, bond]
		
		# Stat Info (Bonuses given to Hero)
		var bonuses = []
		if "atk" in data.stats: bonuses.append("เพิ่มพลังโจมตี +%d" % data.stats.atk)
		if "hp_bonus" in data.stats: 
			var final_hp = int(data.stats.hp_bonus * (1.0 + bond_bonus * 0.01))
			bonuses.append("เพิ่มพลังชีวิต +%d (โบนัสความผูกพัน +%d%%)" % [final_hp, bond_bonus])
		stat_info.text = "ผลต่อผู้กล้า:\n" + "\n".join(bonuses)

func _on_close_btn_pressed():
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("button_click")
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()

func _animate_entry():
	modulate.a = 0
	scale = Vector2(0.8, 0.8)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Floating animation for sprite
	UIThemeManager.animate_floating(companion_sprite, 15.0, 2.5)
