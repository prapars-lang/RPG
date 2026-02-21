extends Control

@onready var points_label = $Panel/PointsLabel
@onready var container = $Panel/ScrollContainer/GridContainer

const SkillTreeData = preload("res://Scripts/Part2/SkillTreeData.gd")

func _ready():
	update_ui()

func update_ui():
	points_label.text = "Elemental Points: " + str(Global.skill_points)
	
	# Clear existing
	for child in container.get_children():
		child.queue_free()
		
	# Populate Skills (showing all for now, sorted by element)
	for key in SkillTreeData.SKILLS:
		var skill = SkillTreeData.SKILLS[key]
		create_skill_node(skill)

func create_skill_node(skill):
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(150, 100)
	btn.text = skill.name + "\n(" + str(skill.cost) + " SP)"
	
	# Check unlock status
	if Global.has_skill(skill.id):
		btn.modulate = Color(0.5, 1, 0.5) # Green = Unlocked
		btn.disabled = true
		btn.text += "\n[UNLOCKED]"
	else:
		# Check prerequisites and cost
		var can_buy = can_afford(skill) and has_prereqs(skill)
		if not has_prereqs(skill):
			btn.modulate = Color(0.5, 0.5, 0.5) # Grey = Locked
			btn.disabled = true
			btn.text += "\n[LOCKED]"
		elif not can_afford(skill):
			btn.modulate = Color(1, 0.5, 0.5) # Red = Not enough points
			btn.disabled = true
		else:
			btn.modulate = Color(1, 1, 1) # Normal = Available
			
	btn.pressed.connect(_on_skill_pressed.bind(skill))
	container.add_child(btn)

func can_afford(skill):
	return Global.skill_points >= skill.cost

func has_prereqs(skill):
	for req in skill.prereq:
		if not Global.has_skill(req):
			return false
	return true

func _on_skill_pressed(skill):
	if Global.skill_points >= skill.cost:
		Global.skill_points -= skill.cost
		Global.unlock_skill(skill.id)
		update_ui()
	else:
		print("Not enough points!")

func _on_close_pressed():
	# Close menu (hide or queue_free depending on usage)
	hide()
