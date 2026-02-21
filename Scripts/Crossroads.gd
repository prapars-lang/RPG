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
	
	# Add Knowledge Codex button to sidebar
	_add_codex_button()
	
	# Check for Secret Boss
	_check_secret_boss()
	
	# Animate Appearance
	UIThemeManager.animate_fade_in(self, 1.0)

func _add_mastery_button():
	"""Add a special mastery button to the sidebar"""
	var summary_btn = Button.new()
	# Changed to "The Core Gate"
	summary_btn.text = "🌌 ประตูสู่แก่นโลก"
	summary_btn.custom_minimum_size = Vector2(0, 50)
	$Sidebar/VBox.add_child(summary_btn)
	UIThemeManager.apply_button_theme(summary_btn, UIThemeManager.FONT_SIZE_SMALL)
	
	# Connect to Final Chapter Logic
	summary_btn.pressed.connect(_on_final_chapter_pressed)
	
	# Highlight the button with a pulsing effect or special color
	summary_btn.modulate = Color(0.8, 0.4, 1.0) # Purple tint for mystery
	
func _on_final_chapter_pressed():
	print("Entering the Final Chapter...")
	AudioManager.play_sfx("battle_start")
	
	# Setup for Story Mode (Final Path)
	Global.is_story_mode = true
	Global.current_path = "final"
	Global.story_progress = 0
	
	# Transition to Story Scene
	get_tree().change_scene_to_file("res://Scenes/StoryScene.tscn")

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

func _add_codex_button():
	"""Add Knowledge Codex button to sidebar"""
	var codex_btn = Button.new()
	var summary = Global.get_codex_summary()
	codex_btn.text = "📖 สมุดความรู้ (%d/%d)" % [summary.unlocked, summary.total]
	codex_btn.custom_minimum_size = Vector2(0, 50)
	$Sidebar/VBox.add_child(codex_btn)
	UIThemeManager.apply_button_theme(codex_btn, UIThemeManager.FONT_SIZE_SMALL)
	codex_btn.pressed.connect(_on_codex_pressed)

func _on_codex_pressed():
	AudioManager.play_sfx("menu_open")
	get_tree().change_scene_to_file("res://Scenes/CodexMenu.tscn")

func _check_secret_boss():
	if Global.is_codex_complete():
		var boss_btn = Button.new()
		boss_btn.text = "😈 ??? 😈"
		boss_btn.custom_minimum_size = Vector2(0, 50)
		boss_btn.add_theme_color_override("font_color", Color(1, 0.2, 0.2)) # Red Text
		$Sidebar/VBox.add_child(boss_btn)
		
		# Special Style for Boss Button
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.1, 0, 0, 0.8)
		style.border_width_bottom = 2
		style.border_color = Color.RED
		style.corner_radius_top_left = 5
		style.corner_radius_top_right = 5
		style.corner_radius_bottom_left = 5
		style.corner_radius_bottom_right = 5
		boss_btn.add_theme_stylebox_override("normal", style)
		
		boss_btn.pressed.connect(_on_secret_boss_pressed)

func _on_secret_boss_pressed():
	print("Challenging the Knowledge Guardian!")
	AudioManager.play_sfx("battle_start") # Or any ominous sound
	
	Global.is_story_mode = true
	Global.queued_story_enemy_id = "knowledge_guardian"
	
	# Transition to Battle
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")
