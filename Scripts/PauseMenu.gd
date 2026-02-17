extends CanvasLayer

var save_load_menu_scene = preload("res://Scenes/SaveLoadMenu.tscn")
var inventory_menu_scene = preload("res://Scenes/InventoryMenu.tscn")
var quest_log_scene = preload("res://Scenes/QuestLog.tscn")

func _ready():
	# Start hidden
	hide()
	
	# Apply theme styling
	_apply_theme()
	
	# Connect hover signals for all primary buttons
	for btn in $Panel/VBoxContainer.get_children():
		if btn is Button:
			btn.pivot_offset = btn.size / 2 # Ensure scaling from center
			btn.mouse_entered.connect(_on_btn_mouse_entered.bind(btn))
			btn.mouse_exited.connect(_on_btn_mouse_exited.bind(btn))

func _apply_theme():
	"""Apply premium UI theme to pause menu"""
	# Style all buttons with UIThemeManager
	for btn in $Panel/VBoxContainer.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn)

func _input(event):
	# Toggle pause menu with ESC key
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	if visible:
		hide()
		get_tree().paused = false
	else:
		show()
		get_tree().paused = true

func _on_resume_btn_pressed():
	hide()
	get_tree().paused = false

func _on_inventory_btn_pressed():
	# Hide pause menu first to prevent overlap
	hide()
	# Instantiate InventoryMenu
	var inv_menu = inventory_menu_scene.instantiate()
	inv_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(inv_menu)
	# Show pause menu again when inventory closes
	inv_menu.tree_exited.connect(func(): show())

func _on_quest_btn_pressed():
	# Hide pause menu first to prevent overlap
	hide()
	# Instantiate QuestLog
	var q_log = quest_log_scene.instantiate()
	q_log.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(q_log)
	# Show pause menu again when quest log closes
	q_log.tree_exited.connect(func(): show())

func _on_save_btn_pressed():
	# Update current scene before showing save menu
	var current_scene_path = get_tree().current_scene.scene_file_path
	Global.current_scene = current_scene_path
	
	# Hide pause menu first to prevent overlap
	hide()
	# Instantiate SaveLoadMenu
	var save_menu = save_load_menu_scene.instantiate()
	save_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(save_menu)
	# Show pause menu again when save menu closes
	save_menu.tree_exited.connect(func(): show())

func _on_load_btn_pressed():
	# Hide pause menu first to prevent overlap
	hide()
	# Instantiate SaveLoadMenu
	var save_menu = save_load_menu_scene.instantiate()
	save_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(save_menu)
	# Show pause menu again when save menu closes
	save_menu.tree_exited.connect(func(): show())

func _on_options_btn_pressed():
	# Hide pause menu
	hide()
	# Instantiate OptionsMenu
	var options_menu = load("res://Scenes/OptionsMenu.tscn").instantiate()
	options_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(options_menu)
	# Show pause menu again when options closes
	options_menu.tree_exited.connect(func(): show())

# --- UI Juice ---
func _on_btn_mouse_entered(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.1)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_btn_mouse_exited(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_main_menu_btn_pressed():
	hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
