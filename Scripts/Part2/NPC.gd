extends Area2D

@export var npc_name = "NPC"
@export var dialogue_key = ""

var player_in_range = false
var player_ref = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$Label.hide()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		trigger_dialogue()

func _on_body_entered(body):
	if body.name == "OverworldPlayer":
		player_in_range = true
		player_ref = body
		$Label.show()

func _on_body_exited(body):
	if body.name == "OverworldPlayer":
		player_in_range = false
		player_ref = null
		$Label.hide()

func trigger_dialogue():
	print("Talking to " + npc_name)
	if dialogue_key != "":
		# Setup Global state for Part 2 Story
		Global.is_part2_story = true
		Global.current_story_key = dialogue_key
		Global.story_progress = 0 # Start from beginning of this dialogue chain
		
		# Save position to return later
		if player_ref:
			Global.last_overworld_position = player_ref.global_position
			
		Global.last_overworld_scene = get_tree().current_scene.scene_file_path
		
		get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")
