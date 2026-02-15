extends Node

# QuestData.gd - Centralized database for game quests
# Part of the Quest & Story System

const QUESTS = {
	"exercise_start": {
		"id": "exercise_start",
		"path": "exercise",
		"title": "จุดเริ่มต้นของการขยับ",
		"description": "เริ่มต้นการเดินทางในป่าแห่งความเฉื่อยและเอาชนะความขี้เกียจ",
		"objective": "เอาชนะ Couch Potato Golem",
		"xp_reward": 200,
		"gold_reward": 100
	},
	"nutrition_start": {
		"id": "nutrition_start",
		"path": "nutrition",
		"title": "กุญแจสำคัญของพลังงาน",
		"description": "เรียนรู้การเลือกทานอาหารที่มีประโยชน์เพื่อเสริมสร้างร่างกาย",
		"objective": "ผ่านบททดสอบแห่งอาหาร 5 หมู่",
		"xp_reward": 200,
		"gold_reward": 100
	},
	"hygiene_start": {
		"id": "hygiene_start",
		"path": "hygiene",
		"title": "ผู้พิทักษ์ความสะอาด",
		"description": "กำจัดแหล่งสะสมเชื้อโรคและรักษาสุขอนามัยของเมือง",
		"objective": "เอาชนะ Plague Lord",
		"xp_reward": 200,
		"gold_reward": 100
	},
	"wisdom_start": {
		"id": "wisdom_start",
		"path": "wisdom",
		"title": "แสงสว่างแห่งปัญญา",
		"description": "ฝึกฝนสมาธิและทักษะทางสังคมเพื่อความสมดุลของจิตใจ",
		"objective": "เอาชนะ Overthinking Golem",
		"xp_reward": 200,
		"gold_reward": 100
	}
}

static func get_quest(quest_id: String) -> Dictionary:
	return QUESTS.get(quest_id, {})

static func get_quests_by_path(path_id: String) -> Array:
	var result = []
	for q_id in QUESTS:
		if QUESTS[q_id].path == path_id:
			result.append(QUESTS[q_id])
	return result
