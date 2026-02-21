extends Node

# Database of Part 2 Companions
# Format: id: { name, sprite, element, skill_name, skill_effect, description }

const COMPANIONS = {
	"ignis_pup": {
		"name": "Ignis Pup",
		"element": Global.ELEMENT_FIRE,
		"sprite": "res://Assets/Part2/Ignis_Pup.png", 
		"description": "สุนัขจิ้งจอกเพลิงจากเผ่า Ignivar ผู้รอดชีวิตจาก Ember Wastes",
		"stats": {"atk": 15, "hp_bonus": 20},
		"skill": {
			"name": "Ignivar Flame",
			"element": Global.ELEMENT_FIRE,
			"value": 25,
			"cost": 10,
			"type": "dmg"
		}
	},
	"aqua_slime": {
		"name": "Aqua Slime",
		"element": Global.ELEMENT_WATER,
		"sprite": "res://Assets/Part2/Aqua_Slime.png", 
		"description": "สไลม์วารีจาก Azure Delta ตัวนุ่มนิ่มแต่ฟื้นฟูไว",
		"stats": {"atk": 10, "hp_bonus": 50},
		"skill": {
			"name": "Aquaryn Bubble",
			"element": Global.ELEMENT_WATER,
			"value": 30,
			"cost": 15,
			"type": "heal"
		}
	},
	"terra_golem": {
		"name": "Terra Golem",
		"element": Global.ELEMENT_EARTH,
		"sprite": "res://Assets/Part2/Terra_Golem.png",
		"description": "โกเลมหินจิ๋วจาก Stoneheart Bastion แข็งแกร่งดั่งภูผา",
		"stats": {"atk": 20, "hp_bonus": 30},
		"skill": {
			"name": "Terradon Wall",
			"element": Global.ELEMENT_EARTH,
			"value": 35,
			"cost": 20,
			"type": "dmg" # Or buff? Keeping dmg for now
		}
	}
}

func get_companion(id):
	return COMPANIONS.get(id, null)
