extends Control

@onready var credits_label = $ScrollContainer/VBoxContainer/CreditsLabel
@onready var scroll_container = $ScrollContainer

var scroll_speed = 60.0
var is_scrolling = true

func _ready():
	# Play Ending Music
	if AudioManager.current_bgm_key != "victory":
		AudioManager.play_bgm("victory")
	
	setup_credits()

func _process(delta):
	if is_scrolling:
		scroll_container.scroll_vertical += scroll_speed * delta
		
		# Check if reached bottom
		if scroll_container.scroll_vertical >= scroll_container.get_v_scroll_bar().max_value - scroll_container.size.y:
			is_scrolling = false
			await get_tree().create_timer(2.0).timeout
			$ReturnButton.visible = true
			$ReturnButton.grab_focus()
			# Enable Buttons
			if has_node("Part2Button"):
				$Part2Button.visible = true
			if has_node("CertBtn"):
				$CertBtn.visible = true

func setup_credits():
	var text = "[center][b][font_size=42]PROJECT: HEALTH RPG - TERRA NOVA[/font_size][/b]\n\n"
	text += "[font_size=20]นวัตกรรมเกมสวมบทบาทดิจิทัลตามแนวคิด Game-Based Learning\n"
	text += "เพื่อพัฒนาทักษะการคิดวิเคราะห์และผลสัมฤทธิ์ทางการเรียน\n"
	text += "ด้านสุขศึกษาในระดับประถมศึกษา[/font_size]\n\n"
	
	text += "[color=#e67e22][font_size=24]ผู้กำกับและออกแบบ[/font_size][/color]\nKRUKAI\n\n"
	text += "[color=#2ecc71][font_size=24]เนื้อหาการศึกษา[/font_size][/color]\nTHAI HEALTH CURRICULUM (P.1 - P.6)\n\n"
	text += "[color=#3498db][font_size=24]ออกแบบมอนสเตอร์และโลก[/font_size][/color]\nKRUKAI & ANTIGRAVITY AI\n\n"
	text += "[color=#9b59b6][font_size=24]ศิลปกรรมและฉากหลัง[/font_size][/color]\nKRUKAI & AI ENHANCED ASSETS\n\n"
	text += "[color=#e74c3c][font_size=24]ดนตรีและเสียงประกอบ[/font_size][/color]\nKRUKAI & ADVENTURE AUDIO PACK\n\n"
	
	text += "[font_size=28]ขอบคุณพิเศษ[/font_size]\n"
	text += "ALL THE STUDENTS WHO LEARN AND PLAY\n(นักเรียนทุกคนที่เรียนรู้และเล่นเกมนี้)\n\n"
	text += "BE HEALTHY, BE HAPPY!\n(ขอให้มีสุขภาพดีและมีความสุข)\n\n"
	text += "THANK YOU FOR PLAYING\n(ขอบคุณที่ร่วมสนุก)\n\n"
	text += "[font_size=32][THE END][/font_size][/center]"
	
	credits_label.text = text

func _on_return_button_pressed():
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_part2_button_pressed():
	AudioManager.play_sfx("button_click")
	print("Starting Part 2...")
	# Future: Load specialized Part 2 init logic here
	get_tree().change_scene_to_file("res://Scenes/Part2/IntroPart2.tscn")

func _on_cert_button_pressed():
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/CertificateScreen.tscn")

