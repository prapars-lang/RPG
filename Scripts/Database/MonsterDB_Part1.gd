extends Node
class_name MonsterDB_Part1

const DATA = {
	"lazy_slime": {
		"name": "สไลม์ขี้เกียจ",
		"hp": 40,
		"atk": 5,
		"xp": 30,
		"min_gold": 10,
		"max_gold": 15,
		"texture": "res://Assets/Lazy Slime.png"
	},
	"atrophy_ghost": {
		"name": "วิญญาณกล้ามลีบ",
		"hp": 60,
		"atk": 12,
		"xp": 50,
		"min_gold": 20,
		"max_gold": 30,
		"texture": "res://Assets/Atrophy Spirit.png"
	},
	"couch_golem": {
		"name": "โกเลมโซฟา",
		"hp": 100,
		"atk": 8,
		"xp": 80,
		"min_gold": 35,
		"max_gold": 50,
		"texture": "res://Assets/Couch Potato Golem.png"
	},
	"sugar_spy": {
		"name": "สายลับน้ำตาล",
		"hp": 70,
		"atk": 12,
		"xp": 60,
		"min_gold": 20,
		"max_gold": 30,
		"texture": "res://Assets/Sugar Overlord.png"
	},
	"fat_phantom": {
		"name": "ปีศาจไขมันพอก",
		"hp": 90,
		"atk": 15,
		"xp": 80,
		"min_gold": 30,
		"max_gold": 45,
		"texture": "res://Assets/Greasy Blob.png"
	},
	"salt_slime": {
		"name": "สไลม์เกลือเค็ม",
		"hp": 80,
		"atk": 20,
		"xp": 75,
		"min_gold": 25,
		"max_gold": 40,
		"texture": "res://Assets/Salt Crystalline.png"
	},
	"junk_food_king": { # Mid-Boss
		"name": "ราชา Junk Food",
		"hp": 400,
		"atk": 50,
		"xp": 800,
		"min_gold": 200,
		"max_gold": 300,
		"texture": "res://Assets/Sugar Overlord.png"
	},
	"soda_slime": {
		"name": "สไลม์น้ำซ่าซาบซ่าน",
		"hp": 100,
		"atk": 25,
		"xp": 90,
		"min_gold": 40,
		"max_gold": 60,
		"texture": "res://Assets/Salt Crystalline.png"
	},
	"preservative_ghost": {
		"name": "ผีสารกันบูด",
		"hp": 120,
		"atk": 22,
		"xp": 110,
		"min_gold": 50,
		"max_gold": 80,
		"texture": "res://Assets/Atrophy Spirit.png"
	},
	"processed_mimic": {
		"name": "อาหารกระป๋องกินคน",
		"hp": 150,
		"atk": 30,
		"xp": 150,
		"min_gold": 70,
		"max_gold": 120,
		"texture": "res://Assets/Trash Demon.png"
	},
	"trans_fat_titan": { # Elite / Sub-Boss
		"name": "ไททันไขมันทรานส์",
		"hp": 250,
		"atk": 40,
		"xp": 300,
		"min_gold": 150,
		"max_gold": 250,
		"texture": "res://Assets/Couch Potato Golem.png"
	},
	"junk_food_emperor": { # Final Boss
		"name": "จักรพรรดิ Junk Food",
		"hp": 1200,
		"atk": 85,
		"xp": 2500,
		"min_gold": 1000,
		"max_gold": 2000,
		"texture": "res://Assets/Plague Lord.png"
	},
	"smoke": {
		"name": "หมอกควันพิษ",
		"hp": 70,
		"atk": 14,
		"xp": 70,
		"gold": 30,
		"texture": "res://Assets/Smog Cloud.png"
	},
	"stress": {
		"name": "เงาความเครียด",
		"hp": 90,
		"atk": 18,
		"xp": 100,
		"gold": 45,
		"texture": "res://Assets/Stress Shadow.png"
	},
	"trash_heap": {
		"name": "กองขยะเดินได้",
		"hp": 90,
		"atk": 10,
		"xp": 70,
		"gold": 35,
		"texture": "res://Assets/Trash Heap.png"
	},
	"noise_banshee": {
		"name": "ปีศาจเสียงรบกวน",
		"hp": 50,
		"atk": 20,
		"xp": 65,
		"gold": 30,
		"texture": "res://Assets/Noise Banshee.png"
	},
	"trash_demon": {
		"name": "ปีศาจขยะ",
		"hp": 80,
		"atk": 12,
		"xp": 80,
		"gold": 40,
		"texture": "res://Assets/Trash Demon.png"
	},
	"virus": {
		"name": "ไวรัสจอมวายร้าย",
		"hp": 100,
		"atk": 15,
		"xp": 120,
		"gold": 50,
		"texture": "res://Assets/Virus Monster.png"
	},
	"germ": {
		"name": "เชื้อโรคอันตราย",
		"hp": 110,
		"atk": 18,
		"xp": 140,
		"gold": 60,
		"texture": "res://Assets/Germ Monster .png"
	},
	"plague_lord": {
		"name": "ราชาโรคระบาด",
		"hp": 300,
		"atk": 40,
		"xp": 600,
		"gold": 250,
		"texture": "res://Assets/Plague Lord.png"
	},
	"parasite": {
		"name": "หนอนพยาธิทมิฬ",
		"hp": 120,
		"atk": 20,
		"xp": 150,
		"gold": 60,
		"texture": "res://Assets/monster_virus.png"
	},
	"overthinking_golem": { 
		"name": "ยักษ์จอมฟุ้งซ่าน",
		"hp": 250,
		"atk": 30,
		"xp": 500,
		"gold": 200,
		"texture": "res://Assets/Overthinking Golem.png"
	},
	"knowledge_guardian": {
		"name": "Pathos อสูรแห่งความเขลา", 
		"hp": 500, "max_hp": 500, 
		"atk": 35, "def": 20, 
		"xp": 500, "gold": 999, 
		"texture": "res://Assets/monsters/shadow_demon.png",
		"weakness": ["nutrition", "hygiene", "exercise", "body", "health", "safety"],
		"description": "บอสลับผู้พิทักษ์ความรู้ แพ้ทางผู้มีความรู้รอบตัว"
	},
	"ignorance_incarnate": {
		"name": "Ignorance Incarnate (ร่างอวตารแห่งความเขลา)", 
		"hp": 800, "max_hp": 800, 
		"atk": 40, "def": 25, 
		"xp": 9999, "gold": 0, 
		"texture": "res://Assets/monsters/final_boss_ignorance.png",
		"description": "ต้นกำเนิดของปีศาจทั้งหมด... ความไม่รู้ที่กัดกินโลก",
		"weakness": "all"
	}
}
