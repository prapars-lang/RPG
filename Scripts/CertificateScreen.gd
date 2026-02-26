extends Control

@onready var background = $Background
@onready var cert_panel = $CertPanel
@onready var title_lbl = $CertPanel/Margin/MainVBox/Title
@onready var subtitle_lbl = $CertPanel/Margin/MainVBox/Subtitle
@onready var name_lbl = $CertPanel/Margin/MainVBox/PlayerName
@onready var class_lbl = $CertPanel/Margin/MainVBox/PlayerClass
@onready var details_lbl = $CertPanel/Margin/MainVBox/ContentHBox/Details
@onready var date_lbl = $CertPanel/Margin/MainVBox/Footer/Date
@onready var hero_portrait = $CertPanel/Margin/MainVBox/ContentHBox/HeroPortrait
@onready var save_btn = $CenterContainer/VBox/SaveBtn
@onready var back_btn = $CenterContainer/VBox/BackBtn
@onready var status_lbl = $StatusLbl

var part_number = 1

func _ready():
	# Decide which part based on global state or metadata
	part_number = 2 if Global.is_part2_story else 1
	_setup_certificate()
	
	UIThemeManager.apply_button_theme(save_btn)
	UIThemeManager.apply_button_theme(back_btn)
	
	status_lbl.text = ""

func _setup_certificate():
	# 1. Background Styling & Themes
	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 25
	style.corner_radius_top_right = 25
	style.corner_radius_bottom_left = 25
	style.corner_radius_bottom_right = 25
	style.set_border_width_all(10)
	style.shadow_size = 30
	style.shadow_color = Color(0, 0, 0, 0.3)
	
	if part_number == 1:
		style.bg_color = Color(0.98, 0.98, 1.0, 0.95) # Formal White with transparency
		style.border_color = Color(0.2, 0.4, 0.7) # Royal Blue
		background.texture = load("res://Assets/img/battlebacks2/Temple.png")
	else:
		style.bg_color = Color(1.0, 0.99, 0.95, 0.95) # Ivory
		style.border_color = Color(0.7, 0.5, 0.1) # Gold
		background.texture = load("res://Assets/img/battlebacks2/Castle1.png")
		
	cert_panel.add_theme_stylebox_override("panel", style)
	
	# 2. Texts (As requested)
	title_lbl.text = "ใบประกาศเกียรติบัตร"
	subtitle_lbl.text = "นวัตกรรมการเรียนรู้แบบเกมเป็นฐาน (Game-Based Learning)\nเรื่อง การพัฒนาทักษะการคิดวิเคราะห์และผลสัมฤทธิ์ทางการเรียนวิชาสุขศึกษา"
	
	name_lbl.text = "[ " + Global.player_name + " ]"
	class_lbl.text = "อาชีพ: " + Global.player_class + " (Level " + str(Global.player_level) + ")"
	
	var desc = "เพื่อรับรองว่าได้ผ่านการจัดกิจกรรมการเรียนรู้ด้วยนวัตกรรมเกมสวมบทบาทดิจิทัล\n"
	desc += "“Amnesia: The Path of Wisdom (ปัญญาพิชิตโรค)”\n"
	desc += "ครบถ้วนตามโครงสร้างหลักสูตรจำนวน 30 บทเรียน\n\n"
	desc += "โดยแสดงให้เห็นถึง\n"
	desc += "• ความสามารถในการวิเคราะห์สถานการณ์ด้านสุขภาพ\n"
	desc += "• การตัดสินใจอย่างมีเหตุผลบนพื้นฐานข้อมูล\n"
	desc += "• ความรับผิดชอบและความมุ่งมั่นในการเรียนรู้\n\n"
	desc += "สมควรได้รับการรับรองผลการเข้าร่วมกิจกรรมการเรียนรู้ตามกรอบการวิจัย"
	
	details_lbl.text = desc
	
	# 3. Date
	var d = Time.get_date_dict_from_system()
	var month_names = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
	var thai_year = d.year + 543
	date_lbl.text = "ให้ไว้ ณ วันที่ %d %s พ.ศ. %d" % [d.day, month_names[d.month], thai_year]
	
	# 4. Hero Portrait
	var icon_key = Global.player_class + "_" + Global.player_gender
	var hero_path = Global.class_icons.get(icon_key, "")
	if hero_path != "" and ResourceLoader.exists(hero_path):
		hero_portrait.texture = load(hero_path)

func _on_save_pressed():
	save_btn.visible = false
	back_btn.visible = false
	status_lbl.text = "กำลังบันทึกภาพ..."
	
	# Small delay to ensure UI updates
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	
	# Capture the specific panel
	var img = cert_panel.get_viewport().get_texture().get_image()
	
	var timestamp = Time.get_unix_time_from_system()
	var filename = "user://Certificate_Part%d_%d.png" % [part_number, timestamp]
	var err = img.save_png(filename)
	
	if err == OK:
		status_lbl.text = "บันทึกสำเร็จที่: " + ProjectSettings.globalize_path(filename)
		print("Certificate saved to: ", filename)
	else:
		status_lbl.text = "เกิดข้อผิดพลาดในการบันทึก"
		
	save_btn.visible = true
	back_btn.visible = true

func _on_back_pressed():
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
