extends Control

# ShopPart2.gd — ร้านค้าวิวัฒนาการ Terra Nova
# จัดการโดย Merchant Maya

@onready var gold_label = $TopBar/GoldLabel
@onready var item_grid = $MainHBox/ItemScrollContainer/ItemGrid
@onready var detail_panel = $MainHBox/DetailPanel
@onready var buy_button = $MainHBox/DetailPanel/DetailVBox/BuyButton
@onready var feedback_label = $FeedbackLabel

# Detail elements
@onready var detail_icon = $MainHBox/DetailPanel/DetailVBox/PreviewIcon
@onready var detail_name = $MainHBox/DetailPanel/DetailVBox/ItemName
@onready var detail_stats = $MainHBox/DetailPanel/DetailVBox/ItemStats
@onready var detail_desc = $MainHBox/DetailPanel/DetailVBox/ItemDesc
@onready var detail_price = $MainHBox/DetailPanel/DetailVBox/ItemPrice

var selected_item_id = ""

func _ready():
	Global.current_scene = "res://Scenes/Part2/ShopPart2.tscn"
	
	# Play Shop BGM
	if AudioManager.has_method("play_bgm"):
		AudioManager.play_bgm("menu")
	
	# Show Maya's Dialogue
	_show_maya_greeting()
	
	_apply_theme()
	update_gold()
	populate_items()
	_clear_detail()

func _show_maya_greeting():
	if is_instance_valid(NPCDialogUI):
		NPCDialogUI.show_npc_dialog("merchant_maya")

func _apply_theme():
	UIThemeManager.apply_button_theme(buy_button)
	# Additional styling...
	pass

func update_gold():
	gold_label.text = "💰 ทอง: %d G" % Global.player_gold

func populate_items():
	for child in item_grid.get_children():
		child.queue_free()
	
	# Only show Part 2 items and some basic consumables
	var items_to_show = []
	
	# Part 2 Items
	for id in ItemDB_Part2.ITEMS:
		items_to_show.append(id)
	
	# Add some helpful Part 1 top-tier items
	var basic_essentials = ["potion_large", "mana_large", "amulet_luck"]
	for id in basic_essentials:
		if id not in items_to_show:
			items_to_show.append(id)
			
	for item_id in items_to_show:
		var item = Global.item_db.get(item_id)
		if item:
			_create_item_card(item_id, item)

func _create_item_card(item_id: String, item: Dictionary):
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(160, 180)
	btn.add_theme_stylebox_override("normal", _get_card_style(item.get("rarity", "common")))
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 10)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn.add_child(vbox)
	
	# Icon
	var rect = TextureRect.new()
	rect.custom_minimum_size = Vector2(64, 64)
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	var icon_path = item.get("icon", "res://Assets/items/potion_hp_large.png")
	if ResourceLoader.exists(icon_path):
		rect.texture = load(icon_path)
	else:
		rect.texture = load("res://Assets/items/potion_hp_large.png")
		
	rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(rect)
	
	# Name
	var name_lbl = Label.new()
	name_lbl.text = item.name
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", 16)
	vbox.add_child(name_lbl)
	
	# Price
	var price_lbl = Label.new()
	price_lbl.text = "%d G" % item.price
	price_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price_lbl.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(price_lbl)
	
	btn.pressed.connect(_select_item.bind(item_id))
	item_grid.add_child(btn)

func _get_card_style(rarity):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.15, 0.2, 0.8)
	style.set_corner_radius_all(10)
	style.set_border_width_all(2)
	
	match rarity:
		"common": style.border_color = Color.GRAY
		"rare": style.border_color = Color.DEEP_SKY_BLUE
		"epic": style.border_color = Color.PURPLE
		"legendary": style.border_color = Color.GOLD
		"mythic": style.border_color = Color.CRIMSON
		
	return style

func _select_item(item_id: String):
	selected_item_id = item_id
	var item = Global.item_db[item_id]
	
	var icon_path = item.get("icon", "res://Assets/items/potion_hp_large.png")
	if ResourceLoader.exists(icon_path):
		detail_icon.texture = load(icon_path)
	else:
		detail_icon.texture = load("res://Assets/items/potion_hp_large.png")
	detail_name.text = item.name
	detail_name.add_theme_color_override("font_color", Global.RARITY_COLORS.get(item.get("rarity", "common"), Color.WHITE))
	
	var stats = []
	if "atk" in item: stats.append("⚔️ ATK: +%d" % item.atk)
	if "def" in item: stats.append("🛡️ DEF: +%d" % item.def)
	if "hp" in item: stats.append("❤️ HP: +%d" % item.hp)
	if "mana" in item: stats.append("💙 MP: +%d" % item.mana)
	if "element" in item: stats.append("🌀 ธาตุ: %s" % Global.ELEMENT_NAMES.get(item.element, item.element))
	
	detail_stats.text = "\n".join(stats)
	detail_desc.text = item.desc
	detail_price.text = "💰 ราคา: %d G" % item.price
	
	buy_button.disabled = Global.player_gold < item.price
	buy_button.text = "🛒 ซื้อทันที" if Global.player_gold >= item.price else "❌ ทองไม่พอ"

func _clear_detail():
	detail_name.text = "กรุณาเลือกสินค้า"
	detail_stats.text = ""
	detail_desc.text = ""
	detail_price.text = ""
	buy_button.disabled = true

func _on_buy_pressed():
	if selected_item_id == "" or Global.player_gold < Global.item_db[selected_item_id].price:
		return
		
	var item = Global.item_db[selected_item_id]
	Global.player_gold -= item.price
	Global.add_item(selected_item_id, 1)
	Global.save_game()
	
	update_gold()
	_select_item(selected_item_id)
	
	if AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("levelup")
		
	feedback_label.text = "ซื้อ %s สำเร็จ!" % item.name
	var t = create_tween()
	t.tween_property(feedback_label, "modulate:a", 1.0, 0.2)
	t.tween_property(feedback_label, "modulate:a", 0.0, 1.0).set_delay(1.5)

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Part2/WorldMap.tscn")
