extends Control

signal dialogue_finished
signal line_changed(data)

@onready var panel = $Panel
@onready var name_label = $Panel/NameLabel
@onready var text_label = $Panel/TextLabel
@onready var next_indicator = $Panel/NextIndicator

var dialogue_queue = []
var current_line = 0

func _ready():
	# Hide on start
	visible = false
	_apply_theme()

func _apply_theme():
	"""Apply premium UI theme to dialogue system"""
	# Style name label (NPC name) - smaller, more proportional
	name_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	name_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_BIG)
	
	# Style text label (dialogue text)
	text_label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	text_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	# Style next indicator
	next_indicator.add_theme_color_override("font_color", UIThemeManager.COLOR_PRIMARY)

func start_dialogue(lines: Array):
	dialogue_queue = lines
	current_line = 0
	show_line()
	visible = true

func start_ai_dialogue(npc_name: String, user_prompt: String):
	visible = true
	name_label.text = npc_name
	text_label.text = "กำลังสื่อสารกับวิญญาณแห่งปัญญา..."
	next_indicator.visible = false
	
	if not LLMService.request_completed.is_connected(_on_ai_responded):
		LLMService.request_completed.connect(_on_ai_responded)
	if not LLMService.request_failed.is_connected(_on_ai_failed):
		LLMService.request_failed.connect(_on_ai_failed)
		
	var full_prompt = user_prompt + "\n\n" + Global.get_ai_context()
	var system_prompt = "คุณคือวิญญาณแห่งปัญญาในเกม RPG แนวการศึกษา ให้คำแนะนำสั้นๆ สุภาพ และมีประโยชน์ต่อเด็กในเรื่องสุขภาพและจริยธรรม ตอบเป็นภาษาไทย"
	
	LLMService.generate_response(full_prompt, system_prompt)

func _on_ai_responded(response_text: String):
	text_label.text = response_text
	next_indicator.visible = true
	# No queue for AI dialogue, it's a one-off for now
	dialogue_queue = [{"name": name_label.text, "text": response_text}]
	current_line = 0

func _on_ai_failed(error_message: String):
	text_label.text = "ขออภัย... ข้าอ่อนแรงเกินกว่าจะสื่อสารในตอนนี้ (Error: %s)" % error_message
	next_indicator.visible = true

func show_line():
	if current_line < dialogue_queue.size():
		var data = dialogue_queue[current_line]
		name_label.text = data.get("name", "???")
		text_label.text = data.get("text", "")
		line_changed.emit(data)
	else:
		finish_dialogue()

func _input(event):
	if visible and (event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed)):
		current_line += 1
		show_line()

func finish_dialogue():
	visible = false
	dialogue_finished.emit()
