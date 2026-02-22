extends Control

@onready var sp_label = $VBox/Header/SPLabel
@onready var fire_grid = $VBox/TabContainer/Fire/Grid
@onready var water_grid = $VBox/TabContainer/Water/Grid
@onready var nature_grid = $VBox/TabContainer/Nature/Grid
@onready var earth_grid = $VBox/TabContainer/Earth/Grid

var SkillTreeData = load("res://Scripts/Part2/SkillTreeData.gd")

func _ready():
	_update_sp_display()
	_refresh_all_grids()

func _update_sp_display():
	sp_label.text = "แต้มทักษะ: " + str(Global.skill_points)

func _refresh_all_grids():
	_populate_grid(fire_grid, Global.ELEMENT_FIRE)
	_populate_grid(water_grid, Global.ELEMENT_WATER)
	_populate_grid(nature_grid, Global.ELEMENT_NATURE)
	_populate_grid(earth_grid, Global.ELEMENT_EARTH)

func _populate_grid(grid, element):
	# Clear old nodes
	for child in grid.get_children():
		child.queue_free()
	
	var skills = SkillTreeData.get_skills_by_element(element)
	
	for skill in skills:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(280, 180)
		
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_theme_constant_override("separation", 10)
		panel.add_child(vbox)
		
		# Skill Name
		var name_lbl = Label.new()
		name_lbl.text = skill.name
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.add_theme_font_size_override("font_size", 22)
		vbox.add_child(name_lbl)
		
		# Skill Desc
		var desc_lbl = Label.new()
		desc_lbl.text = skill.description
		desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.custom_minimum_size = Vector2(240, 0)
		vbox.add_child(desc_lbl)
		
		# Button
		var btn = Button.new()
		var is_unlocked = Global.unlocked_skills.has(skill.id)
		
		if is_unlocked:
			btn.text = "เรียนรู้แล้ว"
			btn.disabled = true
		else:
			# Check Prereq
			var prereq_met = true
			for pre in skill.prereq:
				if not Global.unlocked_skills.has(pre):
					prereq_met = false
					break
			
			if not prereq_met:
				btn.text = "ยังปลดล็อคไม่ได้"
				btn.disabled = true
			else:
				btn.text = "เรียนรู้ (%d SP)" % skill.cost
				btn.disabled = Global.skill_points < skill.cost
				btn.pressed.connect(_on_buy_skill.bind(skill))
		
		UIThemeManager.apply_button_theme(btn)
		vbox.add_child(btn)
		
		grid.add_child(panel)

func _on_buy_skill(skill):
	if Global.skill_points >= skill.cost:
		Global.skill_points -= skill.cost
		Global.unlocked_skills.append(skill.id)
		
		if AudioManager.has_method("play_sfx"):
			AudioManager.play_sfx("levelup")
			
		_update_sp_display()
		_refresh_all_grids()
		Global.save_game()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Part2/WorldMap.tscn")
