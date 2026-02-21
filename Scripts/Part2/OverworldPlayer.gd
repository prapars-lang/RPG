extends CharacterBody2D

const SPEED = 200.0
const ENCOUNTER_CHANCE = 5.0 # 5% per check
const STEPS_TO_CHECK = 50.0 # Check every 50 pixels moved

# Map boundaries — set per-map or auto-detect
@export var map_size = Vector2(1920, 1080)
@export var map_origin = Vector2(0, 0) # Top-left corner of the map

var steps_taken = 0.0
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer # Optional if we add animations later
@onready var camera = $Camera2D

func _ready():
	if Global.is_overworld_mode and Global.last_overworld_position != Vector2.ZERO:
		global_position = Global.last_overworld_position
	
	# Enable overworld mode when this script loads
	Global.is_overworld_mode = true
	
	# Set camera limits to map bounds
	if camera:
		camera.limit_left = int(map_origin.x)
		camera.limit_top = int(map_origin.y)
		camera.limit_right = int(map_origin.x + map_size.x)
		camera.limit_bottom = int(map_origin.y + map_size.y)

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * SPEED
		
		# Simple Flip for visual feedback
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
			
		steps_taken += velocity.length() * delta
		if steps_taken >= STEPS_TO_CHECK:
			steps_taken = 0
			check_encounter()
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
	# Safety clamp — prevent falling off edges even if walls fail
	var margin = 20.0
	global_position.x = clamp(global_position.x, map_origin.x + margin, map_origin.x + map_size.x - margin)
	global_position.y = clamp(global_position.y, map_origin.y + margin, map_origin.y + map_size.y - margin)
	
	if Input.is_action_just_pressed("ui_focus_next"): # Tab or K usually
		toggle_skill_tree()

func toggle_skill_tree():
	var ui = get_node_or_null("SkillTreeUI")
	if ui:
		if ui.visible:
			ui.hide()
		else:
			ui.show()
			ui.update_ui()
	else:
		var skill_scene = load("res://Scenes/Part2/SkillTreeUI.tscn").instantiate()
		add_child(skill_scene)

func check_encounter():
	if randf() * 100 < ENCOUNTER_CHANCE:
		print("Encounter Triggered!")
		start_battle()

func start_battle():
	Global.last_overworld_position = global_position
	Global.last_overworld_scene = scene_file_path
	
	Global.queued_story_enemy_id = "" # Random enemy
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")
