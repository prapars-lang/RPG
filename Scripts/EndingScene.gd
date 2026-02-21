extends Control

@onready var credits_label = $ScrollContainer/VBoxContainer/CreditsLabel
@onready var scroll_container = $ScrollContainer

var scroll_speed = 60.0
var is_scrolling = true

func _ready():
	# Play Ending Music
	if AudioManager.current_bgm_key != "victory":
		AudioManager.play_bgm("victory")
	
	setup_credits()

func _process(delta):
	if is_scrolling:
		scroll_container.scroll_vertical += scroll_speed * delta
		
		# Check if reached bottom
		if scroll_container.scroll_vertical >= scroll_container.get_v_scroll_bar().max_value - scroll_container.size.y:
			is_scrolling = false
			await get_tree().create_timer(2.0).timeout
			$ReturnButton.visible = true
			$ReturnButton.grab_focus()
			# Enable Part 2 Button if available
			if has_node("Part2Button"):
				$Part2Button.visible = true

func setup_credits():
	var text = "[center][b][font_size=40]Congratulations![/font_size][/b]\n\n"
	text += "คุณได้กอบกู้ดินแดน Vita Fantasy สำเร็จ!\n"
	text += "ความรู้ของคุณได้ชำระล้างความเขลาไปจนหมดสิ้น\n\n"
	text += "[font_size=24]Created by[/font_size]\nTheka (Gemini Agent)\n\n"
	text += "[font_size=24]Special Thanks[/font_size]\nGodot Engine\nNotebookLM\nAnd YOU, the Player!\n\n\n"
	text += "ขอบคุณที่ร่วมผจญภัยไปกับเรา\n\n\n\n"
	text += "[THE END][/center]"
	
	credits_label.text = text

func _on_return_button_pressed():
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_part2_button_pressed():
	AudioManager.play_sfx("button_click")
	print("Starting Part 2...")
	# Future: Load specialized Part 2 init logic here
	get_tree().change_scene_to_file("res://Scenes/Part2/IntroPart2.tscn")

