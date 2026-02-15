extends Node

signal level_up_occurred(new_level, stats_before, stats_after)

# --- Player Data ---
var player_name = "ผู้กล้า"
var player_gender = "เด็กชาย" 
var player_class = "อัศวิน" 
var player_level = 1
var player_xp = 0
var player_gold = 0
var current_mana = 0
var current_path = "" # "exercise", "nutrition", "hygiene"
var class_icons = {
	"อัศวิน_เด็กชาย": "res://Assets/Tan.png",
	"อัศวิน_เด็กหญิง": "res://Assets/Rin.png",
	"จอมเวทย์_เด็กชาย": "res://Assets/Pun.png",
	"จอมเวทย์_เด็กหญิง": "res://Assets/Paeng.png",
	"นักล่า_เด็กชาย": "res://Assets/Win.png",
	"นักล่า_เด็กหญิง": "res://Assets/Punch.png",
	"ผู้พิทักษ์_เด็กชาย": "res://Assets/Korn.png",
	"ผู้พิทักษ์_เด็กหญิง": "res://Assets/Fan.png"
}
# Story State
var story_progress = 0 # Current chunk index
var is_story_mode = false # If true, Battle returns to StoryScene
var queued_story_enemy_id = "" # Override enemy for story battles
var used_questions = [] # Track IDs of questions already asked this session
var current_scene = "res://Scenes/MainMenu.tscn" # Track where player is for save/load

# Quest State
var active_quests = [] # IDs of active quests
var completed_quests = [] # IDs of completed quests


# --- System Data ---
var question_data = {}

# --- Inventory & Economy ---
var inventory = {
	"potion": 2,
	"mana_refill": 1,
	"wooden_sword": 1,
	"basic_shield": 1
}

var equipped_items = {
	"weapon": null,
	"head": null,
	"body": null,
	"hands": null,
	"feet": null,
	"accessory": null
}

# Enhancement levels per slot (default +0)
var enhancement_levels = {
	"weapon": 0, "head": 0, "body": 0,
	"hands": 0, "feet": 0, "accessory": 0
}

# Rarity colors for UI
const RARITY_COLORS = {
	"common": Color(1, 1, 1),        # White
	"rare": Color(0.3, 0.6, 1.0),    # Blue
	"epic": Color(0.7, 0.3, 1.0),    # Purple
	"legendary": Color(1, 0.8, 0.2), # Gold
	"mythic": Color(1, 0.2, 0.2)     # Red
}

# Set bonus definitions
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

# Enhancement cost & success rate
const ENHANCE_COST = [100, 200, 400, 800, 1500, 2500, 4000, 6000, 9000, 15000]
const ENHANCE_SUCCESS = [1.0, 0.95, 0.90, 0.80, 0.70, 0.60, 0.50, 0.40, 0.30, 0.20]

var item_db = {
	# === Consumables ===
	"potion": {"name": "น้ำยาฟื้นพลัง", "type": "consumable", "subtype": "hp", "value": 50, "desc": "ฟื้นฟู HP 50", "price": 50, "icon": "res://Assets/items/potion_hp.png"},
	"mana_refill": {"name": "น้ำยาเพิ่มสมาธิ", "type": "consumable", "subtype": "mp", "value": 30, "desc": "ฟื้นฟู MP 30", "price": 80, "icon": "res://Assets/items/potion_mp.png"},
	"potion_large": {"name": "น้ำยาฟื้นพลัง+", "type": "consumable", "subtype": "hp", "value": 120, "desc": "ฟื้นฟู HP 120", "price": 200, "icon": "res://Assets/items/potion_hp_large.png"},
	"mana_large": {"name": "น้ำยาสมาธิ+", "type": "consumable", "subtype": "mp", "value": 80, "desc": "ฟื้นฟู MP 80", "price": 250, "icon": "res://Assets/items/potion_mp_large.png"},

	# === Weapons (slot: weapon) ===
	"wooden_sword": {"name": "ดาบไม้ฝึกหัด", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 5, "desc": "ดาบไม้พื้นฐาน (ATK +5)", "price": 100, "icon": "res://Assets/items/sword_iron.png"},
	"sword_steel": {"name": "ดาบเหล็กกล้า", "type": "equipment", "slot": "weapon", "rarity": "rare", "atk": 12, "desc": "ดาบเหล็กคมกริบ (ATK +12)", "price": 350, "icon": "res://Assets/items/sword_steel.png"},
	"sword_mythril": {"name": "ดาบมิธริล", "type": "equipment", "slot": "weapon", "rarity": "epic", "atk": 22, "def": 3, "desc": "ดาบในตำนาน (ATK +22, DEF +3)", "price": 800, "icon": "res://Assets/items/sword_mythril.png"},
	"sword_flame": {"name": "ดาบเพลิงนรก", "type": "equipment", "slot": "weapon", "rarity": "legendary", "atk": 35, "desc": "ดาบลุกเป็นไฟ (ATK +35)", "price": 2000, "icon": "res://Assets/items/sword_flame.png"},
	"axe_battle": {"name": "ขวานศึก", "type": "equipment", "slot": "weapon", "rarity": "rare", "atk": 18, "desc": "ขวานสองหัวทรงพลัง (ATK +18)", "price": 500, "icon": "res://Assets/items/axe_battle.png"},
	"staff_oak": {"name": "ไม้เท้าโอ๊ค", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 3, "mana": 15, "desc": "ไม้เท้าเพิ่มมานา (ATK +3, MP +15)", "price": 120, "icon": "res://Assets/items/staff_oak.png"},
	"staff_mystic": {"name": "คทาเร้นลับ", "type": "equipment", "slot": "weapon", "rarity": "epic", "atk": 15, "mana": 40, "desc": "คทาโบราณ (ATK +15, MP +40)", "price": 900, "icon": "res://Assets/items/staff_mystic.png", "set_id": "mage_set"},
	"bow_short": {"name": "ธนูสั้น", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 8, "desc": "ธนูเล็กสำหรับเริ่มต้น (ATK +8)", "price": 150, "icon": "res://Assets/items/bow_short.png"},
	"dagger_iron": {"name": "มีดสั้นเหล็ก", "type": "equipment", "slot": "weapon", "rarity": "common", "atk": 6, "desc": "มีดสั้นคมกริบ (ATK +6)", "price": 80, "icon": "res://Assets/items/dagger_iron.png"},

	# === Head (slot: head) ===
	"helm_leather": {"name": "หมวกหนัง", "type": "equipment", "slot": "head", "rarity": "common", "def": 2, "desc": "หมวกหนังพื้นฐาน (DEF +2)", "price": 80, "icon": "res://Assets/items/helm_leather.png"},
	"helm_iron": {"name": "หมวกเหล็ก", "type": "equipment", "slot": "head", "rarity": "rare", "def": 5, "hp": 10, "desc": "หมวกเหล็กแข็งแกร่ง (DEF +5, HP +10)", "price": 300, "icon": "res://Assets/items/helm_iron.png", "set_id": "warrior_set"},
	"helm_knight": {"name": "หมวกอัศวิน", "type": "equipment", "slot": "head", "rarity": "epic", "def": 10, "hp": 25, "desc": "หมวกอัศวินระดับสูง (DEF +10, HP +25)", "price": 700, "icon": "res://Assets/items/helm_knight.png", "set_id": "guardian_set"},
	"hat_wizard": {"name": "หมวกพ่อมด", "type": "equipment", "slot": "head", "rarity": "rare", "def": 2, "mana": 20, "desc": "หมวกเพิ่มพลังเวท (DEF +2, MP +20)", "price": 350, "icon": "res://Assets/items/hat_wizard.png", "set_id": "mage_set"},
	"bandana": {"name": "ผ้าคาดหัว", "type": "equipment", "slot": "head", "rarity": "common", "atk": 2, "desc": "เพิ่มความคล่องแคล่ว (ATK +2)", "price": 60, "icon": "res://Assets/items/bandana.png"},

	# === Body (slot: body) ===
	"basic_shield": {"name": "โล่ไม้พื้นฐาน", "type": "equipment", "slot": "body", "rarity": "common", "def": 3, "desc": "โล่ไม้ทนทาน (DEF +3)", "price": 120, "icon": "res://Assets/items/shield_wooden.png"},
	"armor_leather": {"name": "ชุดเกราะหนัง", "type": "equipment", "slot": "body", "rarity": "common", "def": 4, "desc": "เกราะหนังน้ำหนักเบา (DEF +4)", "price": 150, "icon": "res://Assets/items/armor_leather.png"},
	"armor_chainmail": {"name": "เกราะโซ่เหล็ก", "type": "equipment", "slot": "body", "rarity": "rare", "def": 8, "hp": 15, "desc": "เกราะโซ่แข็งแรง (DEF +8, HP +15)", "price": 450, "icon": "res://Assets/items/armor_chainmail.png", "set_id": "warrior_set"},
	"armor_plate": {"name": "เกราะเพลท", "type": "equipment", "slot": "body", "rarity": "epic", "def": 15, "hp": 30, "desc": "เกราะหนักระดับสูงสุด (DEF +15, HP +30)", "price": 1200, "icon": "res://Assets/items/armor_plate.png", "set_id": "guardian_set"},
	"robe_mystic": {"name": "เสื้อคลุมเวทย์", "type": "equipment", "slot": "body", "rarity": "epic", "def": 5, "mana": 35, "desc": "เสื้อคลุมเพิ่มพลังเวท (DEF +5, MP +35)", "price": 800, "icon": "res://Assets/items/robe_mystic.png", "set_id": "mage_set"},

	# === Hands (slot: hands) ===
	"gloves_leather": {"name": "ถุงมือหนัง", "type": "equipment", "slot": "hands", "rarity": "common", "atk": 1, "def": 1, "desc": "ถุงมือพื้นฐาน (ATK +1, DEF +1)", "price": 60, "icon": "res://Assets/items/gloves_leather.png"},
	"gloves_iron": {"name": "ถุงมือเหล็ก", "type": "equipment", "slot": "hands", "rarity": "rare", "atk": 3, "def": 3, "desc": "ถุงเกราะเหล็ก (ATK +3, DEF +3)", "price": 250, "icon": "res://Assets/items/gloves_iron.png", "set_id": "warrior_set"},
	"gloves_mythril": {"name": "ถุงมือมิธริล", "type": "equipment", "slot": "hands", "rarity": "epic", "atk": 5, "def": 5, "mana": 10, "desc": "ถุงมือในตำนาน (ATK +5, DEF +5, MP +10)", "price": 600, "icon": "res://Assets/items/gloves_mythril.png", "set_id": "mage_set"},

	# === Feet (slot: feet) ===
	"boots_leather": {"name": "รองเท้าหนัง", "type": "equipment", "slot": "feet", "rarity": "common", "def": 1, "desc": "รองเท้าหนังพื้นฐาน (DEF +1)", "price": 50, "icon": "res://Assets/items/boots_leather.png"},
	"boots_iron": {"name": "รองเท้าเหล็ก", "type": "equipment", "slot": "feet", "rarity": "rare", "def": 4, "hp": 10, "desc": "รองเท้าเหล็กทนทาน (DEF +4, HP +10)", "price": 280, "icon": "res://Assets/items/boots_iron.png", "set_id": "warrior_set"},
	"boots_speed": {"name": "รองเท้าแห่งความเร็ว", "type": "equipment", "slot": "feet", "rarity": "epic", "def": 3, "atk": 5, "desc": "รองเท้าเพิ่มความคล่อง (DEF +3, ATK +5)", "price": 550, "icon": "res://Assets/items/boots_speed.png", "set_id": "mage_set"},

	# === Accessories (slot: accessory) ===
	"ring_power": {"name": "แหวนแห่งพลัง", "type": "equipment", "slot": "accessory", "rarity": "rare", "atk": 8, "desc": "เพิ่มพลังโจมตี (ATK +8)", "price": 400, "icon": "res://Assets/items/ring_power.png"},
	"ring_guard": {"name": "แหวนแห่งการ์ด", "type": "equipment", "slot": "accessory", "rarity": "rare", "def": 6, "hp": 15, "desc": "เพิ่มการป้องกัน (DEF +6, HP +15)", "price": 400, "icon": "res://Assets/items/ring_guard.png"},
	"necklace_hp": {"name": "สร้อยแห่งชีวิต", "type": "equipment", "slot": "accessory", "rarity": "epic", "hp": 50, "desc": "เพิ่ม HP อย่างมาก (HP +50)", "price": 700, "icon": "res://Assets/items/necklace_hp.png"},
	"necklace_mp": {"name": "สร้อยแห่งสมาธิ", "type": "equipment", "slot": "accessory", "rarity": "epic", "mana": 40, "desc": "เพิ่ม MP อย่างมาก (MP +40)", "price": 700, "icon": "res://Assets/items/necklace_mp.png"},
	"amulet_luck": {"name": "เครื่องรางนำโชค", "type": "equipment", "slot": "accessory", "rarity": "legendary", "atk": 10, "def": 10, "hp": 30, "mana": 20, "desc": "เครื่องรางในตำนาน (ALL +)", "price": 3000, "icon": "res://Assets/items/amulet_luck.png"},
	"healthy_ring": {"name": "แหวนแห่งสุขภาพ", "type": "equipment", "slot": "accessory", "rarity": "common", "hp": 20, "desc": "เพิ่มพลังชีวิตเล็กน้อย (HP +20)", "price": 200, "icon": "res://Assets/items/ring_guard.png"}
}


# --- Game Data (Stats, Skills, Monsters) ---
var stats = {
	"อัศวิน": {"hp": 120, "max_hp": 120, "mana": 30, "max_mana": 30, "atk": 15, "def": 12},
	"จอมเวทย์": {"hp": 80, "max_hp": 80, "mana": 100, "max_mana": 100, "atk": 25, "def": 5},
	"นักล่า": {"hp": 100, "max_hp": 100, "mana": 50, "max_mana": 50, "atk": 18, "def": 8},
	"ผู้พิทักษ์": {"hp": 110, "max_hp": 110, "mana": 70, "max_mana": 70, "atk": 12, "def": 15}
}

var skills = {
	"อัศวิน": [
		{"name": "โล่ยืดเหยียด", "cost": 10, "type": "buff", "value": 5, "desc": "เพิ่มพลังป้องกันด้วยการยืดเหยียด"}
	],
	"จอมเวทย์": [
		{"name": "พลังอาหาร 5 หมู่", "cost": 15, "type": "dmg", "value": 40, "desc": "โจมตีรุนแรงด้วยพลังโภชนาการ"}
	],
	"นักล่า": [
		{"name": "สเปรย์ฆ่าเชื้อ", "cost": 12, "type": "dmg", "value": 30, "desc": "ฉีดสเปรย์กำจัดเชื้อโรคอย่างรวดเร็ว"}
	],
	"ผู้พิทักษ์": [
		{"name": "ระฆังแห่งสติ", "cost": 20, "type": "buff", "value": 30, "desc": "ฟื้นฟูพลังชีวิตและมานาด้วยเสียงระฆัง"}
	]
}

var monster_db = {
	# --- Basic / Generic ---
	
	# --- Path 1: Body (Exercise) ---
	"lazy_slime": {
		"name": "สไลม์ขี้เกียจ",
		"hp": 40,
		"atk": 5,
		"xp": 30,
		"min_gold": 10,
		"max_gold": 15,
		"texture": "res://Assets/Lazy Slime.png"
	},
	"atrophy_ghost": {
		"name": "วิญญาณกล้ามลีบ",
		"hp": 60,
		"atk": 12,
		"xp": 50,
		"min_gold": 20,
		"max_gold": 30,
		"texture": "res://Assets/Atrophy Spirit.png"
	},
	"couch_golem": {
		"name": "โกเลมโซฟา",
		"hp": 100,
		"atk": 8,
		"xp": 80,
		"min_gold": 35,
		"max_gold": 50,
		"texture": "res://Assets/Couch Potato Golem.png"
	},

	# --- Path 2: Nutrition (Kingdom of Flavors) ---
	"sugar_spy": {
		"name": "สายลับน้ำตาล",
		"hp": 70,
		"atk": 12,
		"xp": 60,
		"gold": 25,
		"texture": "res://Assets/Sugar Spy.png"
	},
	"fat_phantom": {
		"name": "ปีศาจไขมันพอก",
		"hp": 90,
		"atk": 15,
		"xp": 80,
		"gold": 35,
		"texture": "res://Assets/Fat Phantom.png"
	},
	"salt_slime": {
		"name": "สไลม์เกลือเค็ม",
		"hp": 80,
		"atk": 20,
		"xp": 75,
		"gold": 30,
		"texture": "res://Assets/Salt Slime.png"
	},
	"junk_food_king": { # Boss
		"name": "ราชา Junk Food",
		"hp": 350,
		"atk": 45,
		"xp": 700,
		"gold": 300,
		"texture": "res://Assets/Junk Food King.png"
	},

	# --- Path 3: Hygiene (Society) ---
	"smoke": {
		"name": "หมอกควันพิษ",
		"hp": 70,
		"atk": 14,
		"xp": 70,
		"gold": 30,
		"texture": "res://Assets/Smog Cloud.png"
	},
	"stress": {
		"name": "เงาความเครียด",
		"hp": 90,
		"atk": 18,
		"xp": 100,
		"gold": 45,
		"texture": "res://Assets/Stress Shadow.png"
	},
	"trash_heap": {
		"name": "กองขยะเดินได้",
		"hp": 90,
		"atk": 10,
		"xp": 70,
		"gold": 35,
		"texture": "res://Assets/Trash Heap.png"
	},
	"noise_banshee": {
		"name": "ปีศาจเสียงรบกวน",
		"hp": 50,
		"atk": 20,
		"xp": 65,
		"gold": 30,
		"texture": "res://Assets/Noise Banshee.png"
	},
	"trash_demon": {
		"name": "ปีศาจขยะ",
		"hp": 80,
		"atk": 12,
		"xp": 80,
		"gold": 40,
		"texture": "res://Assets/Trash Demon.png"
	},
	"virus": {
		"name": "ไวรัสจอมวายร้าย",
		"hp": 100,
		"atk": 15,
		"xp": 120,
		"gold": 50,
		"texture": "res://Assets/Virus Monster.png"
	},
	"germ": {
		"name": "เชื้อโรคอันตราย",
		"hp": 110,
		"atk": 18,
		"xp": 140,
		"gold": 60,
		"texture": "res://Assets/Germ Monster .png"
	},
	"plague_lord": { # New Boss for Hygiene Path
		"name": "ราชาโรคระบาด",
		"hp": 300,
		"atk": 40,
		"xp": 600,
		"gold": 250,
		"texture": "res://Assets/Plague Lord.png"
	},
	
	# --- Legacy / Others ---
	"parasite": {
		"name": "หนอนพยาธิทมิฬ",
		"hp": 120,
		"atk": 20,
		"xp": 150,
		"gold": 60,
		"texture": "res://Assets/monster_virus.png"
	},
	"overthinking_golem": { # New Boss for Wisdom Path
		"name": "ยักษ์จอมฟุ้งซ่าน",
		"hp": 250,
		"atk": 30,
		"xp": 500,
		"gold": 200,
		"texture": "res://Assets/Overthinking Golem.png"
	}
}

func _ready():
	load_questions()

# --- Core Logic Functions ---

func get_current_stats():
	var base = stats["อัศวิน"]
	if player_class in stats:
		base = stats[player_class].duplicate()
	
	# Add bonuses from equipment
	for slot in equipped_items:
		var item_id = equipped_items[slot]
		if item_id and item_id in item_db:
			var item = item_db[item_id]
			if "hp" in item: base.max_hp += item.hp
			if "mana" in item: base.max_mana += item.mana
			if "atk" in item: base.atk += item.atk
			if "def" in item: base["def"] += item["def"]
			
			# Enhancement bonus: +5% per level for the item's primary stat
			var enh_level = enhancement_levels.get(slot, 0)
			if enh_level > 0:
				if "atk" in item:
					base.atk += int(item.atk * enh_level * 0.05)
				if "def" in item:
					base["def"] += int(item["def"] * enh_level * 0.05)
				if "hp" in item:
					base.max_hp += int(item.hp * enh_level * 0.05)
				if "mana" in item:
					base.max_mana += int(item.mana * enh_level * 0.05)
	
	# Add set bonuses
	var set_bonus = get_set_bonus()
	if set_bonus.size() > 0:
		if "atk" in set_bonus: base.atk += set_bonus.atk
		if "def" in set_bonus: base["def"] += set_bonus["def"]
		if "hp" in set_bonus: base.max_hp += set_bonus.hp
		if "mana" in set_bonus: base.max_mana += set_bonus.mana
	
	return base

func get_set_bonus() -> Dictionary:
	var total_bonus = {}
	
	for set_id in SET_BONUSES:
		var set_data = SET_BONUSES[set_id]
		var count = 0
		
		for slot in equipped_items:
			var item_id = equipped_items[slot]
			if item_id and item_id in item_db:
				var item = item_db[item_id]
				if item.get("set_id", "") == set_id:
					count += 1
		
		if count >= 4 and "bonus_4" in set_data:
			for key in set_data.bonus_4:
				total_bonus[key] = total_bonus.get(key, 0) + set_data.bonus_4[key]
		elif count >= 2 and "bonus_2" in set_data:
			for key in set_data.bonus_2:
				total_bonus[key] = total_bonus.get(key, 0) + set_data.bonus_2[key]
	
	return total_bonus

func get_active_sets() -> Array:
	# Returns array of {"name", "count", "required"} for UI display
	var result = []
	for set_id in SET_BONUSES:
		var set_data = SET_BONUSES[set_id]
		var count = 0
		for slot in equipped_items:
			var item_id = equipped_items[slot]
			if item_id and item_id in item_db:
				if item_db[item_id].get("set_id", "") == set_id:
					count += 1
		if count > 0:
			result.append({"name": set_data.name, "count": count, "total": set_data.pieces.size()})
	return result

func equip_item(item_id):
	if not item_id in item_db: return false
	var item = item_db[item_id]
	
	if item.type != "equipment": return false
	var slot = item.get("slot", "")
	if slot == "" or not slot in equipped_items: return false
	
	# 1. Take out of inventory
	if inventory.get(item_id, 0) <= 0: return false
	inventory[item_id] -= 1
	
	# 2. Unequip old item if exists
	if equipped_items[slot] != null:
		unequip_item(slot)
	
	# 3. Put in slot & reset enhancement
	equipped_items[slot] = item_id
	enhancement_levels[slot] = 0
	save_game()
	return true

func unequip_item(slot):
	if not slot in equipped_items or equipped_items[slot] == null:
		return false
	
	var item_id = equipped_items[slot]
	inventory[item_id] = inventory.get(item_id, 0) + 1
	equipped_items[slot] = null
	enhancement_levels[slot] = 0
	save_game()
	return true

func enhance_item(slot) -> Dictionary:
	# Returns {"success": bool, "message": String, "new_level": int}
	if not slot in equipped_items or equipped_items[slot] == null:
		return {"success": false, "message": "ไม่มีอุปกรณ์ในช่องนี้"}
	
	var current_level = enhancement_levels.get(slot, 0)
	if current_level >= 10:
		return {"success": false, "message": "อัปเกรดสูงสุดแล้ว (+10)"}
	
	var cost = ENHANCE_COST[current_level]
	if player_gold < cost:
		return {"success": false, "message": "เหรียญไม่พอ (ต้องการ %d G)" % cost}
	
	# Deduct gold
	player_gold -= cost
	
	# Roll for success
	var success_rate = ENHANCE_SUCCESS[current_level]
	var roll = randf()
	
	if roll <= success_rate:
		enhancement_levels[slot] = current_level + 1
		save_game()
		return {
			"success": true, 
			"message": "อัปเกรดสำเร็จ! +%d → +%d" % [current_level, current_level + 1],
			"new_level": current_level + 1
		}
	else:
		# Enhancement failed - level stays the same (no downgrade for now)
		save_game()
		return {
			"success": false, 
			"message": "อัปเกรดล้มเหลว! ยังคง +%d" % current_level,
			"new_level": current_level
		}


func get_xp_for_level(level):
	# Formula: Level * 100 * (1 + (Level * 0.1))
	return int(level * 100 * (1 + (level * 0.1)))

func gain_xp(amount):
	player_xp += amount
	var required_xp = get_xp_for_level(player_level)
	
	if player_xp >= required_xp:
		level_up()

func add_gold(amount):
	player_gold += amount
	print("Gold added: ", amount, ". Total: ", player_gold)
	save_game()

func level_up():
	var old_stats = stats[player_class].duplicate()
	player_xp -= get_xp_for_level(player_level)
	player_level += 1
	
	# Class-based Stat Growth
	var s = stats[player_class]
	if player_class == "อัศวิน":
		s.max_hp += 20
		s.max_mana += 5
		s.atk += 3
		s["def"] += 2
	elif player_class == "จอมเวทย์":
		s.max_hp += 10
		s.max_mana += 15
		s.atk += 5
		s["def"] += 1
	elif player_class == "นักล่า":
		s.max_hp += 15
		s.max_mana += 10
		s.atk += 4
		s["def"] += 1
	elif player_class == "ผู้พิทักษ์":
		s.max_hp += 18
		s.max_mana += 12
		s.atk += 2
		s["def"] += 3
		
	s.hp = s.max_hp
	s.mana = s.max_mana
	
	emit_signal("level_up_occurred", player_level, old_stats, s)
	print("LEVEL UP! Level: ", player_level)
	save_game() # Auto-save on level up
	return true

func get_current_grade():
	if player_level <= 2: return "P1"
	elif player_level <= 4: return "P2"
	elif player_level <= 6: return "P3"
	elif player_level <= 8: return "P4"
	elif player_level <= 10: return "P5"
	else: return "P6"

# --- Unique Question Selection Logic ---
# This system ensures NO question is ever repeated during a play session.
# used_questions persists across scene changes and is saved to disk.
func get_unique_question(grade: String, topic: String = "") -> Dictionary:
	var all_questions = question_data.get(grade, [])
	if all_questions.size() == 0:
		print("[QSystem] WARNING: No questions found for grade: ", grade)
		return {}

	# 1. Filter out all previously used questions
	var unused = []
	for q in all_questions:
		if not q.q in used_questions:
			unused.append(q)
	
	print("[QSystem] Grade: ", grade, " | Total: ", all_questions.size(), " | Used: ", used_questions.size(), " | Remaining: ", unused.size())
	
	# 2. If ALL questions for this grade are exhausted, reset ONLY this grade's history
	if unused.size() == 0:
		print("[QSystem] All questions exhausted for grade: ", grade, ". Resetting this grade only.")
		var new_used = []
		for q_text in used_questions:
			var is_from_this_grade = false
			for q_data in all_questions:
				if q_data.q == q_text:
					is_from_this_grade = true
					break
			# Keep questions from OTHER grades in the used list
			if not is_from_this_grade:
				new_used.append(q_text)
		used_questions = new_used
		unused = all_questions
		print("[QSystem] Reset complete. Now available for ", grade, ": ", unused.size())
	
	# 3. Filter unused by topic if provided
	var topic_matches = []
	if topic != "":
		# Handle multiple topics for some paths
		var targets = [topic]
		if topic == "wisdom": targets = ["social", "health", "safety"]
		elif topic == "exercise": targets = ["pe", "body"]
		elif topic == "nutrition": targets = ["nutrition", "food", "health"]
		elif topic == "hygiene": targets = ["hygiene", "body", "environment", "safety"]
		
		for q in unused:
			if q.get("topic", "") in targets:
				topic_matches.append(q)
		
		print("[QSystem] Topic filter '", topic, "' -> targets: ", targets, " | Matches: ", topic_matches.size())
	
	var final_selection = {}
	if topic_matches.size() > 0:
		final_selection = topic_matches.pick_random()
	else:
		# Fallback to any unused question in this grade
		final_selection = unused.pick_random()
	
	if final_selection != {}:
		used_questions.append(final_selection.q)
		print("[QSystem] Selected: '", final_selection.q.left(30), "...' | Total used now: ", used_questions.size())
		# Auto-save used_questions to prevent data loss on crash/exit
		save_game()
		
	return final_selection

func get_monster_for_path(path_name):
	match path_name:
		"exercise":
			return ["lazy_slime", "atrophy_ghost", "couch_golem"].pick_random()
		"nutrition":
			return ["sugar_spy", "fat_phantom", "salt_slime"].pick_random()
		"hygiene":
			return ["smoke", "stress", "trash_heap", "noise_banshee", "virus"].pick_random()
		"wisdom":
			return ["stress", "noise_banshee", "atrophy_ghost"].pick_random()
	return ["virus", "germ"].pick_random() # Fallback

# --- Inventory Functions ---

func add_item(item_id, amount):
	if item_id in inventory:
		inventory[item_id] += amount
	else:
		inventory[item_id] = amount
	print("Added ", amount, " of ", item_id)

func use_item(item_id):
	if item_id in inventory and inventory[item_id] > 0:
		inventory[item_id] -= 1
		return true
	return false

# --- Data Loading & Saving ---

func load_questions():
	var path = "res://Data/questions.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(content)
		if parse_result == OK:
			question_data = json.data
			print("Question database loaded successfully!")
		else:
			print("JSON Parse Error: ", json.get_error_message())
	else:
		print("CRITICAL: questions.json NOT found!")

func save_game():
	var save_data = {
		"name": player_name,
		"gender": player_gender,
		"class": player_class,
		"level": player_level,
		"xp": player_xp,
		"gold": player_gold,
		"stats": stats,
		"inventory": inventory,
		"story_progress": story_progress,
		"current_path": current_path,
		"current_scene": current_scene,
		"used_questions": used_questions,
		"equipped_items": equipped_items,
		"enhancement_levels": enhancement_levels,
		"active_quests": active_quests,
		"completed_quests": completed_quests
	}
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	print("Game Saved!")

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return false
	
	var file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		player_name = data.get("name", "ผู้กล้า")
		player_gender = data.get("gender", "เด็กชาย")
		player_class = data.get("class", "อัศวิน")
		player_level = data.get("level", 1)
		player_xp = data.get("xp", 0)
		player_gold = data.get("gold", 0)
		if "stats" in data: stats = data["stats"]
		if "inventory" in data: inventory = data["inventory"]
		if "story_progress" in data: story_progress = data["story_progress"]
		if "current_path" in data: current_path = data["current_path"]
		if "current_scene" in data: current_scene = data["current_scene"]
		if "used_questions" in data: used_questions = data["used_questions"]
		if "equipped_items" in data:
			var loaded_equip = data["equipped_items"]
			# Migrate old 3-slot saves to 6-slot system
			for slot in equipped_items:
				if slot in loaded_equip:
					equipped_items[slot] = loaded_equip[slot]
			# Migrate old "armor" slot to "body"
			if "armor" in loaded_equip and loaded_equip["armor"] != null:
				equipped_items["body"] = loaded_equip["armor"]
		if "enhancement_levels" in data:
			var loaded_enh = data["enhancement_levels"]
			for slot in enhancement_levels:
				if slot in loaded_enh:
					enhancement_levels[slot] = loaded_enh[slot]
		if "active_quests" in data: active_quests = data["active_quests"]
		if "completed_quests" in data: completed_quests = data["completed_quests"]
		print("Game Loaded!")
		return true
	return false

# --- Helper Functions for Save/Load UI ---

func has_save_file():
	return FileAccess.file_exists("user://savegame.save")

func load_and_start():
	if load_game():
		# Change to the saved scene
		var target_scene = current_scene
		if target_scene == "" or target_scene == "res://Scenes/MainMenu.tscn":
			target_scene = "res://Scenes/Crossroads.tscn" # Default to Crossroads if invalid
		get_tree().change_scene_to_file(target_scene)
		return true
	return false

# --- AI Helpers ---

func get_ai_context() -> String:
	var stats_info = get_current_stats()
	var context = "ข้อมูลผู้เล่นปัจจุบัน:\n"
	context += "- ชื่อ: %s\n" % player_name
	context += "- อาชีพ: %s (HP: %d/%d, ATK: %d, DEF: %d)\n" % [player_class, stats_info.hp, stats_info.max_hp, stats_info.atk, stats_info["def"]]
	context += "- เลเวล: %d\n" % player_level
	context += "- สถานที่ปัจจุบัน: %s\n" % current_scene
	context += "- ความคืบหน้าเนื้อเรื่อง: %d\n" % story_progress
	return context
