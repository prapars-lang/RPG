extends Node
class_name ItemDB

const ITEMS = {
	# === Consumables ===
	"potion": {"name": "น้ำยาฟื้นพลัง", "type": "consumable", "subtype": "hp", "value": 50, "desc": "ฟื้นฟู HP 50", "price": 50, "icon": "res://Assets/items/potion_hp.png"},
	"mana_refill": {"name": "น้ำยาเพิ่มสมาธิ", "type": "consumable", "subtype": "mp", "value": 30, "desc": "ฟื้นฟู MP 30", "price": 80, "icon": "res://Assets/items/potion_mp.png"},
	"potion_large": {"name": "น้ำยาฟื้นพลัง+", "type": "consumable", "subtype": "hp", "value": 120, "desc": "ฟื้นฟู HP 120", "price": 200, "icon": "res://Assets/items/potion_hp_large.png"},
	"mana_large": {"name": "น้ำยาสมาธิ+", "type": "consumable", "subtype": "mp", "value": 80, "desc": "ฟื้นฟู MP 80", "price": 250, "icon": "res://Assets/items/potion_mp_large.png"},

	# === Weapons ===
	"wooden_sword": {"name": "ดาบไม้ฝึกหัด", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 5, "desc": "ดาบไม้พื้นฐาน (ATK +5)", "price": 100, "icon": "res://Assets/items/sword_iron.png"},
	"sword_steel": {"name": "ดาบเหล็กกล้า", "type": "equipment", "slot": "weapon", "rarity": "rare", "atk": 12, "desc": "ดาบเหล็กคมกริบ (ATK +12)", "price": 350, "icon": "res://Assets/items/sword_steel.png"},
	"sword_mythril": {"name": "ดาบมิธริล", "type": "equipment", "slot": "weapon", "rarity": "epic", "atk": 22, "def": 3, "desc": "ดาบในตำนาน (ATK +22, DEF +3)", "price": 800, "icon": "res://Assets/items/sword_mythril.png"},
	"sword_flame": {"name": "ดาบเพลิงนรก", "type": "equipment", "slot": "weapon", "rarity": "legendary", "atk": 35, "desc": "ดาบลุกเป็นไฟ (ATK +35)", "price": 2000, "icon": "res://Assets/items/sword_flame.png"},
	"axe_battle": {"name": "ขวานศึก", "type": "equipment", "slot": "weapon", "rarity": "rare", "atk": 18, "desc": "ขวานสองหัวทรงพลัง (ATK +18)", "price": 500, "icon": "res://Assets/items/axe_battle.png"},
	"staff_oak": {"name": "ไม้เท้าโอ๊ค", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 3, "mana": 15, "desc": "ไม้เท้าเพิ่มมานา (ATK +3, MP +15)", "price": 120, "icon": "res://Assets/items/staff_oak.png"},
	"staff_mystic": {"name": "คทาเร้นลับ", "type": "equipment", "slot": "weapon", "rarity": "epic", "atk": 15, "mana": 40, "desc": "คทาโบราณ (ATK +15, MP +40)", "price": 900, "icon": "res://Assets/items/staff_mystic.png", "set_id": "mage_set"},
	"bow_short": {"name": "ธนูสั้น", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 8, "desc": "ธนูเล็กสำหรับเริ่มต้น (ATK +8)", "price": 150, "icon": "res://Assets/items/bow_short.png"},
	"dagger_iron": {"name": "มีดสั้นเหล็ก", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 6, "desc": "มีดสั้นคมกริบ (ATK +6)", "price": 80, "icon": "res://Assets/items/dagger_iron.png"},

	# === Head ===
	"helm_leather": {"name": "หมวกหนัง", "type": "equipment", "slot": "head", "rarity": "common", "def": 2, "desc": "หมวกหนังพื้นฐาน (DEF +2)", "price": 80, "icon": "res://Assets/items/helm_leather.png"},
	"helm_iron": {"name": "หมวกเหล็ก", "type": "equipment", "slot": "head", "rarity": "rare", "def": 5, "hp": 10, "desc": "หมวกเหล็กแข็งแกร่ง (DEF +5, HP +10)", "price": 300, "icon": "res://Assets/items/helm_iron.png", "set_id": "warrior_set"},
	"helm_knight": {"name": "หมวกอัศวิน", "type": "equipment", "slot": "head", "rarity": "epic", "def": 10, "hp": 25, "desc": "หมวกอัศวินระดับสูง (DEF +10, HP +25)", "price": 700, "icon": "res://Assets/items/helm_knight.png", "set_id": "guardian_set"},
	"hat_wizard": {"name": "หมวกพ่อมด", "type": "equipment", "slot": "head", "rarity": "rare", "def": 2, "mana": 20, "desc": "หมวกเพิ่มพลังเวท (DEF +2, MP +20)", "price": 350, "icon": "res://Assets/items/hat_wizard.png", "set_id": "mage_set"},
	"bandana": {"name": "ผ้าคาดหัว", "type": "equipment", "slot": "head", "rarity": "common", "atk": 2, "desc": "เพิ่มความคล่องแคล่ว (ATK +2)", "price": 60, "icon": "res://Assets/items/bandana.png"},

	# === Body ===
	"basic_shield": {"name": "โล่ไม้พื้นฐาน", "type": "equipment", "slot": "body", "rarity": "common", "def": 3, "desc": "โล่ไม้ทนทาน (DEF +3)", "price": 120, "icon": "res://Assets/items/shield_wooden.png"},
	"armor_leather": {"name": "ชุดเกราะหนัง", "type": "equipment", "slot": "body", "rarity": "common", "def": 4, "desc": "เกราะหนังน้ำหนักเบา (DEF +4)", "price": 150, "icon": "res://Assets/items/armor_leather.png"},
	"armor_chainmail": {"name": "เกราะโซ่เหล็ก", "type": "equipment", "slot": "body", "rarity": "rare", "def": 8, "hp": 15, "desc": "เกราะโซ่แข็งแรง (DEF +8, HP +15)", "price": 450, "icon": "res://Assets/items/armor_chainmail.png", "set_id": "warrior_set"},
	"armor_plate": {"name": "เกราะเพลท", "type": "equipment", "slot": "body", "rarity": "epic", "def": 15, "hp": 30, "desc": "เกราะหนักระดับสูงสุด (DEF +15, HP +30)", "price": 1200, "icon": "res://Assets/items/armor_plate.png", "set_id": "guardian_set"},
	"robe_mystic": {"name": "เสื้อคลุมเวทย์", "type": "equipment", "slot": "body", "rarity": "epic", "def": 5, "mana": 35, "desc": "เสื้อคลุมเพิ่มพลังเวท (DEF +5, MP +35)", "price": 800, "icon": "res://Assets/items/robe_mystic.png", "set_id": "mage_set"},

	# === Hands ===
	"gloves_leather": {"name": "ถุงมือหนัง", "type": "equipment", "slot": "hands", "rarity": "common", "atk": 1, "def": 1, "desc": "ถุงมือพื้นฐาน (ATK +1, DEF +1)", "price": 60, "icon": "res://Assets/items/gloves_leather.png"},
	"gloves_iron": {"name": "ถุงมือเหล็ก", "type": "equipment", "slot": "hands", "rarity": "rare", "atk": 3, "def": 3, "desc": "ถุงเกราะเหล็ก (ATK +3, DEF +3)", "price": 250, "icon": "res://Assets/items/gloves_iron.png", "set_id": "warrior_set"},
	"gloves_mythril": {"name": "ถุงมือมิธริล", "type": "equipment", "slot": "hands", "rarity": "epic", "atk": 5, "def": 5, "mana": 10, "desc": "ถุงมือในตำนาน (ATK +5, DEF +5, MP +10)", "price": 600, "icon": "res://Assets/items/gloves_mythril.png", "set_id": "mage_set"},

	# === Feet ===
	"boots_leather": {"name": "รองเท้าหนัง", "type": "equipment", "slot": "feet", "rarity": "common", "def": 1, "desc": "รองเท้าหนังพื้นฐาน (DEF +1)", "price": 50, "icon": "res://Assets/items/boots_leather.png"},
	"boots_iron": {"name": "รองเท้าเหล็ก", "type": "equipment", "slot": "feet", "rarity": "rare", "def": 4, "hp": 10, "desc": "รองเท้าเหล็กทนทาน (DEF +4, HP +10)", "price": 280, "icon": "res://Assets/items/boots_iron.png", "set_id": "warrior_set"},
	"boots_speed": {"name": "รองเท้าแห่งความเร็ว", "type": "equipment", "slot": "feet", "rarity": "epic", "def": 3, "atk": 5, "desc": "รองเท้าเพิ่มความคล่อง (DEF +3, ATK +5)", "price": 550, "icon": "res://Assets/items/boots_speed.png", "set_id": "mage_set"},

	# === Accessories ===
	"ring_power": {"name": "แหวนแห่งพลัง", "type": "equipment", "slot": "accessory", "rarity": "rare", "atk": 8, "desc": "เพิ่มพลังโจมตี (ATK +8)", "price": 400, "icon": "res://Assets/items/ring_power.png"},
	"ring_guard": {"name": "แหวนแห่งการ์ด", "type": "equipment", "slot": "accessory", "rarity": "rare", "def": 6, "hp": 15, "desc": "เพิ่มการป้องกัน (DEF +6, HP +15)", "price": 400, "icon": "res://Assets/items/ring_guard.png"},
	"necklace_hp": {"name": "สร้อยแห่งชีวิต", "type": "equipment", "slot": "accessory", "rarity": "epic", "hp": 50, "desc": "เพิ่ม HP อย่างมาก (HP +50)", "price": 700, "icon": "res://Assets/items/necklace_hp.png"},
	"necklace_mp": {"name": "สร้อยแห่งสมาธิ", "type": "equipment", "slot": "accessory", "rarity": "epic", "mana": 40, "desc": "เพิ่ม MP อย่างมาก (MP +40)", "price": 700, "icon": "res://Assets/items/necklace_mp.png"},
	"amulet_luck": {"name": "เครื่องรางนำโชค", "type": "equipment", "slot": "accessory", "rarity": "legendary", "atk": 10, "def": 10, "hp": 30, "mana": 20, "desc": "เครื่องรางในตำนาน (ALL +)", "price": 3000, "icon": "res://Assets/items/amulet_luck.png"},
	"healthy_ring": {"name": "แหวนแห่งสุขภาพ", "type": "equipment", "slot": "accessory", "rarity": "common", "hp": 20, "desc": "เพิ่มพลังชีวิตเล็กน้อย (HP +20)", "price": 200, "icon": "res://Assets/items/ring_guard.png"}
}

const SET_BONUSES = {
	"warrior_set": {
		"name": "เซ็ตนักรบ",
		"pieces": ["sword_iron", "helm_iron", "armor_chainmail", "gloves_iron", "boots_iron"],
		"bonus_2": {"atk": 5, "def": 3},
		"bonus_4": {"atk": 15, "def": 8, "hp": 30}
	},
	"mage_set": {
		"name": "เซ็ตจอมเวทย์",
		"pieces": ["staff_mystic", "hat_wizard", "robe_mystic", "gloves_mythril", "boots_speed"],
		"bonus_2": {"mana": 20, "atk": 5},
		"bonus_4": {"mana": 50, "atk": 15, "hp": 20}
	},
	"guardian_set": {
		"name": "เซ็ตผู้พิทักษ์",
		"pieces": ["shield_mythril", "helm_knight", "armor_plate", "gloves_mythril", "boots_iron"],
		"bonus_2": {"def": 8, "hp": 20},
		"bonus_4": {"def": 20, "hp": 60}
	}
}

const RARITY_COLORS = {
	"common": Color(1, 1, 1),
	"rare": Color(0.3, 0.6, 1.0),
	"epic": Color(0.7, 0.3, 1.0),
	"legendary": Color(1, 0.8, 0.2),
	"mythic": Color(1, 0.2, 0.2)
}

const ENHANCE_COST = [100, 200, 400, 800, 1500, 2500, 4000, 6000, 9000, 15000]
const ENHANCE_SUCCESS = [1.0, 0.95, 0.90, 0.80, 0.70, 0.60, 0.50, 0.40, 0.30, 0.20]
