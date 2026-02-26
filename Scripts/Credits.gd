extends Control

@onready var scroll_container = $ScrollContainer
@onready var credits_label = $ScrollContainer/VBox/CreditsLabel

var scroll_speed = 50.0

func _ready():
	_apply_theme()
	scroll_container.get_v_scroll_bar().modulate.a = 0 # Hide scrollbar
	_setup_credits_text()

func _setup_credits_text():
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
	credits_label.text = "\n".join(credits)

func _apply_theme():
	"""Apply premium UI theme to credits"""
	# Style credits label with theme
	credits_label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	credits_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
func _process(delta):
	scroll_container.scroll_vertical += scroll_speed * delta
	
	# Reset or stop when reached end
	if scroll_container.scroll_vertical >= 1000: # Adjust based on content
		_on_back_btn_pressed()

func _input(event):
	if event.is_action_pressed("ui_cancel") or event is InputEventMouseButton:
		_on_back_btn_pressed()

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
