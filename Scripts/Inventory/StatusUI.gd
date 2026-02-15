extends Node

# StatusUI.gd - Displays player stats and equipment in the inventory
# Updated for 6-slot equipment system with set bonuses

const SLOT_LABELS = {
	"weapon": "อาวุธ",
	"head": "หมวก",
	"body": "เกราะ",
	"hands": "ถุงมือ",
	"feet": "รองเท้า",
	"accessory": "เครื่องประดับ"
}

static func update_status_display(container: Control):
	var stats = Global.get_current_stats()
	
	var name_label = container.get_node_or_null("VBox/NameLabel")
	var level_label = container.get_node_or_null("VBox/LevelLabel")
	var class_label = container.get_node_or_null("VBox/ClassLabel")
	var hp_bar = container.get_node_or_null("VBox/HPBar")
	var mp_bar = container.get_node_or_null("VBox/MPBar")
	var gold_label = container.get_node_or_null("VBox/GoldLabel")
	
	if name_label: name_label.text = Global.player_name
	if level_label: level_label.text = "Level " + str(Global.player_level)
	if class_label: class_label.text = Global.player_class
	if gold_label: gold_label.text = "💰 " + str(Global.player_gold) + " G"
	
	if hp_bar:
		hp_bar.max_value = stats.max_hp
		hp_bar.value = stats.hp
		hp_bar.get_node_or_null("Label").text = "HP: " + str(stats.hp) + "/" + str(stats.max_hp) if hp_bar.get_node_or_null("Label") else ""
	
	if mp_bar:
		mp_bar.max_value = stats.max_mana
		mp_bar.value = stats.mana
		mp_bar.get_node_or_null("Label").text = "MP: " + str(stats.mana) + "/" + str(stats.max_mana) if mp_bar.get_node_or_null("Label") else ""
	
	# Display ATK and DEF
	var atk_label = container.get_node_or_null("VBox/AtkValue")
	var def_label = container.get_node_or_null("VBox/DefValue")
	if atk_label: atk_label.text = "ATK: " + str(stats.atk)
	if def_label: def_label.text = "DEF: " + str(stats["def"])
	
	# Display Equipment Slots
	_update_equip_slots(container)

static func _update_equip_slots(container: Control):
	var vbox = container.get_node_or_null("VBox")
	if not vbox: return
	
	for slot_key in SLOT_LABELS:
		var node_name = "Equip_" + slot_key
		var label = vbox.get_node_or_null(node_name)
		
		if label:
			var item_id = Global.equipped_items.get(slot_key)
			if item_id:
				var item = Global.item_db.get(item_id, {})
				var enh = Global.enhancement_levels.get(slot_key, 0)
				var enh_text = ""
				if enh > 0:
					enh_text = " +%d" % enh
				var rarity = item.get("rarity", "common")
				label.text = SLOT_LABELS[slot_key] + ": " + item.get("name", "?") + enh_text
				label.add_theme_color_override("font_color", Global.RARITY_COLORS.get(rarity, Color.WHITE))
			else:
				label.text = SLOT_LABELS[slot_key] + ": -ว่าง-"
				label.remove_theme_color_override("font_color")
	
	# Display set bonus info
	var set_label = vbox.get_node_or_null("SetBonusLabel")
	if set_label:
		var active_sets = Global.get_active_sets()
		if active_sets.size() > 0:
			var set_texts = []
			for s in active_sets:
				set_texts.append("🔗 %s (%d/%d)" % [s.name, s.count, s.total])
			set_label.text = "\n".join(set_texts)
		else:
			set_label.text = ""
