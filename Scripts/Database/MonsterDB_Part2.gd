extends Node
class_name MonsterDB_Part2

const DATA = {
	# --- Body & Senses (ป.1) ---
	"optic_wisp": {
		"name": "Optic Wisp", "hp": 50, "atk": 12, "xp": 40, "min_gold": 15, "max_gold": 25,
		"element": "lightning", "texture": "res://Assets/Part2/optic_wisp.png"
	},
	"echo_bat": {
		"name": "Echo Bat", "hp": 45, "atk": 14, "xp": 45, "min_gold": 20, "max_gold": 30,
		"element": "water", "texture": "res://Assets/Part2/echo_bat.png"
	},
	"sensory_slime": {
		"name": "Sensory Slime", "hp": 60, "atk": 10, "xp": 50, "min_gold": 25, "max_gold": 35,
		"element": "nature", "texture": "res://Assets/Part2/sensory_slime.png"
	},
	"olfactory_cloud": {
		"name": "Olfactory Cloud", "hp": 55, "atk": 15, "xp": 55, "min_gold": 20, "max_gold": 40,
		"element": "nature", "texture": "res://Assets/Part2/olfactory_cloud.png"
	},
	"gustatory_mimic": {
		"name": "Gustatory Mimic", "hp": 70, "atk": 18, "xp": 60, "min_gold": 30, "max_gold": 50,
		"element": "earth", "texture": "res://Assets/Part2/gustatory_mimic.png"
	},

	# --- Hygiene & Diseases (ป.1-ป.2) ---
	"germ_blob": {
		"name": "Germ Blob", "hp": 80, "atk": 20, "xp": 70, "min_gold": 35, "max_gold": 55,
		"element": "water", "texture": "res://Assets/Part2/germ_blob.png"
	},
	"flu_virus_rex": {
		"name": "Flu Virus Rex", "hp": 120, "atk": 25, "xp": 100, "min_gold": 50, "max_gold": 80,
		"element": "nature", "texture": "res://Assets/Part2/flu_virus_rex.png"
	},
	"dental_decay_demon": {
		"name": "Dental Decay Demon", "hp": 100, "atk": 30, "xp": 90, "min_gold": 40, "max_gold": 70,
		"element": "earth", "texture": "res://Assets/Part2/dental_decay_demon.png"
	},
	"parasite_vine": {
		"name": "Parasite Vine", "hp": 90, "atk": 22, "xp": 80, "min_gold": 30, "max_gold": 60,
		"element": "nature", "texture": "res://Assets/Part2/parasite_vine.png"
	},
	"moldy_goop": {
		"name": "Moldy Goop", "hp": 85, "atk": 24, "xp": 85, "min_gold": 35, "max_gold": 65,
		"element": "nature", "texture": "res://Assets/Part2/moldy_goop.png"
	},

	# --- Nutrition & Growth (ป.3) ---
	"sugar_titan": {
		"name": "Sugar Titan", "hp": 200, "atk": 35, "xp": 200, "min_gold": 100, "max_gold": 150,
		"element": "water", "texture": "res://Assets/Part2/sugar_titan.png"
	},
	"carb_crusher": {
		"name": "Carb Crusher", "hp": 150, "atk": 30, "xp": 150, "min_gold": 80, "max_gold": 120,
		"element": "earth", "texture": "res://Assets/Part2/carb_crusher.png"
	},
	"grease_wraith": {
		"name": "Grease Wraith", "hp": 130, "atk": 40, "xp": 140, "min_gold": 70, "max_gold": 110,
		"element": "water", "texture": "res://Assets/Part2/grease_wraith.png"
	},
	"vitamin_guardian": {
		"name": "Vitamin Guardian (Corrupted)", "hp": 140, "atk": 28, "xp": 130, "min_gold": 60, "max_gold": 100,
		"element": "nature", "texture": "res://Assets/Part2/vitamin_guardian.png"
	},
	"sodium_scorpio": {
		"name": "Sodium Scorpio", "hp": 160, "atk": 45, "xp": 170, "min_gold": 90, "max_gold": 140,
		"element": "earth", "texture": "res://Assets/Part2/sodium_scorpio.png"
	},

	# --- Physical & Puberty (ป.4) ---
	"atrophy_soldier": {
		"name": "Atrophy Soldier", "hp": 180, "atk": 38, "xp": 190, "min_gold": 80, "max_gold": 130,
		"element": "dark", "texture": "res://Assets/Part2/atrophy_soldier.png"
	},
	"bone_breaker_ogre": {
		"name": "Bone Breaker Ogre", "hp": 250, "atk": 45, "xp": 250, "min_gold": 120, "max_gold": 180,
		"element": "earth", "texture": "res://Assets/Part2/bone_breaker_ogre.png"
	},
	"hormone_hydra": {
		"name": "Hormone Hydra", "hp": 220, "atk": 42, "xp": 230, "min_gold": 110, "max_gold": 160,
		"element": "fire", "texture": "res://Assets/Part2/hormone_hydra.png"
	},
	"posture_ghoul": {
		"name": "Posture Ghoul", "hp": 170, "atk": 40, "xp": 180, "min_gold": 70, "max_gold": 120,
		"element": "dark", "texture": "res://Assets/Part2/posture_ghoul.png"
	},
	"acne_swarm": {
		"name": "Acne Swarm", "hp": 120, "atk": 50, "xp": 160, "min_gold": 60, "max_gold": 110,
		"element": "fire", "texture": "res://Assets/Part2/acne_swarm.png"
	},

	# --- Systems & Nervous (ป.5) ---
	"neural_net_serpent": {
		"name": "Neural Net Serpent", "hp": 280, "atk": 50, "xp": 300, "min_gold": 150, "max_gold": 220,
		"element": "lightning", "texture": "res://Assets/Part2/neural_net_serpent.png"
	},
	"endocrine_elemental": {
		"name": "Endocrine Elemental", "hp": 240, "atk": 48, "xp": 280, "min_gold": 140, "max_gold": 200,
		"element": "fire", "texture": "res://Assets/Part2/endocrine_elemental.png"
	},
	"synapse_striker": {
		"name": "Synapse Striker", "hp": 200, "atk": 60, "xp": 270, "min_gold": 130, "max_gold": 190,
		"element": "lightning", "texture": "res://Assets/Part2/synapse_striker.png"
	},
	"medulla_kraken": {
		"name": "Medulla Kraken", "hp": 350, "atk": 55, "xp": 400, "min_gold": 200, "max_gold": 300,
		"element": "water", "texture": "res://Assets/Part2/medulla_kraken.png"
	},
	"mental_chaos": {
		"name": "Mental Chaos", "hp": 300, "atk": 65, "xp": 450, "min_gold": 250, "max_gold": 350,
		"element": "dark", "texture": "res://Assets/Part2/mental_chaos.png"
	},

	# --- Circulatory & Respiratory (ป.6) ---
	"systolic_beast": {
		"name": "Systolic Beast", "hp": 400, "atk": 70, "xp": 500, "min_gold": 300, "max_gold": 450,
		"element": "fire", "texture": "res://Assets/Part2/systolic_beast.png"
	},
	"alveoli_absorber": {
		"name": "Alveoli Absorber", "hp": 380, "atk": 65, "xp": 480, "min_gold": 280, "max_gold": 420,
		"element": "nature", "texture": "res://Assets/Part2/alveoli_absorber.png"
	},
	"artery_clogger": {
		"name": "Artery Clogger", "hp": 450, "atk": 60, "xp": 550, "min_gold": 320, "max_gold": 480,
		"element": "earth", "texture": "res://Assets/Part2/artery_clogger.png"
	},
	"hemoglobin_harvester": {
		"name": "Hemoglobin Harvester", "hp": 360, "atk": 75, "xp": 520, "min_gold": 300, "max_gold": 460,
		"element": "dark", "texture": "res://Assets/Part2/hemoglobin_harvester.png"
	},
	"bronchitis_bat": {
		"name": "Bronchitis Bat", "hp": 420, "atk": 68, "xp": 540, "min_gold": 310, "max_gold": 470,
		"element": "nature", "texture": "res://Assets/Part2/bronchitis_bat.png"
	},

	# --- Substances & Hazards (ป.6 / High Risk) ---
	"nicotine_djinn": {
		"name": "Nicotine Djinn", "hp": 500, "atk": 85, "xp": 700, "min_gold": 400, "max_gold": 600,
		"element": "dark", "texture": "res://Assets/Part2/nicotine_djinn.png"
	},
	"ethanol_elemental": {
		"name": "Ethanol Elemental", "hp": 550, "atk": 80, "xp": 750, "min_gold": 450, "max_gold": 650,
		"element": "water", "texture": "res://Assets/Part2/ethanol_elemental.png"
	},
	"caffeine_raptor": {
		"name": "Caffeine Raptor", "hp": 480, "atk": 95, "xp": 800, "min_gold": 500, "max_gold": 700,
		"element": "lightning", "texture": "res://Assets/Part2/caffeine_raptor.png"
	},
	"opioid_octopus": {
		"name": "Opioid Octopus", "hp": 600, "atk": 90, "xp": 900, "min_gold": 550, "max_gold": 800,
		"element": "dark", "texture": "res://Assets/Part2/opioid_octopus.png"
	},
	"toxin_tarantula": {
		"name": "Toxin Tarantula", "hp": 580, "atk": 88, "xp": 850, "min_gold": 520, "max_gold": 750,
		"element": "nature", "texture": "res://Assets/Part2/toxin_tarantula.png"
	},

	# --- Final Bosses ---
	"general_neglect": {
		"name": "General Neglect", "hp": 1200, "atk": 110, "xp": 2000, "min_gold": 1000, "max_gold": 1500,
		"element": "earth", "texture": "res://Assets/Part2/general_neglect.png", "is_boss": true
	},
	"phantom_misinfo": {
		"name": "Phantom Misinfo", "hp": 1500, "atk": 120, "xp": 2500, "min_gold": 1500, "max_gold": 2000,
		"element": "dark", "texture": "res://Assets/Part2/phantom_misinfo.png", "is_boss": true
	},
	"sedentary_serpent": {
		"name": "Sedentary Serpent", "hp": 1800, "atk": 100, "xp": 3000, "min_gold": 2000, "max_gold": 2500,
		"element": "earth", "texture": "res://Assets/Part2/sedentary_serpent.png", "is_boss": true
	},
	"plague_lord": {
		"name": "Lord of Pandemics", "hp": 2500, "atk": 150, "xp": 5000, "min_gold": 3000, "max_gold": 5000,
		"element": "nature", "texture": "res://Assets/Part2/plague_god.png", "is_boss": true
	},
	"god_of_ignorance": {
		"name": "God of Ignorance (Final Form)", "hp": 10000, "atk": 250, "xp": 100000, "min_gold": 5000, "max_gold": 10000,
		"element": "all", "texture": "res://Assets/Part2/God_of_Ignorance.png", "is_boss": true
	},
	
	# --- Mid-Point Special Bosses ---
	"boss_mid_5": {
		"name": "จอมมารแห่งอุบัติเหตุ (Master of Hazards)", "hp": 300, "atk": 45, "xp": 400, "min_gold": 200, "max_gold": 300,
		"element": "earth", "texture": "res://Assets/Part2/Crystal_Spider.png", "is_boss": true
	},
	"boss_mid_10": {
		"name": "บารอนแห่งสารเสพติด (Toxin Baron)", "hp": 700, "atk": 85, "xp": 800, "min_gold": 400, "max_gold": 600,
		"element": "dark", "texture": "res://Assets/Part2/nicotine_djinn.png", "is_boss": true
	},
	"boss_mid_15": {
		"name": "แม่มดแห่งโรคระบาด (Plague Queen)", "hp": 1200, "atk": 110, "xp": 1500, "min_gold": 800, "max_gold": 1200,
		"element": "nature", "texture": "res://Assets/Part2/toxin_tarantula.png", "is_boss": true
	},
	"boss_mid_20": {
		"name": "จอมจักรพรรดิแห่งมลพิษ (Smog Emperor)", "hp": 1800, "atk": 130, "xp": 2500, "min_gold": 1200, "max_gold": 1800,
		"element": "fire", "texture": "res://Assets/Part2/systolic_beast.png", "is_boss": true
	},
	"boss_mid_25": {
		"name": "ขุนพลแห่งความขัดแย้ง (General of Strife)", "hp": 2500, "atk": 160, "xp": 4000, "min_gold": 2000, "max_gold": 3000,
		"element": "dark", "texture": "res://Assets/Part2/phantom_misinfo.png", "is_boss": true
	},
	
	# --- Original Placeholders (for compatibility) ---
	"unstable_slime": { "name": "Classic Unstable Slime", "hp": 60, "atk": 15, "xp": 50, "min_gold": 20, "max_gold": 30, "element": "water", "texture": "res://Assets/Part2/Unstable_Slime.png" },
	"thorn_wolf": { "name": "Classic Thorn Wolf", "hp": 80, "atk": 20, "xp": 70, "min_gold": 30, "max_gold": 45, "element": "nature", "texture": "res://Assets/Part2/Thorn_Wolf.png" },
	"spore_shroom": { "name": "Classic Spore Shroom", "hp": 70, "atk": 18, "xp": 60, "min_gold": 25, "max_gold": 40, "element": "nature", "texture": "res://Assets/Part2/Spore_Shroom.png" },
	"bubble_crab": { "name": "Classic Bubble Crab", "hp": 90, "atk": 22, "xp": 75, "min_gold": 35, "max_gold": 50, "element": "water", "texture": "res://Assets/Part2/Bubble_Crab.png" },
	"magma_slime": { "name": "Classic Magma Slime", "hp": 85, "atk": 25, "xp": 70, "min_gold": 30, "max_gold": 45, "element": "fire", "texture": "res://Assets/Part2/Magma_Slime.png" },
	"crystal_spider": { "name": "Classic Crystal Spider", "hp": 95, "atk": 28, "xp": 80, "min_gold": 40, "max_gold": 55, "element": "earth", "texture": "res://Assets/Part2/Crystal_Spider.png" },
	"thunder_hawk": { "name": "Classic Thunder Hawk", "hp": 100, "atk": 30, "xp": 90, "min_gold": 45, "max_gold": 60, "element": "lightning", "texture": "res://Assets/Part2/Thunder_Hawk.png" },
	"virus": { "name": "ไวรัสมหาภัย", "hp": 150, "atk": 35, "xp": 120, "min_gold": 50, "max_gold": 80, "element": "nature", "texture": "res://Assets/Virus Monster.png" },
	"sugar_spy": { "name": "จารชนน้ำตาล", "hp": 180, "atk": 40, "xp": 150, "min_gold": 60, "max_gold": 100, "element": "water", "texture": "res://Assets/Sugar Overlord.png" },
	"fat_phantom": { "name": "ปีศาจไขมันพอกหน้า", "hp": 250, "atk": 30, "xp": 180, "min_gold": 80, "max_gold": 120, "element": "earth", "texture": "res://Assets/Greasy Blob.png" },
	"atrophy_ghost": { "name": "วิญญาณกล้ามสลาย", "hp": 200, "atk": 45, "xp": 160, "min_gold": 70, "max_gold": 110, "element": "dark", "texture": "res://Assets/Atrophy Spirit.png" },
	"stress": { "name": "เงาทมิฬแห่งความเครียด", "hp": 220, "atk": 50, "xp": 200, "min_gold": 90, "max_gold": 150, "element": "dark", "texture": "res://Assets/Stress Shadow.png" }
}
