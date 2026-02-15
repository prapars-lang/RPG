extends Control

# Shop.gd — ร้านค้าภูติน้อย
# 3-panel layout: Category sidebar | Item grid (with icons) | Detail panel

@onready var gold_label = $TopBar/GoldLabel
@onready var item_grid = $MainHBox/ItemScrollContainer/ItemGrid
@onready var detail_icon = $MainHBox/DetailPanel/DetailVBox/PreviewIcon
@onready var detail_name = $MainHBox/DetailPanel/DetailVBox/ItemName
@onready var detail_rarity = $MainHBox/DetailPanel/DetailVBox/ItemRarity
@onready var detail_stats = $MainHBox/DetailPanel/DetailVBox/ItemStats
@onready var detail_desc = $MainHBox/DetailPanel/DetailVBox/ItemDesc
@onready var detail_price = $MainHBox/DetailPanel/DetailVBox/ItemPrice
@onready var buy_button = $MainHBox/DetailPanel/DetailVBox/BuyButton
@onready var feedback_label = $FeedbackLabel

var pause_menu_scene = preload("res://Scenes/PauseMenu.tscn")
var pause_menu_instance = null

var current_category = "all"
var selected_item_id = ""

const RARITY_NAMES = {
	"common": "⚪ ธรรมดา",
	"rare": "🔵 หายาก",
	"epic": "🟣 มหากาพย์",
	"legendary": "🟡 ตำนาน",
	"mythic": "🔴 ในตำนาน"
}

const SLOT_NAMES = {
	"weapon": "อาวุธ",
	"head": "หมวก",
	"body": "เกราะ",
	"hands": "ถุงมือ",
	"feet": "รองเท้า",
	"accessory": "เครื่องประดับ"
}

func _ready():
	Global.current_scene = "res://Scenes/Shop.tscn"
	
	# PauseMenu
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	
	buy_button.disabled = true
	feedback_label.text = ""
	update_gold()
	populate_items()
	clear_detail()

func update_gold():
	gold_label.text = "💰 Gold: %d" % Global.player_gold

# === Category filter ===
func _on_category_pressed(cat: String):
	current_category = cat
	selected_item_id = ""
	clear_detail()
	populate_items()

# === Build item grid ===
func populate_items():
	for child in item_grid.get_children():
		child.queue_free()
	
	for item_id in Global.item_db:
		var item = Global.item_db[item_id]
		
		# Filter by category
		if current_category != "all":
			if current_category == "consumable":
				if item.type != "consumable":
					continue
			else:
				if item.type != "equipment":
					continue
				if item.get("slot", "") != current_category:
					continue
		
		# Create item card
		_create_item_card(item_id, item)

func _create_item_card(item_id: String, item: Dictionary):
	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(180, 180)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 4)
	card.add_child(vbox)
	
	# Icon
	var icon_rect = TextureRect.new()
	icon_rect.custom_minimum_size = Vector2(64, 64)
	icon_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	var icon_path = item.get("icon", "")
	if icon_path != "" and ResourceLoader.exists(icon_path):
		icon_rect.texture = load(icon_path)
	
	vbox.add_child(icon_rect)
	
	# Name
	var name_label = Label.new()
	name_label.text = item.get("name", item_id)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 14)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	
	var rarity = item.get("rarity", "")
	if rarity != "":
		name_label.add_theme_color_override("font_color", Global.RARITY_COLORS.get(rarity, Color.WHITE))
	
	vbox.add_child(name_label)
	
	# Quick stat line
	var stat_line = _build_stat_line(item)
	if stat_line != "":
		var stat_label = Label.new()
		stat_label.text = stat_line
		stat_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		stat_label.add_theme_font_size_override("font_size", 12)
		stat_label.add_theme_color_override("font_color", Color(0.7, 0.9, 0.7))
		vbox.add_child(stat_label)
	
	# Price
	var price_label = Label.new()
	price_label.text = "💰 %d G" % item.get("price", 0)
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price_label.add_theme_font_size_override("font_size", 14)
	
	if Global.player_gold < item.get("price", 0):
		price_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	else:
		price_label.add_theme_color_override("font_color", Color(1, 0.85, 0))
	
	vbox.add_child(price_label)
	
	# Make entire card clickable via mouse filter
	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_select_item(item_id)
	)
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	# Highlight if selected
	if item_id == selected_item_id:
		card.modulate = Color(1.3, 1.3, 1.0)
	
	item_grid.add_child(card)

func _build_stat_line(item: Dictionary) -> String:
	var parts = []
	if "atk" in item and item.atk > 0: parts.append("ATK+%d" % item.atk)
	if "def" in item and item["def"] > 0: parts.append("DEF+%d" % item["def"])
	if "hp" in item and item.hp > 0: parts.append("HP+%d" % item.hp)
	if "mana" in item and item.mana > 0: parts.append("MP+%d" % item.mana)
	if "value" in item: parts.append("+%d" % item.value)
	return " ".join(parts)

# === Detail panel ===
func _select_item(item_id: String):
	selected_item_id = item_id
	var item = Global.item_db.get(item_id, {})
	
	# Icon
	var icon_path = item.get("icon", "")
	if icon_path != "" and ResourceLoader.exists(icon_path):
		detail_icon.texture = load(icon_path)
	else:
		detail_icon.texture = null
	
	# Name with rarity color
	detail_name.text = item.get("name", item_id)
	var rarity = item.get("rarity", "")
	if rarity != "":
		detail_name.add_theme_color_override("font_color", Global.RARITY_COLORS.get(rarity, Color.WHITE))
	else:
		detail_name.remove_theme_color_override("font_color")
	
	# Rarity label
	if rarity in RARITY_NAMES:
		detail_rarity.text = RARITY_NAMES[rarity]
		detail_rarity.add_theme_color_override("font_color", Global.RARITY_COLORS.get(rarity, Color.WHITE))
	else:
		detail_rarity.text = ""
	
	# Stats
	var stat_parts = []
	if item.type == "equipment":
		stat_parts.append("📍 ช่อง: %s" % SLOT_NAMES.get(item.get("slot", ""), "?"))
	if "atk" in item and item.atk > 0: stat_parts.append("⚔️ ATK +%d" % item.atk)
	if "def" in item and item["def"] > 0: stat_parts.append("🛡️ DEF +%d" % item["def"])
	if "hp" in item and item.hp > 0: stat_parts.append("❤️ HP +%d" % item.hp)
	if "mana" in item and item.mana > 0: stat_parts.append("💙 MP +%d" % item.mana)
	if "value" in item: stat_parts.append("✨ ผล: +%d" % item.value)
	
	# Set info
	var set_id = item.get("set_id", "")
	if set_id != "" and set_id in Global.SET_BONUSES:
		stat_parts.append("🔗 เซ็ต: %s" % Global.SET_BONUSES[set_id].name)
	
	detail_stats.text = "\n".join(stat_parts)
	
	# Description
	detail_desc.text = item.get("desc", "")
	
	# Price
	var price = item.get("price", 0)
	detail_price.text = "💰 ราคา: %d G" % price
	
	# Buy button
	buy_button.disabled = Global.player_gold < price
	buy_button.text = "🛒 ซื้อ (%d G)" % price if Global.player_gold >= price else "❌ เหรียญไม่พอ"
	
	# Refresh grid to show selection highlight
	populate_items()

func clear_detail():
	detail_icon.texture = null
	detail_name.text = "← เลือกไอเทมจากรายการ"
	detail_name.remove_theme_color_override("font_color")
	detail_rarity.text = ""
	detail_stats.text = ""
	detail_desc.text = ""
	detail_price.text = ""
	buy_button.disabled = true
	buy_button.text = "🛒 ซื้อ"

# === Buy logic ===
func _on_buy_pressed():
	if selected_item_id == "":
		return
	
	var item = Global.item_db.get(selected_item_id, {})
	var price = item.get("price", 0)
	
	if Global.player_gold >= price:
		Global.player_gold -= price
		Global.add_item(selected_item_id, 1)
		Global.save_game()
		
		update_gold()
		_select_item(selected_item_id) # Refresh detail panel
		show_feedback("✅ ซื้อ %s สำเร็จ!" % item.get("name", ""), Color(0.3, 1, 0.3))
	else:
		show_feedback("❌ เหรียญไม่พอ!", Color(1, 0.3, 0.3))

func show_feedback(msg: String, color: Color):
	feedback_label.text = msg
	feedback_label.add_theme_color_override("font_color", color)
	feedback_label.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_property(feedback_label, "modulate:a", 0.0, 2.0).set_delay(1.5)

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")
