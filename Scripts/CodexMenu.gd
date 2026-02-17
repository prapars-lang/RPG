extends Control

@onready var card_grid: GridContainer = $Panel/VBox/ScrollContainer/CardGrid
@onready var detail_panel: Panel = $DetailPanel
@onready var detail_name: Label = $DetailPanel/VBox/CardName
@onready var detail_desc: RichTextLabel = $DetailPanel/VBox/CardDesc
@onready var detail_category: Label = $DetailPanel/VBox/CardCategory
@onready var detail_set_label: Label = $DetailPanel/VBox/SetInfo
@onready var summary_label: Label = $Panel/VBox/Header/SummaryLabel
@onready var back_btn: Button = $Panel/VBox/Header/BackBtn

var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null

func _ready():
	Global.current_scene = "res://Scenes/CodexMenu.tscn"
	
	# Add PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	back_btn.pressed.connect(_on_back_pressed)
	$DetailPanel/VBox/CloseBtn.pressed.connect(func(): detail_panel.visible = false)
	detail_panel.visible = false
	
	_update_summary()
	_populate_cards()

func _update_summary():
	var s = Global.get_codex_summary()
	summary_label.text = "สะสม %d/%d ใบ | เซ็ตสำเร็จ %d/%d" % [s.unlocked, s.total, s.sets_complete, s.sets_total]

func _populate_cards():
	# Clear existing children
	for child in card_grid.get_children():
		child.queue_free()
	
	# Group by category
	var categories = {"nutrition": "🍎 โภชนาการ", "hygiene": "🧼 สุขอนามัย", "exercise": "💪 การออกกำลังกาย"}
	
	for cat_key in categories:
		# Category Header
		var header = Label.new()
		header.text = categories[cat_key]
		header.add_theme_font_size_override("font_size", 22)
		header.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
		header.custom_minimum_size = Vector2(card_grid.size.x, 40)
		card_grid.add_child(header)
		# Spacers for remaining columns
		for i in range(card_grid.columns - 1):
			var spacer = Control.new()
			card_grid.add_child(spacer)
		
		# Cards in this category
		var cards = Global.get_cards_by_category(cat_key)
		for card_id in cards:
			var btn = _create_card_button(card_id)
			card_grid.add_child(btn)
		
		# Fill remaining slots in row
		var remainder = cards.size() % card_grid.columns
		if remainder > 0:
			for i in range(card_grid.columns - remainder):
				var spacer = Control.new()
				card_grid.add_child(spacer)

func _create_card_button(card_id: String) -> Button:
	var card_data = Global.card_database[card_id]
	var is_unlocked = Global.is_card_unlocked(card_id)
	
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(160, 100)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var rarity_colors = {"common": Color(0.7, 0.9, 1.0), "rare": Color(0.7, 0.5, 1.0)}
	
	if is_unlocked:
		btn.text = card_data.name
		btn.add_theme_color_override("font_color", rarity_colors.get(card_data.rarity, Color.WHITE))
		btn.add_theme_font_size_override("font_size", 18)
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.pressed.connect(_on_card_clicked.bind(card_id))
	else:
		btn.text = "???"
		btn.modulate = Color(0.5, 0.5, 0.5, 0.7)
		btn.add_theme_font_size_override("font_size", 28)
		btn.tooltip_text = "ยังไม่ปลดล็อก"
	
	return btn

func _on_card_clicked(card_id: String):
	var card_data = Global.card_database.get(card_id, {})
	if card_data.is_empty(): return
	
	detail_name.text = card_data.name
	detail_desc.text = card_data.description
	
	var cat_names = {"nutrition": "โภชนาการ", "hygiene": "สุขอนามัย", "exercise": "การออกกำลังกาย"}
	detail_category.text = "หมวดหมู่: " + cat_names.get(card_data.category, "อื่นๆ")
	
	# Show set progress
	var set_id = card_data.get("set", "")
	if set_id != "":
		var set_data = Global.card_sets.get(set_id, {})
		var progress = Global.get_set_progress(set_id)
		detail_set_label.text = "เซ็ต: %s (%d/%d)" % [set_data.get("name", set_id), progress.unlocked, progress.total]
		if progress.complete:
			detail_set_label.text += " ✅ สำเร็จ!"
	else:
		detail_set_label.text = ""
	
	detail_panel.visible = true
	
	# Animate panel appearance
	detail_panel.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(detail_panel, "modulate:a", 1.0, 0.2)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if detail_panel.visible:
			detail_panel.visible = false
		else:
			_on_back_pressed()
