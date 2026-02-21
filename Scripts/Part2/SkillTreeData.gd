extends Node

# Skill Tree Database
# Define skills for each element

const SKILLS = {
	# --- FIRE (Damage) ---
	"fire_ember": {
		"name": "Ember Spark",
		"id": "fire_ember",
		"element": Global.ELEMENT_FIRE,
		"description": "Deal small Fire damage (20)",
		"cost": 1,
		"prereq": [],
		"type": "active",
		"value": 20
	},
	"fire_blast": {
		"name": "Pyro Blast",
		"id": "fire_blast",
		"element": Global.ELEMENT_FIRE,
		"description": "Deal heavy Fire damage (50)",
		"cost": 3,
		"prereq": ["fire_ember"],
		"type": "active",
		"value": 50
	},
	
	# --- WATER (Heal/Cleanse) ---
	"water_droplet": {
		"name": "Healing Droplet",
		"id": "water_droplet",
		"element": Global.ELEMENT_WATER,
		"description": "Heal 20 HP",
		"cost": 1,
		"prereq": [],
		"type": "heal",
		"value": 20
	},
	"water_wave": {
		"name": "Cleansing Wave",
		"id": "water_wave",
		"element": Global.ELEMENT_WATER,
		"description": "Heal 50 HP and cure burn",
		"cost": 3,
		"prereq": ["water_droplet"],
		"type": "heal",
		"value": 50
	},
	
	# --- NATURE (Support/Buff) ---
	"nature_growth": {
		"name": "Wild Growth",
		"id": "nature_growth",
		"element": Global.ELEMENT_NATURE,
		"description": "Increase DEF by 5 for 3 turns",
		"cost": 1,
		"prereq": [],
		"type": "buff",
		"stat": "def",
		"value": 5
	},
	
	# --- EARTH (Defense) ---
	"earth_shield": {
		"name": "Stone Skin",
		"id": "earth_shield",
		"element": Global.ELEMENT_EARTH,
		"description": "Block next 30 damage",
		"cost": 2,
		"prereq": [],
		"type": "shield",
		"value": 30
	},
	
	# --- WIND/LIGHTNING (Speed/Stun) ---
	"wind_gust": {
		"name": "Zephyr Step",
		"id": "wind_gust",
		"element": Global.ELEMENT_LIGHTNING,
		"description": "Increase Evasion chance",
		"cost": 2,
		"prereq": [],
		"type": "buff",
		"stat": "evasion",
		"value": 20
	}
}

static func get_skills_by_element(element):
	var result = []
	for key in SKILLS:
		if SKILLS[key].element == element:
			result.append(SKILLS[key])
	return result
