extends CanvasLayer

var save_load_menu_scene = preload("res://Scenes/SaveLoadMenu.tscn")
var inventory_menu_scene = preload("res://Scenes/InventoryMenu.tscn")
var quest_log_scene = preload("res://Scenes/QuestLog.tscn")

func _ready():
	# CanvasLayer นี้ต้องทำงานตลอดเวลาแม้เกมจะ pause
	process_mode = Node.PROCESS_MODE_ALWAYS

	# ให้ Panel, Overlay, และปุ่มเมนูมือถือทำงานได้ขณะ pause
	$Panel.process_mode = Node.PROCESS_MODE_ALWAYS
	$Overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	$MobilePauseBtn.process_mode = Node.PROCESS_MODE_ALWAYS

	# ให้ปุ่มทุกอันใน Panel ทำงานได้ขณะ pause
	for btn in $Panel/VBoxContainer.get_children():
		if btn is Button:
			btn.process_mode = Node.PROCESS_MODE_ALWAYS

	# ซ่อน overlay+panel ตอนเริ่มต้น แต่เก็บ CanvasLayer ไว้ (เพื่อให้เห็นปุ่มเมนูมือถือ)
	$Overlay.hide()
	$Panel.hide()

	# Apply theme & hover animations
	_apply_theme()
	for btn in $Panel/VBoxContainer.get_children():
		if btn is Button:
			btn.pivot_offset = btn.size / 2
			btn.mouse_entered.connect(_on_btn_mouse_entered.bind(btn))
			btn.mouse_exited.connect(_on_btn_mouse_exited.bind(btn))

func _apply_theme():
	"""Apply premium UI theme to pause menu"""
	for btn in $Panel/VBoxContainer.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn)

func _input(event):
	# Toggle pause menu with ESC key (keyboard / desktop)
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

# ─── helpers ────────────────────────────────────────────────────────────────

func _open_panel():
	"""เปิดเมนู: แสดง Overlay + Panel แล้ว pause game tree"""
	$Overlay.show()
	$Panel.show()
	get_tree().paused = true

func _close_panel():
	"""ปิดเมนู: ซ่อน Overlay + Panel แล้ว unpause game tree"""
	$Overlay.hide()
	$Panel.hide()
	get_tree().paused = false

# ─── mobile pause button ─────────────────────────────────────────────────────

func toggle_pause():
	if $Panel.visible:
		_close_panel()
	else:
		_open_panel()

# ─── ปุ่มภายในเมนู ───────────────────────────────────────────────────────────

func _on_resume_btn_pressed():
	_close_panel()

func _on_inventory_btn_pressed():
	_close_panel()
	var inv_menu = inventory_menu_scene.instantiate()
	inv_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(inv_menu)

func _on_quest_btn_pressed():
	_close_panel()
	var q_log = quest_log_scene.instantiate()
	q_log.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(q_log)

func _on_companion_btn_pressed():
	_close_panel()
	if ResourceLoader.exists("res://Scenes/Part2/CompanionStatusUI.tscn"):
		var menu = load("res://Scenes/Part2/CompanionStatusUI.tscn").instantiate()
		menu.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().root.add_child(menu)

func _on_skill_tree_btn_pressed():
	_close_panel()
	get_tree().change_scene_to_file("res://Scenes/Part2/SkillTree.tscn")

func _on_save_btn_pressed():
	var current_scene_path = get_tree().current_scene.scene_file_path
	Global.current_scene = current_scene_path
	_close_panel()
	var save_menu = save_load_menu_scene.instantiate()
	save_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(save_menu)

func _on_load_btn_pressed():
	_close_panel()
	var save_menu = save_load_menu_scene.instantiate()
	save_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(save_menu)

func _on_options_btn_pressed():
	_close_panel()
	var options_menu = load("res://Scenes/OptionsMenu.tscn").instantiate()
	options_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(options_menu)

func _on_main_menu_btn_pressed():
	_close_panel()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

# ─── UI Juice (hover animation) ──────────────────────────────────────────────

func _on_btn_mouse_entered(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.1)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_btn_mouse_exited(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
