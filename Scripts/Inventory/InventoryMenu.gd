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
	StatusUI.update_status_display(status_container)
	
	if current_tab == "bag":
		_build_bag_view()
	else:
		_build_enhance_view()

# === BAG TAB ===
func _build_bag_view():
	for child in item_grid.get_children():
		child.queue_free()
	
	var items_found = false
	
	# 1. Show Equipped Items (clickable to unequip)
	for slot in Global.equipped_items:
		var item_id = Global.equipped_items[slot]
		if item_id:
			items_found = true
			var item_data = Global.item_db.get(item_id, {})
			var rarity = item_data.get("rarity", "common")
			var enh = Global.enhancement_levels.get(slot, 0)
			var enh_text = " +%d" % enh if enh > 0 else ""
			
			var btn = Button.new()
			btn.text = "[%s]\n%s%s" % [SLOT_NAMES.get(slot, slot), item_data.get("name", "?"), enh_text]
			btn.modulate = Global.RARITY_COLORS.get(rarity, Color.WHITE)
			btn.custom_minimum_size = Vector2(200, 80)
			btn.tooltip_text = "คลิกเพื่อถอด: " + item_data.get("desc", "")
			
			var captured_slot = slot
			btn.pressed.connect(func():
				Global.unequip_item(captured_slot)
				show_message("ถอด %s เรียบร้อย" % item_data.get("name", "?"))
				refresh_all()
			)
			item_grid.add_child(btn)
	
	# 2. Show Inventory Items (clickable to use/equip)
	for item_id in Global.inventory:
		var count = Global.inventory[item_id]
		if count > 0:
			items_found = true
			var item_data = Global.item_db.get(item_id, {})
			var rarity = item_data.get("rarity", "")
			
			var btn = Button.new()
			btn.text = "%s\n(x%d)" % [item_data.get("name", item_id), count]
			btn.custom_minimum_size = Vector2(200, 80)
			btn.tooltip_text = item_data.get("desc", "")
			
			if rarity != "":
				btn.modulate = Global.RARITY_COLORS.get(rarity, Color.WHITE)
			
			var captured_id = item_id
			btn.pressed.connect(func():
				_on_item_used(captured_id)
			)
			item_grid.add_child(btn)
	
	if not items_found:
		var lbl = Label.new()
		lbl.text = "กระเป๋าว่างเปล่า"
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 20)
		item_grid.add_child(lbl)

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
			
			# Info label
			var info = Label.new()
			var enh_text = "+%d" % current_level if current_level > 0 else "+0"
			info.text = "%s\n%s %s" % [SLOT_NAMES.get(slot, slot), item_data.get("name", "?"), enh_text]
			info.add_theme_color_override("font_color", Global.RARITY_COLORS.get(rarity, Color.WHITE))
			info.add_theme_font_size_override("font_size", 16)
			info.custom_minimum_size = Vector2(200, 70)
			item_grid.add_child(info)
			
			# Enhance button
			if current_level < 10:
				var cost = Global.ENHANCE_COST[current_level]
				var rate = int(Global.ENHANCE_SUCCESS[current_level] * 100)
				
				var btn = Button.new()
				btn.text = "🔨 ตีบวก +%d→+%d\n💰 %d G (สำเร็จ %d%%)" % [current_level, current_level + 1, cost, rate]
				btn.custom_minimum_size = Vector2(250, 70)
				
				if Global.player_gold < cost:
					btn.modulate.a = 0.5
				
				var captured_slot = slot
				btn.pressed.connect(func():
					var result = Global.enhance_item(captured_slot)
					if result.success:
						show_message("✅ " + result.message)
					else:
						show_message("❌ " + result.message)
					refresh_all()
				)
				item_grid.add_child(btn)
			else:
				var max_label = Label.new()
				max_label.text = "⭐ MAX +10"
				max_label.add_theme_color_override("font_color", Color(1, 0.8, 0.2))
				max_label.add_theme_font_size_override("font_size", 20)
				max_label.custom_minimum_size = Vector2(250, 70)
				max_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				item_grid.add_child(max_label)
	
	if not has_equipment:
		var lbl = Label.new()
		lbl.text = "ยังไม่มีอุปกรณ์สวมใส่\nกรุณาสวมใส่อุปกรณ์ก่อนตีบวก"
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 20)
		item_grid.add_child(lbl)

# === Tab switching ===
func _on_bag_tab_pressed():
	current_tab = "bag"
	refresh_all()

func _on_enhance_tab_pressed():
	current_tab = "enhance"
	refresh_all()

# === Item usage ===
func _on_item_used(item_id: String):
	var result_msg = ItemUsage.use_item(item_id)
	show_message(result_msg)
	refresh_all()

func show_message(msg: String):
	message_label.text = msg
	message_label.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(message_label, "modulate:a", 0.0, 2.5).set_delay(1.5)

func _on_close_button_pressed():
	queue_free()
