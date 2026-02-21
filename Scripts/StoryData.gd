extends Node

# Story Script Database
# Format:
# "path_name": {
#    chunk_id: {
#       "type": "dialogue" or "battle",
#       "background": "res://path/to/bg.png",
#       "dialogue": [ { "name": "Name", "text": "Text...", "focus": "hero" or "guide" or "monster" } ],
#       "next_scene": "battle" or "continue",
#       "enemy_id": "monster_id" (if next_scene is battle)
#    }
# }

var final_chapter = {
	"final": {
		# --- Final Scene 1: The Core Gate ---
		0: {
			"type": "dialogue",
			"background": "res://Assets/intro_bg.png",
			"dialogue": [
				{"name": "Hero", "text": "นี่คือจุดสิ้นสุดสินะ... ประตูสู่แก่นโลก", "focus": "hero"},
				{"name": "Guide", "text": "ถูกต้อง พลังงานความเขลาทั้งหมดไหลมารวมกันที่นี่", "focus": "guide"},
				{"name": "System", "text": "(ทันใดนั้น เงาสีดำขนาดมหึมาก็ปรากฏขึ้น!)", "focus": "none"},
				{"name": "Ignorance Incarnate", "text": "เจ้าคิดว่าจะเปลี่ยนแปลงอะไรได้? มนุษย์ย่อมขี้เกียจ... มักง่าย... และอ่อนแอ...", "focus": "monster"},
				{"name": "Hero", "text": "อาจจะใช่... แต่พวกเราเรียนรู้ได้! และพวกเราเปลี่ยนแปลงได้!", "focus": "hero"}
			],
			"next_chunk": 1
		},
		1: {
			"type": "battle",
			"enemy_id": "ignorance_incarnate",
			"next_chunk": 2
		},
		2: {
			"type": "dialogue",
			"background": "res://Assets/intro_bg.png",
			"dialogue": [
				{"name": "Ignorance Incarnate", "text": "เป็นไปไม่ได้... แสงสว่างแห่งปัญญานี้มัน...", "focus": "monster"},
				{"name": "Hero", "text": "นี่คือพลังของการดูแลตัวเอง! พลังของความรู้!", "focus": "hero"},
				{"name": "Guide", "text": "สำเร็จแล้ว! ความมืดมิดกำลังสลายไป!", "focus": "guide"}
			],
			"next_chunk": 3
		},
		3: {
			"type": "end_chapter",
			"next_scene": "res://Scenes/EndingScene.tscn"
		}
	}
}

var path_power = {
	# --- Scene 1: The Sleepy Entrance ---
	0: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"music": "res://Audio/bgm_creepy_forest.mp3", # Placeholder
		"dialogue": [
			{"name": "Hero", "text": "อึก... ทำไม... พื้นที่นี่มันเดินยากชะมัด เหมือนโคลนดูดเลย...", "focus": "hero"},
			{"name": "Hero", "text": "แถมบรรยากาศก็... (หาว) ...น่านอนชะมัด", "focus": "hero"},
			{"name": "Guide", "text": "ตบหน้าตัวเองเดี๋ยวนี้! ท่านผู้กล้า!", "focus": "guide"},
			{"name": "Hero", "text": "เพี๊ยะ! โอ๊ย! ทำอะไรเนี่ย!", "focus": "hero"},
			{"name": "Guide", "text": "ข้าช่วยชีวิตท่านต่างหาก! ที่นี่คือ 'Forest of Inertia' (ป่าแห่งความเฉื่อย)", "focus": "guide"},
			{"name": "Guide", "text": "อากาศที่ท่านหายใจเข้าไปผสมด้วย 'ละอองนิทรา' เข้มข้น มันจะหลอกสมองท่านว่าท่านเหนื่อย ทั้งที่ท่านยังมีแรงเหลือเฟือ", "focus": "guide"},
			{"name": "Hero", "text": "มิน่าล่ะ... ขาฉันรู้สึกหนักๆ เหมือนใส่รองเท้าเหล็กข้างละ 20 กิโล... แถมตายังจะปิด", "focus": "hero"}
		],
		"next_chunk": 1
	},
	
	# --- Scene 2: The Fallen Statue ---
	1: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "Hero", "text": "(ลูบรูปปั้น) นี่มัน... คนจริงๆ เหรอ?", "focus": "hero"},
			{"name": "Guide", "text": "ใช่... เขาคือนักรบผู้เก่งกาจเมื่อ 50 ปีก่อน เขาแค่นั่งพัก 'แป๊บเดียว' เพราะคิดว่าตัวเองแข็งแรงพอที่จะลุกต่อได้เสมอ", "focus": "guide"},
			{"name": "Hero", "text": "แล้วทำไม...", "focus": "hero"},
			{"name": "Guide", "text": "ความขี้เกียจมันน่ากลัวตรงนี้แหละท่านผู้กล้า... มันไม่ได้กระโจนเข้าใส่ท่านเหมือนสัตว์ร้าย", "focus": "guide"},
			{"name": "Guide", "text": "แต่มันจะค่อยๆ กล่อมท่านด้วยความสบาย จนท่านลืมเป้าหมาย และสุดท้าย... ก็กลายเป็นหินผาที่ไร้ชีวิต", "focus": "guide"},
			{"name": "Hero", "text": "(กลืนน้ำลาย) ฉัน... จะไม่ยอมเป็นแบบหมอนี่แน่", "focus": "hero"}
		],
		"next_chunk": 2
	},

	# --- Scene 3: The Whispers ---
	2: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "เสียงปริศนา", "text": "เหนื่อยไปทำไม... พักเถอะ...", "focus": "none"},
			{"name": "เสียงปริศนา", "text": "วันนี้วิ่งมาเยอะแล้ว... พรุ่งนี้ค่อยเอาจริงก็ได้...", "focus": "none"},
			{"name": "เสียงปริศนา", "text": "เตียงนุ่มๆ รออยู่... แอร์เย็นๆ...", "focus": "none"},
			{"name": "Hero", "text": "(เอามือกุมหัว) หยุดนะ! ออกไปจากหัวฉัน!", "focus": "hero"},
			{"name": "Guide", "text": "มันคือ 'เสียงแห่งข้ออ้าง' (Echoes of Excuses) ยิ่งท่านลังเล มันยิ่งดัง! อย่าเถียงกับมัน! จงกลบเสียงมันด้วยเสียงฝีเท้าของท่าน!", "focus": "guide"},
			{"name": "Hero", "text": "ได้! ฉันจะวิ่งให้เสียงเท้าดังกว่าเสียงพวกแกเลย! (เริ่มออกวิ่ง)", "focus": "hero"}
		],
		"next_chunk": 3
	},

	# --- Scene 4: Swamp of Procrastination ---
	3: {
		"type": "dialogue",
		"background": "res://Assets/Swamp of Procrastination.png",
		"dialogue": [
			{"name": "Hero", "text": "ทางขาด... มีทางอ้อมไหม?", "focus": "hero"},
			{"name": "Guide", "text": "ไม่มีทางอ้อมสำหรับความสำเร็จ! บึงนี้คือ 'บึงผลัดวันประกันพรุ่ง' ถ้าท่านหยุดคิดว่าจะข้ามดีไหม ท่านจะไม่มีวันได้ข้าม วิธีเดียวคือ... กระโดด!", "focus": "guide"},
			{"name": "Hero", "text": "เฮ้ย! กว้างขนาดนี้เนี่ยนะ?", "focus": "hero"},
			{"name": "Guide", "text": "เชื่อมั่นในพลังขาของท่าน! 1... 2... ฮึบ!", "focus": "guide"},
			{"name": "Hero", "text": "(กระโดดสุดตัว) ย้ากกก!", "focus": "hero"},
			{"name": "Hero", "text": "(หอบ) เกือบไปแล้ว... ถ้าลังเลเมื่อกี้ คงตกลงไปแน่", "focus": "hero"}
		],
		"next_chunk": 4
	},

	# --- Scene 5: The Ambush of Inertia (Pre-Battle) ---
	4: {
		"type": "dialogue",
		"background": "res://Assets/Swamp of Procrastination.png",
		"dialogue": [
			{"name": "Lazy Slime", "text": "ข้าม... มา... ทำไม... กลับ... ไป... นอน... ดีกว่า...", "focus": "monster"},
			{"name": "Atrophy Spirit", "text": "วิ่ง... มาก... ระวัง... เข่า... เสื่อม... นะ...", "focus": "monster2"},
			{"name": "Hero", "text": "ขู่กันจังนะ! ปีศาจพวกนี้มันกัดไม่ปล่อยจริงๆ", "focus": "hero"},
			{"name": "Guide", "text": "จัดการมัน! จำไว้ว่าพวกมันแพ้ 'ความต่อเนื่อง' (Consistency)! อย่าหยุดโจมตี!", "focus": "guide"},
			{"name": "Hero", "text": "(ชักดาบ) เข้ามา! ฉันจะวอร์มอัพด้วยพวกแกนี่แหละ!", "focus": "hero"}
		],
		"next_chunk": 5, # Next is Battle
		"enemy_id": "lazy_slime" # Or group? We'll stick to 1v1 mechanics for now, maybe "lazy_slime_group" later
	},
	
	# --- Chunk 5 Trigger: Battle Start ---
	5: {
		"type": "battle",
		"enemy_id": "lazy_slime", # Fighting the slime first
		"next_chunk": 6
	},

	# --- Scene 6: The Hall of Stagnation ---
	6: {
		"type": "dialogue",
		"background": "res://Assets/The Hall of Stagnation.png",
		"dialogue": [
			{"name": "Couch Golem", "text": "ช่างน่ารำคาญ... เสียงหัวใจเต้นของเจ้า... มันรบกวนการนอนของข้า...", "focus": "boss"},
			{"name": "Hero", "text": "เลิกนอนแล้วตื่นมาคุยกันดีๆ เซ่! นายทำป่าทั้งป่าป่วยหมดแล้ว!", "focus": "hero"},
			{"name": "Couch Golem", "text": "ป่วย? เปล่าเลย... ข้ากำลังรักษา 'พลังงาน' ให้ป่าต่างหาก... การอยู่นิ่งคือการอนุรักษ์พลังงานที่ยั่งยืนที่สุด", "focus": "boss"},
			{"name": "Hero", "text": "ตรรกะวิบัติชัดๆ! ร่างกายมีไว้ใช้ ถ้าไม่ใช้มันก็พัง!", "focus": "hero"}
		],
		"next_chunk": 7
	},

	# --- Scene 7: The Gentle Trap ---
	7: {
		"type": "dialogue",
		"background": "res://Assets/The Hall of Stagnation.png",
		"dialogue": [
			{"name": "Couch Golem", "text": "เจ้าดูเหนื่อยนะ... เดินทางมาไกล... สู้มาหนัก... ดูสิ ข้าเตรียมรางวัลไว้ให้เจ้าแล้ว", "focus": "boss"},
			{"name": "System", "text": "(เบาะโซฟานุ่มๆ ลอยลงมาตรงหน้า Hero พร้อมโต๊ะที่มีน้ำหวานและขนมขบเคี้ยว)", "focus": "none"},
			{"name": "Couch Golem", "text": "แค่นั่งลง... หลับตา... แล้วความเหนื่อยล้าจะหายไป...", "focus": "boss"},
			{"name": "Hero", "text": "โห... น่ากิน... เอ้ย! น่าเอนหลังชะมัด...", "focus": "hero"},
			{"name": "Guide", "text": "อย่าหลงกลมัน! นั่นคือ 'Comfort Zone' (โซนปลอดภัยจอมปลอม)! ถ้านั่งลง ท่านจะลุกไม่ได้อีกตลอดกาล!", "focus": "guide"}
		],
		"next_chunk": 8
	},

	# --- Scene 8: The Mental Battle & Scene 9: Fire (Pre-Boss) ---
	8: {
		"type": "dialogue",
		"background": "res://Assets/The Hall of Stagnation.png",
		"dialogue": [
			{"name": "Hero", "text": "(ส่ายหน้าเรียกสติ) ไม่! ความสบายแบบนี้ฉันหาเมื่อไหร่ก็ได้... แต่สุขภาพดี ถ้าเสียไปแล้วมันหาคืนยาก!", "focus": "hero"},
			{"name": "Couch Golem", "text": "เจ้าคนดื้อด้าน!! งั้นจงจมดิ่งลงสู่ห้วงนิทราเดี๋ยวนี้! Comfort Ray!!", "focus": "boss"},
			{"name": "Hero", "text": "อึก... หนัก... หนังตา... หนักมาก...", "focus": "hero"},
			{"name": "Hero", "text": "ไม่เอาแล้ว... พรุ่งนี้ค่อยกู้โลก... วันนี้ขอนอน...", "focus": "hero"},
			{"name": "Guide", "text": "นึกถึงเป้าหมาย! นึกถึงคนข้างหลัง! นึกถึงตัวเองในเวอร์ชันที่ดีกว่านี้!!", "focus": "guide"},
			{"name": "Hero", "text": "(กัดปากจนเลือดซิบ) เจ็บ... แต่ตื่นเลย! ออกไปจากหัวฉันนะโว้ยยย!", "focus": "hero"},
			{"name": "Hero", "text": "แกบอกว่าการขยับคือการเสียพลังงานใช่มั้ย... งั้นฉันจะเผาผลาญพลังงานให้แกดูจนตาบอดไปเลย!", "focus": "hero"},
			{"name": "Hero", "text": "เข้ามา!!", "focus": "hero"}
		],
		"next_chunk": 9,
		"enemy_id": "couch_golem"
	},

	# --- Chunk 9 Trigger: Boss Battle ---
	9: {
		"type": "battle",
		"enemy_id": "couch_golem",
		"next_chunk": 10
	},

	# --- Scene 10: The Pulse of Life (Conclusion) ---
	10: {
		"type": "dialogue",
		"background": "res://Assets/The Restored Forest.png",
		"dialogue": [
			{"name": "Couch Golem", "text": "ร้อน... ร้อนเหลือเกิน... พลังงาน... โอเวอร์โหลด... อ้ากกก!", "focus": "none"},
			{"name": "System", "text": "(โกเลมระเบิดออก กลายเป็นนุ่นปลิวว่อนไปทั่วท้องฟ้า)", "focus": "none"},
			{"name": "Hero", "text": "(หอบ) แฮ่ก... แฮ่ก... จบ... แล้ว...", "focus": "hero"},
			{"name": "Guide", "text": "ฟังสิ...", "focus": "guide"},
			{"name": "Hero", "text": "เสียง... หัวใจเต้น?", "focus": "hero"},
			{"name": "Guide", "text": "ไม่ใช่แค่ของท่าน... แต่เป็นเสียงหัวใจของป่า... ท่านทำได้ ท่านปลุกป่านี้ให้ตื่นแล้ว", "focus": "guide"},
			{"name": "System", "text": "[ได้รับ: Vitality Gem (อัญมณีพลังชีวิต)]", "focus": "none"},
			{"name": "Hero", "text": "(ยิ้มกว้าง) เหนื่อยแทบตาย... แต่โคตรสะใจเลย!", "focus": "hero"},
			{"name": "Guide", "text": "ไปกันเถอะ... นี่แค่ด่านแรก ทางเดินแห่งพลังยังอีกยาวไกล...", "focus": "guide"}
		],
		"next_chunk": 11 # End of Chapter
	},
	
	11: {
		"type": "end_chapter",
		"next_scene": "res://Scenes/Crossroads.tscn"
	}
}

var path_wisdom = {
	# --- 0 to 4: Intro & Stress ---
	0: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "Hero", "text": "หมอกหนาจัง... มองไม่เห็นทางเลย", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "ยินดีต้อนรับสู่ 'เขาวงกตแห่งความสับสน' (Maze of Confusion) ท่านผู้กล้า", "focus": "guide"}
		],
		"next_chunk": 1
	},
	1: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "Shadow", "text": "เจ้าทำไม่ได้หรอก... ทุกอย่างมันยากเกินไป...", "focus": "monster"},
			{"name": "วิญญาณแห่งปัญญา", "text": "มันคือ 'เงาความเครียด' (Stress Shadow) อย่าให้มันมามีอำนาจเหนือใจท่าน!", "focus": "guide"}
		],
		"next_chunk": 2
	},
	2: { "type": "battle", "enemy_id": "stress", "next_chunk": 3 },
	3: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "Hero", "text": "ชนะแล้ว! แต่หมอกยังไม่หายไปเลยนะ", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "ความเครียดเป็นแค่จุดเริ่ม... ทางข้างหน้ายังต้องการการตัดสินใจที่เฉลียวฉลาด", "focus": "guide"}
		],
		"next_chunk": 4
	},
	4: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "System", "text": "(ท่านพบกระจกบานใหญ่ตั้งอยู่กลางป่า มันสะท้อนภาพตัวท่านเอง)", "focus": "none"},
			{"name": "Hero", "text": "นี่คือ... ฉันในอนาคตเหรอ? ทำไมดูเหนื่อยล้าจัง", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "กระจกลวงตา (Mirror of Falsehood) มันสะท้อนความกลัวในใจท่าน!", "focus": "guide"}
		],
		"next_chunk": 5
	},

	# --- 5 to 9: Social & Decisions ---
	5: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "เสียงกระซิบ", "text": "มาอยู่กับพวกเราสิ... ไม่ต้องทำอะไร... แค่ทำตามที่คนอื่นบอกก็พอ...", "focus": "none"},
			{"name": "Hero", "text": "เสียงของใครน่ะ? ดูเหมือนจะมีคนล้อมฉันอยู่", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "นี่คือ 'ผีแห่งแรงกดดัน' (Peer Pressure Ghost) มันจะพยายามให้ท่านลืมตัวตน!", "focus": "guide"}
		],
		"next_chunk": 6
	},
	6: { "type": "battle", "enemy_id": "germ", "next_chunk": 7 },
	7: {
		"type": "dialogue",
		"background": "res://Assets/The Restored Forest.png",
		"dialogue": [
			{"name": "Hero", "text": "ขอบคุณท่านวิญญาณ ถ้าไม่ได้ท่านเตือน ฉันคงหลงเชื่อพวกมันไปแล้ว", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "การมีจุดยืนคือพลังของปัญญา... จงจำไว้ว่านั่นคือเกราะคุ้มกันชั้นดี", "focus": "guide"}
		],
		"next_chunk": 8
	},
	8: {
		"type": "dialogue",
		"background": "res://Assets/The Restored Forest.png",
		"dialogue": [
			{"name": "Hero", "text": "ทางหน้ามีแยกอีกแล้ว! คราวนี้จะไปไหนดี?", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "ซ้ายคือความง่ายที่ไร้คุณค่า ขวาคือความท้าทายที่นำไปสู่ความเจือจางของหมอก", "focus": "guide"},
			{"name": "Hero", "text": "แน่นอน! ฉันเลือกทางที่ท้าทายอยู่แล้ว!", "focus": "hero"}
		],
		"next_chunk": 9
	},
	9: {
		"type": "dialogue",
		"background": "res://Assets/The Restored Forest.png",
		"dialogue": [
			{"name": "วิญญาณแห่งปัญญา", "text": "ท่านผู้กล้า... ข้าขอถาม... หากท่านพบเพื่อนที่กำลังหลงทาง ท่านจะช่วยเขาอย่างไร?", "focus": "guide"},
			{"name": "Hero", "text": "ฉันจะยืนข้างๆ และแบ่งปันสติที่ฉันได้รับมาจากท่าน!", "focus": "hero"}
		],
		"next_chunk": 10
	},

	# --- 10 to 14: Clarity & Noise ---
	10: {
		"type": "dialogue",
		"background": "res://Assets/Hall of Clarity.png",
		"dialogue": [
			{"name": "Hero", "text": "หมอกเริ่มจางลงแล้ว! นั่นมัน... วิหารอะไรน่ะ?", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "วิหารแห่งความกระจ่าง (Hall of Clarity) แต่ระวัง... ยิ่งใกล้ความจริง สิ่งลวงตายิ่งรุนแรง", "focus": "guide"}
		],
		"next_chunk": 11
	},
	11: {
		"type": "dialogue",
		"background": "res://Assets/Hall of Clarity.png",
		"dialogue": [
			{"name": "Hero", "text": "กึก! พื้นสั่น... มีอะไรโผล่ออกมาอีกแล้ว!", "focus": "hero"},
			{"name": "System", "text": "(ไวรัสแห่งความเขลาโผล่ออกมาขวางทาง)", "focus": "none"}
		],
		"next_chunk": 12
	},
	12: { "type": "battle", "enemy_id": "virus", "next_chunk": 13 },
	13: {
		"type": "dialogue",
		"background": "res://Assets/Library of Memories.png",
		"dialogue": [
			{"name": "Hero", "text": "ฟู้ว... เกือบไป แต่อย่างน้อยทางก็เปิดแล้ว", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "ห้องสมุดแห่งความจำอยู่ข้างหน้า... จงเข้าไปค้นหาความจริง!", "focus": "guide"}
		],
		"next_chunk": 14
	},
	14: {
		"type": "dialogue",
		"background": "res://Assets/Library of Memories.png",
		"dialogue": [
			{"name": "Banshee", "text": "กรี๊ดดดด! หยุดฟังเดี๋ยวนี้นะ! ทุกอย่างที่เจ้าเชื่อมันคือเรื่องโกหก!", "focus": "monster"},
			{"name": "Hero", "text": "หูฉัน! เสียงนั่นมันเสียดแทรกเข้าไปถึงสมองเลย!", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "มันคือปีศาจเสียงรบกวน! ปิดหูแล้วใช้ใจฟังความจริง!", "focus": "guide"}
		],
		"next_chunk": 15
	},

	# --- 15 to 19: Boss & Conclusion ---
	15: { "type": "battle", "enemy_id": "noise_banshee", "next_chunk": 16 },
	16: {
		"type": "dialogue",
		"background": "res://Assets/Hall of Clarity.png",
		"dialogue": [
			{"name": "Hero", "text": "เงียบลงแล้ว... แต่ทำไมบรรยากาศมันหนักอึ้งขนาดนี้", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "เจ้าของวิหารแห่งนี้... กำลังรอเจ้าอยู่", "focus": "guide"}
		],
		"next_chunk": 17
	},
	17: {
		"type": "dialogue",
		"background": "res://Assets/Hall of Clarity.png",
		"dialogue": [
			{"name": "Golem", "text": "เจ้าคิดมากเกินไป... กังวลเกินไป... มานี่สิ... ข้าจะช่วยให้เจ้าหยุดคิดตลอดกาล...", "focus": "boss"},
			{"name": "Hero", "text": "ยักษ์จอมฟุ้งซ่าน! ฉันจะไม่ให้แกหยุดความฝันของฉันหรอก!", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "นี่คือบททดสอบสุดท้าย... จงรวบรวมสมาธิทั้งหมดที่มี!", "focus": "guide"}
		],
		"next_chunk": 18
	},
	18: { "type": "battle", "enemy_id": "overthinking_golem", "next_chunk": 19 },
	19: {
		"type": "dialogue",
		"background": "res://Assets/The Restored Forest.png",
		"dialogue": [
			{"name": "Hero", "text": "สำเร็จ... ฉัน... ฉันเอาชนะมันได้แล้ว!", "focus": "hero"},
			{"name": "วิญญาณแห่งปัญญา", "text": "ท่านคือผู้ครอบครองปัญญาที่แท้จริง... จงจำความรู้สึกนี้ไว้สวมใส่เป็นเกราะในโลกความจริง", "focus": "guide"},
			{"name": "System", "text": "[ได้รับ: Wisdom Emblem (เหรียญตราแห่งปัญญา)]", "focus": "none"}
		],
		"next_chunk": 20
	},
	20: {
		"type": "end_chapter",
		"next_scene": "res://Scenes/Crossroads.tscn"
	}
}

# ==================== PATH OF HYGIENE ====================
var path_hygiene = {
	# --- Scene 0: Filthy Lane Entrance ---
	0: {
		"type": "dialogue",
		"background": "res://Assets/Filthy Lane.png",
		"dialogue": [
			{"name": "Hero", "text": "อุ๊ย! กลิ่นนี่มันเหม็นชะมัด! กลิ่นอะไรนี่?", "focus": "hero"},
			{"name": "Guide", "text": "ยินดีต้อนรับสู่ 'ซอยแห่งความสกปรก' (Filthy Lane) ท่านผู้กล้า", "focus": "guide"},
			{"name": "Hero", "text": "ทำไมมีขยะกองทับถมขนาดนี้! กองนี่สูงเท่าตึกสองชั้นเลย!", "focus": "hero"},
			{"name": "Guide", "text": "นี่คือพลังแห่งความเพิกเฉย ผู้คนทิ้งขยะวันละนิด สองนิด สุดท้ายมันก็กลายเป็นภูเขา", "focus": "guide"},
			{"name": "Hero", "text": "แล้วทำไมไม่มีใครทำความสะอาดล่ะ?", "focus": "hero"},
			{"name": "Guide", "text": "เพราะทุกคนคิดว่า 'ไม่ใช่ฉัน คนอื่นจะทำ' และสุดท้าย... ก็ไม่มีใครทำเลย", "focus": "guide"}
		],
		"next_chunk": 1
	},
	
	# --- Scene 1: Trash Demon Encounter ---
	1: {
		"type": "dialogue",
		"background": "res://Assets/Filthy Lane.png",
		"dialogue": [
			{"name": "Trash Demon", "text": "ฮิฮิฮิ... มนุษย์อีกแล้ว... มาทิ้งขยะเพิ่มให้ข้าเหรอ?", "focus": "monster"},
			{"name": "Hero", "text": "อะไรนะ! ฉันไม่ได้มาทิ้งขยะ!", "focus": "hero"},
			{"name": "Trash Demon", "text": "ไม่ต้องหลอกกันหรอก... ข้ารู้นิสัยมนุษย์ดี ขี้เกียจเดินไปทิ้งถังขยะ เลยทิ้งแถวนี้ซะเลย", "focus": "monster"},
			{"name": "Guide", "text": "ปีศาจขยะนี่เกิดจากความไม่รับผิดชอบของผู้คน ถ้าทุกคนคัดแยกขยะและทิ้งถูกที่ มันก็จะไม่มีอยู่", "focus": "guide"},
			{"name": "Hero", "text": "งั้นฉันจะเริ่มจากการกำจัดแกก่อนแล้วกัน!", "focus": "hero"}
		],
		"next_chunk": 2
	},
	
	# --- Scene 2: Stagnant Water ---
	2: {
		"type": "dialogue",
		"background": "res://Assets/Stagnant Water .png",
		"dialogue": [
			{"name": "Hero", "text": "บึงน้ำนี้... ทำไมมันสีเขียวๆ แล้วก็มีกลิ่นเหม็นด้วย", "focus": "hero"},
			{"name": "Guide", "text": "นี่คือน้ำเน่า น้ำที่ขังนิ่งไม่ไหล เป็นแหล่งเพาะพันธุ์ยุงลายพาหะโรค", "focus": "guide"},
			{"name": "Hero", "text": "เห็นตัวอ่อนลอยอยู่เต็มไปหมด!", "focus": "hero"},
			{"name": "Guide", "text": "ถูกแล้ว ถ้าปล่อยทิ้งไว้ 7 วัน ลูกน้ำพวกนี้จะกลายเป็นยุงร้อยตัว แพร่โรคไข้เลือดออกได้", "focus": "guide"},
			{"name": "Hero", "text": "แล้วทำยังไงดีล่ะ?", "focus": "hero"},
			{"name": "Guide", "text": "ต้องระบายน้ำ หรือหาวิธีทำให้น้ำไหลเวียน... แต่ระวังนะ มีสิ่งมีชีวิตอันตรายในนั้น!", "focus": "guide"}
		],
		"next_chunk": 3,
		"enemy_id": "smoke"
	},
	
	# --- Scene 3: Battle vs Smog Cloud ---
	3: {
		"type": "battle",
		"enemy_id": "smoke",
		"next_chunk": 4
	},
	
	# --- Scene 4: Abandoned Toilet ---
	4: {
		"type": "dialogue",
		"background": "res://Assets/Abandoned Toilet.png",
		"dialogue": [
			{"name": "Hero", "text": "ห้องน้ำที่นี่มันรกร้างชะมัด... กลิ่นโคตรเหม็น", "focus": "hero"},
			{"name": "Guide", "text": "นี่คือห้องน้ำสาธารณะที่ไม่มีใครดูแล ไม่มีน้ำล้าง ไม่มีสบู่ล้างมือ", "focus": "guide"},
			{"name": "Hero", "text": "แค่เปิดประตูเข้ามาก็รู้สึกป่วยแล้ว", "focus": "hero"},
			{"name": "Guide", "text": "ห้องน้ำสกปรกเป็นแหล่งสะสมเชื้อโรค ถ้าไม่ทำความสะอาดสม่ำเสมอ มันจะกลายเป็นบ่อเพาะโรค", "focus": "guide"},
			{"name": "Hero", "text": "เราต้องทำความสะอาดที่นี่ให้ได้!", "focus": "hero"}
		],
		"next_chunk": 5
	},
	
	# --- Scene 5: Meet Hygiene Spirit ---
	5: {
		"type": "dialogue",
		"background": "res://Assets/Filthy Lane.png",
		"dialogue": [
			{"name": "วิญญาณนักสุขาภิบาล", "text": "ข้าเฝ้ารอผู้กล้าคนนี้มานานแล้ว", "focus": "guide"},
			{"name": "Hero", "text": "ท่านคือใคร?", "focus": "hero"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "ข้าคือวิญญาณนักสุขาภิบาล เคยดูแลเมืองนี้ให้สะอาดปราศจากโรค", "focus": "guide"},
			{"name": "Hero", "text": "แล้วทำไมเมืองนี้ถึงกลายเป็นแบบนี้?", "focus": "hero"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "เพราะผู้คนเลิกใส่ใจ พวกเขาคิดว่าน้อยนิดของตนไม่สำคัญ... แต่เมื่อทุกคนคิดแบบนั้น ภัยพิบัติก็เกิดขึ้น", "focus": "guide"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "ท่านพร้อมที่จะเรียนรู้ 7 ขั้นตอนล้างมือหรือยัง?", "focus": "guide"},
			{"name": "Hero", "text": "พร้อมครับ!", "focus": "hero"}
		],
		"next_chunk": 6
	},
	
	# --- Scene 6: Battle vs Trash Heap ---
	6: {
		"type": "battle",
		"enemy_id": "trash_heap",
		"next_chunk": 7
	},
	
	# --- Scene 7: Handwashing Lesson ---
	7: {
		"type": "dialogue",
		"background": "res://Assets/Filthy Lane.png",
		"dialogue": [
			{"name": "วิญญาณนักสุขาภิบาล", "text": "การล้างมือที่ถูกวิธีมี 7 ขั้นตอน จำไว้ให้ดีนะ", "focus": "guide"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "1.เปียกมือ 2.ใส่สบู่ 3.ถูฝ่ามือ 4.ถูหลังมือ 5.ถูซอกนิ้ว 6.ถูปลายนิ้ว 7.ล้างออก", "focus": "guide"},
			{"name": "Hero", "text": "ต้องทำทุกครั้งหลังออกจากห้องน้ำ ก่อนกินข้าว และหลังสัมผัสของสกปรกใช่ไหม?", "focus": "hero"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "ถูกต้อง! การล้างมืออย่างถูกวิธีป้องกันโรคได้ถึง 80%", "focus": "guide"},
			{"name": "Hero", "text": "เข้าใจแล้วครับ!", "focus": "hero"}
		],
		"next_chunk": 8
	},
	
	# --- Scene 8: Epidemic Street ---
	8: {
		"type": "dialogue",
		"background": "res://Assets/Epidemic Street.png",
		"dialogue": [
			{"name": "Hero", "text": "ทำไมถนนนี้มันเงียบสงัดขนาดนี้?", "focus": "hero"},
			{"name": "Guide", "text": "นี่คือ 'ถนนโรคระบาด' (Epidemic Street) คนที่เคยอาศัยที่นี่ล้มป่วยกันหมด", "focus": "guide"},
			{"name": "Hero", "text": "ทำไมถึงเกิดอะไรขึ้น?", "focus": "hero"},
			{"name": "Guide", "text": "เพราะพวกเขาไม่สวมหน้ากาก ไม่ล้างมือ ไม่เว้นระยะห่าง... เชื้อโรคจึงแพร่กระจายอย่างรวดเร็ว", "focus": "guide"},
			{"name": "Hero", "text": "ฉันรู้สึกว่ามีอะไรลอยอยู่ในอากาศ...", "focus": "hero"}
		],
		"next_chunk": 9
	},
	
	# --- Scene 9: Virus Encounter ---
	9: {
		"type": "dialogue",
		"background": "res://Assets/Epidemic Street.png",
		"dialogue": [
			{"name": "Virus Monster", "text": "ฮื้อออ! เจ้าของร่างกายใหม่มาแล้ว!", "focus": "monster"},
			{"name": "Hero", "text": "ไวรัส!", "focus": "hero"},
			{"name": "Virus Monster", "text": "ข้าจะเข้าไปในร่างกายเจ้า แล้วจะขยายพันธุ์ออกไปอีกหลายล้านตัว!", "focus": "monster"},
			{"name": "Guide", "text": "ระวังนะ! ไวรัสแพร่กระจายผ่านละอองฝอย คราบน้ำลาย และการสัมผัส", "focus": "guide"},
			{"name": "Hero", "text": "แล้วฉันจะป้องกันยังไง?", "focus": "hero"},
			{"name": "Guide", "text": "ระบบภูมิคุ้มกันของเจ้าคือเกราะป้องกันที่ดีที่สุด! กินอาหารครบ 5 หมู่ พักผ่อนให้เพียงพอ!", "focus": "guide"}
		],
		"next_chunk": 10,
		"enemy_id": "virus"
	},
	
	# --- Scene 10: Battle vs Virus ---
	10: {
		"type": "battle",
		"enemy_id": "virus",
		"next_chunk": 11
	},
	
	# --- Scene 11: Abandoned Clinic ---
	11: {
		"type": "dialogue",
		"background": "res://Assets/Abandoned Clinic.png",
		"dialogue": [
			{"name": "Hero", "text": "คลินิกที่นี่ดูร้างไปหมด แต่มีอุปกรณ์ทางการแพทย์เหลืออยู่", "focus": "hero"},
			{"name": "Guide", "text": "นี่คือคลินิกที่เคยให้บริการวัคซีนแก่ชาวบ้าน", "focus": "guide"},
			{"name": "Hero", "text": "วัคซีนคืออะไร?", "focus": "hero"},
			{"name": "Guide", "text": "วัคซีนคือเชื้อโรคที่ถูกทำให้อ่อนแรง เมื่อฉีดเข้าร่างกาย ภูมิต้านทานจะได้เรียนรู้วิธีต่อสู้กับมัน", "focus": "guide"},
			{"name": "Hero", "text": "เหมือนการซ้อมรบก่อนสงครามจริงเลย!", "focus": "hero"},
			{"name": "Guide", "text": "ถูกต้อง! วัคซีนป้องกันโรคร้ายแรงหลายชนิด เช่น หัด คอตีบ ไข้ทรพิษ", "focus": "guide"}
		],
		"next_chunk": 12
	},
	
	# --- Scene 12: Sanitation Spirit Wisdom ---
	12: {
		"type": "dialogue",
		"background": "res://Assets/Abandoned Clinic.png",
		"dialogue": [
			{"name": "วิญญาณนักสุขาภิบาล", "text": "ท่านได้เรียนรู้มามากแล้ว ตอนนี้ข้าจะสอนเรื่องอาหารปลอดภัย", "focus": "guide"},
			{"name": "Hero", "text": "อาหารปลอดภัยคืออะไร?", "focus": "hero"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "คือการดับอาหารที่สะอาด ปรุงสุก เก็บในอุณหภูมิที่เหมาะสม", "focus": "guide"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "อาหารที่ทิ้งไว้นานเกิน 2 ชั่วโมงในอุณหภูมิปกติจะมีเชื้อโรคเพิ่มขึ้น", "focus": "guide"},
			{"name": "Hero", "text": "แล้วถ้ากินเข้าไปล่ะ?", "focus": "hero"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "จะท้องเสีย อาเจียน หรือเป็นพิษอาหาร รุนแรงถึงตายได้", "focus": "guide"}
		],
		"next_chunk": 13,
		"enemy_id": "germ"
	},
	
	# --- Scene 13: Battle vs Germ ---
	13: {
		"type": "battle",
		"enemy_id": "germ",
		"next_chunk": 14
	},
	
	# --- Scene 14: Food Safety Lesson ---
	14: {
		"type": "dialogue",
		"background": "res://Assets/Abandoned Clinic.png",
		"dialogue": [
			{"name": "วิญญาณนักสุขาภิบาล", "text": "จำไว้นะ หลักการปลอดภัยอาหาร: สะอาด สด ปรุงสุก เก็บถูกวิธี", "focus": "guide"},
			{"name": "Hero", "text": "แล้วเรื่องน้ำดื่มล่ะ?", "focus": "hero"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "น้ำดื่มต้องต้มให้เดือดอย่างน้อย 1 นาที หรือดื่มน้ำบรรจุขวดที่ผ่านมาตรฐาน", "focus": "guide"},
			{"name": "Hero", "text": "ฉันจะจำไว้!", "focus": "hero"}
		],
		"next_chunk": 15
	},
	
	# --- Scene 15: Restored Park ---
	15: {
		"type": "dialogue",
		"background": "res://Assets/Restored Park.png",
		"dialogue": [
			{"name": "Hero", "text": "ว้าว! ที่นี่สะอาดสวยงามชะมัด!", "focus": "hero"},
			{"name": "Guide", "text": "นี่คือ 'สวนสาธารณะที่ฟื้นคืนชีพ' คนที่นี่ช่วยกันดูแลรักษา", "focus": "guide"},
			{"name": "Hero", "text": "เห็นเด็กๆ เล่นอย่างมีความสุข ไม่มีขยะกองทับถม", "focus": "hero"},
			{"name": "Guide", "text": "เพราะทุกคนรับผิดชอบร่วมกัน ทิ้งขยะถูกที่ คัดแยกขยะ ปลูกต้นไม้", "focus": "guide"},
			{"name": "Hero", "text": "นี่แหละ! เมืองที่ฉันอยากเห็น!", "focus": "hero"}
		],
		"next_chunk": 16
	},
	
	# --- Scene 16: Teaching Others ---
	16: {
		"type": "dialogue",
		"background": "res://Assets/Restored Park.png",
		"dialogue": [
			{"name": "เด็กน้อย", "text": "พี่ฮีโร่ค่ะ! สอนหนูล้างมือหน่อยได้ไหม?", "focus": "npc"},
			{"name": "Hero", "text": "ได้สิน้อง! ฟังนะ ต้องล้างมือ 7 ขั้นตอน", "focus": "hero"},
			{"name": "Hero", "text": "เปียกมือ ใส่สบู่ ถูฝ่ามือ ถูหลังมือ ถูซอกนิ้ว ถูปลายนิ้ว แล้วล้างออก", "focus": "hero"},
			{"name": "เด็กน้อย", "text": "ค่าา! หนูจะทำทุกวันเลย!", "focus": "npc"},
			{"name": "Guide", "text": "ดีมาก! ความรู้ที่แบ่งปันคือความรู้ที่ทรงพลังที่สุด", "focus": "guide"}
		],
		"next_chunk": 17
	},
	
	# --- Scene 17: Preparation for Final Boss ---
	17: {
		"type": "dialogue",
		"background": "res://Assets/Epidemic Street.png",
		"dialogue": [
			{"name": "Guide", "text": "ท่านผู้กล้า... การเดินทางกำลังจะถึงจุดสูงสุด", "focus": "guide"},
			{"name": "Hero", "text": "ข้างหน้ามีอะไร?", "focus": "hero"},
			{"name": "Guide", "text": "ราชาโรคระบาด (Plague Lord) ต้นกำเนิดของโรคภัยทั้งหมดในเมืองนี้", "focus": "guide"},
			{"name": "Hero", "text": "มันแข็งแกร่งแค่ไหน?", "focus": "hero"},
			{"name": "Guide", "text": "มันคือการรวมตัวของไวรัส เชื้อโรค และความสกปรกทั้งหมด", "focus": "guide"},
			{"name": "Hero", "text": "แต่ฉันมีความรู้ มีภูมิคุ้มกัน และมีจิตใจที่พร้อม!", "focus": "hero"},
			{"name": "Guide", "text": "ถูกแล้ว! ความสะอาดและความรู้คือดาบของเจ้า!", "focus": "guide"}
		],
		"next_chunk": 18,
		"enemy_id": "plague_lord"
	},
	
	# --- Scene 18: Boss Battle vs Plague Lord ---
	18: {
		"type": "battle",
		"enemy_id": "plague_lord",
		"next_chunk": 19
	},
	
	# --- Scene 19: Victory ---
	19: {
		"type": "dialogue",
		"background": "res://Assets/Restored Park.png",
		"dialogue": [
			{"name": "Plague Lord", "text": "ไม่... ไม่นาา! ความสะอาดกำลังทำลายข้า!", "focus": "monster"},
			{"name": "Hero", "text": "นี่คือพลังแห่งความรู้และความรับผิดชอบ!", "focus": "hero"},
			{"name": "Plague Lord", "text": "อ๊ากกกก! (ระเบิดเป็นฟองสบู่นับพัน)", "focus": "monster"},
			{"name": "Guide", "text": "ท่านทำได้! เมืองนี้ได้รับการฟื้นฟูแล้ว!", "focus": "guide"},
			{"name": "วิญญาณนักสุขาภิบาล", "text": "ขอบคุณท่านผู้กล้า จงรับ 'ตราแห่งความสะอาด' (Hygiene Emblem) ไว้เถิด", "focus": "guide"},
			{"name": "Hero", "text": "ฉันจะนำความรู้นี้ไปเผยแพร่ต่อให้ทุกคนรู้!", "focus": "hero"}
		],
		"next_chunk": 20
	},
	
	# --- Scene 20: End Chapter ---
	20: {
		"type": "end_chapter",
		"next_scene": "res://Scenes/Crossroads.tscn"
	}
}

var path_final = {
	# --- Scene 0: The Core Gate ---
	0: {
		"type": "dialogue",
		"background": "res://Assets/The Restored Forest.png", # Placeholder for Core
		"dialogue": [
			{"name": "Guide", "text": "ท่านผู้กล้า... ในที่สุดท่านก็รวบรวมตราประทับครบทั้ง 4", "focus": "guide"},
			{"name": "Guide", "text": "ประตูสู่แก่นโลกเปิดออกแล้ว... ที่นั่นคือต้นกำเนิดของความมืดมิดทั้งหมด", "focus": "guide"},
			{"name": "Hero", "text": "ฉันพร้อมแล้ว! ไม่ว่าอะไรจะอยู่ข้างใน ฉันจะจัดการมัน!", "focus": "hero"}
		],
		"next_chunk": 1
	},
	1: {
		"type": "dialogue",
		"background": "res://Assets/The Hall of Stagnation.png", # Dark ominous bg
		"dialogue": [
			{"name": "Ignorance", "text": "เจ้าคิดว่าการกำจัดลูกน้องข้าจะเปลี่ยนแปลงอะไรได้งั้นรึ?", "focus": "boss"},
			{"name": "Hero", "text": "แกคือใคร?!", "focus": "hero"},
			{"name": "Ignorance", "text": "ข้าคือ 'ความไม่รู้' (Ignorance)... ตราบใดที่มนุษย์ยังเพิกเฉย ไม่ใส่ใจดูแลตัวเอง ข้าก็จะไม่มีวันตาย!", "focus": "boss"},
			{"name": "Hero", "text": "แต่ความรู้เปลี่ยนแปลงทุกอย่างได้! ฉันพิสูจน์มาแล้ว!", "focus": "hero"}
		],
		"next_chunk": 2
	},
	2: { "type": "battle", "enemy_id": "ignorance_incarnate", "next_chunk": 3 },
	3: {
		"type": "dialogue",
		"background": "res://Assets/The Restored Forest.png",
		"dialogue": [
			{"name": "Ignorance", "text": "เป็นไปไม่ได้... แสงแห่งปัญญา... มันแสบตาเหลือเกิน!", "focus": "boss"},
			{"name": "Hero", "text": "หายไปซะ! โลกนี้ไม่ต้องการแกอีกแล้ว!", "focus": "hero"},
			{"name": "System", "text": "(ความมืดมิดสลายไป แสงสว่างสาดส่องไปทั่วทุกมุมโลก)", "focus": "none"},
			{"name": "Guide", "text": "ยินดีด้วยท่านผู้กล้า... ท่านได้กอบกู้โลกนี้ไว้อย่างสมบูรณ์แล้ว", "focus": "guide"},
			{"name": "Hero", "text": "การเรียนรู้... มันคือการผจญภัยที่คุ้มค่าจริงๆ", "focus": "hero"}
		],
		"next_chunk": 4
	},
	4: {
		"type": "end_game", # Special type for Credits
		"next_scene": "res://Scenes/MainMenu.tscn"
	}
}

func get_story_chunk(path_name, chunk_index):
	return null

const path_nutrition = {
	# --- ACT 1: The Sugary Border (0-4) ---
	0: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png", 
		"dialogue": [
			{"name": "Guide", "text": "ยินดีต้อนรับสู่ 'อาณาจักรแห่งรสชาติ' ท่านผู้กล้า! ที่นี่เคยเป็นสวรรค์ของอาหารสุขภาพ", "focus": "guide"},
			{"name": "Hero", "text": "แต่ตอนนี้มันดู... เหนียวเหนอะหนะไปหมดเลยนะ", "focus": "hero"},
			{"name": "Guide", "text": "เพราะกองทัพ 'น้ำตาลซ่อนเร้น' นำโดยสายลับน้ำตาลได้ยึดครองชายแดนไว้!", "focus": "guide"}
		],
		"next_chunk": 1
	},
	1: { "type": "battle", "enemy_id": "sugar_spy", "next_chunk": 2 },
	2: {
		"type": "dialogue",
		"background": "res://Assets/The Sleepy Forest.png",
		"dialogue": [
			{"name": "Guide", "text": "น้ำตาลให้พลังงานก็จริง แต่ถ้ามากไปมันจะกลายเป็นไขมันสะสมนะ", "focus": "guide"},
			{"name": "Hero", "text": "พวกมันชอบซ่อนอยู่ในน้ำอัดลมและขนมหวานสินะ", "focus": "hero"},
			{"name": "System", "text": "(เสียงซ่าๆ ดังมาจากพุ่มไม้ข้างหน้า)", "focus": "none"}
		],
		"next_chunk": 3
	},
	3: { "type": "battle", "enemy_id": "soda_slime", "next_chunk": 4 },
	4: {
		"type": "dialogue",
		"background": "res://Assets/Mirror of Falsehood.png",
		"dialogue": [
			{"name": "Guide", "text": "ระวัง! ทางข้างหน้าคือ 'ทุ่งหญ้าสารกันบูด' สิ่งที่ดูสดใหม่อาจจะเป็นของปลอม", "focus": "guide"},
			{"name": "Hero", "text": "นั่นมัน... วิญญาณที่ลอยอยู่นั่นคืออะไร?", "focus": "hero"}
		],
		"next_chunk": 5
	},

	# --- ACT 2: The Processed Wasteland (5-9) ---
	5: { "type": "battle", "enemy_id": "preservative_ghost", "next_chunk": 6 },
	6: {
		"type": "dialogue",
		"background": "res://Assets/Mirror of Falsehood.png",
		"dialogue": [
			{"name": "Hero", "text": "สารกันบูดพวกนี้ทำให้ร่างกายเราทำงานหนักขึ้นในการขับสารพิษ!", "focus": "hero"},
			{"name": "Guide", "text": "ถูกต้อง! การเลือกทานอาหารสดใหม่คือทางออกที่ดีที่สุด", "focus": "guide"},
			{"name": "System", "text": "(ท่านพบกระป๋องอาหารขนาดยักษ์ขวางทางอยู่)", "focus": "none"}
		],
		"next_chunk": 7
	},
	7: { "type": "battle", "enemy_id": "processed_mimic", "next_chunk": 8 },
	8: {
		"type": "dialogue",
		"background": "res://Assets/The Hall of Stagnation.png",
		"dialogue": [
			{"name": "Hero", "text": "อาหารแปรรูปพวกนี้มีทั้งโซเดียมและสารเจือปนเต็มไปหมด!", "focus": "hero"},
			{"name": "Guide", "text": "เรากำลังเข้าสู่เขตของ 'ลอร์ดโซเดียม'... เตรียมตัวให้พร้อม ความเค็มกำลังจะมา!", "focus": "guide"}
		],
		"next_chunk": 9
	},
	9: { "type": "battle", "enemy_id": "salt_slime", "next_chunk": 10 },

	# --- ACT 3: The Salty Dunes & Fatty Mountains (10-14) ---
	10: {
		"type": "dialogue",
		"background": "res://Assets/The Hall of Stagnation.png",
		"dialogue": [
			{"name": "Hero", "text": "กินเค็มมากไปทำให้ตัวบวมและไตทำงานหนักนะเนี่ย", "focus": "hero"},
			{"name": "Guide", "text": "ใช่แล้ว! คาถาป้องกันคือ 'ลดเค็ม ลดโรค' และดื่มน้ำเปล่าให้เพียงพอ", "focus": "guide"}
		],
		"next_chunk": 11
	},
	11: {
		"type": "dialogue",
		"background": "res://Assets/Candy Castle Gate.png",
		"dialogue": [
			{"name": "System", "text": "(เงาขนาดยักษ์ทอดทับทางเดิน... มันคือไททันแห่งความอ้วน)", "focus": "none"},
			{"name": "Hero", "text": "นั่นมัน... ตัวอะไรน่ะ ใหญ่ยักษ์ชะมัด!", "focus": "hero"},
			{"name": "Guide", "text": "นั่นคือ 'ไททันไขมันทรานส์' มือขวาของจักรพรรดิ!", "focus": "guide"}
		],
		"next_chunk": 12
	},
	12: { "type": "battle", "enemy_id": "trans_fat_titan", "next_chunk": 13 },
	13: {
		"type": "dialogue",
		"background": "res://Assets/Candy Castle Gate.png",
		"dialogue": [
			{"name": "Hero", "text": "เอาชนะมันได้แล้ว! แต่นั่นเป็นแค่จุดเริ่มใช่ไหม?", "focus": "hero"},
			{"name": "Guide", "text": "ใช่! ปราสาท Junk Food อยู่ข้างหน้า... ที่สถิตของราชาและจักรพรรดิ", "focus": "guide"}
		],
		"next_chunk": 14
	},
	14: { "type": "battle", "enemy_id": "fat_phantom", "next_chunk": 15 },

	# --- ACT 4: The Imperial Candy Castle (15-19) ---
	15: {
		"type": "dialogue",
		"background": "res://Assets/Candy Castle Gate.png",
		"dialogue": [
			{"name": "Hero", "text": "ใกล้ถึงแล้ว! ฉันรู้สึกถึงพลังงานความหวานที่รุนแรงมาก", "focus": "hero"},
			{"name": "Guide", "text": "ระวังตัวด้วย! 'ราชา Junk Food' กำลังเฝ้าประตูอยู่!", "focus": "guide"}
		],
		"next_chunk": 16
	},
	16: { "type": "battle", "enemy_id": "junk_food_king", "next_chunk": 17 },
	17: {
		"type": "dialogue",
		"background": "res://Assets/Restored Park.png", # Represents inner castle
		"dialogue": [
			{"name": "Hero", "text": "ชั้นสุดท้ายแล้วสินะ... จักรพรรดิ Junk Food!", "focus": "hero"},
			{"name": "Emperor", "text": "มนุษย์ผู้โง่เขลา... เจ้าคิดว่าถั่วและผักจะสู้ความอร่อยของข้าได้หรือ?", "focus": "boss"},
			{"name": "Hero", "text": "ความอร่อยที่ไม่ยั่งยืนคือยาพิษ! รับมือ!", "focus": "hero"}
		],
		"next_chunk": 18
	},
	18: { "type": "battle", "enemy_id": "junk_food_emperor", "next_chunk": 19 },
	19: {
		"type": "dialogue",
		"background": "res://Assets/Restored Park.png",
		"dialogue": [
			{"name": "Emperor", "text": "อ๊ากกกก! พลังแห่งวิตามิน... มันทำลายข้า!", "focus": "boss"},
			{"name": "Hero", "text": "ความสมดุลคือชัยชนะที่แท้จริง!", "focus": "hero"},
			{"name": "Guide", "text": "ยอดเยี่ยมมากท่านผู้กล้า! ตราแห่งโภชนาการเป็นของท่านแล้ว", "focus": "guide"},
			{"name": "System", "text": "[ได้รับ: Nutrition Emblem (เหรียญตราแห่งโภชนาการ)]", "focus": "none"}
		],
		"next_chunk": 20
	},
	20: {
		"type": "end_chapter",
		"next_scene": "res://Scenes/Crossroads.tscn"
	}
}
