extends Control

@onready var continue_btn = $MainContainer/ContinueBtn

func _ready():
	# Check if save file exists and enable/disable Continue button
	if Global.has_save_file():
		continue_btn.disabled = false
	else:
		continue_btn.disabled = true

func _on_start_btn_pressed():
	print("Starting New Game...")
	# Reset Global state for new game
	Global.player_level = 1
	Global.player_xp = 0
	Global.player_gold = 0
	Global.story_progress = 0
	Global.current_path = ""
	Global.used_questions = []
	Global.inventory = {
		"potion": 2,
		"mana_refill": 1
	}
	# Navigate to Character Selection
	get_tree().change_scene_to_file("res://Scenes/CharacterSelection.tscn")

func _on_continue_btn_pressed():
	print("Loading saved game...")
	Global.load_and_start()

func _on_options_btn_pressed():
	print("Options menu (placeholder)")
	# TODO: Create OptionsMenu scene

func _on_credits_btn_pressed():
	print("Credits screen (placeholder)")
	# TODO: Create Credits scene

func _on_exit_btn_pressed():
	get_tree().quit()
