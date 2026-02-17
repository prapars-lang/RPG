extends Control

@onready var slot1_label = $Panel/VBoxContainer/SlotsContainer/Slot1/SlotLabel
@onready var slot2_label = $Panel/VBoxContainer/SlotsContainer/Slot2/SlotLabel
@onready var slot3_label = $Panel/VBoxContainer/SlotsContainer/Slot3/SlotLabel

@onready var load_btn1 = $Panel/VBoxContainer/SlotsContainer/Slot1/LoadBtn1
@onready var load_btn2 = $Panel/VBoxContainer/SlotsContainer/Slot2/LoadBtn2
@onready var load_btn3 = $Panel/VBoxContainer/SlotsContainer/Slot3/LoadBtn3

var slot_paths = [
	"user://savegame_slot1.save",
	"user://savegame_slot2.save",
	"user://savegame_slot3.save"
]

func _ready():
	_apply_theme()
	refresh_slots()
	
	# Connect hover signals for static buttons
	for btn in get_tree().get_nodes_in_group("save_load_btns"): # Assuming they might be in a group, or just find them
		_setup_btn_hover(btn)
	
	# Alternatively, just find all buttons in the VBox
	for btn in $Panel/VBoxContainer.find_children("*", "Button", true):
		_setup_btn_hover(btn)

func _apply_theme():
	"""Apply premium UI theme to save/load menu"""
	# Style slot labels
	for label in [slot1_label, slot2_label, slot3_label]:
		label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
		label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	# Style all buttons
	for btn in [load_btn1, load_btn2, load_btn3]:
		UIThemeManager.apply_button_theme(btn)
	
	# Find delete/close buttons and style them too
	for btn in $Panel/VBoxContainer.find_children("*", "Button", true):
		if btn not in [load_btn1, load_btn2, load_btn3]:
			UIThemeManager.apply_button_theme(btn)

func _setup_btn_hover(btn: Button):
	btn.pivot_offset = btn.size / 2
	if not btn.mouse_entered.is_connected(_on_btn_hover.bind(btn)):
		btn.mouse_entered.connect(_on_btn_hover.bind(btn))
	if not btn.mouse_exited.is_connected(_on_btn_unhover.bind(btn)):
		btn.mouse_exited.connect(_on_btn_unhover.bind(btn))

func _on_btn_hover(btn: Button):
	create_tween().tween_property(btn, "scale", Vector2(1.05, 1.05), 0.1)

func _on_btn_unhover(btn: Button):
	create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)

func refresh_slots():
	var labels = [slot1_label, slot2_label, slot3_label]
	var load_btns = [load_btn1, load_btn2, load_btn3]
	
	for i in range(3):
		if FileAccess.file_exists(slot_paths[i]):
			var save_info = load_slot_info(i + 1)
			if save_info:
				labels[i].text = "ช่องที่ %d: Lv.%d - %s" % [i + 1, save_info.level, save_info.name]
				load_btns[i].disabled = false
		else:
			labels[i].text = "ช่องที่ %d: (ว่าง)" % (i + 1)
			load_btns[i].disabled = true

func load_slot_info(slot_num):
	var path = slot_paths[slot_num - 1]
	if not FileAccess.file_exists(path):
		return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		return {
			"name": data.get("name", "ผู้กล้า"),
			"level": data.get("level", 1)
		}
	return null

func save_to_slot(slot_num):
	var save_data = {
		"name": Global.player_name,
		"gender": Global.player_gender,
		"class": Global.player_class,
		"level": Global.player_level,
		"xp": Global.player_xp,
		"gold": Global.player_gold,
		"stats": Global.stats,
		"inventory": Global.inventory,
		"story_progress": Global.story_progress,
		"current_path": Global.current_path,
		"current_scene": Global.current_scene,
		"equipped_items": Global.equipped_items,
		"enhancement_levels": Global.enhancement_levels,
		"active_quests": Global.active_quests,
		"completed_quests": Global.completed_quests,
		"used_questions": Global.used_questions
	}
	
	var path = slot_paths[slot_num - 1]
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	print("Game saved to slot ", slot_num)
	refresh_slots()

func load_from_slot(slot_num):
	var path = slot_paths[slot_num - 1]
	if not FileAccess.file_exists(path):
		print("No save file in slot ", slot_num)
		return false
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		Global.player_name = data.get("name", "ผู้กล้า")
		Global.player_gender = data.get("gender", "เด็กชาย")
		Global.player_class = data.get("class", "อัศวิน")
		Global.player_level = data.get("level", 1)
		Global.player_xp = data.get("xp", 0)
		Global.player_gold = data.get("gold", 0)
		if "stats" in data: Global.stats = data["stats"]
		if "inventory" in data: Global.inventory = data["inventory"]
		if "story_progress" in data: Global.story_progress = data["story_progress"]
		if "current_path" in data: Global.current_path = data["current_path"]
		if "current_scene" in data: Global.current_scene = data["current_scene"]
		
		# Load equipment data (with backward compatibility)
		if "equipped_items" in data:
			var loaded_equip = data["equipped_items"]
			for slot in Global.equipped_items:
				if slot in loaded_equip:
					Global.equipped_items[slot] = loaded_equip[slot]
			# Migrate old "armor" slot to "body"
			if "armor" in loaded_equip and loaded_equip["armor"] != null:
				Global.equipped_items["body"] = loaded_equip["armor"]
		if "enhancement_levels" in data:
			var loaded_enh = data["enhancement_levels"]
			for slot in Global.enhancement_levels:
				if slot in loaded_enh:
					Global.enhancement_levels[slot] = loaded_enh[slot]
		if "active_quests" in data: Global.active_quests = data["active_quests"]
		if "completed_quests" in data: Global.completed_quests = data["completed_quests"]
		if "used_questions" in data: Global.used_questions = data["used_questions"]
		
		print("Game loaded from slot ", slot_num)
		
		# Unpause the game before changing scene
		get_tree().paused = false
		
		# Change to saved scene
		var target_scene = Global.current_scene
		if target_scene == "" or target_scene == "res://Scenes/MainMenu.tscn":
			target_scene = "res://Scenes/Crossroads.tscn"
		get_tree().change_scene_to_file(target_scene)
		return true
	return false

func _on_save_btn_pressed(slot_num):
	save_to_slot(slot_num)

func _on_load_btn_pressed(slot_num):
	load_from_slot(slot_num)

func _on_close_btn_pressed():
	queue_free()
