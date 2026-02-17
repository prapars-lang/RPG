extends Control

# TownHub.gd - Central hub for NPC interactions and resting

var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null

func _ready():
	Global.current_scene = "res://Scenes/TownHub.tscn"
	
	# Play peaceful town music
	AudioManager.play_bgm("menu", 2.0)
	
	# Add PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	_apply_theme()
	
	# Fade in
	UIThemeManager.animate_fade_in(self, 0.8)

func _apply_theme():
	"""Apply premium green glass UI theme to town hub"""
	# Title - Gold accent
	var title = $Title
	title.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	
	# Description line
	var desc = $DescriptionLine
	desc.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85, 0.8))
	
	# Apply green glass theme to all grid buttons
	for btn in $CenterContainer/AreasGrid.get_children():
		if btn is Button:
			UIThemeManager.apply_green_glass_theme(btn, UIThemeManager.FONT_SIZE_NORMAL)
	
	# Quest button - slightly different style (top-left corner)
	UIThemeManager.apply_green_glass_theme($QuestBtn, UIThemeManager.FONT_SIZE_NORMAL)

func _on_library_pressed():
	AudioManager.play_sfx("button_click")
	NPCDialogUI.show_npc_dialog("elder_wisdom")

func _on_temple_pressed():
	AudioManager.play_sfx("button_click")
	NPCDialogUI.show_npc_dialog("healer_compassion")

func _on_shop_pressed():
	AudioManager.play_sfx("menu_open")
	get_tree().change_scene_to_file("res://Scenes/Shop.tscn")

func _on_arena_pressed():
	AudioManager.play_sfx("button_click")
	NPCDialogUI.show_npc_dialog("rival_ambitious")

func _on_crossroads_pressed():
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")

func _on_inventory_pressed():
	AudioManager.play_sfx("menu_open")
	if ResourceLoader.exists("res://Scenes/InventoryMenu.tscn"):
		get_tree().change_scene_to_file("res://Scenes/InventoryMenu.tscn")

func _on_quest_pressed():
	AudioManager.play_sfx("menu_open")
	if ResourceLoader.exists("res://Scenes/QuestLog.tscn"):
		var log_instance = load("res://Scenes/QuestLog.tscn").instantiate()
		add_child(log_instance)
