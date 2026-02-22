extends RefCounted
class_name StoryDataPart2

# Part 2: Story Script Database (Terra Nova — 500 Years Later)
# Act 1: "The Awakening" — ตื่นขึ้นใน Verdant Hollow

const CHAPTERS = {
	"chapter_1": {
		"name": "The Awakening (P.1 Body & Senses)",
		"summary": "ในบทนี้ท่านได้เรียนรู้ถึงความสำคัญของประสาทสัมผัสทั้ง 5 และการดูแลสุขอนามัยเบื้องต้น เช่น การล้างมือ การตัดเล็บ และการพักผ่อนสายตา เพื่อรักษาสมดุลของร่างกายให้พร้อมต่อการผจญภัย",
		"part2_intro": {
			"0": {
				"type": "dialogue",
				"background": "res://Assets/Part2/BG_Void_Dimension.png",
				"npc_sprite": "res://Assets/Part2/NPC_Aetherion.png",
				"dialogue": [
					{"name": "Aetherion", "text": "500 ปีแล้วสินะ... ที่ผนึกแห่งอดีตได้ปกป้องโลกใบนี้เอาไว้", "focus": "guide"},
					{"name": "Aetherion", "text": "แต่บัดนี้ เงามืดที่เคยถูกสะกดกำลังตื่นขึ้นอีกครั้ง... ความประมาททำลายสมดุลของ Terra Nova", "focus": "guide"}
				],
				"next_scene": "continue"
			},
			"1": {
				"type": "dialogue",
				"background": "res://Assets/Part2/BG_Void_Dimension.png",
				"npc_sprite": "res://Assets/Part2/NPC_Aetherion.png",
				"dialogue": [
					{"name": "Aetherion", "text": "เจ้าคือผู้เดียวที่มีสายเลือดแห่งผู้กล้า... ถึงเวลาแล้วที่เจ้าจะต้องตื่นขึ้น", "focus": "guide"},
					{"name": "Aetherion", "text": "จงจดจำไว้... ร่างกายที่แข็งแรงและความรู้ที่ถูกต้อง คือดาบและโล่ที่แท้จริงของเจ้า", "focus": "guide"}
				],
				"next_scene": "0" 
			}
		},
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Hero", "text": "อื้อ... แสงแดดจ้าจัง ตาของข้าพร่ามัวไปหมด (Health P.1: ดวงตาและการมองเห็น)", "focus": "hero"},
				{"name": "Aetherion", "text": "ค่อยๆ ลืมตาเถิดผู้สืบทอด... แสงแดดแห่ง Verdant Hollow จะช่วยปรับสมดุลวิสัยทัศน์ของเจ้า", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"1": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Hero", "text": "เสียงนั่น... เสียงลมกระซิบหรือใครเรียกข้ากันนะ? (Health P.1: หูและการได้ยิน)", "focus": "hero"},
				{"name": "Aetherion", "text": "ข้าเอง... เอเธอเรียน จิตวิญญาณแห่งพฤกษา จงใช้หูของเจ้าสดับฟังเสียงแห่งธรรมชาติ", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"2": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Hero", "text": "กลิ่นดอกไม้อบอวลไปหมด... จมูกของข้าเริ่มสัมผัสได้ถึงกลิ่นอายที่คุ้นเคย (Health P.1: จมูกและการดมกลิ่น)", "focus": "hero"},
				{"name": "Aetherion", "text": "ลมหายใจคือจุดเริ่มต้นของพลัง จงสูดอากาศบริสุทธิ์ให้เต็มปอด", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"3": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Hero", "text": "รสสัมผัสของน้ำค้างบนยอดหญ้าช่างหวานล้ำ... ลิ้นของข้าเริ่มรับรสได้ดีขึ้น (Health P.1: ปากและลิ้น)", "focus": "hero"},
				{"name": "Aetherion", "text": "ปากและฟันคือด่านแรกของพลังงาน จงดูแลความสะอาดทุกเช้าและเย็น", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"4": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Hero", "text": "ขยับนิ้วมือได้แล้ว! แต่รู้สึกเหมือนมีเศษดินติดอยู่ใต้เล็บเลย (Health P.1: มือและเล็บ)", "focus": "hero"},
				{"name": "Aetherion", "text": "การรักษาความสะอาดของมือคือปราการด่านแรกของสุขภาพ จงตัดเล็บให้สั้นและหมั่นล้างมือ", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"5": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Hero", "text": "หญ้านุ่มจัง... ผิวหนังของข้ารู้สึกถึงความเย็นสบาย (Health P.1: ผิวหนังและการสัมผัส)", "focus": "hero"},
				{"name": "Aetherion", "text": "ผิวหนังปกป้องเจ้าจากภายนอก จงระวังอย่าให้เกิดบาดแผลที่อาจติดเชื้อได้", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"6": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Hero", "text": "ข้าจะลองยืดตัวขึ้น... เท้าของข้าเริ่มมั่นคงบนผืนดิน (Health P.1: เท้าและการเดิน)", "focus": "hero"},
				{"name": "Aetherion", "text": "การเดินที่ถูกสุขลักษณะคือหัวใจสำคัญ... แต่ก่อนอื่นเลือกสัตว์คู่หูที่จะร่วมเดินทางไปกับเจ้าเสียก่อน", "focus": "guide"}
			],
			"next_scene": "companion_select"
		},
		"7": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "เดินเข้ามาลึกขึ้น... ทำไมที่นี่ถึงดูแห้งเหี่ยวและหม่นหมองจัง?", "focus": "hero"},
				{"name": "Aetherion", "text": "ความละเลยต่อสุขภาพของผู้คนใน Terra Nova ทำให้ป่าแห่งนี้เสื่อมโทรม", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"8": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ข้าได้ยินเสียงแว่วๆ มาจากพุ่มไม้! หูของข้ายังทำงานได้ดีเยี่ยม", "focus": "hero"},
				{"name": "Aetherion", "text": "ระวังตัวไว้... ประสาทสัมผัสทั้ง 5 ของเจ้าคือเครื่องมือชั้นยอดในการระวังภัย", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"9": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "โอ๊ะ! ข้ารู้สึกเสียวฟันแปลกๆ (Health P.1: สุขภาพฟัน)", "focus": "hero"},
				{"name": "Aetherion", "text": "อย่าลืมแปรงฟันให้ถูกวิธี 2 นาที 2 ครั้งต่อวัน เพื่อป้องกันฟันผุ", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"10": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "เส้นผมของข้าดูยุ่งเหยิงและคันหนังศีรษะนิดหน่อย (Health P.1: เส้นผมและการสระผม)", "focus": "hero"},
				{"name": "Aetherion", "text": "การสระผมรักษาความสะอาดศีรษะจะช่วยให้เจ้ารู้สึกสดชื่นและมีสมาธิ", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"11": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "นั่นมันสไลม์! แต่มันสั่นเทาและดูอ่อนแรงมาก", "focus": "hero"},
				{"name": "Aetherion", "text": "มันคือ Unstable Slime ร่างกายมันสะสมแต่ของเสียจนควบคุมพลังไม่ได้", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"12": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ตาของมันแดงก่ำเหมือนไม่ได้รับการพักผ่อน (Health P.1: การพักผ่อนสายตา)", "focus": "hero"},
				{"name": "Aetherion", "text": "ดวงตาที่เหนื่อยล้าต้องการการพักผ่อน เช่นเดียวกับเจ้าที่ต้องนอนหลับให้เพียงพอ", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"13": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ข้าจะรักษาความสะอาดมือและเท้าให้ดี ก่อนจะเข้าไปช่วยมัน (Health P.1: ความสะอาดร่างกาย)", "focus": "hero"},
				{"name": "Aetherion", "text": "ถูกต้องแล้ว... สุขนิสัยที่ดีคือรากฐานของความแข็งแกร่ง", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"14": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "กลิ่นของความเสื่อมมลายรุนแรงขึ้น! ข้าต้องกลั้นหายใจเป็นระยะ", "focus": "hero"},
				{"name": "Aetherion", "text": "ใช้ผ้าสะอาดปิดจมูกหากอากาศไม่บริสุทธิ์ ข้าจะช่วยแผ่พลังปกป้องปอดของเจ้า", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"15": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ร่างกายของข้าพร้อมแล้ว... กล้ามเนื้อทุกส่วนตื่นตัวเต็มที่!", "focus": "hero"},
				{"name": "Aetherion", "text": "การออกกำลังกายสม่ำเสมอทำให้ร่างกายของเจ้าพร้อมรับทุกสถานการณ์", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"16": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ข้าจะใช้ประสาทสัมผัสทั้งหมด เพื่อชำระล้างความทรมานของเจ้าสไลม์", "focus": "hero"},
				{"name": "Aetherion", "text": "จดจำ 'สุขบัญญัติ 10 ประการ' ไว้ให้ดี มันคืออาวุธที่แท้จริง", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"17": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ยืดหลังให้ตรง! ก้าวเท้าให้มั่น! ข้ามาเพื่อช่วยเจ้าแล้ว", "focus": "hero"},
				{"name": "Aetherion", "text": "ดีมาก! เข้าสู่การต่อสู้ครั้งแรกของเจ้าได้เลย!", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"18": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "เพื่อความสมดุลและความแข็งแรงของ Terra Nova!", "focus": "hero"},
				{"name": "Aetherion", "text": "โจมตีเลยผู้สืบทอด!", "focus": "guide"}
			],
			"next_scene": "battle",
			"enemy_id": "unstable_slime"
		},
		"19": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "มันกลับมาสดใสแล้ว... ประสาทสัมผัสของข้าบอกความจริงแก่ข้า", "focus": "hero"},
				{"name": "Aetherion", "text": "เก่งมาก... เจ้าได้เรียนรู้พื้นฐานของร่างกายอย่างครบถ้วนแล้ว", "focus": "guide"},
				{"name": "Aetherion", "text": "แต่บททดสอบต่อไปจะยากขึ้น... จงเตรียมตัวสำหรับเส้นทางแห่งสุขอนามัย!", "focus": "guide"}
			],
			"next_scene": "continue"
		}
	},
	"chapter_2": {
		"name": "พิธีกรรมแห่งความบริสุทธิ์ (Hygiene)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "การเดินทางช่วงแรกช่างหนักหนานัก... แต่ข้ากลับรู้สึกกระปรี้กระเปร่าอย่างประหลาด", "focus": "hero"},
				{"name": "Aetherion", "text": "นั่นเป็นเพราะเจ้าเริ่มเข้าใจธาตุพื้นฐานของร่างกายตนเองแล้ว แต่จงระวัง...", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"1": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "ความแข็งแรงเพียงอย่างเดียวไม่พอ หากเจ้าละเลยความสะอาด ภัยเงียบจะกัดกินเจ้าจากภายใน", "focus": "guide"},
				{"name": "Hero", "text": "ภัยเงียบงั้นหรือ? ท่านหมายถึงอะไร?", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"2": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Companion", "text": "นายท่าน! ท่านดูนั่นสิ! กลิ่นเหม็นนั่นมาจากเมือกด่างๆ บนพื้น", "focus": "companion"},
				{"name": "Hero", "text": "อุ้ย! กลิ่นมันชวนเวียนหัวจริงๆ... มันคือเมือกอะไรกัน?", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"3": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "นั่นคือ 'เมือกแห่งความเสื่อมโทรม' มันคือแหล่งสะสมของเชื้อโรคที่ถูกทิ้งไว้ 500 ปี", "focus": "guide"},
				{"name": "Aetherion", "text": "จงจดจำไว้... ร่างกายที่สกปรกคือบ้านที่เชื้อโรคชอบอาศัย (Health P.1: สุขบัญญัติ)", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"4": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ข้าเริ่มรู้สึกคันตามตัวแล้วสิ... หรือว่าเมือกพวกนี้กำลังส่งผลกับข้า?", "focus": "hero"},
				{"name": "Aetherion", "text": "ผิวหนังของเจ้าคือเกราะชั้นแรก แต่ถ้ามันสกปรก เกราะนั้นจะผุพังลง", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"5": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "การอาบน้ำชำระล้างร่างกายทุกวัน ไม่ใช่แค่เรื่องความสดชื่น แต่มันคือการเสริมเกราะป้องกัน!", "focus": "guide"},
				{"name": "Hero", "text": "ข้าเข้าใจแล้ว! ข้าต้องรักษาความสะอาดเพื่อรักษาพลังของข้าไว้", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"6": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Companion", "text": "โฮ่ง! ดูที่มือของท่านสิครับนายท่าน! ไปโดนเมือกพวกนั้นตอนไหน?", "focus": "companion"},
				{"name": "Hero", "text": "จริงด้วย! มือข้าเปื้อนไปหมดเลย... ข้าน่าจะเผลอไปสัมผัสตอนสำรวจ", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"7": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "มือคือพาหะชั้นดี! ต้องล้างมือให้สะอาดก่อนกินอาหารและหลังจากสัมผัสสิ่งสกปรก", "focus": "guide"},
				{"name": "Hero", "text": "ข้าจะรีบหาน้ำสะอาดล้างมือเดี๋ยวนี้เลย! (Health P.2: การล้างมือ 7 ขั้นตอน)", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"8": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "เจอแล้ว! แหล่งน้ำข้างหน้า... เอ๊ะ แต่น้ำมันดูขุ่นๆ แปลกๆ นะ?", "focus": "hero"},
				{"name": "Aetherion", "text": "หยุดก่อน! น้ำนั่นปนเปื้อนด้วยมลพิษ หากใช้ล้างตัวเจ้าจะยิ่งแย่ลง", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"9": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Companion", "text": "มีตัวอะไรบางอย่างแอบอยู่ในพุ่มไม้ใกล้น้ำนั่น! ตาของมันแดงก่ำเลย!", "focus": "companion"},
				{"name": "Hero", "text": "นั่นมัน... Thorn Wolf! แต่มันดูโทรมและอ่อนแอมาก", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"10": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "มันอาศัยอยู่ในพื้นที่สกปรกนานเกินไป เชื้อโรคทำให้มันดุร้ายและเสียสติ", "focus": "guide"},
				{"name": "Hero", "text": "น่าสงสารนัก... ข้าอยากจะช่วยชำระล้างความทรมานของมัน", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"11": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ถ้าข้ากำจัดเมือกพวกนี้ได้ แหล่งน้ำนี้จะกลับมาสะอาดอีกครั้งใช่ไหม?", "focus": "hero"},
				{"name": "Aetherion", "text": "ใช่แล้ว... สภาพแวดล้อมที่สะอาดจะนำมาซึ่งชีวิตที่สมบูรณ์", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"12": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "แต่ก่อนจะสู้... ดูเล็บของเจ้าสิ! มันยาวจนสะสมเชื้อโรคไว้ข้างในหมดแล้ว", "focus": "guide"},
				{"name": "Hero", "text": "จริงด้วย! ข้าต้องตัดเล็บให้สั้นและสะอาดอยู่เสมอ (Health P.3: การดูแลเล็บ)", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"13": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Companion", "text": "อย่าลืมเรื่องฟันด้วยนะครับนายท่าน! กลิ่นปากท่านเริ่มแรงขึ้นเหมือนกันนะอิอิ", "focus": "companion"},
				{"name": "Hero", "text": "เจ้าหมานี่! ข้าแค่ยังไม่ได้แปรงฟันหลังจากกินแอปเปิ้ลป่าเมื่อเช้าเอง!", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"14": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "การแปรงฟันอย่างถูกวิธีจะช่วยให้พลังงานของเจ้าไหลเวียนได้ดีขึ้นและป้องกันฟันผุ", "focus": "guide"},
				{"name": "Hero", "text": "ข้าจะระลึกไว้เสมอ... ความสะอาดคือวินัยอันศักดิ์สิทธิ์!", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"15": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ข้าเจอ 'สบู่โบราณ' ในหีบแถวนี้ด้วย! พลังของมันดูบริสุทธิ์มาก", "focus": "hero"},
				{"name": "Aetherion", "text": "จงใช้มันเคลือบศาสตราของเจ้า... มันจะช่วยสลายเมือกความมืดเหล่านั้นได้ง่ายขึ้น", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"16": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "กลิ่นสาปและความโสโครกเริ่มรุนแรงขึ้นแล้ว! ข้าถอยหลังกลับไม่ได้แล้ว", "focus": "hero"},
				{"name": "Companion", "text": "ผมจะคอยระวังหลังให้ท่านเอง! มั่นใจในความสะอาดของเราได้เลย!", "focus": "companion"}
			],
			"next_scene": "continue"
		},
		"17": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "หัวใจที่สะอาดจะมองเห็นความจริงท่ามกลางภาพลวงตาแห่งความสกปรก", "focus": "guide"},
				{"name": "Hero", "text": "ข้าพร้อมแล้ว... สำหรับพิธีกรรมแห่งความบริสุทธิ์ครั้งนี้!", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"18": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "เพื่อความสมดุลของ Terra Nova และสุขภาวะที่ดีของมวลมนุษย์!", "focus": "guide"},
				{"name": "Hero", "text": "เพื่อร่างกายที่แข็งแรงและจิตใจที่สดใส!", "focus": "hero"}
			],
			"next_scene": "continue"
		},
		"19": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "ระวัง! Thorn Wolf พุ่งเข้ามาแล้ว! สู้เพื่อความสะอาด!", "focus": "guide"},
				{"name": "Hero", "text": "ย้ากกก! รับไปซะ พลังชำระล้าง!", "focus": "hero"}
			],
			"next_scene": "battle",
			"enemy_id": "thorn_wolf",
			"chapter_end": true
		}
	},
	"chapter_3": {
		"name": "พลังงานจากพฤกษา (Nutrition)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "ท้องของข้าเริ่มร้องแล้ว... ข้าไม่ได้กินอะไรเลยตั้งแต่ตื่นมา", "focus": "hero"},
				{"name": "Aetherion", "text": "สารอาหารคือเชื้อเพลิงของวิญญาณ ในยุค Terra Nova นี้ ป่าสามารถมอบพลังให้เจ้าได้", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"1": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "นั่นมันผลไม้สีสดใส! มันกินได้ไหมนะ?", "focus": "hero"},
				{"name": "Aetherion", "text": "อย่าเพิ่งใจร้อน! บางสิ่งที่ดูสวยงามอาจเต็มไปด้วยพิษ (Health P.3: สารอาหารและพิษ)", "focus": "guide"}
			],
			"next_scene": "continue"
		},
		"2": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "จริงด้วย! มี Spore Shroom คอยปล่อยสปอร์พิษครอบคลุมผลไม้เหล่านั้นอยู่", "focus": "hero"},
				{"name": "Aetherion", "text": "จงพิสูจน์ความรู้ด้านโภชนาการของเจ้า และชิงแหล่งอาหารกลับคืนมา!", "focus": "guide"}
			],
			"next_scene": "battle",
			"enemy_id": "spore_shroom"
		}
	},
	"chapter_4": {
		"name": "ความสมดุลและความยืดหยุ่น (Exercise)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "การออกกำลังกายสม่ำเสมอทำให้ร่างกายเจ้าพร้อมรับมือทุกอุปสรรค (Health P.4: การเคลื่อนไหว)", "focus": "guide"},
				{"name": "Hero", "text": "ข้ารู้สึกเบาสบายตัวเมื่อได้ยืดเหยียดร่างกาย!", "focus": "hero"}
			],
			"next_scene": "battle",
			"enemy_id": "crystal_spider"
		}
	},
	"chapter_5": {
		"name": "ความปลอดภัยในพงไพร (Safety)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Aetherion", "text": "จงระวังภัยที่มองไม่เห็น อุบัติเหตุสามารถเกิดขึ้นได้ทุกเมื่อหากประมาท (Health P.5: ความปลอดภัย)", "focus": "guide"},
				{"name": "Hero", "text": "ข้าจะระมัดระวังทุกฝีก้าว!", "focus": "hero"}
			],
			"next_scene": "battle",
			"enemy_id": "atrophy_ghost"
		}
	},
	"chapter_6": { "name": "บทเรียนที่ 6 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_7": { "name": "บทเรียนที่ 7 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_8": { "name": "บทเรียนที่ 8 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_9": { "name": "บทเรียนที่ 9 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_10": { "name": "บทเรียนที่ 10 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_11": { "name": "บทเรียนที่ 11 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_12": { "name": "บทเรียนที่ 12 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_13": { "name": "บทเรียนที่ 13 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_14": { "name": "บทเรียนที่ 14 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_15": { "name": "บทเรียนที่ 15 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_16": { "name": "บทเรียนที่ 16 (Coming Soon)", "0": { "type": "dialogue", "background": "res://Assets/Part2/BG_Verdant_Start.png", "dialogue": [{"name": "Aetherion", "text": "บทเรียนถัดไปกำลังเตรียมพร้อม..."}], "next_scene": "end" } },
	"chapter_17": {
		"name": "The Conflict Bridge (P.6 Social)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Villager A", "text": "เจ้านั่นแหละที่ทำผิด!"},
				{"name": "Hero", "text": "ใจเย็นๆ การขัดแย้งคุยกันได้ (Health P.6: แก้ปัญหาขัดแย้ง)", "focus": "hero"}
			],
			"next_scene": "continue"
		}
	},
	"chapter_18": {
		"name": "The Deep Addiction (P.6 Drugs)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Dealer", "text": "ลองกินสมุนไพรนี่ดูสิ... มันจะทำให้เจ้าลืมทุกอย่าง", "focus": "none"},
				{"name": "Aetherion", "text": "อย่า! มันคือสารเสพติดทำลายชีวิต (Health P.6: สารเสพติด)", "focus": "guide"}
			],
			"next_scene": "battle",
			"enemy_id": "atrophy_ghost"
		}
	},
	"chapter_19": {
		"name": "The Disaster Wall (P.6 Disaster)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Hero", "text": "แผ่นดินกำลังสั่นไหวอย่างรุนแรง!", "focus": "hero"},
				{"name": "Aetherion", "text": "นี่คือภัยพิบัติ! เราต้องมีสติและแผนเตรียมพร้อม (Health P.6: ภัยธรรมชาติ)", "focus": "guide"}
			],
			"next_scene": "battle",
			"enemy_id": "crystal_spider"
		}
	},
	"chapter_20": {
		"name": "Dawn of the Plague (P.6 Prevention)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Deep.png",
			"dialogue": [
				{"name": "Plague Lord", "text": "ข้าจะปล่อยไวรัสกลายพันธุ์ทำลายโลกนี้!", "focus": "none"},
				{"name": "Hero", "text": "ข้าจะไม่ยอมให้เจ้าแพร่เชื้อโรคได้อีกต่อไป! (Health P.6: ป้องกันโรค)", "focus": "hero"}
			],
			"next_scene": "battle",
			"enemy_id": "plague_lord"
		}
	},
	"chapter_21": {
		"name": "The Eternal Seal (P.1-6 Mastery)",
		"0": {
			"type": "dialogue",
			"background": "res://Assets/Part2/BG_Verdant_Start.png",
			"dialogue": [
				{"name": "Aetherion", "text": "ชนะแล้ว! โลกกลับมาร่มเย็นเพราะเจ้ามีความรู้และวินัยอย่างแท้จริง", "focus": "guide"},
				{"name": "Hero", "text": "สุขภาพที่ดีคืออาวุธที่ถาวรที่สุด!", "focus": "hero"}
			],
			"next_scene": "end"
		}
	}
}

# ==================================================================
# Quest Data
# ==================================================================
const QUESTS = {
	"stabilize_forest": {
		"name": "ปรับสมดุลป่า (Stabilize Forest)",
		"desc": "กำจัด Unstable Slime 3 ตัว เพื่อลดความแปรปรวนของธาตุใน Verdant Hollow",
		"target_id": "unstable_slime",
		"target_count": 3,
		"reward_gold": 200,
		"reward_xp": 100
	}
}
