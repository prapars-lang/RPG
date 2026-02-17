extends Node

# PathData.gd - Data provider for learning paths
# Part of the Complete Path Expansion System

const PATHS = [
	{
		"id": "exercise",
		"title": "ทางเดินแห่งพลัง",
		"subtitle": "การออกกำลังกาย",
		"icon": "res://Assets/Couch Potato Golem.png",
		"description": "ฝึกฝนร่างกายให้แข็งแกร่งด้วยการออกกำลังกายอย่างสม่ำเสมอ",
		"bg_color": Color(0.1, 0.4, 0.1, 0.8)
	},
	{
		"id": "nutrition",
		"title": "ทางเดินแห่งโภชนาการ",
		"subtitle": "อาหาร 5 หมู่",
		"icon": "res://Assets/Sugar Overlord.png",
		"description": "เรียนรู้การเลือกทานอาหารที่มีประโยชน์เพื่อให้ร่างกายมีพลังงาน",
		"bg_color": Color(0.1, 0.1, 0.4, 0.8)
	},
	{
		"id": "hygiene",
		"title": "ทางเดินแห่งความสะอาด",
		"subtitle": "สุขอนามัย",
		"icon": "res://Assets/Plague Lord.png",
		"description": "รักษาสุขอนามัยส่วนบุคคลเพื่อป้องกันโรคร้ายที่มองไม่เห็น",
		"bg_color": Color(0.4, 0.1, 0.4, 0.8)
	},
	{
		"id": "wisdom",
		"title": "ทางเดินแห่งปัญญา",
		"subtitle": "สุขภาพจิตและสังคม",
		"icon": "res://Assets/Overthinking Golem.png",
		"description": "ฝึกฝนสมาธิและทักษะทางสังคมเพื่อความสมดุลของชีวิต",
		"bg_color": Color(0.4, 0.3, 0.1, 0.8)
	}
]

static func get_all_paths() -> Array:
	return PATHS

static func get_path_data(path_id: String) -> Dictionary:
	for p in PATHS:
		if p.id == path_id:
			return p
	return {}
