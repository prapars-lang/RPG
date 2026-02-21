extends Node

signal level_up_occurred(new_level, stats_before, stats_after, new_skills)
signal achievement_unlocked(id)

# --- Player Data ---
var player_name = "ผู้กล้า"
var player_gender = "เด็กชาย" 
var player_class = "อัศวิน" 
var player_level = 1
var player_xp = 0
# --- Part 2: Elemental System ---
const ELEMENT_FIRE = "fire"
const ELEMENT_WATER = "water"
const ELEMENT_NATURE = "nature"
const ELEMENT_WIND = "wind"
const ELEMENT_LIGHTNING = "lightning"
const ELEMENT_EARTH = "earth"

const ELEMENT_NAMES = {
	ELEMENT_FIRE: "Ignivar (Fire)",
	ELEMENT_WATER: "Aquaryn (Water)",
	ELEMENT_NATURE: "Sylvan (Nature)",
	ELEMENT_WIND: "Zephyra (Wind)",
	ELEMENT_LIGHTNING: "Voltaris (Lightning)",
	ELEMENT_EARTH: "Terradon (Earth)"
}

var current_map_element = ELEMENT_NATURE # Default for Forest

func get_elemental_weakness(attacker_elm, defender_elm):
	# Return 2.0 (Strong), 0.5 (Weak), or 1.0 (Neutral)
	match attacker_elm:
		ELEMENT_FIRE: return 2.0 if defender_elm == ELEMENT_NATURE else (0.5 if defender_elm == ELEMENT_WATER else 1.0)
		ELEMENT_WATER: return 2.0 if defender_elm == ELEMENT_FIRE else (0.5 if defender_elm == ELEMENT_LIGHTNING else 1.0) # Water conducts lightning? Game logic varies
		ELEMENT_NATURE: return 2.0 if defender_elm == ELEMENT_WATER else (0.5 if defender_elm == ELEMENT_FIRE else 1.0)
		ELEMENT_WIND: return 2.0 if defender_elm == ELEMENT_EARTH else (0.5 if defender_elm == ELEMENT_LIGHTNING else 1.0)
		ELEMENT_EARTH: return 2.0 if defender_elm == ELEMENT_LIGHTNING else (0.5 if defender_elm == ELEMENT_WIND else 1.0)
		ELEMENT_LIGHTNING: return 2.0 if defender_elm == ELEMENT_WATER else (0.5 if defender_elm == ELEMENT_EARTH else 1.0)
	return 1.0

var player_gold = 0
var current_mana = 0
var current_path = "" # "exercise", "nutrition", "hygiene"
var current_companion_id = "" # "ignis_pup", "aqua_slime", etc.
var companion_level = 1

# Overworld State
var last_overworld_position = Vector2.ZERO
var last_overworld_scene = ""
var is_overworld_mode = false
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


var story_progress = 0 # Current chunk index
var is_story_mode = false # If true, Battle returns to StoryScene
var queued_story_enemy_id = "" # Override enemy for story battles
var current_story_key = "" # Key for Part 2 dialogue (e.g., "meet_aetherion")
var is_part2_story = false # Flag to switch StoryScene to Part 2 mode
var used_questions = [] # Track IDs of questions already asked this session
var current_scene = "res://Scenes/MainMenu.tscn" # Track where player is for save/load

# Gamification State
var achievements = [] # ["first_battle", "health_expert", "streak_3"]
var last_login_date = ""
var login_streak = 0
var learning_points = 0 # Reward currency for correct answers

# --- Knowledge Codex (Collection & Badges) ---
signal card_unlocked(card_id, card_data)

var unlocked_cards: Array = [] # Card IDs the player has collected


var card_database = {
	# ===== Nutrition Cards (10) =====
	"vitamin_c": {"name": "วิตามินซี", "category": "nutrition", "set": "vitamins", "image": "res://Assets/cards/vitamin_c.png",
		"description": "ช่วยเสริมสร้างภูมิคุ้มกัน พบมากในส้ม มะนาว ฝรั่ง", "rarity": "common"},
	"vitamin_a": {"name": "วิตามินเอ", "category": "nutrition", "set": "vitamins", "image": "res://Assets/cards/vitamin_a.png",
		"description": "บำรุงสายตาและผิวพรรณ พบในแครอท ฟักทอง ตับ", "rarity": "common"},
	"vitamin_d": {"name": "วิตามินดี", "category": "nutrition", "set": "vitamins", "image": "res://Assets/cards/vitamin_d.png",
		"description": "ช่วยดูดซึมแคลเซียม ร่างกายสร้างได้จากแสงแดด", "rarity": "rare"},
	"protein": {"name": "โปรตีน", "category": "nutrition", "set": "nutrients", "image": "res://Assets/cards/protein.png",
		"description": "สร้างกล้ามเนื้อและซ่อมแซมเซลล์ พบในไข่ เนื้อสัตว์ ถั่ว", "rarity": "common"},
	"carbohydrate": {"name": "คาร์โบไฮเดรต", "category": "nutrition", "set": "nutrients", "image": "res://Assets/cards/carbohydrate.png",
		"description": "แหล่งพลังงานหลักของร่างกาย พบในข้าว ขนมปัง เส้นก๋วยเตี๋ยว", "rarity": "common"},
	"calcium": {"name": "แคลเซียม", "category": "nutrition", "set": "minerals", "image": "res://Assets/cards/calcium.png",
		"description": "เสริมสร้างกระดูกและฟันให้แข็งแรง พบในนม โยเกิร์ต ผักใบเขียว", "rarity": "common"},
	"iron": {"name": "ธาตุเหล็ก", "category": "nutrition", "set": "minerals", "image": "res://Assets/cards/iron.png",
		"description": "ช่วยขนส่งออกซิเจนในเลือด พบในตับ เนื้อแดง ผักโขม", "rarity": "common"},
	"fiber": {"name": "ใยอาหาร", "category": "nutrition", "set": "nutrients", "image": "res://Assets/cards/fiber.png",
		"description": "ช่วยระบบย่อยอาหาร ป้องกันท้องผูก พบในผัก ผลไม้ ธัญพืช", "rarity": "common"},
	"food_pyramid": {"name": "พีระมิดอาหาร", "category": "nutrition", "set": "food_wisdom", "image": "res://Assets/cards/food_pyramid.png",
		"description": "อาหารหลัก 5 หมู่ครบถ้วน กินหลากหลายสัดส่วนพอเหมาะ", "rarity": "rare"},
	"water_benefits": {"name": "ประโยชน์ของน้ำ", "category": "nutrition", "set": "food_wisdom", "image": "res://Assets/cards/water_benefits.png",
		"description": "ดื่มน้ำสะอาด 6-8 แก้วต่อวัน ช่วยขับของเสียและหล่อเลี้ยงร่างกาย", "rarity": "common"},



# --- Knowledge Codex (Collection & Badges) ---
	"hand_washing": {"name": "ล้างมือ 7 ขั้นตอน", "category": "hygiene", "set": "hygiene_basics", "image": "res://Assets/cards/hand_washing.png",
		"description": "ล้างมือด้วยสบู่อย่างน้อย 20 วินาที ลดเชื้อโรคได้กว่า 80%", "rarity": "common"},
	"tooth_brushing": {"name": "แปรงฟันถูกวิธี", "category": "hygiene", "set": "hygiene_basics", "image": "res://Assets/cards/tooth_brushing.png",
		"description": "แปรงฟันวันละ 2 ครั้ง เช้า-ก่อนนอน อย่างน้อยครั้งละ 2 นาที", "rarity": "common"},
	"bathing": {"name": "อาบน้ำให้สะอาด", "category": "hygiene", "set": "hygiene_basics", "image": "res://Assets/cards/bathing.png",
		"description": "อาบน้ำทุกวันเพื่อกำจัดเหงื่อ สิ่งสกปรก และเชื้อแบคทีเรีย", "rarity": "common"},
	"food_safety": {"name": "อาหารปลอดภัย", "category": "hygiene", "set": "hygiene_advanced", "image": "res://Assets/cards/food_safety.png",
		"description": "กินร้อน ช้อนกลาง ล้างมือ ลดความเสี่ยงโรคระบบทางเดินอาหาร", "rarity": "rare"},
	"germ_defense": {"name": "ป้องกันเชื้อโรค", "category": "hygiene", "set": "hygiene_advanced", "image": "res://Assets/cards/germ_defense.png",
		"description": "สวมหน้ากากเมื่ออยู่ที่แออัด และเลี่ยงสัมผัสใบหน้า", "rarity": "rare"},
	"nail_care": {"name": "ดูแลเล็บ", "category": "hygiene", "set": "self_care", "image": "res://Assets/cards/nail_care.png",
		"description": "ตัดเล็บให้สั้นสะอาด ลดการสะสมเชื้อโรคใต้เล็บ", "rarity": "common"},
	"hair_washing": {"name": "สระผมสะอาด", "category": "hygiene", "set": "self_care", "image": "res://Assets/cards/hair_washing.png",
		"description": "สระผม 2-3 ครั้งต่อสัปดาห์ ป้องกันรังแคและเหา", "rarity": "common"},
	"clean_clothes": {"name": "เสื้อผ้าสะอาด", "category": "hygiene", "set": "self_care", "image": "res://Assets/cards/clean_clothes.png",
		"description": "เปลี่ยนเสื้อผ้าทุกวัน ซักให้สะอาดตากแดดฆ่าเชื้อ", "rarity": "common"},
	"dental_floss": {"name": "ไหมขัดฟัน", "category": "hygiene", "set": "hygiene_advanced", "image": "res://Assets/cards/dental_floss.png",
		"description": "ใช้ไหมขัดฟันวันละ 1 ครั้ง ทำความสะอาดซอกฟันที่แปรงเข้าไม่ถึง", "rarity": "rare"},
	"sneeze_etiquette": {"name": "มารยาทการจาม", "category": "hygiene", "set": "hygiene_basics", "image": "res://Assets/cards/sneeze_etiquette.png",
		"description": "ใช้ข้อพับแขนปิดปากเวลาจาม ป้องกันการแพร่เชื้อทางอากาศ", "rarity": "common"},

	# ===== Exercise Cards (10) =====
	"cardio": {"name": "แอโรบิก", "category": "exercise", "set": "exercise_types", "image": "res://Assets/cards/cardio.png",
		"description": "วิ่ง ว่ายน้ำ ปั่นจักรยาน เสริมสร้างหัวใจและปอดให้แข็งแรง", "rarity": "common"},
	"stretching": {"name": "ยืดเหยียดร่างกาย", "category": "exercise", "set": "exercise_types", "image": "res://Assets/cards/stretching.png",
		"description": "ยืดร่างกายก่อนและหลังออกกำลังกาย ป้องกันการบาดเจ็บ", "rarity": "common"},
	"strength": {"name": "เสริมสร้างกล้ามเนื้อ", "category": "exercise", "set": "exercise_types", "image": "res://Assets/cards/strength.png",
		"description": "วิดพื้น ซิทอัพ สร้างกล้ามเนื้อให้แข็งแรง", "rarity": "common"},
	"sleep": {"name": "นอนหลับพักผ่อน", "category": "exercise", "set": "rest_recovery", "image": "res://Assets/cards/sleep.png",
		"description": "เด็กควรนอน 9-11 ชั่วโมง เพื่อให้ร่างกายเจริญเติบโต", "rarity": "rare"},
	"hydration": {"name": "ดื่มน้ำเพียงพอ", "category": "exercise", "set": "rest_recovery", "image": "res://Assets/cards/hydration.png",
		"description": "ดื่มน้ำวันละ 6-8 แก้ว ช่วยให้ร่างกายทำงานได้เต็มประสิทธิภาพ", "rarity": "common"},
	"team_sports": {"name": "กีฬาทีม", "category": "exercise", "set": "sports_spirit", "image": "res://Assets/cards/team_sports.png",
		"description": "ฟุตบอล บาสเกตบอล วอลเลย์บอล ฝึกการทำงานร่วมกันและมีน้ำใจนักกีฬา", "rarity": "common"},
	"balance_training": {"name": "ฝึกการทรงตัว", "category": "exercise", "set": "exercise_types", "image": "res://Assets/cards/balance_training.png",
		"description": "กระโดดเชือก ยืนขาเดียว ฝึกระบบประสาทและกล้ามเนื้อทำงานประสานกัน", "rarity": "common"},
	"warm_up": {"name": "วอร์มอัพ", "category": "exercise", "set": "sports_spirit", "image": "res://Assets/cards/warm_up.png",
		"description": "อุ่นเครื่อง 5-10 นาทีก่อนออกกำลังกาย ลดอาการบาดเจ็บกล้ามเนื้อ", "rarity": "common"},
	"posture": {"name": "ท่าทางที่ถูกต้อง", "category": "exercise", "set": "rest_recovery", "image": "res://Assets/cards/posture.png",
		"description": "นั่งหลังตรง ไม่ก้มหน้าดูจอนาน ป้องกันอาการปวดหลังปวดคอ", "rarity": "rare"},
	"breathing_exercise": {"name": "ฝึกหายใจ", "category": "exercise", "set": "sports_spirit", "image": "res://Assets/cards/breathing_exercise.png",
		"description": "หายใจลึกๆ ช้าๆ ช่วยลดความเครียดและเพิ่มสมาธิ", "rarity": "rare"},
}

var card_sets = {
	"vitamins": {"name": "ชุดวิตามิน", "cards": ["vitamin_c", "vitamin_a", "vitamin_d"],
		"reward_type": "title", "reward_id": "นักโภชนาการน้อย"},
	"nutrients": {"name": "ชุดสารอาหาร", "cards": ["protein", "carbohydrate", "fiber"],
		"reward_type": "gold", "reward_id": 200},
	"minerals": {"name": "ชุดแร่ธาตุ", "cards": ["calcium", "iron"],
		"reward_type": "gold", "reward_id": 250},
	"food_wisdom": {"name": "ชุดภูมิปัญญาอาหาร", "cards": ["food_pyramid", "water_benefits"],
		"reward_type": "title", "reward_id": "ปราชญ์แห่งอาหาร"},
	"hygiene_basics": {"name": "ชุดสุขอนามัยพื้นฐาน", "cards": ["hand_washing", "tooth_brushing", "bathing", "sneeze_etiquette"],
		"reward_type": "title", "reward_id": "ยอดนักสะอาด"},
	"hygiene_advanced": {"name": "ชุดสุขอนามัยขั้นสูง", "cards": ["food_safety", "germ_defense", "dental_floss"],
		"reward_type": "gold", "reward_id": 300},
	"self_care": {"name": "ชุดดูแลตัวเอง", "cards": ["nail_care", "hair_washing", "clean_clothes"],
		"reward_type": "title", "reward_id": "เจ้าหญิง/เจ้าชายสะอาด"},
	"exercise_types": {"name": "ชุดการออกกำลังกาย", "cards": ["cardio", "stretching", "strength", "balance_training"],
		"reward_type": "title", "reward_id": "นักกีฬาแห่งอนาคต"},
	"rest_recovery": {"name": "ชุดพักผ่อนฟื้นฟู", "cards": ["sleep", "hydration", "posture"],
		"reward_type": "gold", "reward_id": 200},
	"sports_spirit": {"name": "ชุดหัวใจนักกีฬา", "cards": ["team_sports", "warm_up", "breathing_exercise"],
		"reward_type": "title", "reward_id": "จิตวิญญาณนักกีฬา"},
}


# Map question categories to card categories
var category_to_cards_map = {
	"exercise": "exercise", "nutrition": "nutrition", "hygiene": "hygiene"
}

func unlock_card(card_id: String) -> bool:
	if card_id in card_database and card_id not in unlocked_cards:
		unlocked_cards.append(card_id)
		card_unlocked.emit(card_id, card_database[card_id])
		# Check if this completes a set
		var card_set_id = card_database[card_id].get("set", "")
		if card_set_id != "":
			var progress = get_set_progress(card_set_id)
			if progress.complete:
				_claim_set_reward(card_set_id)
		return true
	return false

func is_card_unlocked(card_id: String) -> bool:
	return card_id in unlocked_cards

func get_set_progress(set_id: String) -> Dictionary:
	var set_data = card_sets.get(set_id, {})
	var required = set_data.get("cards", [])
	var count = 0
	for c in required:
		if is_card_unlocked(c):
			count += 1
	return {"unlocked": count, "total": required.size(), "complete": count >= required.size()}

func get_cards_by_category(category: String) -> Array:
	var result = []
	for card_id in card_database:
		if card_database[card_id].category == category:
			result.append(card_id)
	return result

func try_unlock_random_card(path: String, chance: float = 0.20) -> String:
	if randf() > chance:
		return ""
	var cat = category_to_cards_map.get(path, "nutrition")
	var pool = get_cards_by_category(cat)
	var locked = pool.filter(func(c): return not is_card_unlocked(c))
	if locked.size() == 0:
		return ""
	var pick = locked[randi() % locked.size()]
	unlock_card(pick)
	return pick

func _claim_set_reward(set_id: String):
	var set_data = card_sets.get(set_id, {})
	var rtype = set_data.get("reward_type", "")
	var rid = set_data.get("reward_id", "")
	if rtype == "gold" and rid is int:
		add_gold(rid)
	elif rtype == "title":
		if rid not in achievements:
			achievements.append(str(rid))
			achievement_unlocked.emit(str(rid))

func get_codex_summary() -> Dictionary:
	var total = card_database.size()
	var unlocked = unlocked_cards.size()
	var sets_complete = 0
	for s in card_sets:
		if get_set_progress(s).complete:
			sets_complete += 1
	return {"unlocked": unlocked, "total": total, "sets_complete": sets_complete, "sets_total": card_sets.size()}

# Quest State
var active_quests = [] # IDs of active quests
var completed_quests = [] # IDs of completed quests
var quest_progress = {} # { "quest_id": current_count }

# Skill Tree System
var skill_points = 5 # Starting points (for testing)
var unlocked_skills = [] # List of skill IDs unlocked

func unlock_skill(skill_id):
	if not unlocked_skills.has(skill_id):
		unlocked_skills.append(skill_id)
		print("Skill Unlocked: ", skill_id)

func has_skill(skill_id):
	return unlocked_skills.has(skill_id)

func check_all_paths_completed() -> bool:
	var path_quests = ["exercise_start", "nutrition_start", "hygiene_start", "wisdom_start"]
	for q_id in path_quests:
		if q_id not in completed_quests:
			return false
	return true


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
		{"name": "โล่ยืดเหยียด", "level": 1, "cost": 10, "type": "buff", "value": 5, "desc": "เพิ่มพลังป้องกันด้วยการยืดเหยียด"},
		{"name": "ลับคมดาบ", "level": 2, "cost": 12, "type": "buff", "value": 5, "desc": "เตรียมพร้อมโจมตี เพิ่มพลังโจมตีชั่วคราว"},
		{"name": "จังหวะคาร์ดิโอ", "level": 3, "cost": 15, "type": "dmg", "value": 35, "desc": "โจมตีต่อเนื่องด้วยความกระปรี้กระเปร่า"},
		{"name": "โล่กระแทก", "level": 4, "cost": 18, "type": "dmg", "value": 40, "desc": "กระแทกศัตรูด้วยโล่"},
		{"name": "พลังกล้ามเนื้อ", "level": 5, "cost": 25, "type": "dmg", "value": 60, "desc": "โจมตีรุนแรงด้วยพลังกายที่ฝึกฝนมาดี"},
		{"name": "ฟันกวาด", "level": 6, "cost": 30, "type": "dmg", "value": 50, "desc": "โจมตีศัตรูทั้งหมด (สมมติ)"},
		{"name": "ปราการเหล็ก", "level": 8, "cost": 35, "type": "buff", "value": 15, "desc": "เพิ่มพลังป้องกันอย่างมหาศาล"},
		{"name": "หัวใจนักกีฬา", "level": 10, "cost": 40, "type": "heal", "value": 50, "desc": "ฟื้นฟูพลังชีวิตและเพิ่มพลังป้องกัน"}
	],
	"จอมเวทย์": [
		{"name": "พลังอาหาร 5 หมู่", "level": 1, "cost": 15, "type": "dmg", "value": 40, "desc": "โจมตีรุนแรงด้วยพลังโภชนาการ"},
		{"name": "สมาธิ", "level": 2, "cost": 10, "type": "mp", "value": 20, "desc": "ฟื้นฟูมานาเล็กน้อย"},
		{"name": "วิตามินบำรุงสมอง", "level": 3, "cost": 20, "type": "mp", "value": 30, "desc": "ฟื้นฟูมานาด้วยสารอาหารบำรุงสมอง"},
		{"name": "ศรน้ำแข็ง", "level": 4, "cost": 25, "type": "dmg", "value": 50, "desc": "ยิงศรน้ำแข็งใส่ศัตรู"},
		{"name": "พลังงานสะอาด", "level": 5, "cost": 30, "type": "dmg", "value": 75, "desc": "ระเบิดพลังงานบริสุทธิ์ใส่ศัตรู"},
		{"name": "ไฟบอล", "level": 6, "cost": 35, "type": "dmg", "value": 80, "desc": "ลูกไฟยักษ์เผาผลาญ"},
		{"name": "เกราะเวทย์", "level": 8, "cost": 40, "type": "buff", "value": 10, "desc": "สร้างเกราะป้องกันด้วยเวทมนตร์"},
		{"name": "โภชนาการสมบูรณ์", "level": 10, "cost": 45, "type": "dmg", "value": 120, "desc": "สุดยอดเวทมนตร์แห่งสุขภาพสมบูรณ์"}
	],
	"นักล่า": [
		{"name": "สเปรย์ฆ่าเชื้อ", "level": 1, "cost": 12, "type": "dmg", "value": 30, "desc": "ฉีดสเปรย์กำจัดเชื้อโรคอย่างรวดเร็ว"},
		{"name": "เล็งเป้า", "level": 2, "cost": 10, "type": "buff", "value": 5, "desc": "เพิ่มความแม่นยำและพลังโจมตี"},
		{"name": "กับดักสบู่", "level": 3, "cost": 18, "type": "dmg", "value": 45, "desc": "วางกับดักสบู่ชำระล้างความชั่วร้าย"},
		{"name": "ยิงเบิ้ล", "level": 4, "cost": 20, "type": "dmg", "value": 55, "desc": "ยิงธนูสองดอกพร้อมกัน"},
		{"name": "หน้ากากป้องกัน", "level": 5, "cost": 22, "type": "buff", "value": 15, "desc": "สวมหน้ากากเพิ่มพลังป้องกันมลภาวะ"},
		{"name": "ฝนธนู", "level": 6, "cost": 30, "type": "dmg", "value": 70, "desc": "ยิงธนูจำนวนมากขึ้นฟ้าตกลงมาใส่ศัตรู"},
		{"name": "พรางตัว", "level": 8, "cost": 25, "type": "buff", "value": 10, "desc": "หลบซ่อนตัวเพื่อลดความเสียหาย"},
		{"name": "ล้างบางเชื้อโรค", "level": 10, "cost": 35, "type": "dmg", "value": 100, "desc": "กำจัดเชื้อโรคและสิ่งสกปรกทั้งหมดในพริบตา"}
	],
	"ผู้พิทักษ์": [
		{"name": "ระฆังแห่งสติ", "level": 1, "cost": 15, "type": "heal", "value": 30, "desc": "ฟื้นฟูพลังชีวิตด้วยเสียงระฆัง"},
		{"name": "แสงศรัทธา", "level": 2, "cost": 15, "type": "dmg", "value": 35, "desc": "โจมตีด้วยแสงแห่งความดี"},
		{"name": "สมาธิภาวนา", "level": 3, "cost": 20, "type": "buff", "value": 12, "desc": "สงบนิ่งเพื่อเพิ่มพลังป้องกันอย่างมาก"},
		{"name": "ค้อนธรรมะ", "level": 4, "cost": 25, "type": "dmg", "value": 60, "desc": "ทุบศัตรูด้วยค้อนแห่งธรรม"},
		{"name": "จิตใจที่แจ่มใส", "level": 5, "cost": 25, "type": "heal", "value": 60, "desc": "เยียวยาจิตใจและร่างกายด้วยพลังบวก"},
		{"name": "โล่ศักดิ์สิทธิ์", "level": 6, "cost": 30, "type": "buff", "value": 20, "desc": "สร้างโล่ป้องกันความชั่วร้าย"},
		{"name": "พรแห่งชีวิต", "level": 8, "cost": 40, "type": "heal", "value": 100, "desc": "ฟื้นฟูพลังชีวิตอย่างมาก"},
		{"name": "พลังแห่งการพักผ่อน", "level": 10, "cost": 50, "type": "heal", "value": 150, "desc": "สุดยอดพลังแห่งการฟื้นฟูจากการพักผ่อนที่เพียงพอ"}
	]
}

var monster_db = {
	# --- Basic / Generic ---
	
	# --- Path 1: Body (Exercise) ---
	"unstable_slime": {
		"name": "Unstable Slime",
		"hp": 60,
		"atk": 15,
		"xp": 50,
		"min_gold": 20,
		"max_gold": 30,
		"element": ELEMENT_WATER, 
		"texture": "res://Assets/Part2/Unstable_Slime.png"
	},
	"thorn_wolf": {
		"name": "Thorn Wolf",
		"hp": 80,
		"atk": 20,
		"xp": 70,
		"min_gold": 30,
		"max_gold": 45,
		"element": ELEMENT_NATURE,
		"texture": "res://Assets/Part2/Thorn_Wolf.png"
	},
	"spore_shroom": {
		"name": "Spore Shroom",
		"hp": 70,
		"atk": 18,
		"xp": 60,
		"min_gold": 25,
		"max_gold": 40,
		"element": ELEMENT_NATURE,
		"texture": "res://Assets/Part2/Spore_Shroom.png"
	},
	"bubble_crab": {
		"name": "Bubble Crab",
		"hp": 90,
		"atk": 22,
		"xp": 75,
		"min_gold": 35,
		"max_gold": 50,
		"element": ELEMENT_WATER,
		"texture": "res://Assets/Part2/Bubble_Crab.png"
	},
	"magma_slime": {
		"name": "Magma Slime",
		"hp": 85,
		"atk": 25,
		"xp": 70,
		"min_gold": 30,
		"max_gold": 45,
		"element": ELEMENT_FIRE,
		"texture": "res://Assets/Part2/Magma_Slime.png"
	},
	"crystal_spider": {
		"name": "Crystal Spider",
		"hp": 95,
		"atk": 28,
		"xp": 80,
		"min_gold": 40,
		"max_gold": 55,
		"element": ELEMENT_EARTH,
		"texture": "res://Assets/Part2/Crystal_Spider.png"
	},
	"thunder_hawk": {
		"name": "Thunder Hawk",
		"hp": 100,
		"atk": 30,
		"xp": 90,
		"min_gold": 45,
		"max_gold": 60,
		"element": ELEMENT_LIGHTNING, # Mapping Wind/Lightning to Lightning for now
		"texture": "res://Assets/Part2/Thunder_Hawk.png"
	},
	"corrupted_treant": {
		"name": "Corrupted Treant (BOSS)",
		"hp": 500,
		"atk": 50,
		"xp": 1000,
		"min_gold": 500,
		"max_gold": 600,
		"element": ELEMENT_NATURE,
		"texture": "res://Assets/Part2/Corrupted_Treant.png"
	},
	"lazy_slime": {
		"name": "สไลม์ขี้เกียจ",
		"hp": 40,
		"atk": 5,
		"xp": 30,
		"min_gold": 10,
		"max_gold": 15,

		"element": ELEMENT_WATER,
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
		"min_gold": 20,
		"max_gold": 30,
		"texture": "res://Assets/Sugar Overlord.png"
	},
	"fat_phantom": {
		"name": "ปีศาจไขมันพอก",
		"hp": 90,
		"atk": 15,
		"xp": 80,
		"min_gold": 30,
		"max_gold": 45,
		"texture": "res://Assets/Greasy Blob.png"
	},
	"salt_slime": {
		"name": "สไลม์เกลือเค็ม",
		"hp": 80,
		"atk": 20,
		"xp": 75,
		"min_gold": 25,
		"max_gold": 40,
		"texture": "res://Assets/Salt Crystalline.png"
	},
	"junk_food_king": { # Mid-Boss
		"name": "ราชา Junk Food",
		"hp": 400,
		"atk": 50,
		"xp": 800,
		"min_gold": 200,
		"max_gold": 300,
		"texture": "res://Assets/Sugar Overlord.png"
	},
	"soda_slime": {
		"name": "สไลม์น้ำซ่าซาบซ่าน",
		"hp": 100,
		"atk": 25,
		"xp": 90,
		"min_gold": 40,
		"max_gold": 60,
		"texture": "res://Assets/Salt Crystalline.png" # Placeholder tintable
	},
	"preservative_ghost": {
		"name": "ผีสารกันบูด",
		"hp": 120,
		"atk": 22,
		"xp": 110,
		"min_gold": 50,
		"max_gold": 80,
		"texture": "res://Assets/Atrophy Spirit.png"
	},
	"processed_mimic": {
		"name": "อาหารกระป๋องกินคน",
		"hp": 150,
		"atk": 30,
		"xp": 150,
		"min_gold": 70,
		"max_gold": 120,
		"texture": "res://Assets/Trash Demon.png" # Placeholder
	},
	"trans_fat_titan": { # Elite / Sub-Boss
		"name": "ไททันไขมันทรานส์",
		"hp": 250,
		"atk": 40,
		"xp": 300,
		"min_gold": 150,
		"max_gold": 250,
		"texture": "res://Assets/Couch Potato Golem.png"
	},
	"junk_food_emperor": { # Final Boss
		"name": "จักรพรรดิ Junk Food",
		"hp": 1200,
		"atk": 85,
		"xp": 2500,
		"min_gold": 1000,
		"max_gold": 2000,
		"texture": "res://Assets/Plague Lord.png" # Using Plague Lord as Emperor placeholder
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
		"element": ELEMENT_NATURE,
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
	},
	"knowledge_guardian": {
		"name": "Pathos อสูรแห่งความเขลา", 
		"hp": 500, "max_hp": 500, 
		"atk": 35, "def": 20, 
		"xp": 500, "gold": 999, 
		"sprite": "res://Assets/monsters/shadow_demon.png",
		"weakness": ["nutrition", "hygiene", "exercise", "body", "health", "safety"],
		"description": "บอสลับผู้พิทักษ์ความรู้ แพ้ทางผู้มีความรู้รอบตัว"
	},
	"ignorance_incarnate": {
		"name": "Ignorance Incarnate (ร่างอวตารแห่งความเขลา)", 
		"hp": 800, "max_hp": 800, 
		"atk": 40, "def": 25, 
		"xp": 9999, "gold": 0, 
		"sprite": "res://Assets/monsters/final_boss_ignorance.png",
		"description": "ต้นกำเนิดของปีศาจทั้งหมด... ความไม่รู้ที่กัดกินโลก",
		"weakness": "all" # Special flag for battle logic
	}
}

func is_codex_complete() -> bool:
	if card_database.is_empty(): return false
	for card_id in card_database.keys():
		if not card_id in unlocked_cards:
			return false
	return true

func _ready():
	# Load Config
	var config = ConfigManager.load_config()
	if config:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(config.master_volume))
	
	load_questions()
	load_game() # Load data first!
	check_login_streak()

# --- Gamification Logic ---

func check_login_streak():
	var current_date = Time.get_date_string_from_system()
	# Robust Date Check using UNIX time
	var today_unix = Time.get_unix_time_from_datetime_string(current_date)
	var last_login_unix = 0
	if last_login_date != "":
		last_login_unix = Time.get_unix_time_from_datetime_string(last_login_date)
	
	if last_login_date == "":
		login_streak = 1
		last_login_date = current_date
	elif last_login_date != current_date:
		# 86400 seconds = 1 Day
		# Allow some loose timing (e.g. within 48 hours to be safe, but ideally check date diff)
		var diff_seconds = today_unix - last_login_unix
		var diff_days = int(diff_seconds / 86400)
		
		# If login is consecutive day (diff is approx 1 day)
		# Note: get_date_string_from_system returns YYYY-MM-DD, so strict check is better
		if diff_days == 1:
			login_streak += 1
			print("[Gamification] Streak increased! Day: ", login_streak)
			if login_streak == 3: unlock_achievement("streak_3")
			if login_streak == 7: unlock_achievement("streak_7")
		elif diff_days > 1:
			login_streak = 1 # Reset if missed a day
			print("[Gamification] Streak reset. Missed ", diff_days, " days.")
		
		last_login_date = current_date
	save_game()

var achievement_data = {
	"streak_3": {"name": "ผู้มุ่งมั่น", "desc": "ล็อคอินต่อเนื่อง 3 วัน", "icon": "🔥"},
	"streak_7": {"name": "วินัยเหล็ก", "desc": "ล็อคอินต่อเนื่อง 7 วัน", "icon": "📅"},
	"first_blood": {"name": "ก้าวแรกสู่สังเวียน", "desc": "ชนะการต่อสู้ครั้งแรก", "icon": "⚔️"},
	"rich_kid": {"name": "เศรษฐีน้อย", "desc": "มีเงินครบ 1,000 Gold", "icon": "💰"},
	"scholar": {"name": "หนอนหนังสือ", "desc": "ตอบคำถามถูก 10 ข้อ", "icon": "🎓"},
	"collector": {"name": "นักสะสม", "desc": "รวบรวมการ์ดครบ 5 ใบ", "icon": "🃏"}
}

func get_achievement_info(id):
	return achievement_data.get(id, {"name": "Unknown", "desc": "???", "icon": "❓"})

func unlock_achievement(achievement_id: String):
	if not achievement_id in achievements:
		achievements.append(achievement_id)
		print("[Gamification] UNLOCKED: ", achievement_id)
		# Reward for unlocking
		learning_points += 50
		save_game()
func _show_achievement_notification(achievement_id: String):
	# Find the current scene root to add the popup
	var root = get_tree().current_scene
	if root:
		var popup_scene = load("res://Scenes/AchievementPopup.tscn")
		var popup = popup_scene.instantiate()
		root.add_child(popup)
		# Ensure it's on top of everything
		popup.z_index = 100
		
		# Allow the popup to qualify itself
		if popup.has_method("setup"):
			popup.setup(achievement_id)

func gain_learning_points(amount: int):
	learning_points += amount
	print("[Gamification] Gained ", amount, " Learning Points. Total: ", learning_points)
	if learning_points >= 1000: unlock_achievement("master_scholar")
	save_game()



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
	check_level_up()

func check_level_up():
	while player_xp >= get_xp_for_level(player_level):
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
		s.max_hp += 30 # Increased from 20
		s.max_mana += 5
		s.atk += 4
		s["def"] += 3
	elif player_class == "จอมเวทย์":
		s.max_hp += 15 # Increased from 10
		s.max_mana += 20
		s.atk += 6
		s["def"] += 2
	elif player_class == "นักล่า":
		s.max_hp += 20 # Increased from 15
		s.max_mana += 15
		s.atk += 5
		s["def"] += 2
	elif player_class == "ผู้พิทักษ์":
		s.max_hp += 35 # Increased from 18
		s.max_mana += 15
		s.atk += 3
		s["def"] += 4
		
	s.hp = s.max_hp
	s.mana = s.max_mana
	
	# Check for new skills
	var new_skills = []
	for skill in skills[player_class]:
		if skill.level == player_level:
			new_skills.append(skill.name)
	
	if new_skills.size() > 0:
		print("New Skills Learned: ", new_skills)
	
	emit_signal("level_up_occurred", player_level, old_stats, s, new_skills)
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
		# Shuffle the options for variety
		final_selection = shuffle_question_options(final_selection)
		
	return final_selection

func shuffle_question_options(question: Dictionary) -> Dictionary:
	"""Shuffle answer options while keeping track of correct answer"""
	if question.is_empty() or question.get("options") == null:
		return question
	
	# Create a copy to avoid modifying original
	var shuffled = question.duplicate(true)
	var options = shuffled.get("options", []).duplicate()
	
	if options.size() <= 1:
		return shuffled
	
	# Shuffle the options array
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Fisher-Yates shuffle
	for i in range(options.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		var temp = options[i]
		options[i] = options[j]
		options[j] = temp
	
	shuffled["options"] = options
	print("[QSystem] Options shuffled for: '", question.q.left(30), "...'")
	
	return shuffled

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
		"completed_quests": completed_quests,
		"achievements": achievements,
		"last_login_date": last_login_date,
		"login_streak": login_streak,
		"learning_points": learning_points,
		"unlocked_cards": unlocked_cards
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
		if "stats" in data:
			for key in data["stats"]:
				if key in stats:
					stats[key] = data["stats"][key]
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
		if "achievements" in data: achievements = data["achievements"]
		if "last_login_date" in data: last_login_date = data["last_login_date"]
		if "login_streak" in data: login_streak = data["login_streak"]
		if "learning_points" in data: learning_points = data["learning_points"]
		if "unlocked_cards" in data: unlocked_cards = data["unlocked_cards"]
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
