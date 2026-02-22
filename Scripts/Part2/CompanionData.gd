extends Node

# Database of Part 2 Companions
# Format: id: { name, sprite, element, skill_name, skill_effect, description }

const EVOLUTION_THRESHOLD = 50

const COMPANIONS = {
	"ignis_pup": {
		"name": "Ignis Pup",
		"element": Global.ELEMENT_FIRE,
		"sprite": "res://Assets/Part2/ignis_pup_transparent.png", 
		"description": "สุนัขจิ้งจอกเพลิงจากเผ่า Ignivar ผู้รอดชีวิตจาก Ember Wastes",
		"stats": {"atk": 15, "hp_bonus": 20},
		"skill": {
			"name": "Ignivar Flame",
			"element": Global.ELEMENT_FIRE,
			"value": 25,
			"cost": 10,
			"type": "dmg"
		},
		"evolution": {
			"name": "Ignis Wolf",
			"sprite": "res://Assets/Part2/ignis_wolf_transparent.png",
			"description": "จิ้งจอกเพลิงที่วิวัฒนาการเป็นหมาป่าอัคคี มีพลังเผาผลาญศัตรูอย่างรุนแรง",
			"stats": {"atk": 35, "hp_bonus": 60},
			"skill": {
				"name": "Infernal Supernova",
				"element": Global.ELEMENT_FIRE,
				"value": 60,
				"cost": 25,
				"type": "dmg"
			}
		}
	},
	"aqua_slime": {
		"name": "Aqua Slime",
		"element": Global.ELEMENT_WATER,
		"sprite": "res://Assets/Part2/aqua_slime_transparent.png", 
		"description": "สไลม์วารีจาก Azure Delta ตัวนุ่มนิ่มแต่ฟื้นฟูไว",
		"stats": {"atk": 10, "hp_bonus": 50},
		"skill": {
			"name": "Aquaryn Bubble",
			"element": Global.ELEMENT_WATER,
			"value": 30,
			"cost": 15,
			"type": "heal"
		},
		"evolution": {
			"name": "Aqua Hydra Slime",
			"sprite": "res://Assets/Part2/aqua_hydra_slime_transparent.png",
			"description": "สไลม์วารีที่ควบรวมพลังจากสายน้ำขนาดใหญ่ สามารถฟื้นฟูบาดแผลได้มหาศาล",
			"stats": {"atk": 25, "hp_bonus": 120},
			"skill": {
				"name": "Azure Great Wave",
				"element": Global.ELEMENT_WATER,
				"value": 70,
				"cost": 30,
				"type": "heal"
			}
		}
	},
	"terra_golem": {
		"name": "Terra Golem",
		"element": Global.ELEMENT_EARTH,
		"sprite": "res://Assets/Part2/terra_golem_transparent.png",
		"description": "โกเลมหินจิ๋วจาก Stoneheart Bastion แข็งแกร่งดั่งภูผา",
		"stats": {"atk": 20, "hp_bonus": 30},
		"skill": {
			"name": "Terradon Wall",
			"element": Global.ELEMENT_EARTH,
			"value": 35,
			"cost": 20,
			"type": "dmg"
		},
		"evolution": {
			"name": "Terra Titan",
			"sprite": "res://Assets/Part2/terra_titan_transparent.png",
			"description": "ยักษ์ศิลาที่ตื่นจากการหลับใหลหมื่นปี ผิวพรรณแข็งแกร่งยากจะทำลาย",
			"stats": {"atk": 50, "hp_bonus": 80},
			"skill": {
				"name": "Bastion Quake",
				"element": Global.ELEMENT_EARTH,
				"value": 85,
				"cost": 35,
				"type": "dmg"
			}
		}
	}
}

func get_companion(id, bond = 0):
	var base = COMPANIONS.get(id)
	if not base: return null
	
	if bond >= EVOLUTION_THRESHOLD and base.has("evolution"):
		var evo = base.evolution
		# Merge evolution data over base
		var final_data = base.duplicate(true)
		final_data.name = evo.name
		final_data.sprite = evo.sprite
		final_data.description = evo.description
		final_data.stats = evo.stats
		final_data.skill = evo.skill
		final_data.is_evolved = true
		return final_data
		
	var final_data = base.duplicate(true)
	final_data.is_evolved = false
	return final_data
