extends CanvasLayer

# NPC Dialog UI
# Displays NPC information and dialog when interacting with NPCs

@onready var npc_name_label = $Panel/VBox/NameLabel
@onready var npc_title_label = $Panel/VBox/TitleLabel
@onready var dialog_text_box = $Panel/VBox/DialogBox
@onready var dialog_text = $Panel/VBox/DialogBox/MarginContainer/DialogText
@onready var reputation_label = $Panel/VBox/RepLabel
@onready var buttons_container = $Panel/VBox/ButtonsContainer
@onready var sprite_rect = $Panel/SpriteContainer/SpriteRect

var current_npc_id: String = ""
var dialog_index: int = 0
var current_dialog: Array = []

func _ready():
	"""Initialize NPC dialog UI"""
	_apply_theme()
	# Connect button signals
	$Panel/VBox/ButtonsContainer/NextBtn.pressed.connect(_on_next_dialog)
	$Panel/VBox/ButtonsContainer/InteractBtn.pressed.connect(_on_interact)
	$Panel/VBox/ButtonsContainer/CloseBtn.pressed.connect(_on_close)
	
	hide()

func _apply_theme():
	"""Apply UI theme"""
	# Style panel
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = UIThemeManager.COLOR_DARK_BG
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_width_right = 2
	panel_style.border_width_bottom = 2
	panel_style.border_color = UIThemeManager.COLOR_PRIMARY
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12
	
	$Panel.add_theme_stylebox_override("panel", panel_style)
	
	# Style labels
	for label in $Panel/VBox.find_children("*Label", "Label", true):
		label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
		label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	npc_name_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_BIG)
	npc_title_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	reputation_label.add_theme_color_override("font_color", UIThemeManager.COLOR_SUCCESS)
	
	# Style buttons
	for btn in buttons_container.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn)

func show_npc_dialog(npc_id: String) -> void:
	"""Display dialog for a specific NPC"""
	current_npc_id = npc_id
	dialog_index = 0
	
	var npc = NPCManager.get_npc(npc_id)
	if npc.is_empty():
		return
	
	# Set NPC info
	npc_name_label.text = npc.get("name", "Unknown")
	npc_title_label.text = npc.get("title", "")
	
	# Load sprite
	var sprite_path = npc.get("sprite", "")
	if sprite_path and ResourceLoader.exists(sprite_path):
		sprite_rect.texture = load(sprite_path)
		sprite_rect.modulate = Color.WHITE
	else:
		sprite_rect.modulate = Color.GRAY
	
	# Get and display dialog
	current_dialog = NPCManager.get_npc_dialogue(npc_id)
	_display_current_dialog()
	
	# Update reputation display
	_update_reputation_display()
	
	# Mark as visited
	NPCManager.interact_with_npc(npc_id)
	
	# Play NPC greeting SFX
	AudioManager.play_sfx("menu_open")
	
	show()

func _display_current_dialog() -> void:
	"""Display current dialog line instantly"""
	if dialog_index < current_dialog.size():
		var full_text = current_dialog[dialog_index]
		dialog_text.text = full_text
		dialog_text.visible_ratio = 1.0
		_update_buttons_state()
	else:
		dialog_text.text = "..."
		_update_buttons_state()

func _update_buttons_state() -> void:
	"""Update button labels and visibility based on dialog state"""
	var next_btn = buttons_container.find_child("NextBtn")
	var interact_btn = buttons_container.find_child("InteractBtn")
	
	if dialog_index < current_dialog.size() - 1:
		next_btn.text = "ต่อไป"
	else:
		next_btn.text = "เสร็จ"
	
	# Only show interact button on last line
	var npc = NPCManager.get_npc(current_npc_id)
	interact_btn.visible = (dialog_index == current_dialog.size() - 1)
	
	# Update Interact button text based on NPC type
	match npc.get("type"):
		NPCManager.NPCType.MERCHANT: interact_btn.text = "ซื้อขาย"
		NPCManager.NPCType.QUEST_GIVER: interact_btn.text = "รับเควส"
		NPCManager.NPCType.HEALER: interact_btn.text = "รักษา"
		NPCManager.NPCType.GUIDE: interact_btn.text = "ขอคำแนะนำ"
		NPCManager.NPCType.RIVAL: interact_btn.text = "⚔️ ท้าสู้"
		NPCManager.NPCType.ELDER: interact_btn.text = "📚 ท้าทายปัญญา"
		_: interact_btn.text = "ตกลง"

func _update_reputation_display() -> void:
	"""Update reputation label"""
	if current_npc_id == "": return
	
	var rep = NPCManager.get_reputation(current_npc_id)
	var rep_level = NPCManager.get_reputation_level(current_npc_id)
	
	var rep_text = "ความสัมพันธ์: %d (%s)" % [rep, rep_level]
	match rep_level:
		"devoted":
			reputation_label.add_theme_color_override("font_color", Color.GREEN)
		"friendly":
			reputation_label.add_theme_color_override("font_color", UIThemeManager.COLOR_SUCCESS)
		"hostile":
			reputation_label.add_theme_color_override("font_color", Color.RED)
		"enemy":
			reputation_label.add_theme_color_override("font_color", Color.DARK_RED)
		_:
			reputation_label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	
	reputation_label.text = rep_text

func _on_next_dialog() -> void:
	"""Go to next dialog line"""
	AudioManager.play_sfx("button_click")
	
	if dialog_index < current_dialog.size() - 1:
		dialog_index += 1
		_display_current_dialog()
	else:
		_on_close()

func _on_close() -> void:
	"""Close NPC dialog"""
	AudioManager.play_sfx("menu_close")
	current_npc_id = ""
	dialog_index = 0
	current_dialog.clear()
	hide()

func _on_interact() -> void:
	"""Interact with NPC (context-based)"""
	AudioManager.play_sfx("button_click")
	
	var npc = NPCManager.get_npc(current_npc_id)
	var npc_type = npc.get("type")
	
	match npc_type:
		NPCManager.NPCType.MERCHANT:
			_open_shop()
		NPCManager.NPCType.QUEST_GIVER:
			_handle_quests()
		NPCManager.NPCType.HEALER:
			_perform_healing()
		NPCManager.NPCType.GUIDE:
			_show_guide_hints()
		NPCManager.NPCType.RIVAL:
			_start_arena_battle()
		NPCManager.NPCType.ELDER:
			_start_elder_challenge()
		_:
			print("Interacting with: %s" % npc.get("name"))
			_on_close()

func _show_guide_hints() -> void:
	"""Display hints/advice from a guide NPC"""
	var npc = NPCManager.get_npc(current_npc_id)
	var hints = npc.get("hints", [])
	
	if hints.size() > 0:
		# Replace current dialog with hints
		current_dialog = hints
		dialog_index = 0
		_display_current_dialog()
		
		# Hide interact button to avoid recursive hint loops
		var interact_btn = buttons_container.find_child("InteractBtn")
		interact_btn.visible = false
	else:
		dialog_text.text = "ผมยังไม่มีคำแนะนำในตอนนี้ครับ..."
		await get_tree().create_timer(2.0).timeout
		_on_close()

func _open_shop() -> void:
	"""Open shop interface"""
	_on_close()
	AudioManager.play_sfx("menu_open")
	get_tree().change_scene_to_file("res://Scenes/Shop.tscn")

func _handle_quests() -> void:
	"""Display quest selection or give quest"""
	var npc = NPCManager.get_npc(current_npc_id)
	var available_quests = npc.get("quests", [])
	
	if available_quests.size() > 0:
		var quest_id = available_quests[0]
		if not QuestManager.is_quest_active(quest_id) and not QuestManager.is_quest_completed(quest_id):
			QuestManager.activate_quest(quest_id)
			dialog_text.text = "รับทราบ! ฉันได้มอบภารกิจให้เจ้าแล้ว..."
		elif QuestManager.is_quest_active(quest_id):
			dialog_text.text = "ภารกิจยังไม่เสร็จสิ้นนะลูกศิษย์..."
		else:
			dialog_text.text = "ขอบใจมากที่ช่วยจัดการเรื่องนี้!"
	
	await get_tree().create_timer(1.5).timeout
	_on_close()

func _perform_healing() -> void:
	"""Heal player"""
	AudioManager.play_sfx("heal")
	if Global.has_method("heal_player"):
		Global.heal_player(100)
	dialog_text.text = "บาดแผลของคุณได้รับการรักษาแล้ว..."
	await get_tree().create_timer(1.5).timeout
	_on_close()

func _start_arena_battle() -> void:
	"""Start a random arena battle from the Rival NPC"""
	var arena_enemies = ["lazy_slime", "couch_golem", "sugar_spy", "fat_phantom", "smoke", "stress"]
	var random_enemy = arena_enemies.pick_random()
	
	dialog_text.text = "⚔️ เตรียมตัวให้พร้อม! ข้าท้าเจ้าสู้!"
	await get_tree().create_timer(1.5).timeout
	
	_on_close()
	Global.is_story_mode = false
	Global.queued_story_enemy_id = random_enemy
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

func _start_elder_challenge() -> void:
	"""Start a random wisdom challenge from the Elder NPC"""
	var wisdom_enemies = ["stress", "noise_banshee", "atrophy_ghost", "virus"]
	var random_enemy = wisdom_enemies.pick_random()
	
	dialog_text.text = "📚 ถึงเวลาพิสูจน์ความรู้ของเจ้าแล้ว!"
	await get_tree().create_timer(1.5).timeout
	
	_on_close()
	Global.is_story_mode = false
	Global.queued_story_enemy_id = random_enemy
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")
