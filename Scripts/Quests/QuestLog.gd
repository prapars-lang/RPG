extends Control

# QuestLog.gd - Controller for the Quest Tracking UI
# Part of the Quest & Story System

const QuestData = preload("res://Scripts/Quests/QuestData.gd")

@onready var active_list = $Panel/VBox/Scroll/ActiveQuests
@onready var completed_list = $Panel/VBox/Scroll/CompletedQuests
@onready var close_btn = $Panel/VBox/CloseBtn

func _ready():
	refresh_quest_log()

func refresh_quest_log():
	# Clear existing
	for child in active_list.get_children(): child.queue_free()
	for child in completed_list.get_children(): child.queue_free()
	
	# Populate Active
	for q_id in Global.active_quests:
		var data = QuestData.get_quest(q_id)
		if not data.is_empty():
			add_quest_item(active_list, data, false)
			
	# Populate Completed
	for q_id in Global.completed_quests:
		var data = QuestData.get_quest(q_id)
		if not data.is_empty():
			add_quest_item(completed_list, data, true)

func add_quest_item(container: Control, data: Dictionary, is_done: bool):
	var panel = PanelContainer.new()
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = data.title
	title.add_theme_font_size_override("font_size", 20)
	if is_done: title.modulate = Color(0.5, 1.0, 0.5) # Greenish for done
	vbox.add_child(title)
	
	var desc = Label.new()
	desc.text = data.description
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override("font_size", 14)
	desc.modulate = Color(0.8, 0.8, 0.8)
	vbox.add_child(desc)
	
	var gold_label = Label.new()
	gold_label.text = "รางวัล: %d Gold, %d XP" % [data.gold_reward, data.xp_reward]
	gold_label.add_theme_font_size_override("font_size", 12)
	gold_label.modulate = Color(1.0, 0.8, 0.2)
	vbox.add_child(gold_label)
	
	container.add_child(panel)

func _on_close_pressed():
	queue_free()
