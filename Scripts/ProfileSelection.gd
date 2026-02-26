extends Control

@onready var profile_list_container = $Panel/VBoxContainer/ScrollContainer/ProfileList
@onready var name_input = $Panel/VBoxContainer/CreatePanel/HBox/NameInput
@onready var status_label = $Panel/VBoxContainer/StatusLabel

func _ready():
	_apply_styling()
	refresh_list()
	status_label.text = "กรุณาเลือกโปรไฟล์หรือสร้างใหม่"

func _apply_styling():
	# Use UIThemeManager if available, or manual styling
	$Panel.self_modulate = Color(0.1, 0.1, 0.15, 0.9)
	if has_node("Panel/VBoxContainer/Title"):
		$Panel/VBoxContainer/Title.add_theme_font_size_override("font_size", 32)
		$Panel/VBoxContainer/Title.add_theme_color_override("font_color", Color.GOLD)

func refresh_list():
	# Clear existing
	for child in profile_list_container.get_children():
		child.queue_free()
	
	var profiles = ProfileManager.get_profile_list()
	
	if profiles.size() == 0:
		var empty_lbl = Label.new()
		empty_lbl.text = "(ยังไม่มีโปรไฟล์)"
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		profile_list_container.add_child(empty_lbl)
	else:
		for p in profiles:
			_create_profile_row(p)

func _create_profile_row(data: Dictionary):
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	profile_list_container.add_child(hbox)
	
	var btn = Button.new()
	btn.text = "%s (LP: %d | เลเวลสูงสุด: %d)" % [data.name, data.total_lp, data.max_level]
	btn.custom_minimum_size.y = 50
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.add_theme_font_size_override("font_size", 20)
	btn.pressed.connect(_on_profile_selected.bind(data.name))
	hbox.add_child(btn)
	
	var del_btn = Button.new()
	del_btn.text = " X "
	del_btn.custom_minimum_size.x = 50
	del_btn.add_theme_color_override("font_color", Color.RED)
	del_btn.pressed.connect(_on_delete_pressed.bind(data.name))
	hbox.add_child(del_btn)

func _on_delete_pressed(p_name: String):
	# Simple confirmation could be added here
	ProfileManager.delete_profile(p_name)
	refresh_list()

func _on_create_btn_pressed():
	var new_name = name_input.text.strip_edges()
	if new_name == "":
		status_label.text = "กรุณากรอกชื่อ!"
		return
	
	if ProfileManager.create_profile(new_name):
		name_input.text = ""
		status_label.text = "สร้างโปรไฟล์ '%s' สำเร็จ" % new_name
		refresh_list()
	else:
		status_label.text = "ชื่อนี้มีอยู่ในระบบแล้ว!"

func _on_profile_selected(p_name: String):
	ProfileManager.set_active_profile(p_name)
	status_label.text = "เลือกโปรไฟล์: %s" % p_name
	
	# Transition to Main Menu or Character Selection
	AudioManager.play_sfx("button_click")
	
	# If they have a save file, maybe go to Main Menu, else Character Selection?
	# For now, just go to Main Menu as the "active" profile
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
