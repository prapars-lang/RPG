extends Node

# ItemUsage.gd - Module for item effects logic
# Part of the Modular Inventory System

static func use_item(item_id: String) -> String:
	var item_data = Global.item_db.get(item_id)
	if not item_data: return "ไม่พบข้อมูลไอเทม"
	
	var stats = Global.get_current_stats()
	var message = ""
	
	# Consumable items
	if item_data.type == "consumable":
		if item_data.subtype == "hp":
			if stats.hp >= stats.max_hp:
				return "พลังชีวิตเต็มอยู่แล้ว"
			stats.hp = min(stats.hp + item_data.value, stats.max_hp)
			message = "ใช้ %s! ฟื้นฟู HP %d หน่วย" % [item_data.name, item_data.value]
		elif item_data.subtype == "mp":
			if stats.mana >= stats.max_mana:
				return "มานาเต็มอยู่แล้ว"
			stats.mana = min(stats.mana + item_data.value, stats.max_mana)
			message = "ใช้ %s! ฟื้นฟู MP %d หน่วย" % [item_data.name, item_data.value]
		
		if Global.use_item(item_id):
			return message
		else:
			return "ไอเทมหมด"
	
	# Equipment items
	elif item_data.type == "equipment":
		if Global.equip_item(item_id):
			return "สวมใส่ %s เรียบร้อย" % item_data.name
		else:
			return "ไม่สามารถสวมใส่ได้"
	
	return "ไม่สามารถใช้ไอเทมนี้ได้"
