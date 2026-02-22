extends Control

@onready var dialogue_system = $DialogueSystem
@onready var spirit_sprite = $SpiritSprite
@onready var life_core = $LifeCoreSprite
@onready var hero_sprite = $HeroSprite

func _ready():
	print("VictoryScene started.")
	_apply_theme()
	
	# Play Victory BGM
	AudioManager.play_bgm("victory")
	# Load Spirit
	var spirit_path = "res://Assets/forest_spirit.png"
	if ResourceLoader.exists(spirit_path) or FileAccess.file_exists(spirit_path):
		spirit_sprite.texture = load(spirit_path)
		print("Victory Spirit loaded")
	
	# Load Hero
	var icon_key = Global.player_class + "_" + Global.player_gender
	var hero_path = Global.class_icons.get(icon_key, "")
	if hero_path != "" and (ResourceLoader.exists(hero_path) or FileAccess.file_exists(hero_path)):
		hero_sprite.texture = load(hero_path)
		hero_sprite.show()
		print("Victory Hero loaded: ", hero_path)
	
	# Load Life Core
	var core_path = "res://Assets/life_core.png"
	if ResourceLoader.exists(core_path) or FileAccess.file_exists(core_path):
		life_core.texture = load(core_path)
		life_core.visible = true
		print("Life Core loaded")

	# Victory Dialogue
	var lines = [
		{"name": "จิตวิญญาณแห่งป่า", "text": "ยอดเยี่ยมมาก! ... หมอกทมิฬจางหายไปแล้ว"},
		{"name": "จิตวิญญาณแห่งป่า", "text": "ดูสิ! ดอกไม้กำลังบานสะพรั่งอีกครั้ง เพราะท่านใส่ใจในสุขภาพ"},
		{"name": "ระบบ", "text": "ได้รับไอเทม: ผลไม้แห่งปัญญา (Life Core)"},
		{"name": "จิตวิญญาณแห่งป่า", "text": "นี่คือ 'แก่นแท้แห่งชีวิต' ชิ้นแรก... มันจะช่วยฟื้นฟูพลังของผืนป่า"},
		{"name": "Hero", "text": "ข้ารู้สึกแข็งแกร่งขึ้น... และพร้อมสำหรับก้าวต่อไป"},
		{"name": "จิตวิญญาณแห่งป่า", "text": "หนทางข้างหน้าคือ 'ทางแยกแห่งชะตา' (Crossroads)..."},
		{"name": "จิตวิญญาณแห่งป่า", "text": "ท่านจะต้องเลือกระหว่าง ทางแห่งร่างกาย, ทางแห่งจิตใจ, หรือ ทางแห่งสังคม"},
		{"name": "จิตวิญญาณแห่งป่า", "text": "เตรียมตัวให้พร้อม... การผจญภัยที่แท้จริงเพิ่งเริ่มต้น!"}
	]
	
	dialogue_system.dialogue_finished.connect(_on_victory_finished)
	dialogue_system.line_changed.connect(_on_line_changed)
	# Wait a bit before starting
	await get_tree().create_timer(1.0).timeout
	dialogue_system.start_dialogue(lines)

func _apply_theme():
	"""Apply premium UI theme to victory scene"""
	# The dialogue system will handle its own styling via DialogueSystem.gd _apply_theme()
	pass
	
func _on_line_changed(data):
	var speaker = data.get("name", "").to_lower()
	if "hero" in speaker or "ผู้กล้า" in speaker:
		hero_sprite.modulate = Color(1, 1, 1, 1)
		spirit_sprite.modulate = Color(0.4, 0.4, 0.4, 0.7)
	elif "จิตวิญญาณ" in speaker or "spirit" in speaker:
		hero_sprite.modulate = Color(0.4, 0.4, 0.4, 0.7)
		spirit_sprite.modulate = Color(1, 1, 1, 1)
	else:
		hero_sprite.modulate = Color(1, 1, 1, 1)
		spirit_sprite.modulate = Color(1, 1, 1, 1)

func _on_victory_finished():
	if Global.is_part2_story:
		get_tree().change_scene_to_file("res://Scenes/Part2/WorldMap.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")
