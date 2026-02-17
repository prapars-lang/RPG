extends Control

@onready var name_input = $VBoxContainer/NameHBox/NameInput
@onready var gender_label = $VBoxContainer/GenderHBox/GenderValue
@onready var class_label = $VBoxContainer/ClassHBox/ClassValue
@onready var desc_label = $VBoxContainer/DescriptionLabel
@onready var hero_preview = $HeroPreview

var genders = ["เด็กชาย", "เด็กหญิง"]
var gender_index = 0

var classes = ["อัศวิน", "จอมเวทย์", "นักล่า", "ผู้พิทักษ์"]
var class_index = 0

var class_descriptions = {
	"อัศวิน": "อัศวินสุขภาพ: พลังป้องกันสูง เน้นการออกกำลังกาย",
	"จอมเวทย์": "จอมเวทย์โภชนาการ: พลังเวทย์สูง เน้นอาหาร 5 หมู่",
	"นักล่า": "พรานสุขอนามัย: ความเร็วสูง เน้นความสะอาด",
	"ผู้พิทักษ์": "ผู้พิทักษ์จิตใจ: มานาสูงและฟื้นฟูได้ดี เน้นสุขภาพจิต"
}

@onready var hp_val = $VBoxContainer/StatsHBox/HP
@onready var atk_val = $VBoxContainer/StatsHBox/ATK
@onready var def_val = $VBoxContainer/StatsHBox/DEF

func _ready():
	# Apply premium UI theme using UIThemeManager
	_apply_theme()
	
	# Animate Hero Preview (Breath)
	var tween = create_tween().set_loops()
	tween.tween_property(hero_preview, "position:y", hero_preview.position.y - 15, 2.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(hero_preview, "position:y", hero_preview.position.y, 2.5).set_trans(Tween.TRANS_SINE)
		
	update_display()

func _apply_theme():
	"""Apply premium UI theme to all elements"""
	# Style buttons with UIThemeManager
	var buttons = [$VBoxContainer/GenderHBox/NextGender, $VBoxContainer/ClassHBox/NextClass, $VBoxContainer/StartGame]
	for btn in buttons:
		UIThemeManager.apply_button_theme(btn)
		btn.pivot_offset = btn.size / 2
		btn.mouse_entered.connect(_on_btn_mouse_entered.bind(btn))
		btn.mouse_exited.connect(_on_btn_mouse_exited.bind(btn))
	
	# Style text labels with theme colors
	gender_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	gender_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_TITLE)
	
	class_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	class_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_TITLE)
	
	desc_label.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	desc_label.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZE_NORMAL)
	
	hp_val.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	atk_val.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	def_val.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
	
	# Style name input with theme
	var input_style = StyleBoxFlat.new()
	input_style.bg_color = UIThemeManager.COLOR_DARK_BG
	input_style.corner_radius_top_left = 8
	input_style.corner_radius_top_right = 8
	input_style.corner_radius_bottom_left = 8
	input_style.corner_radius_bottom_right = 8
	input_style.border_width_left = 1
	input_style.border_width_top = 1
	input_style.border_width_right = 1
	input_style.border_width_bottom = 1
	input_style.border_color = UIThemeManager.COLOR_PRIMARY
	name_input.add_theme_stylebox_override("normal", input_style)
	name_input.add_theme_stylebox_override("focus", input_style)
	name_input.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)

func update_display():
	gender_label.text = genders[gender_index]
	var selected_class = classes[class_index]
	class_label.text = selected_class
	
	if selected_class in class_descriptions:
		desc_label.text = class_descriptions[selected_class]
	
	# Update Stats
	var s = Global.stats[selected_class]
	hp_val.text = "HP: " + str(s.max_hp)
	atk_val.text = "ATK: " + str(s.atk)
	def_val.text = "DEF: " + str(s.def)
	
	# Update Hero Image with a small fade
	var icon_key = selected_class + "_" + genders[gender_index]
	if icon_key in Global.class_icons:
		var img_path = Global.class_icons[icon_key]
		if ResourceLoader.exists(img_path) or FileAccess.file_exists(img_path):
			var tex = load(img_path)
			if hero_preview.texture != tex:
				var tween = create_tween()
				tween.tween_property(hero_preview, "modulate:a", 0.0, 0.1)
				tween.tween_callback(func(): hero_preview.texture = tex)
				tween.tween_property(hero_preview, "modulate:a", 1.0, 0.1)
		else:
			hero_preview.texture = null

# --- UI Juice ---
func _on_btn_mouse_entered(btn: Button):
	create_tween().tween_property(btn, "scale", Vector2(1.05, 1.05), 0.1)

func _on_btn_mouse_exited(btn: Button):
	create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)

func _on_next_gender_pressed():
	gender_index = (gender_index + 1) % genders.size()
	update_display()

func _on_next_class_pressed():
	class_index = (class_index + 1) % classes.size()
	update_display()

func _on_start_game_pressed():
	var p_name = name_input.text.strip_edges()
	if p_name == "":
		p_name = "ผู้กล้า" # Default name
	
	Global.player_name = p_name
	Global.player_gender = genders[gender_index]
	Global.player_class = classes[class_index]
	
	print("Starting game as: ", Global.player_name, " (", Global.player_gender, " ", Global.player_class, ")")
	
	# Initial Save
	Global.save_game()
	
	print("Attempting to change scene to IntroStory.tscn...")
	var error = get_tree().change_scene_to_file("res://Scenes/IntroStory.tscn")
	if error != OK:
		print("Error changing scene: ", error)
