extends Node
class_name MonsterDB_Part2

const DATA = {
	"unstable_slime": {
		"name": "Unstable Slime",
		"hp": 60,
		"atk": 15,
		"xp": 50,
		"min_gold": 20,
		"max_gold": 30,
		"element": "water", 
		"texture": "res://Assets/Part2/Unstable_Slime.png"
	},
	"thorn_wolf": {
		"name": "Thorn Wolf",
		"hp": 80,
		"atk": 20,
		"xp": 70,
		"min_gold": 30,
		"max_gold": 45,
		"element": "nature",
		"texture": "res://Assets/Part2/Thorn_Wolf.png"
	},
	"spore_shroom": {
		"name": "Spore Shroom",
		"hp": 70,
		"atk": 18,
		"xp": 60,
		"min_gold": 25,
		"max_gold": 40,
		"element": "nature",
		"texture": "res://Assets/Part2/Spore_Shroom.png"
	},
	"bubble_crab": {
		"name": "Bubble Crab",
		"hp": 90,
		"atk": 22,
		"xp": 75,
		"min_gold": 35,
		"max_gold": 50,
		"element": "water",
		"texture": "res://Assets/Part2/Bubble_Crab.png"
	},
	"magma_slime": {
		"name": "Magma Slime",
		"hp": 85,
		"atk": 25,
		"xp": 70,
		"min_gold": 30,
		"max_gold": 45,
		"element": "fire",
		"texture": "res://Assets/Part2/Magma_Slime.png"
	},
	"crystal_spider": {
		"name": "Crystal Spider",
		"hp": 95,
		"atk": 28,
		"xp": 80,
		"min_gold": 40,
		"max_gold": 55,
		"element": "earth",
		"texture": "res://Assets/Part2/Crystal_Spider.png"
	},
	"thunder_hawk": {
		"name": "Thunder Hawk",
		"hp": 100,
		"atk": 30,
		"xp": 90,
		"min_gold": 45,
		"max_gold": 60,
		"element": "lightning",
		"texture": "res://Assets/Part2/Thunder_Hawk.png"
	},
	"corrupted_treant": {
		"name": "Corrupted Treant (BOSS)",
		"hp": 500,
		"atk": 50,
		"xp": 1000,
		"min_gold": 500,
		"max_gold": 600,
		"element": "nature",
		"texture": "res://Assets/Part2/Corrupted_Treant.png"
	},
	"god_of_ignorance": {
		"name": "God of Ignorance (FINAL BOSS)",
		"hp": 2500,
		"atk": 80,
		"xp": 5000,
		"min_gold": 1000,
		"max_gold": 2000,
		"element": "fire",
		"texture": "res://Assets/Part2/God_of_Ignorance.png"
	},
	# === Reused from Part 1 (Evolved/TerraNova Versions) ===
	"virus": {
		"name": "ไวรัสมหาภัย (TerraNova)",
		"hp": 150, "atk": 35, "xp": 120, "min_gold": 50, "max_gold": 80,
		"element": "nature", "texture": "res://Assets/Virus Monster.png"
	},
	"sugar_spy": {
		"name": "จารชนน้ำตาล (TerraNova)",
		"hp": 180, "atk": 40, "xp": 150, "min_gold": 60, "max_gold": 100,
		"element": "water", "texture": "res://Assets/Sugar Overlord.png"
	},
	"fat_phantom": {
		"name": "ปีศาจไขมันพอกหน้า (TerraNova)",
		"hp": 250, "atk": 30, "xp": 180, "min_gold": 80, "max_gold": 120,
		"element": "earth", "texture": "res://Assets/Greasy Blob.png"
	},
	"atrophy_ghost": {
		"name": "วิญญาณกล้ามสลาย (TerraNova)",
		"hp": 200, "atk": 45, "xp": 160, "min_gold": 70, "max_gold": 110,
		"element": "dark", "texture": "res://Assets/Atrophy Spirit.png"
	},
	"stress": {
		"name": "เงาทมิฬแห่งความเครียด (TerraNova)",
		"hp": 220, "atk": 50, "xp": 200, "min_gold": 90, "max_gold": 150,
		"element": "dark", "texture": "res://Assets/Stress Shadow.png"
	},
	"plague_lord": {
		"name": "จอมราชาโรคระบาด (TerraNova)",
		"hp": 1500, "atk": 75, "xp": 3000, "min_gold": 500, "max_gold": 800,
		"element": "nature", "texture": "res://Assets/Plague Lord.png",
		"is_boss": true
	}
}
