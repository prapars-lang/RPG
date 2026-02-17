extends Control

@onready var dialogue_system = $DialogueSystem
@onready var hero_sprite = $HeroSprite
@onready var spirit_sprite = $SpiritSprite

# Using Global.class_icons now

func _ready():
	print("IntroStory started. Player class: ", Global.player_class, " Gender: ", Global.player_gender)
	_apply_theme()
	
	# Play Intro/Story Music
	AudioManager.play_bgm("story")
	
	# Load Hero Sprite — key format: "อาชีพ_เพศ" e.g. "นักล่า_เด็กชาย"
	var icon_key = Global.player_class + "_" + Global.player_gender
	var hero_path = Global.class_icons.get(icon_key, "")
	print("[IntroStory] icon_key='%s' hero_path='%s'" % [icon_key, hero_path])
	
	if hero_path != "" and (ResourceLoader.exists(hero_path) or FileAccess.file_exists(hero_path)):
		hero_sprite.texture = load(hero_path)
		print("[IntroStory] Hero texture loaded successfully!")
	else:
		push_warning("[IntroStory] CRITICAL: Hero texture NOT found at: " + hero_path)
		# Fallback: try without gender
		var fallback_path = Global.class_icons.get(Global.player_class, "")
		if fallback_path != "" and (ResourceLoader.exists(fallback_path) or FileAccess.file_exists(fallback_path)):
			hero_sprite.texture = load(fallback_path)
			print("[IntroStory] Loaded fallback hero texture")
	
	# Load Spirit Sprite
	var spirit_path = "res://Assets/forest_spirit.png"
	if ResourceLoader.exists(spirit_path) or FileAccess.file_exists(spirit_path):
		spirit_sprite.texture = load(spirit_path)
		print("[IntroStory] Spirit texture loaded successfully!")
	else:
		push_warning("[IntroStory] CRITICAL: Spirit texture NOT found at: " + spirit_path)
	
	# Start Dialogue
	var story = [
		{"name": "จิตวิญญาณแห่งป่า", "text": "ยินดีต้อนรับ... ป่าแห่งนี้กำลังจะตาย", "focus": "spirit"},
		{"name": Global.player_class, "text": "ทำไมมันถึงเงียบเหงาเช่นนี้?", "focus": "hero"},
		{"name": "จิตวิญญาณแห่งป่า", "text": "เพราะมนุษย์หลงลืมการดูแลตนเอง... ปีศาจโรคร้ายจึงก่อตัวขึ้น", "focus": "spirit"},
		{"name": "จิตวิญญาณแห่งป่า", "text": "ท่านต้องใช้ 'ปัญญา' ในการชำระล้างพวกมัน", "focus": "spirit"},
		{"name": "จิตวิญญาณแห่งป่า", "text": "จงระวัง... ปีศาจพวกนี้แข็งแกร่งกว่าที่ตาเห็น... ไปเถอะ!", "focus": "spirit"}
	]
	
	dialogue_system.dialogue_finished.connect(_on_intro_finished)
	dialogue_system.start_dialogue(story)
	
	# Initial focus
	update_visual_focus("spirit")

func _apply_theme():
	"""Apply premium UI theme to intro story"""
	# The dialogue system will handle its own styling via DialogueSystem.gd
	pass

func _input(event):
	# Listen for dialogue progression to update focus
	if dialogue_system.visible and (event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed)):
		# Small delay to let current_line update in DialogueSystem
		await get_tree().process_frame
		var line_idx = dialogue_system.current_line
		if line_idx < dialogue_system.dialogue_queue.size():
			update_visual_focus(dialogue_system.dialogue_queue[line_idx].get("focus", ""))

func update_visual_focus(target):
	if target == "hero":
		hero_sprite.modulate = Color(1, 1, 1, 1)
		spirit_sprite.modulate = Color(0.5, 0.5, 0.5, 1)
	elif target == "spirit":
		hero_sprite.modulate = Color(0.5, 0.5, 0.5, 1)
		spirit_sprite.modulate = Color(1, 1, 1, 1)

func _on_intro_finished():
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")
