extends Control

@onready var background = $Background
@onready var title = $Margin/VBox/Title
@onready var summary_text = $Margin/VBox/Summary
@onready var credits_scroll = $Margin/VBox/CreditsContainer/CreditsLabel
@onready var main_menu_btn = $Margin/VBox/MainMenuBtn

func _ready():
	# Track current scene
	Global.current_scene = "res://Scenes/Part2/EndingScenePart2.tscn"
	
	# Initial states
	modulate.a = 0
	main_menu_btn.modulate.a = 0
	main_menu_btn.disabled = true
	if has_node("Margin/VBox/CertBtn"):
		$Margin/VBox/CertBtn.modulate.a = 0
		$Margin/VBox/CertBtn.disabled = true
	
	# Apply theme
	UIThemeManager.apply_button_theme(main_menu_btn)
	if has_node("Margin/VBox/CertBtn"):
		UIThemeManager.apply_button_theme($Margin/VBox/CertBtn)
	
	# Play Ending Theme
	AudioManager.play_bgm("victory") # Changed from victory_theme to match AudioManager
	
	# Start Sequence
	_start_ending_sequence()

func _start_ending_sequence():
	var tween = create_tween()
	
	# 1. Fade in the whole scene
	tween.tween_property(self, "modulate:a", 1.0, 2.0)
	
	# 2. Show Victory Title
	tween.tween_interval(1.0)
	
	# 3. Animate Summary Text
	summary_text.text = "ยินดีด้วยผู้กล้า! เจ้าได้พิชิตภัยร้ายแห่งความไม่รู้\nและสร้างรากฐานสุขภาพที่แข็งแกร่งให้กับ Terra Nova อีกครั้ง"
	summary_text.visible_ratio = 0
	tween.tween_property(summary_text, "visible_ratio", 1.0, 3.0)
	
	# 4. Scroll Credits
	_scroll_credits()
	
	# 5. Show Main Menu Button after delay
	await get_tree().create_timer(10.0).timeout
	var btn_tween = create_tween().set_parallel(true)
	btn_tween.tween_property(main_menu_btn, "modulate:a", 1.0, 1.5)
	if has_node("Margin/VBox/CertBtn"):
		btn_tween.tween_property($Margin/VBox/CertBtn, "modulate:a", 1.0, 1.5)
	
	main_menu_btn.disabled = false
	if has_node("Margin/VBox/CertBtn"):
		$Margin/VBox/CertBtn.disabled = false

func _scroll_credits():
	var credits = [
		"PROJECT: HEALTH RPG - TERRA NOVA",
		"นวัตกรรมเกมสวมบทบาทดิจิทัลตามแนวคิด Game-Based Learning",
		"เพื่อพัฒนาทักษะการคิดวิเคราะห์และผลสัมฤทธิ์ทางการเรียน",
		"ด้านสุขศึกษาในระดับประถมศึกษา",
		"",
		"ผู้กำกับและออกแบบ: KRUKAI",
		"",
		"เนื้อหาการศึกษา: THAI HEALTH CURRICULUM (P.1 - P.6)",
		"",
		"ออกแบบมอนสเตอร์และโลก: KRUKAI & ANTIGRAVITY AI",
		"",
		"ศิลปกรรมและฉากหลัง: KRUKAI & AI ENHANCED ASSETS",
		"",
		"ดนตรีและเสียงประกอบ: KRUKAI & ADVENTURE AUDIO PACK",
		"",
		"ขอบคุณพิเศษ:",
		"ALL THE STUDENTS WHO LEARN AND PLAY",
		"(นักเรียนทุกคนที่เรียนรู้และเล่นเกมนี้)",
		"",
		"BE HEALTHY, BE HAPPY!",
		"(ขอให้มีสุขภาพดีและมีความสุข)",
		"",
		"THANK YOU FOR PLAYING",
		"(ขอบคุณที่ร่วมสนุก)"
	]
	
	credits_scroll.text = "\n".join(credits)
	var scroll_height = credits_scroll.size.y + 600
	
	var c_tween = create_tween()
	credits_scroll.position.y = 400
	c_tween.tween_property(credits_scroll, "position:y", -scroll_height, 15.0)

func _on_main_menu_pressed():
	# Reset progress if desired or just go back
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_cert_pressed():
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/CertificateScreen.tscn")
