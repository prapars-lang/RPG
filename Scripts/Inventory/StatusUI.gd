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

static func update_status_display(container: Control, controller: Control = null):
	var stats = Global.get_current_stats()
	
	var name_label = container.get_node_or_null("VBox/Header/NameLabel")
	var level_label = container.get_node_or_null("VBox/Header/LevelLabel")
	var class_label = container.get_node_or_null("VBox/Header/ClassLabel")
	var hp_bar = container.get_node_or_null("VBox/Bars/HPBar")
	var mp_bar = container.get_node_or_null("VBox/Bars/MPBar")
	var gold_label = container.get_node_or_null("VBox/StatsGrid/GoldLabel")
	var hero_preview = container.get_node_or_null("VBox/HeroPreview")
	
	if name_label: name_label.text = Global.player_name
	if level_label: level_label.text = "Level " + str(Global.player_level)
	if class_label: class_label.text = Global.player_class
	if gold_label: gold_label.text = "💰 " + str(Global.player_gold) + " G"
	
	# Update Hero Preview & Animation
	if hero_preview:
		var icon_key = Global.player_class + "_" + Global.player_gender
		var path = Global.class_icons.get(icon_key, "")
		if path != "" and ResourceLoader.exists(path):
			hero_preview.texture = load(path)
			
			# Breathing Animation (only if not already animating)
			if not hero_preview.has_meta("is_animating"):
				hero_preview.set_meta("is_animating", true)
				hero_preview.pivot_offset = hero_preview.size / 2
				var t = hero_preview.create_tween().set_loops()
				t.tween_property(hero_preview, "scale", Vector2(1.05, 1.05), 2.0).set_trans(Tween.TRANS_SINE)
				t.tween_property(hero_preview, "scale", Vector2(1.0, 1.0), 2.0).set_trans(Tween.TRANS_SINE)
	
	if hp_bar:
		hp_bar.max_value = stats.max_hp
		hp_bar.value = stats.hp
		var l = hp_bar.get_node_or_null("Label")
		if l: l.text = "HP: %d/%d" % [stats.hp, stats.max_hp]
	
	if mp_bar:
		mp_bar.max_value = stats.max_mana
		mp_bar.value = stats.mana
		var l = mp_bar.get_node_or_null("Label")
		if l: l.text = "MP: %d/%d" % [stats.mana, stats.max_mana]
	
	# Display ATK and DEF
	var atk_label = container.get_node_or_null("VBox/StatsGrid/AtkValue")
	var def_label = container.get_node_or_null("VBox/StatsGrid/DefValue")
	if atk_label: atk_label.text = "โจมตี: " + str(stats.atk)
	if def_label: def_label.text = "ป้องกัน: " + str(stats["def"])
	
	# Display Equipment Slots
	_update_equip_slots(container, controller)

static func _update_equip_slots(container: Control, controller: Control = null):
	var grid = container.get_node_or_null("VBox/EquipGrid")
	if not grid: return
	
	for slot_key in SLOT_LABELS:
		var node_name = "Slot_" + slot_key
		var btn = grid.get_node_or_null(node_name)
		
		if btn and btn is Button:
			var item_id = Global.equipped_items.get(slot_key)
			
			# Base Style for Slot
			var style = StyleBoxFlat.new()
			style.bg_color = Color(0, 0, 0, 0.4)
			style.corner_radius_top_left = 8
			style.corner_radius_top_right = 8
			style.corner_radius_bottom_left = 8
			style.corner_radius_bottom_right = 8
			style.border_width_left = 1
			style.border_width_top = 1
			style.border_color = Color(1, 1, 1, 0.1)
			
			# Clear previous connections to avoid stacking
			for sig in btn.pressed.get_connections():
				btn.pressed.disconnect(sig.callable)
			
			if item_id:
				var item = Global.item_db.get(item_id, {})
				var enh = Global.enhancement_levels.get(slot_key, 0)
				var enh_text = " +%d" % enh if enh > 0 else ""
				var rarity = item.get("rarity", "common")
				var r_color = Global.RARITY_COLORS.get(rarity, Color.WHITE)
				
				btn.text = "%s\n%s%s" % [SLOT_LABELS[slot_key], item.get("name", "?"), enh_text]
				btn.add_theme_color_override("font_color", r_color)
				style.border_color = r_color.lerp(Color.WHITE, 0.3)
				style.bg_color = r_color.lerp(Color.BLACK, 0.85)
				style.bg_color.a = 0.5
				btn.tooltip_text = "คลิกเพื่อถอด: " + item.get("desc", "")
				
				var captured_slot = slot_key
				var captured_name = item.get("name", "?")
				btn.pressed.connect(func():
					Global.unequip_item(captured_slot)
					if controller and controller.has_method("show_message"):
						controller.show_message("ถอด %s" % captured_name)
						controller.refresh_all()
				)
			else:
				btn.text = "%s\n-ไม่มี-" % SLOT_LABELS[slot_key]
				btn.remove_theme_color_override("font_color")
				btn.tooltip_text = "ช่องว่าง: " + SLOT_LABELS[slot_key]
				
			btn.add_theme_stylebox_override("normal", style)
	
	# Display set bonus info
	var set_label = container.get_node_or_null("VBox/SetBonusLabel")
	if set_label:
		var active_sets = Global.get_active_sets()
		if active_sets.size() > 0:
			var set_texts = []
			for s in active_sets:
				set_texts.append("🔗 %s (%d/%d)" % [s.name, s.count, s.total])
			set_label.text = "\n".join(set_texts)
		else:
			set_label.text = ""
