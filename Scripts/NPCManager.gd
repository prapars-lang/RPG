extends Node

# NPC Management System
# Handles all NPCs in the game (merchants, quest givers, guides, etc.)

# NPC Type Enum
enum NPCType {
	MERCHANT = 0,      # Sells items
	QUEST_GIVER = 1,   # Gives quests
	GUIDE = 2,         # Provides information/guidance
	HEALER = 3,        # Heals players
	RIVAL = 4,         # Antagonist/rival character
	ELDER = 5,         # Wise character
	SCHOLAR = 6,       # Knowledge source
	STORYTELLER = 7    # Tells stories
}

# Reputation system
var npc_reputation: Dictionary = {}  # NPC ID -> reputation value (-100 to 100)
var npc_visited: Dictionary = {}     # NPC ID -> bool (has visited)
var npc_quests: Dictionary = {}      # NPC ID -> [quest_ids]

# NPC Database
var npcs: Dictionary = {
	"elder_wisdom": {
		"name": "ท่านอาจารย์สติ",
		"type": NPCType.ELDER,
		"title": "อาจารย์แห่งสติบัญญัติ",
		"description": "ผู้สูงวัยด้วยความเข้าใจลึกซึ้ง",
		"location": "Library of Memories",
		"sprite": "res://Assets/npc_elder.png",
		"dialogue": [
			"สติและการตั้งใจคือพื้นฐานของทุกสิ่ง",
			"ความเข้าใจในตนเองคือก้าวแรกของการเรียนรู้",
			"เจ้าพร้อมที่จะฝึกฝนจิตใจแล้วหรือยัง?"
		],
		"quests": ["wisdom_start"],
		"relationship_bonus": 5
	},
	
	"merchant_fortune": {
		"name": "พ่อค้าโชค",
		"type": NPCType.MERCHANT,
		"title": "พ่อค้าผู้คิดค่าแพง",
		"description": "ขายสินค้าและเลือกกำไร",
		"location": "Shop",
		"sprite": "res://Assets/npc_merchant.png",
		"dialogue": [
			"สินค้าดีต้องมีราคาดี",
			"มีอะไรอยากซื้อไหม",
			"ลูกค้าเก่าได้ส่วนลด นะ"
		],
		"items": ["potion_hp", "mana_potion", "antidote"],
		"relationship_bonus": 3
	},
	
	"guide_path": {
		"name": "ไกด์ทางสำนัก",
		"type": NPCType.GUIDE,
		"title": "ผู้นำทางผู้รอบรู้",
		"description": "ผู้ช่วยให้คำแนะนำในเส้นทางมรรคา",
		"location": "Crossroads",
		"sprite": "res://Assets/npc_guide.png",
		"dialogue": [
			"ยินดีต้อนรับสู่ทางแยกแห่งการเรียนรู้ครับ!",
			"ที่นี่คือจุดเริ่มต้นของการเดินทางเพื่อฟื้นฟูป่าแห่งชีวิต",
			"หากคุณไม่แน่ใจว่าควรไปทางไหน ลองมาปรึกษาผมได้เสมอนะครับ"
		],
		"hints": [
			"ทางเดินแห่งพลัง: เน้นการออกกำลังกาย เหมาะสำหรับผู้ที่ต้องการเพิ่มพลังกาย!",
			"ทางเดินแห่งโภชนาการ: เรียนรู้เรื่องอาหาร 5 หมู่ เพื่อบริหารพลังงานมานา",
			"ทางเดินแห่งความสะอาด: ป้องกันตัวจากโรคร้ายด้วยสุขอนามัยที่ดี",
			"ทางเดินแห่งปัญญา: ฝึกฝนสมาธิเพื่อเพิ่มความต้านทานทางจิตใจ"
		],
		"provides_hints": true,
		"relationship_bonus": 4
	},
	
	"healer_compassion": {
		"name": "หมอแล่งจิต",
		"type": NPCType.HEALER,
		"title": "หมอความเห็นใจ",
		"description": "ช่วยเหลือผู้ป่วยด้วยหัวใจ",
		"location": "Healing Temple",
		"sprite": "res://Assets/npc_healer.png",
		"dialogue": [
			"ปลายสติ หายชั่วขณะแต่จิตใจฟื้นบ้าง",
			"ศรัทธามีพลังบ่งชี่",
			"เรียนกับใจแ�กแงว"
		],
		"healing_discount": 0.8,  # 20% discount
		"relationship_bonus": 6
	},
	
	"rival_ambitious": {
		"name": "ศত(อ)สิขร คนตั้งใจสูง",
		"type": NPCType.RIVAL,
		"title": "คู่แข่งผู้เลื่องชื่อ",
		"description": "ศัตรูซึ่งมีเคารพ",
		"location": "Arena",
		"sprite": "res://Assets/npc_rival.png",
		"dialogue": [
			"ตรวจสอบกำลังของเราสักครั้ง",
			"ฉันจะชนะเธอเสมอ",
			"เตรียมตัวให้พร้อม"
		],
		"provides_battles": true,
		"relationship_bonus": 2
	},
	
	"scholar_knowledge": {
		"name": "อักษร โครงการความรู้",
		"type": NPCType.SCHOLAR,
		"title": "นักวิชาการแห่งสถาบัน",
		"description": "นักศึกษาที่รักษาความรู้",
		"location": "Library of Memories",
		"sprite": "res://Assets/npc_scholar.png",
		"dialogue": [
			"การศึกษาคือกุญแจสู่อนาคต",
			"รู้หรือไม่ว่าเหตุการณ์นี้เป็นอย่างไร",
			"หนังสือบันทึกทั้งหมด"
		],
		"teaches_skills": true,
		"relationship_bonus": 5
	},
	
	"storyteller_tales": {
		"name": "กาลหัวใจค่ะเล่าเรื่อง",
		"type": NPCType.STORYTELLER,
		"title": "นักเล่าเรื่องผู้ชำนาญ",
		"description": "ผู้เล่าเรื่องไทยเก่าแก่",
		"location": "Campfire",
		"sprite": "res://Assets/npc_storyteller.png",
		"dialogue": [
			"เคยได้ยินเรื่องแห่ง 6 ทางนี้หรือ",
			"ดั้งเดิมอักษรเก่าแล้วว",
			"ฟังเรื่องเหมือนสารนี่"
		],
		"unlocks_lore": true,
		"relationship_bonus": 4
	},
	
	"merchant_potions": {
		"name": "ยา'สั้น เคมีรงเรียง",
		"type": NPCType.MERCHANT,
		"title": "พ่อค้ายาแต่งสรร",
		"description": "ผู้ผลิตยาปรุงแต่งเทพ",
		"location": "Shop",
		"sprite": "res://Assets/npc_potion_merchant.png",
		"dialogue": [
			"วิธีการสร้างยาเห็นไขว้เข้า",
			"แต่งสรรด้วยน้ำจากแม่น้ำ",
			"ขายประเทศประสิทธี"
		],
		"sells_potions": true,
		"relationship_bonus": 3
	},
	
	"quest_master": {
		"name": "นายใหญ่เทพ",
		"type": NPCType.QUEST_GIVER,
		"title": "เจ้านายใหญ่",
		"description": "ผู้สัง่ผลงานอันยิ่งใหญ่",
		"location": "Guild Hall",
		"sprite": "res://Assets/npc_questmaster.png",
		"dialogue": [
			"อาณาจักรนี้มีภารกิจมากมายที่รอผู้กล้าอยู่",
			"การช่วยเหลือผู้อื่นจะทำให้เมืองของเราเข้มแข็ง",
			"มีงานชิ้นใหญ่ที่เหมาะกับเจ้าพอดี..."
		],
		"quests": ["exercise_start", "nutrition_start", "hygiene_start"],
		"relationship_bonus": 4
	},
	
	"guardian_spirit": {
		"name": "วิญญาณผู้รักษา",
		"type": NPCType.GUIDE,
		"title": "เทวดาแห่งป่า",
		"description": "วิญญาณศักดิ์สิทธิ์แห่งธรรมชาติ",
		"location": "The Sleepy Forest",
		"sprite": "res://Assets/npc_guardian.png",
		"dialogue": [
			"ป่าโลกนี้มีจิตใจของตัวเอง",
			"คำตำหนิความเฉื่อยแน่นะ",
			"ช่วยฟื้นฟูป่ากันเถอะ"
		],
		"environmental_quests": true,
		"relationship_bonus": 7
	},
	
	"merchant_maya": {
		"name": "Merchant Maya",
		"type": NPCType.MERCHANT,
		"title": "แม่ค้าแห่ง Terra Nova",
		"description": "ผู้รวบรวมไอเทมหายากจากทั่วทุกมุมโลก",
		"location": "World Map",
		"sprite": "res://Assets/Part2/NPC_Merchant.png",
		"dialogue": [
			"พรแห่ง Terra Nova สถิตอยู่กับเจ้า...",
			"ยินดีต้อนรับสู่ร้านค้าแห่งการวิวัฒนาการ!",
			"เลือกชมสินค้าพรีเมียมจากเราได้เลย!"
		],
		"relationship_bonus": 5
	}
}

func _ready():
	"""Initialize NPC system"""
	_init_npc_data()
	print("[NPCManager] Initialized with %d NPCs" % npcs.size())

func _init_npc_data():
	"""Initialize NPC reputation and tracking"""
	for npc_id in npcs.keys():
		npc_reputation[npc_id] = 0  # Neutral reputation
		npc_visited[npc_id] = false
		npc_quests[npc_id] = []

# ============== NPC INTERACTION ==============

func get_npc(npc_id: String) -> Dictionary:
	"""Get full NPC data"""
	if npc_id in npcs:
		return npcs[npc_id].duplicate(true)
	return {}

func get_npc_dialogue(npc_id: String) -> Array:
	"""Get random dialogue from NPC"""
	var npc = get_npc(npc_id)
	if "dialogue" in npc:
		return npc["dialogue"]
	return ["..."]

func interact_with_npc(npc_id: String) -> void:
	"""Handle NPC interaction"""
	if npc_id not in npcs:
		return
	
	# Mark as visited
	npc_visited[npc_id] = true
	
	# Increase reputation bonus
	var bonus = npcs[npc_id].get("relationship_bonus", 1)
	npc_reputation[npc_id] += bonus
	
	print("[NPC] Interacted with %s | Rep: %d" % [npcs[npc_id]["name"], npc_reputation[npc_id]])

func get_npc_by_type(type: int) -> Array:
	"""Get all NPCs of a specific type"""
	var result = []
	for npc_id in npcs.keys():
		if npcs[npc_id]["type"] == type:
			result.append(npc_id)
	return result

func get_npc_by_location(location: String) -> Array:
	"""Get all NPCs at a specific location"""
	var result = []
	for npc_id in npcs.keys():
		if npcs[npc_id].get("location", "") == location:
			result.append(npc_id)
	return result

# ============== REPUTATION SYSTEM ==============

func add_reputation(npc_id: String, amount: int) -> void:
	"""Add reputation with an NPC"""
	if npc_id in npc_reputation:
		npc_reputation[npc_id] = clamp(npc_reputation[npc_id] + amount, -100, 100)
		print("[Rep] %s now at %d (friendly: %s)" % [npcs[npc_id]["name"], npc_reputation[npc_id], npc_reputation[npc_id] > 50])

func get_reputation(npc_id: String) -> int:
	"""Get reputation with an NPC"""
	return npc_reputation.get(npc_id, 0)

func is_friendly(npc_id: String) -> bool:
	"""Check if NPC is friendly (>50 rep)"""
	return get_reputation(npc_id) > 50

func is_hostile(npc_id: String) -> bool:
	"""Check if NPC is hostile (<-50 rep)"""
	return get_reputation(npc_id) < -50

func get_reputation_level(npc_id: String) -> String:
	"""Get reputation level as text"""
	var rep = get_reputation(npc_id)
	if rep > 75:
		return "devoted"
	elif rep > 50:
		return "friendly"
	elif rep > 25:
		return "neutral"
	elif rep > -25:
		return "suspicious"
	elif rep > -75:
		return "hostile"
	else:
		return "enemy"

# ============== QUEST INTEGRATION ==============

func get_available_quests(npc_id: String) -> Array:
	"""Get quests available from NPC"""
	var npc = get_npc(npc_id)
	return npc.get("quests", [])

func complete_quest_for_npc(npc_id: String, quest_id: String) -> void:
	"""Mark quest as completed"""
	if npc_id in npc_quests:
		if quest_id not in npc_quests[npc_id]:
			npc_quests[npc_id].append(quest_id)
			add_reputation(npc_id, 10)
			print("[Quest] Completed %s for %s" % [quest_id, npcs[npc_id]["name"]])

# ============== MERCHANT FUNCTIONS ==============

func is_merchant(npc_id: String) -> bool:
	"""Check if NPC is a merchant"""
	var npc = get_npc(npc_id)
	return npc.get("type") == NPCType.MERCHANT

func get_merchant_items(npc_id: String) -> Array:
	"""Get items sold by merchant"""
	var npc = get_npc(npc_id)
	var items = npc.get("items", [])
	if npc.get("sells_potions", false):
		items += ["potion_hp", "potion_mana", "potion_antidote"]
	return items

func get_merchant_discount(npc_id: String) -> float:
	"""Get price discount from merchant (based on reputation)"""
	var npc = get_npc(npc_id)
	var base_discount = npc.get("healing_discount", 1.0)
	var rep = get_reputation(npc_id)
	
	# Better reputation = better discount
	if rep > 50:
		return base_discount * 0.9  # 10% additional discount
	elif rep < -50:
		return base_discount * 1.2  # 20% price increase
	
	return base_discount

# ============== LOCATION SYSTEM ==============

func get_all_locations() -> Array:
	"""Get all unique NPC locations"""
	var locations = []
	for npc_id in npcs.keys():
		var loc = npcs[npc_id].get("location", "Unknown")
		if loc not in locations:
			locations.append(loc)
	return locations

func get_npc_count() -> int:
	"""Get total NPC count"""
	return npcs.size()

func print_npc_status() -> void:
	"""Debug: Print all NPC info"""
	print("\n=== NPC SYSTEM STATUS ===")
	print("Total NPCs: %d" % npcs.size())
	print("\nNPC List:")
	for npc_id in npcs.keys():
		var npc = npcs[npc_id]
		var type_name = NPCType.keys()[npc["type"]]
		var rep = get_reputation(npc_id)
		print("  • %s (%s) | Rep: %d (%s) | Location: %s" % [
			npc["name"],
			type_name,
			rep,
			get_reputation_level(npc_id),
			npc.get("location", "Unknown")
		])
	print("=======================\n")
