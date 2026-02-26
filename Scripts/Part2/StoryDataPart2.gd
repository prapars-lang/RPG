extends RefCounted
class_name StoryDataPart2

# Part 2: Story Script Database (Terra Nova — 500 Years Later)
# Fully populated with 30 Chapters, 60 Battles, and unique Backgrounds

const CHAPTERS = {
	"chapter_1": {
		"name": "สัมผัสแห่งวิญญาณ (P.1 Body & Senses)",
		"summary": "เรียนรู้ประสาทสัมผัสทั้ง 5 และการดูแลร่างกายเบื้องต้น",
		"0": {
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch1_senses.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [
				{"name": "Elder Arin", "text": "ยินดีต้อนรับผู้สืบทอด! ตาและหูของเจ้าคือหน้าต่างบานแรกสู่โลกกว้าง", "focus": "other"},
				{"name": "Hero", "text": "ท่านผู้เฒ่า! ข้าสัมผัสได้ถึงพลังงานที่แปรปรวนในป่าแห่งนี้!", "focus": "hero"}
			], "next_scene": "continue"
		},
		"1": {
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch1_senses.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [{"name": "Aetherion", "text": "นั่นไง! Optic Wisp มันกำลังรบกวนการมองเห็นของเจ้า!", "focus": "guide"}],
			"next_scene": "battle", "enemy_id": "optic_wisp"
		},
		"2": {
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch1_senses.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [
				{"name": "Hero", "text": "ตามองเห็นชัดขึ้นแล้ว... แต่หูของข้าเริ่มอื้อ!", "focus": "hero"},
				{"name": "Elder Arin", "text": "ระวัง! Echo Bat กำลังจู่โจมด้วยคลื่นเสียง! จงปกป้องหูของเจ้า!", "focus": "other"}
			], "next_scene": "continue"
		},
		"3": {
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch1_senses.png",
			"dialogue": [{"name": "Aetherion", "text": "จงใช้ความรู้เรื่องการปกป้องหูเพื่อเอาชนะมัน!", "focus": "guide"}],
			"next_scene": "battle", "enemy_id": "echo_bat"
		},
		"4": {
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch1_senses.png",
			"dialogue": [{"name": "Hero", "text": "ร่างก่ายของข้าพร้อมสำหรับการเดินทางที่ยิ่งใหญ่กว่านี้แล้ว!", "focus": "hero"}],
			"next_scene": "end"
		}
	},
	"chapter_2": {
		"name": "เกราะแห่งความสะอาด (P.1 Hygiene)",
		"summary": "ฝึกฝนสุขนิสัยที่ดีเพื่อป้องกันเชื้อโรค",
		"0": {
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch2_clean.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [
				{"name": "Healer Elowen", "text": "หยุดก่อนนักเดินทาง! ร่างกายที่สกปรกคือรังของเชื้อโรค จงล้างมือให้สะอาดก่อนเข้าหมู่บ้าน", "focus": "other"},
				{"name": "Hero", "text": "ข้าเข้าใจแล้ว! ความสะอาดคือเกราะป้องกันแรกของข้า", "focus": "hero"}
			], "next_scene": "continue"
		},
		"1": { "type": "battle", "enemy_id": "germ_blob", "next_scene": "continue" },
		"2": {
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch2_clean.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [{"name": "Healer Elowen", "text": "เจ้าทำได้ดี! แต่ระวัง Virus Rex ที่กำลังแพร่กระจายอากาศเสีย!", "focus": "other"}],
			"next_scene": "continue"
		},
		"3": { "type": "battle", "enemy_id": "flu_virus_rex", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch2_clean.png", "dialogue": [{"name": "Aetherion", "text": "บททดสอบความสะอาดของเจ้าผ่านไปได้ด้วยดี!", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_3": {
		"name": "พลังงานจากธรรมชาติ (P.1 Nutrition)",
		"summary": "เลือกกินอาหารที่มีประโยชน์และถูกหลักโภชนาการ",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch3_orchard.png", "npc_sprite": "res://Assets/Part2/NPC_Fisher_Kael.png",
			"dialogue": [
				{"name": "Fisher Kael", "text": "โอ้! เจ้าดูหิวโหยนะ เลือกกินผลไม้ที่สดใหม่สิ อย่าไปแตะต้องพวกที่เน่าเสียล่ะ", "focus": "other"},
				{"name": "Hero", "text": "ขอบคุณท่านลุงข้าจะเลือกอาหารที่ให้พลังงานที่แท้จริง!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "moldy_goop", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch3_orchard.png", "npc_sprite": "res://Assets/Part2/NPC_Fisher_Kael.png",
			"dialogue": [{"name": "Fisher Kael", "text": "นั่นไง! พวกปีศาจน้ำตาลกำลังพยายามล่อลวงเจ้า!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "sugar_spy", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch3_orchard.png", "dialogue": [{"name": "Aetherion", "text": "จำไว้ว่าอาหารที่สะอาดและครบ 5 หมู่คือเกราะป้องกันชั้นเลิศ", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_4": {
		"name": "จังหวะแห่งการเคลื่อนไหว (P.1 Exercise)",
		"summary": "การออกกำลังกายช่วยให้ร่างกายแข็งแรงและยืดหยุ่น",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch4_training.png", "npc_sprite": "res://Assets/Part2/NPC_Miner_Toph.png",
			"dialogue": [
				{"name": "Miner Toph", "text": "เฮ้! อย่างมัวแต่อู้งานล่ะ ยิ่งขยับร่างกายมากเท่าไหร่ เจ้าก็ยิ่งแข็งแกร่งขึ้นเท่านั้น!", "focus": "other"},
				{"name": "Hero", "text": "ร่างกายของข้าพร้อมสำหรับการฝึกฝนแล้ว!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "sensory_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch4_training.png", "npc_sprite": "res://Assets/Part2/NPC_Miner_Toph.png",
			"dialogue": [{"name": "Miner Toph", "text": "กล้ามเนื้อที่ไม่ได้ใช้งานจะลีบฝ่อลง จงกำจัด Atrophy Soldier ซะ!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch4_training.png", "dialogue": [{"name": "Aetherion", "text": "ความสม่ำเสมอคือหัวใจของการออกกำลังกาย", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_5": {
		"name": "ปราการความปลอดภัย (P.1 Safety)",
		"summary": "ระมัดระวังอุบัติเหตุและอันตรายในชีวิตประจำวัน",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch5_safe_fort.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [
				{"name": "Pilot Cid", "text": "ระวังตัวด้วย! พื้นที่ข้างหน้าเต็มไปด้วยกับดักและของมีคม เจ้าต้องมีสติเสมอ", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะระมัดระวังอุบัติเหตุและอันตรายทุกฝีก้าว!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "crystal_spider", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch5_safe_fort.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [{"name": "Pilot Cid", "text": "นั่นไง! Thorn Wolf มันโจมตีอย่างรวดเร็วเมื่อเจ้าเผลอ!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "thorn_wolf", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch5_safe_fort.png", "dialogue": [{"name": "Aetherion", "text": "การมีแผนเตรียมพร้อมช่วยลดอันตรายได้มหาศาล... แต่เดี๋ยวก่อน!", "focus": "guide"}], "next_scene": "boss_event" },
		"boss_event": {
			"0": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch5_safe_fort.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
				"dialogue": [
					{"name": "Elder Arin", "text": "ระวัง! ข้าสัมผัสได้ถึงกลิ่นอายแห่งหายนะครั้งใหญ่!", "focus": "other"},
					{"name": "Hero", "text": "นั่นมัน... จอมมารแห่งอุบัติเหตุ (Hazard Lord)!", "focus": "hero"}
				], "next_scene": "continue"
			},
			"1": { "type": "battle", "enemy_id": "boss_mid_5", "next_scene": "continue" },
			"2": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch5_safe_fort.png",
				"dialogue": [
					{"name": "Hero", "text": "ข้าพิสูจน์แล้วว่าความไม่ประมาทคืออาวุธที่ทรงพลังที่สุด!", "focus": "hero"},
					{"name": "Elder Arin", "text": "เจ้าทำได้ดีมาก ความปลอดภัยของดินแดนนี้อยู่ในมือเจ้าแล้ว", "focus": "other"}
				], "next_scene": "end"
			}
		}
	},
	"chapter_6": {
		"name": "รากฐานแห่งครอบครัว (P.2 Home & Family)",
		"summary": "ความสัมพันธ์ที่ดีในครอบครัวคือพลังที่แข็งแรง",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch6_home.png", "npc_sprite": "res://Assets/Part2/NPC_Merchant.png",
			"dialogue": [
				{"name": "Merchant Maya", "text": "ยินดีต้อนรับกลับบ้านจ้ะ ความอบอุ่นในครอบครัวคือสิ่งที่ขับไล่ความมืดมนนะ", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะปกป้องสายใยครอบครัวจากความเครียดและความโกรธ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "stress", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch6_home.png", "npc_sprite": "res://Assets/Part2/NPC_Merchant.png",
			"dialogue": [{"name": "Merchant Maya", "text": "ความโกรธกำลังทำลายความสงบ! จงใช้ความเข้าใจเอาชนะมัน", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "stress", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch6_home.png", "dialogue": [{"name": "Aetherion", "text": "สายใยครอบครัวที่เหนียวแน่นจะปกป้องเจ้าจากความเศร้า", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_7": {
		"name": "ส่องกระจกดูอารมณ์ (P.2 Emotions)",
		"summary": "การรู้จักและจัดการอารมณ์ของตนเอง",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch7_mirror_lake.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [
				{"name": "Scholar Veila", "text": "มองลงไปในน้ำสิ อารมณ์ของเจ้าเป็นอย่างไรในตอนนี้? จงยอมรับมัน", "focus": "other"},
				{"name": "Hero", "text": "ใจที่สงบคืออาวุธที่ทรงพลังที่สุด ข้าจะไม่ให้อารมณ์มาควบคุมข้า!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch7_mirror_lake.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [{"name": "Scholar Veila", "text": "Hormone Hydra โจมตีด้วยความแปรปรวนของใจ! จงมีสติ!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch7_mirror_lake.png", "dialogue": [{"name": "Aetherion", "text": "ใจที่สงบคืออาวุธที่ทรงพลังที่สุด", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_8": {
		"name": "ก้าวข้ามการเติบโต (P.2 Growth)",
		"summary": "ความแตกต่างของร่างกายและการเจริญเติบโต",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch8_giant_tree.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [
				{"name": "Healer Elowen", "text": "ดูต้นไม้ใหญ่ต้นนี้สิ มันเติบโตมาจากเมล็ดเล็กๆ เหมือนกับตัวเจ้า!", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะดูแลร่างกายให้ดีที่สุดเพื่อให้เติบโตอย่างแข็งแรง!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch8_giant_tree.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [{"name": "Healer Elowen", "text": "ร่างกายของเจ้ากำลังเปลี่ยนแปลงไปในทางที่ดี อย่ากลัวการเติบโตเลลย", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch8_giant_tree.png", "dialogue": [{"name": "Aetherion", "text": "จงรักษาสุขภาพเพื่อให้เติบโตอย่างแข็งแรง", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_9": {
		"name": "กำราบโรคระบาด (P.2 Disease Prevention)",
		"summary": "การป้องกันและดูแลตนเองจากโรคติดต่อ",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch9_toxic_swamp.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [
				{"name": "Elder Arin", "text": "หนองน้ำพิษนี้เป็นแหล่งแพร่เชื้อร้าย! เจ้าต้องใช้ความรู้เรื่องสุขบัญญัติปกป้องตัวเอง", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะกำจัดไวรัสพวกนี้และหยุดยั้งการระบาด!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "virus", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch9_toxic_swamp.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [{"name": "Elder Arin", "text": "ไวรัสกลายพันธุ์! อย่าลืมมนตรา 'กินร้อน ช้อนกลาง ล้างมือ'!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "virus", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch9_toxic_swamp.png", "dialogue": [{"name": "Aetherion", "text": "การมีวินัยในการรักษาสุขภาพคืออาวุธทำลายเชื้อโรค", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_10": {
		"name": "โอสถแห่งความรู้ (P.2 Medicines & Drugs)",
		"summary": "ความรู้เรื่องยาสามัญประจำบ้านและภัยจากสารเสพติด",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch10_alchemist_garden.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [
				{"name": "Scholar Veila", "text": "สวนนี้มียาทั้งที่รักษาและที่ทำลายชีวิต จงเลือกใช้อย่างมีสติ", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะยาเพื่อการรักษาเท่านั้น และจะหลีกเลี่ยงสารเสพติดให้โทษ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "moldy_goop", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch10_alchemist_garden.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [{"name": "Scholar Veila", "text": "เห็ดมึนเมาพวกนี้กำลังครอบงำจิตใจผู้คน! จงทำลายมัน!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch10_alchemist_garden.png", "dialogue": [{"name": "Aetherion", "text": "สติที่ระลึกถึงโทษของสารเสพติดจะทำให้เจ้าปลอดภัย... แต่ดูนั่น!", "focus": "guide"}], "next_scene": "boss_event" },
		"boss_event": {
			"0": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch10_alchemist_garden.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
				"dialogue": [
					{"name": "Scholar Veila", "text": "เงามืดจากควันดำกำลังรวมตัวกัน... บารอนแห่งสารเสพติด (Toxin Baron) มาแล้ว!", "focus": "other"},
					{"name": "Hero", "text": "ข้าจะไม่ยอมให้สิ่งมึนเมามาทำลายอนาคตของข้า!", "focus": "hero"}
				], "next_scene": "continue"
			},
			"1": { "type": "battle", "enemy_id": "boss_mid_10", "next_scene": "continue" },
			"2": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch10_alchemist_garden.png",
				"dialogue": [
					{"name": "Hero", "text": "แสงสว่างแห่งสติได้ขับไล่ความมืดมนออกไปแล้ว!", "focus": "hero"},
					{"name": "Scholar Veila", "text": "ยินดีด้วยผู้กล้า เจ้าได้ก้าวข้ามบททดสอบที่ยิ่งใหญ่", "focus": "other"}
				], "next_scene": "end"
			}
		}
	},
	"chapter_11": {
		"name": "วิวัฒนาการแห่งชีวิต (P.3 Growth)",
		"summary": "ทำความเข้าใจปัจจัยที่มีผลต่อการเติบโตของร่างกาย",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch11_ancient_cave.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [
				{"name": "Elder Arin", "text": "ในถ้ำโบราณแห่งนี้ เจ้าจะเห็นร่องรอยการเปลี่ยนแปลงของทุกสรรพสิ่ง รวมทั้งตัวเจ้าเองด้วย", "focus": "other"},
				{"name": "Hero", "text": "ข้าพร้อมที่จะเรียนรู้ปัจจัยที่ทำให้ข้าเติบโตอย่างสมบูรณ์!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch11_ancient_cave.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [{"name": "Elder Arin", "text": "มรดกแห่งเวลาดึงดูดสัตว์ร้ายที่กินความเยาว์วัย! จงรักษาพลังชีวิตของเจ้าไว้!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch11_ancient_cave.png", "dialogue": [{"name": "Aetherion", "text": "การพักผ่อนและอาหารที่มีประโยชน์คือหัวใจของการเติบโต", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_12": {
		"name": "เกียรติแห่งความเคารพ (P.3 Respect & Rights)",
		"summary": "การเคารพสิทธิในร่างกายและความหลากหลายทางเพศ",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch12_unity_plaza.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [
				{"name": "Scholar Veila", "text": "ลานกว้างแห่งความสามัคคีนี้สร้างขึ้นเพื่อเตือนใจว่าทุกคนเท่าเทียมกัน ไม่ว่าจะมีความแตกต่างเพียงใด", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะให้เกียรติและเคารพสิทธิในร่างกายของผู้อื่นเสมอ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "stress", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch12_unity_plaza.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [{"name": "Scholar Veila", "text": "ความวุ่นวายเกิดจากความไม่เข้าใจ! จงใช้พุทธิปัญญาคืนความสงบสู่ที่นี่!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "stress", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch12_unity_plaza.png", "dialogue": [{"name": "Aetherion", "text": "โลกที่สวยงามเริ่มต้นจากหัวใจที่รู้จักให้คุณค่ากับทุกคน", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_13": {
		"name": "พิทักษ์ปราการสีขาว (P.3 Dental Health)",
		"summary": "การดูแลสุขภาพฟันและช่องปากอย่างถูกวิธี",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch13_white_crystals.png", "npc_sprite": "res://Assets/Part2/NPC_Blacksmith_Gorr.png",
			"dialogue": [
				{"name": "Blacksmith Gorr", "text": "ฟันของเจ้าต้องแข็งแรงเหมือนเนื้อเหล็กที่ข้าตี! อย่าปล่อยให้มันผุกร่อนล่ะ", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะแปรงฟันให้ถูกวิธีแลจะระวังตัวจากปีศาจฟันผุ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "sensory_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch13_white_crystals.png", "npc_sprite": "res://Assets/Part2/NPC_Blacksmith_Gorr.png",
			"dialogue": [{"name": "Blacksmith Gorr", "text": "นั่นมันเมือกน้ำตาล! มันจะทำร้ายปราการสีขาวของเจ้า!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "sensory_slime", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch13_white_crystals.png", "dialogue": [{"name": "Aetherion", "text": "รอยยิ้มที่สดใสเริ่มจากการดูแลช่องปากให้สะอาด", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_14": {
		"name": "วิถีแห่งความปลอดภัย (P.3 Safety & Drowning)",
		"summary": "การป้องกันอุบัติเหตุจากการจมน้ำและความร้อน",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch14_harvest_valley.png", "npc_sprite": "res://Assets/Part2/NPC_Fisher_Kael.png",
			"dialogue": [
				{"name": "Fisher Kael", "text": "สายน้ำในหุบเขาเก็บเกี่ยวนี้ดูลึกและเชี่ยว เจ้าต้องระวังอย่าพลาดตกลงไปล่ะ!", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะไม่ประมาทและจะระวังอุบัติเหตุทั้งความร้อนและทางน้ำ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch14_harvest_valley.png", "npc_sprite": "res://Assets/Part2/NPC_Fisher_Kael.png",
			"dialogue": [{"name": "Fisher Kael", "text": "ระวัง! Unstable Slime กำลังพยายามดึงเจ้าลงน้ำ!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch14_harvest_valley.png", "dialogue": [{"name": "Aetherion", "text": "ความรู้ช่วยให้เจ้าเอาชีวิตรอดได้ในทุกสถานการณ์", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_15": {
		"name": "ปฐมพยาบาลเบื้องต้น (P.3 First Aid)",
		"summary": "การช่วยเหลือเบื้องต้นเมื่อเกิดอุบัติเหตุหรือบาดเจ็บ",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch15_guarded_bridge.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [
				{"name": "Healer Elowen", "text": "ที่สะพานผู้พิทักษ์นี้มีคนบาดเจ็บจากการต่อสู้ เจ้าพอจะช่วยปฐมพยาบาลเบื้องต้นได้ไหม?", "focus": "other"},
				{"name": "Hero", "text": "ข้าพร้อมที่จะนำความรู้มาช่วยบรรเทาความเจ็บปวดให้เพื่อนมนุษย์!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "sensory_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch15_guarded_bridge.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [{"name": "Healer Elowen", "text": "เจ้าทำได้ดี การปฐมพยาบาลที่ถูกต้องช่วยลดการสูญเสียได้มหาศาล!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "sensory_slime", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch15_guarded_bridge.png", "dialogue": [{"name": "Aetherion", "text": "ฮีโร่ตัวจริงคือคนที่รู้วิธีรักษาชีวิตคนอื่น... แต่ฉับพลันนั้น!", "focus": "guide"}], "next_scene": "boss_event" },
		"boss_event": {
			"0": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch15_guarded_bridge.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
				"dialogue": [
					{"name": "Healer Elowen", "text": "ระวัง! เชื้อร้ายที่แข็งแกร่งที่สุดกำลังคืบคลานมา... แม่มดแห่งโรคระบาด (Plague Queen)!", "focus": "other"},
					{"name": "Hero", "text": "ข้าจะใช้ความรู้เรื่องการรักษาทำลายคำสาปของเจ้า!", "focus": "hero"}
				], "next_scene": "continue"
			},
			"1": { "type": "battle", "enemy_id": "boss_mid_15", "next_scene": "continue" },
			"2": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch15_guarded_bridge.png",
				"dialogue": [
					{"name": "Hero", "text": "การป้องกันและรักษาที่ถูกต้องคือชัยชนะเหนือโรคภัย!", "focus": "hero"},
					{"name": "Healer Elowen", "text": "เจ้าคือผู้รักษาที่แท้จริงแห่ง Terra Nova", "focus": "other"}
				], "next_scene": "end"
			}
		}
	},
	"chapter_16": {
		"name": "โครงสร้างรากฐาน (P.4 Muscle & Bone)",
		"summary": "การทำงานและการดูแลกล้ามเนื้อและกระดูก",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch16_titan_peaks.png", "npc_sprite": "res://Assets/Part2/NPC_Blacksmith_Gorr.png",
			"dialogue": [
				{"name": "Blacksmith Gorr", "text": "ยอดเขายักษ์นี้เปรียบดั่งกระดูกสันหลังของโลก ร่างกายเจ้าก็ต้องมีกระดูกที่แข็งแรงเช่นกัน!", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะดูแลกล้ามเนื้อและกระดูกให้มั่นคงเหมือนภูเขาลูกนี้!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch16_titan_peaks.png", "npc_sprite": "res://Assets/Part2/NPC_Blacksmith_Gorr.png",
			"dialogue": [{"name": "Blacksmith Gorr", "text": " Atrophy Soldier กำลังใช้มนตราทำให้กระดูกเจ้าอ่อนแรง! สู้กับมัน!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch16_titan_peaks.png", "dialogue": [{"name": "Aetherion", "text": "ความสง่างามมาจากการมีบุคลิกภาพที่ดีภายใต้โครงสร้างที่แข็งแรง", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_17": {
		"name": "จังหวะชีวิตแห่งหัวใจ (P.4 Heart & Circulatory)",
		"summary": "การทำงานของระบบไหลเวียนโลหิตและหัวใจ",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch17_changing_tide.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [
				{"name": "Pilot Cid", "text": "คลื่นในทะเลแห่งการเปลี่ยนแปลงนี้เปรียบดั่งเลือดที่สูบฉีดในตัวเจ้า เจ้าต้องรักษาจังหวะมันให้ดี", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะดูแลหัวใจและระบบไหลเวียนให้ทำงานอย่างมีประสิทธิภาพ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch17_changing_tide.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [{"name": "Pilot Cid", "text": "Hormone Hydra กำลังทำให้จังหวะหัวใจเจ้าปั่นป่วน! คุมสติไว้!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch17_changing_tide.png", "dialogue": [{"name": "Aetherion", "text": "หัวใจที่แข็งแรงคือเครื่องยนต์ที่ไม่มีวันเหนื่อยล้า", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_18": {
		"name": "วิญญาณแห่งความสะอาด (P.4 Personal Hygiene)",
		"summary": "การดูแลสุขภาพช่องปากและร่างกายขั้นสูง",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch18_whispering_woods.png", "npc_sprite": "res://Assets/Part2/NPC_Merchant.png",
			"dialogue": [
				{"name": "Merchant Maya", "text": "ป่ากระซิบแห่งนี้เต็มไปด้วยความลึกลับ แต่เจ้าจะผ่านมันไปได้ด้วยความสะอาดที่บริสุทธิ์", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะรักษาความสะอาดเพื่อไล่ความมืดมนออกไป!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "moldy_goop", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch18_whispering_woods.png", "npc_sprite": "res://Assets/Part2/NPC_Merchant.png",
			"dialogue": [{"name": "Merchant Maya", "text": "ความสกปรกสร้างปีศาจเชื้อรา! กำจัดมันซะให้สิ้นซาก!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "moldy_goop", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch18_whispering_woods.png", "dialogue": [{"name": "Aetherion", "text": "สุขนิสัยที่ดีในวันนี้คือทุนทรัพย์สุขภาพในวันหน้า", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_19": {
		"name": "พิทักษ์โลกร้อน (P.4 Environment & Health)",
		"summary": "ผลกระทบของสิ่งแวดล้อมต่อสุขภาพและโลกร้อน",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch19_foggy_wasteland.png", "npc_sprite": "res://Assets/Part2/NPC_Miner_Toph.png",
			"dialogue": [
				{"name": "Miner Toph", "text": "หมอกควันนี้เกิดจากการขุดเจาะที่ไม่ระวัง มันกำลังทำลายลมหายใจของทุกคน!", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะปกป้องสิ่งแวดล้อมเพื่ออากาศบริสุทธิ์ของ Terra Nova!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "virus", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch19_foggy_wasteland.png", "npc_sprite": "res://Assets/Part2/NPC_Miner_Toph.png",
			"dialogue": [{"name": "Miner Toph", "text": "ไวรัสทางเดินหายใจแฝงตัวอยู่ในควันนี้! ระวังตัวด้วย!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "virus", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch19_foggy_wasteland.png", "dialogue": [{"name": "Aetherion", "text": "เมื่อโลกสุขภาพดี มนุษย์ก็จะสุขภาพดีไปด้วย", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_20": {
		"name": "รุ่งอรุณแห่งวัย (P.4 Puberty)",
		"summary": "การยอมรับและปรับตัวต่อการเปลี่ยนแปลงของร่างกาย",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch20_herb_clinic.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [
				{"name": "Healer Elowen", "text": "เจ้าดูโตขึ้นมากนะ! รอยสิวหรืออารมณ์ที่พลุ่งพล่านเป็นเรื่องปกติของวัยนี้", "focus": "other"},
				{"name": "Hero", "text": "ข้าเรียนรู้ที่จะปรับตัวและยอมรับทุกฉบับของการเติบโต!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch20_herb_clinic.png", "npc_sprite": "res://Assets/Part2/NPC_Elowen.png",
			"dialogue": [{"name": "Healer Elowen", "text": "Hormone Hydra กำลังทำให้เจ้าไม่มั่นใจ! จงแสดงพลังของความภูมิใจในตนเอง!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch20_herb_clinic.png", "dialogue": [{"name": "Aetherion", "text": "ความสวยงามที่แท้จริงคือความมั่นใจที่มาจากข้างใน... ทว่า!", "focus": "guide"}], "next_scene": "boss_event" },
		"boss_event": {
			"0": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch20_herb_clinic.png", "npc_sprite": "res://Assets/Part2/NPC_Miner_Toph.png",
				"dialogue": [
					{"name": "Miner Toph", "text": "พื้นดินสั่นสะเทือน! จอมจักรพรรดิแห่งมลพิษ (Smog Emperor) ตื่นจากการหลับใหลแล้ว!", "focus": "other"},
					{"name": "Hero", "text": "ข้าจะปกป้องทั้งร่างกายและโลกใบนี้จากมลพิษ!" , "focus": "hero"}
				], "next_scene": "continue"
			},
			"1": { "type": "battle", "enemy_id": "boss_mid_20", "next_scene": "continue" },
			"2": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch20_herb_clinic.png",
				"dialogue": [
					{"name": "Hero", "text": "วิถีแห่งธรรมชาติและความสมดุลได้คืนกลับมาแล้ว!", "focus": "hero"},
					{"name": "Miner Toph", "text": "เจ้าแกร่งเหมือนหินผาจริงๆ เลยนะเนี่ย!", "focus": "other"}
				], "next_scene": "end"
			}
		}
	},
	"chapter_21": {
		"name": "รักษ์ต้นกำเนิด (P.5 Reproductive)",
		"summary": "การทำงานและดูแลระบบสืบพันธุ์",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch21_neural_forest.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [
				{"name": "Scholar Veila", "text": "ในป่าประสาทแห่งนี้ เราจะเรียนรู้ถึงความละเอียดอ่อนของจุดเริ่มต้นแห่งชีวิต", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะดูแลรักษาระบบที่สำคัญที่สุดของร่างกายด้วยความเข้าใจ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch21_neural_forest.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [{"name": "Scholar Veila", "text": "ปีศาจแห่งความประมาทกำลังจู่โจม! จงปกป้องรากฐานของเจ้า!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch21_neural_forest.png", "dialogue": [{"name": "Aetherion", "text": "ความรู้เรื่องเพศศึกษาคือภูมิคุ้มกันชีวิต", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_22": {
		"name": "สะพานแห่งมิตรภาพ (P.5 Relationships)",
		"summary": "การสร้างและรักษาความสัมพันธ์ที่ดีกับเพื่อนและคนรอบข้าง",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch22_echo_chamber.png", "npc_sprite": "res://Assets/Part2/NPC_Merchant.png",
			"dialogue": [
				{"name": "Merchant Maya", "text": "ความสัมพันธ์ที่สั่นคลอนเหมือนเสียงสะท้อนที่บิดเบี้ยว เจ้าต้องสร้างความเชื่อมั่นขึ้นมาใหม่", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะใช้ความซื่อสัตย์และการสื่อสารที่ดีเป็นสะพานเชื่อมมิตรภาพ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "stress", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch22_echo_chamber.png", "npc_sprite": "res://Assets/Part2/NPC_Merchant.png",
			"dialogue": [{"name": "Merchant Maya", "text": "ความเข้าใจผิดกำลังสร้างพายุอารมณ์! จงสงบมันด้วยเหตุผล", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "stress", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch22_echo_chamber.png", "dialogue": [{"name": "Aetherion", "text": "การเป็นผู้ฟังที่ดีคือจุดเริ่มต้นของมิตรภาพที่ยั่งยืน", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_23": {
		"name": "สวนโภชนาการ (P.5 High Nutrition)",
		"summary": "โภชนบัญญัติและการเลือกซื้ออาหาร",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch23_bloom_garden.png", "npc_sprite": "res://Assets/Part2/NPC_Fisher_Kael.png",
			"dialogue": [
				{"name": "Fisher Kael", "text": "สวนนี้ผลิบานตลอดปี แต่อย่าดูแค่สีสัน จงดูสารอาหารที่เจ้าจะได้รับด้วย!", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะเลือกอาหารอย่างชาญฉลาดตามหลักโภชนาการ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "sugar_spy", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch23_bloom_garden.png", "npc_sprite": "res://Assets/Part2/NPC_Fisher_Kael.png",
			"dialogue": [{"name": "Fisher Kael", "text": "Sugar Spy กำลังปลอมตัวเป็นอาหารหวานฉ่ำ! อย่าหลงกลมัน!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "sugar_spy", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch23_bloom_garden.png", "dialogue": [{"name": "Aetherion", "text": "เจ้าคือสิ่งทีเจ้าเลือกกิน จงเลือกให้ดีที่สุด", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_24": {
		"name": "หอคอยแห่งความคิด (P.5 Mental Health)",
		"summary": "สุขภาวะทางจิตและการจัดการความเครียด",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch24_illusion_tower.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [
				{"name": "Elder Arin", "text": "หอคอยมายานี้สะท้อนความเครียดในใจคน เจ้าต้องฝึกใจให้เข้มแข็งเพื่อมองผ่านภาพลวงตา", "focus": "other"},
				{"name": "Hero", "text": "ข้าฝึกฝนที่จะจัดการกับความเครียดและเป็นนายเหนืออารมณ์ตนเอง!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch24_illusion_tower.png", "npc_sprite": "res://Assets/Part2/NPC_Elder_Arin.png",
			"dialogue": [{"name": "Elder Arin", "text": "Hormone Hydra สร้างความสับสนในหอคอยแห่งนี้! จงปามันด้วยความรู้!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "hormone_hydra", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch24_illusion_tower.png", "dialogue": [{"name": "Aetherion", "text": "สุขภาพจิตที่ดีคือรากฐานของร่างกายที่แข็งแรง", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_25": {
		"name": "หมู่บ้านปลอดพยันตราย (P.5 Accidents & Safety)",
		"summary": "การมีส่วนร่วมในกิจกรรมป้องกันอุบัติเหตุในชุมชน",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch25_clean_village.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [
				{"name": "Pilot Cid", "text": "หมู่บ้านแห่งนี้สะอาดและปลอดภัยก็เพราะความร่วมมือของทุกคน เจ้าพร้อมจะช่วยเหลือไหม?", "focus": "other"},
				{"name": "Hero", "text": "ข้าพร้อมที่จะมีส่วนร่วมในการรักษาความปลอดภัยของหมู่บ้าน!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch25_clean_village.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [{"name": "Pilot Cid", "text": "สัตว์ประหลาดเมือกกำลังคุกคามทางเดินสัญจร! กำจัดมันพวกเราจะได้เดินทางได้สะดวก!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch25_clean_village.png", "dialogue": [{"name": "Aetherion", "text": "ความรับผิดชอบต่อส่วนรวมทำให้ชุมชนน่าอยู่... แต่ภัยร้ายยังไม่จบ!", "focus": "guide"}], "next_scene": "boss_event" },
		"boss_event": {
			"0": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch25_clean_village.png", "npc_sprite": "res://Assets/Part2/NPC_Merchant.png",
				"dialogue": [
					{"name": "Merchant Maya", "text": "ความขัดแย้งกำลังก่อตัวเป็นรูปร่าง! ขุนพลแห่งความขัดแย้ง (General of Strife) กำลังจู่โจมจิตใจผู้คน!", "focus": "other"},
					{"name": "Hero", "text": "ข้าจะใช้ความเข้าใจและความรักสยบความขัดแย้งนี้!", "focus": "hero"}
				], "next_scene": "continue"
			},
			"1": { "type": "battle", "enemy_id": "boss_mid_25", "next_scene": "continue" },
			"2": {
				"type": "dialogue", "background": "res://Assets/Part2/bg_ch25_clean_village.png",
				"dialogue": [
					{"name": "Hero", "text": "มิตรภาพและการสื่อสารที่แท้จริงคือทางออกของทุกปัญหา!", "focus": "hero"},
					{"name": "Merchant Maya", "text": "หมู่บ้านของเรากลับมาสงบสุขอีกครั้งเพราะเจ้าแท้ๆ", "focus": "other"}
				], "next_scene": "end"
			}
		}
	},
	"chapter_26": {
		"name": "สายธารแห่งระบบ (P.6 Biological Systems)",
		"summary": "การทำงานร่วมกันของระบบต่างๆ ในร่างกาย",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch26_river_of_life.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [
				{"name": "Scholar Veila", "text": "แม่น้ำแห่งชีวิตนี้เชื่อมต่อทุกสิ่ง เหมือนระบบในร่างกายเจ้าที่ต้องทำงานร่วมกัน", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะเรียนรู้วิธีทำให้ทุกระบบในตัวข้าทำงานอย่างสอดคล้องกัน!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "virus", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch26_river_of_life.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [{"name": "Scholar Veila", "text": "ไวรัสพวกนี้กำลังโจมตีอวัยวะสำคัญ! จงปกป้องสายธารชีวิตไว!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "virus", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch26_river_of_life.png", "dialogue": [{"name": "Aetherion", "text": "ความสมดุลคือหัวใจหลักของสุขภาพที่ยั่งยืน", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_27": {
		"name": "วิถีแห่งวินัย (P.6 Health Habits)",
		"summary": "การสร้างนิสัยและค่านิยมสุขภาพที่ยั่งยืน",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch27_floating_isle.png", "npc_sprite": "res://Assets/Part2/NPC_Miner_Toph.png",
			"dialogue": [
				{"name": "Miner Toph", "text": "เกาะลอยฟ้านี้ทรงตัวอยู่ได้ด้วยความสมดุล เหมือนร่างกายเจ้าที่ต้องมีวินัยสม่ำเสมอ", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะสร้างค่านิยมสุขภาพที่ถาวรเพื่อชีวิตที่สดใส!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch27_floating_isle.png", "npc_sprite": "res://Assets/Part2/NPC_Miner_Toph.png",
			"dialogue": [{"name": "Miner Toph", "text": " Atrophy Soldier กำลังจะทำลายความพยายามของเจ้า! อย่าใหความขี้เกียจเอาชนะ!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch27_floating_isle.png", "dialogue": [{"name": "Aetherion", "text": "เจ้าคือผู้กำหนดชะตาชีวิตและสุขภาพของตนเอง", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_28": {
		"name": "รับมือพยัพพายุ (P.6 Disaster Preparedness)",
		"summary": "การเตรียมพร้อมรับมือภัยธรรมชาติและสถานการณ์ฉุกเฉิน",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch28_storm_cliff.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [
				{"name": "Pilot Cid", "text": "พายุลูกใหญ่กำลังจะมา! เจ้าต้องรู้วิธีอพยพและป้องกันภัยอย่างถูกต้องนะ", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะเตรียมความพร้อมทั้งแผนรับมือและสติสัมปชัญญะ!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch28_storm_cliff.png", "npc_sprite": "res://Assets/Part2/NPC_Pilot_Cid.png",
			"dialogue": [{"name": "Pilot Cid", "text": "พายุโคลนถล่มนำ Unstable Slime มาทำร้ายผู้คน! ขวางพวกมันไว้!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "unstable_slime", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch28_storm_cliff.png", "dialogue": [{"name": "Aetherion", "text": "การเตรียมตัวที่ดีจะเปลี่ยนวิกฤตให้เป็นโอกาสรอด", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_29": {
		"name": "ขอบเหวแห่งเงามืด (P.6 Drugs & Dangers)",
		"summary": "การป้องกันและหลีกเลี่ยงสารเสพติดและภัยสังคมขั้นสูง",
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch29_abyss_edge.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [
				{"name": "Scholar Veila", "text": "ใต้ขอบเหวนี้คือเงามืดของสารเสพติดที่จ้องทำลายผู้คน เจ้าต้องใช้แสงสว่างแห่งปัญญาขจัดมัน", "focus": "other"},
				{"name": "Hero", "text": "ข้าจะเป็นแสงสว่างที่จะไม่ก้าวลงไปในขอบเหวของอบายมุข!", "focus": "hero"}
			], "next_scene": "continue" 
		},
		"1": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"2": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch29_abyss_edge.png", "npc_sprite": "res://Assets/Part2/NPC_Veiled_Scholar_Reveal.png",
			"dialogue": [{"name": "Scholar Veila", "text": "ปีศาจแห่งความเสพติดกำลังรุมล้อมเจ้า! จงแสดงพลังเจตจำนงที่แข็งแกร่ง!", "focus": "other"}], 
			"next_scene": "continue" 
		},
		"3": { "type": "battle", "enemy_id": "atrophy_soldier", "next_scene": "continue" },
		"4": { "type": "dialogue", "background": "res://Assets/Part2/bg_ch29_abyss_edge.png", "dialogue": [{"name": "Aetherion", "text": "เสรีภาพที่แท้จริงคือการไม่เป็นทาสของสารเสพติด", "focus": "guide"}], "next_scene": "end" }
	},
	"chapter_30": { 
		"name": "ศึกตัดสินแห่ง Terra Nova (Final)", 
		"0": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch30_holy_library.png", "npc_sprite": "res://Assets/Part2/NPC_Aetherion.png",
			"dialogue": [{"name": "Aetherion", "text": "นี่คือบทสรุปแห่งความรู้ทั้งหมดที่เจ้ามี! จงเผชิญหน้ากับต้นเหตุแห่งความเขลา!", "focus": "guide"}], 
			"next_scene": "continue" 
		}, 
		"1": { 
			"type": "battle", "enemy_id": "plague_lord", 
			"next_scene": "continue" 
		}, 
		"2": { 
			"type": "battle", "enemy_id": "god_of_ignorance", 
			"next_scene": "continue" 
		}, 
		"3": { 
			"type": "dialogue", "background": "res://Assets/Part2/bg_ch30_holy_library.png", 
			"dialogue": [
				{"name": "Hero", "text": "Terra Nova สงบสุขแล้ว... ด้วยความรู้และสุขภาพที่ดี!", "focus": "hero"}, 
				{"name": "Aetherion", "text": "เจ้าได้เป็นผู้พิทักษ์แห่งยุคสมัยใหม่อย่างแท้จริง", "focus": "guide"}
			], 
			"next_scene": "end" 
		} 
	}
}
