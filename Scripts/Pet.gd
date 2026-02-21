extends Control

@onready var pet_sprite = $PetContainer/PetSprite
@onready var name_label = $InfoContainer/NameLabel
@onready var level_label = $InfoContainer/LevelLabel
@onready var buff_label = $InfoContainer/BuffLabel
@onready var joy_bar = $StatsContainer/JoyBar
@onready var hunger_bar = $StatsContainer/HungerBar
@onready var feed_btn = $ActionsContainer/FeedBtn
@onready var play_btn = $ActionsContainer/PlayBtn

var pet_data_script = preload("res://Scripts/PetData.gd").new()

func _ready():
	_update_ui()
	_start_idle_animation()

func _update_ui():
	var pet_id = Global.current_pet_id
	var stats = Global.pet_stats
	var info = pet_data_script.get_pet_info(pet_id)
	
	if info.is_empty(): return
	
	# Text Info
	name_label.text = info.name
	level_label.text = "Lv. %d" % stats.level
	
	var buff_val = pet_data_script.get_buff_value(pet_id, stats.level)
	buff_label.text = "Bonus: +%d %s" % [buff_val, info.buff_type.to_upper()]
	
	# Visual
	pet_sprite.texture = load(info.texture)
	
	# Bars
	joy_bar.value = stats.joy
	hunger_bar.value = stats.hunger
	
	# Button States
	feed_btn.text = "Feed (-50 Gold)"
	feed_btn.disabled = Global.player_gold < 50 or stats.hunger >= 100

func _on_feed_btn_pressed():
	if Global.player_gold >= 50:
		Global.player_gold -= 50
		Global.pet_stats.hunger = min(Global.pet_stats.hunger + 20, 100)
		Global.pet_stats.xp += 10
		_check_level_up()
		AudioManager.play_sfx("eat") # Assume exist or generic
		_update_ui()
		_play_reaction("happy")

func _on_play_btn_pressed():
	if Global.pet_stats.joy < 100:
		Global.pet_stats.joy = min(Global.pet_stats.joy + 15, 100)
		Global.pet_stats.hunger = max(Global.pet_stats.hunger - 5, 0) # Playing makes hungry
		Global.pet_stats.xp += 5
		_check_level_up()
		AudioManager.play_sfx("jump")
		_update_ui()
		_play_reaction("jump")

func _check_level_up():
	var needed = pet_data_script.get_next_level_xp(Global.pet_stats.level)
	if Global.pet_stats.xp >= needed:
		Global.pet_stats.xp -= needed
		Global.pet_stats.level += 1
		AudioManager.play_sfx("level_up")
		# Show level up effect (simple scale tween)
		var t = create_tween()
		t.tween_property(pet_sprite, "scale", Vector2(1.5, 1.5), 0.3)
		t.tween_property(pet_sprite, "scale", Vector2(1.0, 1.0), 0.3)

func _start_idle_animation():
	var t = create_tween().set_loops()
	t.tween_property(pet_sprite, "position:y", pet_sprite.position.y - 10, 1.0).set_trans(Tween.TRANS_SINE)
	t.tween_property(pet_sprite, "position:y", pet_sprite.position.y, 1.0).set_trans(Tween.TRANS_SINE)

func _play_reaction(type):
	if type == "jump":
		var t = create_tween()
		t.tween_property(pet_sprite, "scale", Vector2(1.2, 0.8), 0.1)
		t.tween_property(pet_sprite, "scale", Vector2(0.8, 1.2), 0.1)
		t.tween_property(pet_sprite, "scale", Vector2(1.0, 1.0), 0.1)
	elif type == "happy":
		var t = create_tween()
		t.tween_property(pet_sprite, "rotation", 0.1, 0.1)
		t.tween_property(pet_sprite, "rotation", -0.1, 0.1)
		t.tween_property(pet_sprite, "rotation", 0.0, 0.1)

func _on_back_btn_pressed():
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
