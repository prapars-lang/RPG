extends Control

const PathData = preload("res://Scripts/Paths/PathData.gd")
const PathCardScene = preload("res://Scenes/PathCard.tscn")

@onready var grid_container = $GridContainer

var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null

func _ready():
	print("At the Crossroads...")
	
	# Track current scene
	Global.current_scene = "res://Scenes/Crossroads.tscn"
	
	# Add PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	# Populate Paths
	setup_paths()

func setup_paths():
	# Clear existing if any
	for child in grid_container.get_children():
		child.queue_free()
		
	var paths = PathData.get_all_paths()
	for data in paths:
		var card = PathCardScene.instantiate()
		grid_container.add_child(card)
		card.setup(data)
		card.selected.connect(_on_path_selected)

func _on_path_selected(path_name):
	print("Player chose path: ", path_name)
	Global.current_path = path_name
	
	Global.is_story_mode = true
	Global.story_progress = 0 # Start from beginning
	
	# Transition to Story Scene
	print("Transitioning to StoryScene...")
	get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")

func _on_shop_pressed():
	print("Entering Shop from Crossroads...")
	get_tree().change_scene_to_file("res://Scenes/Shop.tscn")
