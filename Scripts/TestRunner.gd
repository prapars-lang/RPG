extends Control

@onready var log_display = $Panel/LogDisplay
@onready var status_label = $Panel/StatusLabel

func _ready():
	if Global.auto_tester:
		Global.auto_tester.test_log_updated.connect(_on_log_updated)
		status_label.text = "Ready to test."
	else:
		status_label.text = "Error: AutoTester not found!"

func _on_start_btn_pressed():
	if Global.auto_tester:
		Global.auto_tester.start_test()
		status_label.text = "Running..."
		# Load initial scene to start loop?
		# For full test, maybe start from Intro or Overworld
		if Global.is_part2_story:
			get_tree().change_scene_to_file("res://Scenes/Part2/IntroPart2.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")

func _on_stop_btn_pressed():
	if Global.auto_tester:
		Global.auto_tester.stop_test()
		status_label.text = "Stopped."

func _on_log_updated(msg):
	log_display.text += msg + "\n"
	log_display.scroll_to_line(log_display.get_line_count() - 1)

func _on_close_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
