extends Control

# QuestLog.gd - Controller for the Quest Tracking UI
# Part of the Quest & Story System

const QuestData = preload("res://Scripts/Quests/QuestData.gd")

@onready var active_list = $Panel/VBox/Scroll/VBox/ActiveQuests
@onready var completed_list = $Panel/VBox/Scroll/VBox/CompletedQuests
@onready var close_btn = $Panel/VBox/CloseBtn

func _ready():
	_apply_theme()
	refresh_quest_log()

func _apply_theme():
	"""Apply premium theme to QuestLog"""
	# Panel style
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = UIThemeManager.COLOR_DARK_BG
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_width_right = 2
	panel_style.border_width_bottom = 2
	panel_style.border_color = UIThemeManager.COLOR_PRIMARY
	panel_style.corner_radius_top_left = 16
	panel_style.corner_radius_top_right = 16
	panel_style.corner_radius_bottom_left = 16
	panel_style.corner_radius_bottom_right = 16
	$Panel.add_theme_stylebox_override("panel", panel_style)
	
	# Title
	var title = $Panel/VBox/Title
	title.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	
	# Headers
	var active_header = $Panel/VBox/Scroll/VBox/ActiveHeader
	active_header.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	var completed_header = $Panel/VBox/Scroll/VBox/CompletedHeader
	completed_header.add_theme_color_override("font_color", UIThemeManager.COLOR_SUCCESS)
	
	# Close button
	UIThemeManager.apply_button_theme(close_btn)

func refresh_quest_log():
	# Clear existing
	for child in active_list.get_children(): child.queue_free()
	for child in completed_list.get_children(): child.queue_free()
	
	# Populate Active
	var has_active = false
	for q_id in Global.active_quests:
		var data = QuestData.get_quest(q_id)
		if not data.is_empty():
			add_quest_item(active_list, data, false)
			has_active = true
	
	if not has_active:
		var empty_label = Label.new()
		empty_label.text = "ยังไม่มีภารกิจที่กำลังทำ"
		empty_label.add_theme_font_size_override("font_size", 16)
		empty_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		active_list.add_child(empty_label)
	
	# Populate Completed
	var has_completed = false
	for q_id in Global.completed_quests:
		var data = QuestData.get_quest(q_id)
		if not data.is_empty():
			add_quest_item(completed_list, data, true)
			has_completed = true
	
	if not has_completed:
		var empty_label = Label.new()
		empty_label.text = "ยังไม่มีภารกิจที่สำเร็จ"
		empty_label.add_theme_font_size_override("font_size", 16)
		empty_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		completed_list.add_child(empty_label)

func add_quest_item(container: Control, data: Dictionary, is_done: bool):
	var panel = PanelContainer.new()
	
	# Style the quest item panel
	var item_style = StyleBoxFlat.new()
	if is_done:
		item_style.bg_color = Color(0.1, 0.3, 0.15, 0.6)
	else:
		item_style.bg_color = Color(0.15, 0.15, 0.25, 0.6)
	item_style.corner_radius_top_left = 10
	item_style.corner_radius_top_right = 10
	item_style.corner_radius_bottom_left = 10
	item_style.corner_radius_bottom_right = 10
	item_style.border_width_left = 1
	item_style.border_width_top = 1
	item_style.border_width_right = 1
	item_style.border_width_bottom = 1
	item_style.border_color = UIThemeManager.COLOR_PRIMARY if not is_done else UIThemeManager.COLOR_SUCCESS
	item_style.content_margin_left = 15
	item_style.content_margin_top = 10
	item_style.content_margin_right = 15
	item_style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", item_style)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	# Title row with status icon
	var title = Label.new()
	var status_icon = "✅ " if is_done else "⚔️ "
	title.text = status_icon + data.title
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	vbox.add_child(title)
	
	# Description
	var desc = Label.new()
	desc.text = data.description
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override("font_size", 16)
	desc.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	vbox.add_child(desc)
	
	# Objective
	if data.has("objective"):
		var obj = Label.new()
		obj.text = "🎯 เป้าหมาย: " + data.objective
		obj.add_theme_font_size_override("font_size", 14)
		obj.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
		vbox.add_child(obj)
	
	# Rewards
	var reward_label = Label.new()
	reward_label.text = "💰 รางวัล: %d Gold, %d XP" % [data.gold_reward, data.xp_reward]
	reward_label.add_theme_font_size_override("font_size", 14)
	reward_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	vbox.add_child(reward_label)
	
	container.add_child(panel)

func _on_close_pressed():
	AudioManager.play_sfx("menu_close")
	queue_free()
