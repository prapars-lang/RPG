extends Node
class_name ItemDB_Part2

const ITEMS = {
	# === Advanced Consumables ===
	"mega_potion": {
		"name": "เมก้าโพชั่น", "type": "consumable", "subtype": "hp", "value": 300, 
		"desc": "ฟื้นฟู HP 300 ทันที", "price": 500, "icon": "res://Assets/items/potion_hp_large.png"
	},
	"elixir_mana": {
		"name": "อีลิกเซอร์มานา", "type": "consumable", "subtype": "mp", "value": 150, 
		"desc": "ฟื้นฟู MP 150 ทันที", "price": 600, "icon": "res://Assets/items/potion_mp_large.png"
	},
	"revive_crystal": {
		"name": "คริสตัลคืนชีพ", "type": "consumable", "subtype": "revive", "value": 1, 
		"desc": "ชุบชีวิตเพื่อนร่วมทีม (ยังไม่รองรับในระบบต่อสู้ปัจจุบัน)", "price": 1000, "icon": "res://Assets/items/vitality_gem.png"
	},

	# === Elemental Weapons (Part 2 specialized) ===
	"terra_blade": {
		"name": "ดาบผ่าปฐพี (Terra Blade)", "type": "equipment", "slot": "weapon", "rarity": "epic", 
		"atk": 45, "def": 10, "element": "earth",
		"desc": "ดาบที่อาบพลังแห่งผืนดิน (ATK +45, DEF +10, ธาตุ: ดิน)", "price": 2500, "icon": "res://Assets/items/sword_mythril.png"
	},
	"inferno_staff": {
		"name": "คทาเพลิงกัลป์", "type": "equipment", "slot": "weapon", "rarity": "epic", 
		"atk": 20, "mana": 100, "element": "fire",
		"desc": "คทาที่บรรจุเปลวไฟมหาพินาศ (ATK +20, MP +100, ธาตุ: ไฟ)", "price": 2800, "icon": "res://Assets/items/staff_mystic.png"
	},
	"storm_bow": {
		"name": "ธนูวายุคลั่ง", "type": "equipment", "slot": "weapon", "rarity": "epic", 
		"atk": 55, "element": "wind",
		"desc": "ธนูที่ยิงลูกศรได้รวดเร็วปานลมพายุ (ATK +55, ธาตุ: ลม)", "price": 2600, "icon": "res://Assets/items/bow_short.png"
	},

	# === Powerful Armor ===
	"aether_plate": {
		"name": "เกราะเอเธอร์", "type": "equipment", "slot": "body", "rarity": "legendary", 
		"def": 40, "hp": 150, "desc": "ชุดเกราะหนักที่สร้างจากแร่ศักดิ์สิทธิ์ (DEF +40, HP +150)", "price": 5000, "icon": "res://Assets/items/armor_plate.png"
	},
	"celestial_robe": {
		"name": "ผ้าคลุมสวรรค์", "type": "equipment", "slot": "body", "rarity": "legendary", 
		"def": 20, "mana": 200, "desc": "ผ้าคลุมที่ถักทอด้วยแสงดารา (DEF +20, MP +200)", "price": 4800, "icon": "res://Assets/items/robe_mystic.png"
	},

	# === Accessories (Elemental) ===
	"fire_ring": {
		"name": "แหวนอัคคี", "type": "equipment", "slot": "accessory", "rarity": "rare", 
		"atk": 15, "element": "fire", "desc": "แหวนที่เพิ่มพลังโจมตีธาตุไฟ (ATK +15)", "price": 1200, "icon": "res://Assets/items/ring_power.png"
	},
	"water_amulet": {
		"name": "เครื่องรางวารี", "type": "equipment", "slot": "accessory", "rarity": "rare", 
		"def": 20, "element": "water", "desc": "เครื่องรางที่ช่วยป้องกันและเพิ่มพลังน้ำ (DEF +20)", "price": 1200, "icon": "res://Assets/items/necklace_hp.png"
	}
}
