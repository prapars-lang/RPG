extends Control

const PathData = preload("res://Scripts/Paths/PathData.gd")
const PathCardScene = preload("res://Scenes/PathCard.tscn")

@onready var grid_container = $MainLayout/GridContainer
@onready var guide_sprite = $MainLayout/NPCSection/GuideSprite
@onready var sidebar = $Sidebar
@onready var title_label = $TitleLabel
@onready var instruction_label = $InstructionLabel

var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null

func _ready():
	print("At the Crossroads...")
	
	# Apply theme styling
	_apply_theme()
	
	# Track current scene
	Global.current_scene = "res://Scenes/Crossroads.tscn"
	
	# Play crossroads/forest ambient music
	AudioManager.play_bgm("forest", 1.5)
	
	# Add PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	# Populate Paths
	setup_paths()
	
	# Check for mastery summary
	if Global.check_all_paths_completed():
		_add_mastery_button()
	
	# Animate Appearance
	UIThemeManager.animate_fade_in(self, 1.0)

func _add_mastery_button():
	"""Add a special mastery button to the sidebar"""
	var summary_btn = Button.new()
	summary_btn.text = "🏆 สรุปการเรียนรู้"
	summary_btn.custom_minimum_size = Vector2(0, 50)
	$Sidebar/VBox.add_child(summary_btn)
	UIThemeManager.apply_button_theme(summary_btn, UIThemeManager.FONT_SIZE_SMALL)
	summary_btn.pressed.connect(_on_summary_pressed)
	
	# Highlight the button
	summary_btn.modulate = Color(1.0, 0.9, 0.4) # Gold tint

func _on_summary_pressed():
	AudioManager.play_sfx("menu_open")
	var summary_scene = load("res://Scenes/LearningSummary.tscn")
	if summary_scene:
		var summary = summary_scene.instantiate()
		add_child(summary)

func _apply_theme():
	"""Apply premium UI theme to crossroads"""
	UIThemeManager.apply_title_theme(title_label)
	UIThemeManager.apply_subtitle_theme(instruction_label)
	
	# Style Sidebar
	var side_style = UIThemeManager.create_panel_style()
	side_style.bg_color = Color(0, 0, 0, 0.6)
	sidebar.add_theme_stylebox_override("panel", side_style)
	
	# Style Sidebar Buttons
	for btn in $Sidebar/VBox.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn, UIThemeManager.FONT_SIZE_SMALL)

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
	AudioManager.play_sfx("button_click")
	
	Global.current_path = path_name
	
	# Auto-activate the quest for the selected path
	var quest_id = path_name + "_start"
	if not QuestManager.is_quest_active(quest_id) and not QuestManager.is_quest_completed(quest_id):
		QuestManager.activate_quest(quest_id)
		print("Auto-activated quest: ", quest_id)
	
	Global.is_story_mode = true
	Global.story_progress = 0 # Start from beginning
	
	# Transition to Story Scene
	print("Transitioning to StoryScene...")
	get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")

func _on_shop_pressed():
	print("Entering Shop from Crossroads...")
	AudioManager.play_sfx("menu_open")
	get_tree().change_scene_to_file("res://Scenes/Shop.tscn")

func _on_talk_pressed():
	print("Talking to Guide in Crossroads...")
	NPCDialogUI.show_npc_dialog("guide_path")

func _on_return_to_town_pressed():
	print("Returning to Vita Village...")
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/TownHub.tscn")
