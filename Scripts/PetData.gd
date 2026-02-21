extends Node

# Pet Database
# buff_type: "hp", "atk", "def", "mana", "xp_gain", "gold_gain"
var pet_db = {
	"slime_baby": {
		"name": "สไลม์น้อย (Jelly)",
		"texture": "res://Assets/Lazy Slime.png",
		"buff_type": "hp",
		"base_buff": 10,
		"growth_per_level": 5,
		"max_level": 10,
		"desc": "สไลม์นุ่มนิ่ม เพิ่มพลังชีวิตให้ผู้เลี้ยง",
		"evolution": "slime_king"
	},
	"forest_spirit": {
		"name": "ภูติน้อย (Pixie)",
		"texture": "res://Assets/Atrophy Spirit.png",
		"buff_type": "mana",
		"base_buff": 10,
		"growth_per_level": 2,
		"max_level": 10,
		"desc": "ภูติจิ๋วช่วยฟื้นฟูสมาธิเพิ่มมานา",
		"evolution": "forest_guardian"
	},
	"rock_golem": {
		"name": "หินน้อย (Rocky)",
		"texture": "res://Assets/Couch Potato Golem.png",
		"buff_type": "def",
		"base_buff": 2,
		"growth_per_level": 1,
		"max_level": 10,
		"desc": "ก้อนหินมีชีวิต เพิ่มความอึดถึกทน",
		"evolution": "iron_golem"
	}
}

# Evolution Database (Future Proofing)
var evolution_db = {
	"slime_king": {
		"name": "ราชาสไลม์",
		"texture": "res://Assets/Lazy Slime.png", # Placeholder, ideally new art
		"buff_type": "hp",
		"base_buff": 100,
		"growth_per_level": 10,
		"desc": "สไลม์ที่เติบโตจนเป็นราชา"
	}
}

func get_pet_info(pet_id: String) -> Dictionary:
	if pet_id in pet_db:
		return pet_db[pet_id]
	if pet_id in evolution_db:
		return evolution_db[pet_id]
	return {}

func get_buff_value(pet_id: String, level: int) -> int:
	var info = get_pet_info(pet_id)
	if info.is_empty(): return 0
	
	var base = info.get("base_buff", 0)
	var growth = info.get("growth_per_level", 0)
	return base + (growth * (level - 1))

func get_next_level_xp(level: int) -> int:
	# XP Curve: Level * 100 (e.g. Lv1 -> Lv2 needs 100 xp)
	return level * 100
