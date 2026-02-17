extends Control

# InventoryMenu.gd - Main Hub Controller
# Supports: Bag (use/equip items) and Enhance (upgrade equipment) tabs

const StatusUI = preload("res://Scripts/Inventory/StatusUI.gd")
const ItemGrid = preload("res://Scripts/Inventory/ItemGrid.gd")
const ItemUsage = preload("res://Scripts/Inventory/ItemUsage.gd")

@onready var status_container = $HBox/StatusContainer
@onready var item_grid = $HBox/VBox/ScrollContainer/ItemGrid
@onready var message_label = $MessageLabel

var current_tab = "bag" # "bag" or "enhance"

const SLOT_NAMES = {
	"weapon": "⚔️ อาวุธ",
	"head": "🪖 หมวก",
	"body": "🛡️ เกราะ",
	"hands": "🧤 ถุงมือ",
	"feet": "👢 รองเท้า",
	"accessory": "💍 เครื่องประดับ"
}

func _ready():
	refresh_all()

func refresh_all():
	StatusUI.update_status_display(status_container, self)
	_apply_base_ui_styles()
	
	if current_tab == "bag":
		_build_bag_view()
	else:
		_build_enhance_view()

func _apply_base_ui_styles():
	# Glassmorphism Panel
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0, 0, 0, 0.6)
	panel_style.corner_radius_top_left = 20
	panel_style.corner_radius_top_right = 20
	panel_style.corner_radius_bottom_left = 20
	panel_style.corner_radius_bottom_right = 20
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_color = Color(1, 1, 1, 0.1)
	$Panel.add_theme_stylebox_override("panel", panel_style)
	
	# Tab Buttons
	var tab_normal = panel_style.duplicate()
	tab_normal.bg_color = Color(0.1, 0.1, 0.1, 0.4)
	
	var tab_active = panel_style.duplicate()
	tab_active.bg_color = Color(0.2, 0.4, 0.3, 0.6)
	tab_active.border_color = Color(0.4, 1.0, 0.6, 0.8)

	$HBox/VBox/TabBar/BagTab.add_theme_stylebox_override("normal", tab_active if current_tab == "bag" else tab_normal)
	$HBox/VBox/TabBar/EnhanceTab.add_theme_stylebox_override("normal", tab_active if current_tab == "enhance" else tab_normal)

# === BAG TAB ===
func _build_bag_view():
	for child in item_grid.get_children():
		child.queue_free()
	
	# The Equipped items are now visually displayed on the LEFT side (StatusContainer)
	# So we only show the Bag items here to avoid redundancy and keep it professional.
	_add_section_header("🎒 กระเป๋าสัมภาระ")
	
	var inv_count = 0
	for item_id in Global.inventory:
		var count = Global.inventory[item_id]
		if count > 0:
			inv_count += 1
			var btn = _create_item_button(item_id, "", false, count)
			item_grid.add_child(btn)
			
	if inv_count == 0:
		_add_empty_label("กระเป๋าว่างเปล่า")

func _create_item_button(item_id: String, slot: String, is_equipped: bool, count: int = 1) -> Button:
	var item_data = Global.item_db.get(item_id, {})
	var rarity = item_data.get("rarity", "common")
	var rarity_color = Global.RARITY_COLORS.get(rarity, Color.WHITE)
	
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(240, 90)
	
	# Glass Style with Rarity Border
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.5)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = rarity_color.lerp(Color.BLACK, 0.4)
	btn.add_theme_stylebox_override("normal", style)
	
	var h_style = style.duplicate()
	h_style.bg_color = Color(0.2, 0.2, 0.2, 0.6)
	h_style.border_color = rarity_color
	h_style.shadow_color = rarity_color.lerp(Color.TRANSPARENT, 0.8)
	h_style.shadow_size = 8
	btn.add_theme_stylebox_override("hover", h_style)

	var display_name = item_data.get("name", item_id)
	if is_equipped:
		var enh = Global.enhancement_levels.get(slot, 0)
		var enh_text = " +%d" % enh if enh > 0 else ""
		btn.text = "%s\n%s%s" % [SLOT_NAMES.get(slot, slot), display_name, enh_text]
	else:
		btn.text = "%s\n(จำนวน: %d)" % [display_name, count]
		
	btn.add_theme_color_override("font_color", rarity_color)
	btn.tooltip_text = item_data.get("desc", "")
	
	btn.pressed.connect(func():
		if is_equipped:
			Global.unequip_item(slot)
			show_message("ถอด %s" % display_name)
		else:
			_on_item_used(item_id)
		refresh_all()
	)
	_setup_button_hover(btn)
	return btn

func _add_section_header(title: String):
	var lbl = Label.new()
	lbl.text = "\n" + title
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", Color(1, 0.9, 0.5))
	item_grid.add_child(lbl)
	# Spacer for grid
	item_grid.add_child(Control.new())
	item_grid.add_child(Control.new())

func _add_empty_label(text: String):
	var lbl = Label.new()
	lbl.text = text
	lbl.modulate.a = 0.5
	item_grid.add_child(lbl)
	item_grid.add_child(Control.new())
	item_grid.add_child(Control.new())

# === ENHANCE TAB ===
func _build_enhance_view():
	for child in item_grid.get_children():
		child.queue_free()
	
	var has_equipment = false
	for slot in Global.equipped_items:
		var item_id = Global.equipped_items[slot]
		if item_id:
			has_equipment = true
			var item_data = Global.item_db.get(item_id, {})
			var current_level = Global.enhancement_levels.get(slot, 0)
			var rarity = item_data.get("rarity", "common")
			var rarity_color = Global.RARITY_COLORS.get(rarity, Color.WHITE)
			
			# Info Panel Container
			var container = PanelContainer.new()
			var c_style = StyleBoxFlat.new()
			c_style.bg_color = Color(0,0,0,0.3)
			c_style.corner_radius_top_left = 10
			c_style.corner_radius_bottom_left = 10
			container.add_theme_stylebox_override("panel", c_style)
			
			var v = VBoxContainer.new()
			v.alignment = BoxContainer.ALIGNMENT_CENTER
			container.add_child(v)
			
			var l1 = Label.new()
			l1.text = SLOT_NAMES.get(slot, slot)
			l1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			v.add_child(l1)
			
			var l2 = Label.new()
			l2.text = item_data.get("name", "?") + " +%d" % current_level
			l2.add_theme_color_override("font_color", rarity_color)
			l2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			v.add_child(l2)
			
			item_grid.add_child(container)
			
			# Enhance button
			if current_level < 10:
				var cost = Global.ENHANCE_COST[current_level]
				var rate = int(Global.ENHANCE_SUCCESS[current_level] * 100)
				
				var btn = Button.new()
				btn.text = "🔨 ตีบวก 💰 %d G\n(โอกาสสำเร็จ %d%%)" % [cost, rate]
				btn.custom_minimum_size = Vector2(250, 70)
				
				var b_style = StyleBoxFlat.new()
				b_style.bg_color = Color(0.1, 0.3, 0.2, 0.5) if Global.player_gold >= cost else Color(0.3, 0.1, 0.1, 0.5)
				b_style.corner_radius_top_right = 10
				b_style.corner_radius_bottom_right = 10
				btn.add_theme_stylebox_override("normal", b_style)
				
				if Global.player_gold < cost:
					btn.disabled = true
				
				btn.pressed.connect(func():
					var result = Global.enhance_item(slot)
					show_message(("✅ " if result.success else "❌ ") + result.message)
					refresh_all()
				)
				_setup_button_hover(btn)
				item_grid.add_child(btn)
			else:
				var max_lbl = Label.new()
				max_lbl.text = "⭐ พลังสูงสุด +10"
				max_lbl.add_theme_color_override("font_color", Color.YELLOW)
				item_grid.add_child(max_lbl)
			
			item_grid.add_child(Control.new()) # Grid alignment spacer

	if not has_equipment:
		_add_empty_label("กรุณาสวมใส่อุปกรณ์ก่อนตีบวก")

# === Tab switching, Item usage, UI Juice etc unchanged logic-wise ===
func _on_bag_tab_pressed():
	current_tab = "bag"
	refresh_all()

func _on_enhance_tab_pressed():
	current_tab = "enhance"
	refresh_all()

func _on_item_used(item_id: String):
	var result_msg = ItemUsage.use_item(item_id)
	show_message(result_msg)
	refresh_all()

func _setup_button_hover(btn: Button):
	btn.pivot_offset = btn.custom_minimum_size / 2
	btn.mouse_entered.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.03, 1.03), 0.1)
	)
	btn.mouse_exited.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	)

func show_message(msg: String):
	message_label.text = msg
	message_label.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(message_label, "modulate:a", 0.0, 2.5).set_delay(1.5)

func _on_close_button_pressed():
	queue_free()
