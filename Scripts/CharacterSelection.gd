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

func _ready():
	# Check if nodes exist before accessing them to avoid crashes if scene tree is different
	if not name_input or not gender_label or not class_label:
		print("CharacterSelection: Error - UI Nodes not found!")
		return
		
	update_display()

func update_display():
	gender_label.text = genders[gender_index]
	class_label.text = classes[class_index]
	
	if classes[class_index] in class_descriptions:
		desc_label.text = class_descriptions[classes[class_index]]
	else:
		desc_label.text = ""
	
	# Update Hero Image
	var icon_key = classes[class_index] + "_" + genders[gender_index]
	if icon_key in Global.class_icons:
		var img_path = Global.class_icons[icon_key]
		if ResourceLoader.exists(img_path) or FileAccess.file_exists(img_path):
			hero_preview.texture = load(img_path)
		else:
			hero_preview.texture = null

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
