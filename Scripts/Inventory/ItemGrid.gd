extends Node

# ItemGrid.gd - Builds the item grid in the inventory
# Shows equipped items first (with rarity colors), then inventory items

const SLOT_NAMES = {
	"weapon": "⚔️ อาวุธ",
	"head": "🪖 หมวก",
	"body": "🛡️ เกราะ",
	"hands": "🧤 ถุงมือ",
	"feet": "👢 รองเท้า",
	"accessory": "💍 เครื่องประดับ"
}

static func rebuild_grid(grid_container: GridContainer, use_callback: Callable):
	# Clear existing items
	for child in grid_container.get_children():
		child.queue_free()
	
	var items_found = false
	
	# 1. Show Equipped Items First (by slot)
	for slot in Global.equipped_items:
		var item_id = Global.equipped_items[slot]
		if item_id:
			items_found = true
			var item_data = Global.item_db.get(item_id, {})
			var rarity = item_data.get("rarity", "common")
			var enh_level = Global.enhancement_levels.get(slot, 0)
			var enh_text = ""
			if enh_level > 0:
				enh_text = " +%d" % enh_level
			
			var btn = Button.new()
			btn.text = "[%s] %s%s" % [SLOT_NAMES.get(slot, slot), item_data.get("name", "?"), enh_text]
			btn.modulate = Global.RARITY_COLORS.get(rarity, Color.WHITE)
			btn.custom_minimum_size = Vector2(200, 80)
			btn.tooltip_text = "ถอดอุปกรณ์: " + item_data.get("desc", "")
			
			btn.pressed.connect(func():
				Global.unequip_item(slot)
				grid_container.get_parent().get_parent().get_parent().refresh_all()
			)
			grid_container.add_child(btn)

	# 2. Show Inventory Items
	for item_id in Global.inventory:
		var count = Global.inventory[item_id]
		if count > 0:
			items_found = true
			var item_data = Global.item_db.get(item_id, {})
			var rarity = item_data.get("rarity", "")
			
			var btn = Button.new()
			btn.text = item_data.get("name", item_id) + " (x" + str(count) + ")"
			btn.custom_minimum_size = Vector2(200, 80)
			btn.tooltip_text = item_data.get("desc", "")
			
			# Color equipment items by rarity
			if rarity != "":
				btn.modulate = Global.RARITY_COLORS.get(rarity, Color.WHITE)
			
			btn.pressed.connect(use_callback.bind(item_id))
			grid_container.add_child(btn)

	if not items_found:
		var empty_label = Label.new()
		empty_label.text = "ไม่มีไอเทม"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid_container.add_child(empty_label)
