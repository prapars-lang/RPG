extends Control

const CompanionData = preload("res://Scripts/Part2/CompanionData.gd")

@onready var option1_ui = $HBoxContainer/Option1
@onready var option2_ui = $HBoxContainer/Option2
@onready var option3_ui = $HBoxContainer/Option3
@onready var desc_label = $DescriptionLabel

var com_db = CompanionData.new()
var options = ["ignis_pup", "aqua_slime", "terra_golem"]

func _ready():
	_setup_option(option1_ui, options[0])
	_setup_option(option2_ui, options[1])
	_setup_option(option3_ui, options[2])

func _setup_option(container, id):
	var data = com_db.get_companion(id)
	if not data: return
	
	container.get_node("Name").text = data.name
	
	var sprite_path = data.sprite
	if ResourceLoader.exists(sprite_path):
		container.get_node("Sprite").texture = load(sprite_path)
	
	var btn = container.get_node("SelectBtn")
	btn.pressed.connect(_on_select_pressed.bind(id))
	btn.mouse_entered.connect(_on_hover.bind(id))

func _on_hover(id):
	var data = com_db.get_companion(id)
	desc_label.text = data.description + "\n(Skill: " + data.skill.name + ")"

func _on_select_pressed(id):
	print("Selected Companion: ", id)
	
	# Save to Global
	Global.current_companion_id = id
	
	# Fix: Use 'levelup' which exists in AudioManager.gd
	AudioManager.play_sfx("levelup") 
	
	# Proceed to Story — continue from next scene after companion_select
	await get_tree().create_timer(1.0).timeout
	Global.story_progress += 1 # Advance to the next scene in the chapter
	Global.save_game() # Save selection and progress
	get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")
