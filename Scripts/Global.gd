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
const ELEMENT_DARK = "dark"

const ELEMENT_NAMES = {
	ELEMENT_FIRE: "Ignivar (Fire)",
	ELEMENT_WATER: "Aquaryn (Water)",
	ELEMENT_NATURE: "Sylvan (Nature)",
	ELEMENT_WIND: "Zephyra (Wind)",
	ELEMENT_LIGHTNING: "Voltaris (Lightning)",
	ELEMENT_EARTH: "Terradon (Earth)",
	ELEMENT_DARK: "Umbralis (Dark)"
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
		ELEMENT_DARK: return 1.0 # Neutral
	return 1.0

var player_gold = 0
var current_mana = 0
var current_path = "" # "exercise", "nutrition", "hygiene"
var companion_level = 1
var companion_exp = 0
var companion_bond = 0 # Incremented by correct answers

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
	"ผู้พิทักษ์_เด็กหญิง": "res://Assets/Fan.png",
	"TerraNova_เด็กชาย": "res://Assets/Part2/Hero_TerraNova.png",
	"TerraNova_เด็กหญิง": "res://Assets/Part2/Hero_TerraNova_Female_Pixel.png"
}


var story_progress = 0 # Current chunk index
var is_story_mode = false # If true, Battle returns to StoryScene
var queued_story_enemy_id = "" # Override enemy for story battles
var queued_battle_background = "" # Override background for story battles
var current_story_key = "" # Key for Part 2 dialogue (e.g., "meet_aetherion")
var is_part2_story = false # Flag to switch StoryScene to Part 2 mode
var current_chapter = 1 # Track progress through Part 2 (1-20)
var unlocked_chapters = [1] # IDs of chapters the player can access
var current_companion_id = "" # Selected companion in Part 2
var max_chapters = 21
var used_questions = [] # Track IDs of questions already asked this session
var current_scene = "res://Scenes/MainMenu.tscn" # Track where player is for save/load

# Gamification State
var achievements = [] # ["first_battle", "health_expert", "streak_3"]
var last_login_date = ""
var login_streak = 0
var learning_points = 0 # Reward currency for correct answers

# --- Knowledge Codex (Collection & Badges) ---
signal card_unlocked(card_id, card_data)

var unlocked_cards: Array = []


var card_database = CodexDB.CARDS.duplicate(true)
var card_sets = CodexDB.SETS.duplicate(true)

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
const RARITY_COLORS = ItemDB.RARITY_COLORS

# Set bonus definitions
const SET_BONUSES = ItemDB.SET_BONUSES

# Enhancement cost & success rate
const ENHANCE_COST = ItemDB.ENHANCE_COST
const ENHANCE_SUCCESS = ItemDB.ENHANCE_SUCCESS

var item_db = ItemDB.ITEMS.duplicate(true)

var stats = SkillDB.STATS.duplicate(true)
var skills = SkillDB.SKILLS.duplicate(true)

# --- Monster Data & Dynamic Selection ---
var monster_db: Dictionary:
	get:
		if not is_part2_story:
			return MonsterDB_Part1.DATA
		else:
			return MonsterDB_Part2.DATA

func get_monster_for_path(path_name):
	# STRICT SEPARATION: prevent Part 2 monsters from appearing in Part 1 and vice-versa
	if not is_part2_story:
		# Part 1 Logic
		match path_name:
			"exercise":
				return ["lazy_slime", "atrophy_ghost", "couch_golem"].pick_random()
			"nutrition":
				return ["sugar_spy", "fat_phantom", "salt_slime"].pick_random()
			"hygiene":
				return ["smoke", "stress", "trash_heap", "noise_banshee", "virus"].pick_random()
			"wisdom":
				return ["stress", "noise_banshee", "atrophy_ghost"].pick_random()
		return ["virus", "germ"].pick_random()
	else:
		# Part 2 Logic (Terra Nova)
		var p2_pool = ["unstable_slime", "thorn_wolf", "spore_shroom", "bubble_crab", "magma_slime", "crystal_spider", "thunder_hawk"]
		
		# Optional: filter by element if map element is set
		var element_pool = []
		for m_id in p2_pool:
			if MonsterDB_Part2.DATA.has(m_id) and MonsterDB_Part2.DATA[m_id].get("element", "") == current_map_element:
				element_pool.append(m_id)
		
		if element_pool.size() > 0:
			return element_pool.pick_random()
		return p2_pool.pick_random()

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
		var diff_days = int(diff_seconds / 86400.0)
		
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
	
	# --- ADDED: Companion Bonuses ---
	if current_companion_id != "":
		var comp_path = "res://Scripts/Part2/CompanionData.gd"
		if FileAccess.file_exists(comp_path):
			var CompDB = load(comp_path).new()
			var comp_data = CompDB.get_companion(current_companion_id, companion_bond)
			if comp_data and "stats" in comp_data:
				var c_stats = comp_data.stats
				if "atk" in c_stats: base.atk += c_stats.atk
				if "hp_bonus" in c_stats: 
					# Bond impact: 1% extra bonus per Bond point (capped at +50%)
					var bond_mult = 1.0 + min(companion_bond, 50) * 0.01
					base.max_hp += int(c_stats.hp_bonus * bond_mult)
	
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
	elif unused.size() > 0:
		# Fallback to any unused question in this grade
		final_selection = unused.pick_random()
	else:
		print("[QSystem] ERROR: Absolutely no questions available to pick!")
		return {}
	
	if final_selection != {}:
		used_questions.append(final_selection.q)
		# Improved logging without cutting mid-character
		var q_preview = final_selection.q
		if q_preview.length() > 30:
			q_preview = q_preview.left(30) + "..."
		print("[QSystem] Selected: '", q_preview, "' | Total used now: ", used_questions.size())
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
			print("Question database loaded successfully! Grades: ", question_data.keys())
		else:
			push_error("JSON Parse Error in questions.json: " + json.get_error_message() + " at line " + str(json.get_error_line()))
			# Attempt to find where it failed if possible
			print("Content around error: ", content.substr(max(0, json.get_error_line() - 50), 100))
	else:
		print("CRITICAL: questions.json NOT found!")

func save_game(path: String = "user://savegame.save"):
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
		"quest_progress": quest_progress,
		"achievements": achievements,
		"last_login_date": last_login_date,
		"login_streak": login_streak,
		"learning_points": learning_points,
		"unlocked_cards": unlocked_cards,
		"is_part2_story": is_part2_story,
		"current_chapter": current_chapter,
		"unlocked_chapters": unlocked_chapters,
		"current_story_key": current_story_key,
		"current_companion_id": current_companion_id,
		"companion_level": companion_level,
		"companion_exp": companion_exp,
		"companion_bond": companion_bond,
		"unlocked_skills": unlocked_skills,
		"skill_points": skill_points
	}
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(save_data))
		print("Game Saved to: ", path)
	else:
		push_error("Failed to save game to: " + path)

func load_game(path: String = "user://savegame.save"):
	if not FileAccess.file_exists(path):
		return false
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		player_name = data.get("name", "ผู้กล้า")
		player_gender = data.get("gender", "เด็กชาย")
		player_class = data.get("class", "อัศวิน")
		player_level = int(data.get("level", 1))
		player_xp = int(data.get("xp", 0))
		player_gold = int(data.get("gold", 0))
		if "stats" in data:
			for key in data["stats"]:
				if key in stats:
					stats[key] = data["stats"][key]
		if "inventory" in data: inventory = data["inventory"]
		if "story_progress" in data: story_progress = int(data["story_progress"])
		if "current_path" in data: current_path = data["current_path"]
		if "current_scene" in data: current_scene = data["current_scene"]
		if "used_questions" in data: used_questions = data["used_questions"]
		if "is_part2_story" in data: is_part2_story = data["is_part2_story"]
		if "current_chapter" in data: current_chapter = int(data["current_chapter"])
		if "unlocked_chapters" in data: unlocked_chapters = data["unlocked_chapters"]
		if "current_story_key" in data: current_story_key = data["current_story_key"]
		if "current_companion_id" in data: current_companion_id = data["current_companion_id"]
		if "companion_level" in data: companion_level = int(data["companion_level"])
		if "companion_exp" in data: companion_exp = int(data["companion_exp"])
		if "companion_bond" in data: companion_bond = int(data["companion_bond"])
		if "unlocked_skills" in data: unlocked_skills = data["unlocked_skills"]
		if "skill_points" in data: skill_points = data["skill_points"]
		if "equipped_items" in data:
			var loaded_equip = data["equipped_items"]
			for slot in equipped_items:
				if slot in loaded_equip:
					equipped_items[slot] = loaded_equip[slot]
			if "armor" in loaded_equip and loaded_equip["armor"] != null:
				equipped_items["body"] = loaded_equip["armor"]
		if "enhancement_levels" in data:
			var loaded_enh = data["enhancement_levels"]
			for slot in enhancement_levels:
				if slot in loaded_enh:
					enhancement_levels[slot] = loaded_enh[slot]
		if "active_quests" in data: active_quests = data["active_quests"]
		if "completed_quests" in data: completed_quests = data["completed_quests"]
		if "quest_progress" in data: quest_progress = data["quest_progress"]
		if "achievements" in data: achievements = data["achievements"]
		if "last_login_date" in data: last_login_date = data["last_login_date"]
		if "login_streak" in data: login_streak = int(data["login_streak"])
		if "learning_points" in data: learning_points = int(data["learning_points"])
		if "unlocked_cards" in data: unlocked_cards = data["unlocked_cards"]
		print("Game Loaded from: ", path)
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
