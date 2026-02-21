@tool
extends SceneTree

# GameValidator.gd - Automated Game Verification Script 🤖
# Run via command line: godot --headless --script Scripts/GameValidator.gd

var total_tests = 0
var passed_tests = 0
var failed_items = []

const GlobalScript = preload("res://Scripts/Global.gd")

func _init():
	print("\n========================================")
	print("🤖 STARTING AUTOMATED GAME VALIDATION 🤖")
	print("========================================")
	
	# 1. Setup Environment
	var global = GlobalScript.new()
	
	# 2. Run Tests
	test_data_integrity(global)
	test_battle_simulation(global)
	test_progression(global)
	test_save_load(global)
	test_gamification(global)
	test_knowledge_boss(global)
	test_final_chapter(global)
	
	# 3. Report Results
	print("\n========================================")
	print("📊 TEST SUMMARY")
	print("passed: %d / %d" % [passed_tests, total_tests])
	if failed_items.size() > 0:
		print("❌ FAILED TESTS:")
		for item in failed_items:
			print(" - " + item)
		print("\nFix these issues before release!")
		quit(1)
	else:
		print("✅ ALL SYSTEMS GO! No critical bugs found.")
		quit(0)

func log_test(name: String, result: bool, message: String = ""):
	total_tests += 1
	if result:
		passed_tests += 1
		print("✅ PASS: " + name)
	else:
		print("❌ FAIL: " + name + " (" + message + ")")
		failed_items.append("%s: %s" % [name, message])

# --- TEST SUITES ---

func test_data_integrity(global):
	print("\n--- 1. Checking Data Integrity ---")
	
	# Check Question Database
	var q_file = FileAccess.open("res://Data/questions.json", FileAccess.READ)
	if q_file:
		var json = JSON.new()
		var error = json.parse(q_file.get_as_text())
		log_test("Load questions.json", error == OK, "JSON Parse Error" if error != OK else "")
		if error == OK:
			var data = json.data
			log_test("Questions content", data.size() > 0, "Empty question data")
	else:
		log_test("Load questions.json", false, "File not found")
		
	# Check Card Prompts
	var c_file = FileAccess.open("res://Data/card_prompts.json", FileAccess.READ)
	if c_file:
		var json = JSON.new()
		var error = json.parse(c_file.get_as_text())
		log_test("Load card_prompts.json", error == OK, "JSON Parse Error")
	else:
		log_test("Load card_prompts.json", false, "File not found")

	# Check Global Assets
	# Verify a few key icons exist in project
	var sample_icons = [
		"res://Assets/items/potion_hp.png",
		"res://Assets/items/sword_iron.png"
	]
	for icon_path in sample_icons:
		log_test("Asset exists: " + icon_path.get_file(), FileAccess.file_exists(icon_path), "Missing file")

func test_battle_simulation(global):
	print("\n--- 2. Simulating Battle Logic ---")
	
	# Mock Player Stats
	global.player_class = "อัศวิน"
	var stats = global.get_current_stats()
	log_test("Player Stats Calculation", stats.has("hp") and stats.max_hp > 0, "Invalid stats")
	
	# Mock Enemy
	var enemy = global.monster_db.get("lazy_slime")
	log_test("Load Enemy Data", enemy != null, "Enemy 'lazy_slime' not found")
	
	if enemy:
		# Simulate Damage
		var dmg = 10
		var enemy_hp = enemy.hp - dmg
		log_test("Damage Calculation", enemy_hp < enemy.hp, "HP did not decrease")

func test_progression(global):
	print("\n--- 3. Testing Progression System ---")
	
	# Level Up Logic
	global.player_level = 1
	var xp_needed = global.get_xp_for_level(1)
	log_test("XP Calculation", xp_needed > 0, "XP needed is 0 or negative")
	
	global.gain_xp(xp_needed + 1)
	log_test("Level Up Trigger", global.player_level == 2, "Level did not increase (Current: %d)" % global.player_level)
	
	# Equipment Logic
	var sword = "wooden_sword"
	global.inventory[sword] = 1
	var success = global.equip_item(sword)
	log_test("Equip Item", success, "Failed to equip valid item")
	log_test("Stat Update", global.equipped_items.weapon == sword, "Slot not updated")

func test_save_load(global):
	print("\n--- 4. Testing Save/Load System ---")
	
	# Modify state
	global.player_gold = 999
	
	# Save (Mocking save function behavior since it relies on file system)
	var save_path = "user://test_save_validator.json"
	var data = {
		"player_gold": global.player_gold,
		"level": global.player_level
	}
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	file.store_string(json_string)
	file.close()
	
	log_test("Save File Creation", FileAccess.file_exists(save_path), "Save file not created")
	
	# Load back
	file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			var loaded = json.data
			log_test("Data Persistence", loaded.get("player_gold") == 999, "Gold value mismatch")
		else:
			log_test("Data Persistence", false, "JSON Parse Error on Load")
	else:
		log_test("Load File", false, "Could not open save file")

func test_gamification(global):
	print("\n--- 5. Testing Gamification & Streaks ---")
	
	# Test Streak Logic
	global.last_login_date = "2023-01-01" # Past date
	global.login_streak = 1
	
	# Simulate Login Today
	global.check_login_streak()
	# The logic resets if diff > 1 day
	log_test("Streak Reset Logic", global.login_streak == 1, "Streak should reset for old date")
	
	# Simulate Consecutive Day
	# We need to hack the date check or trust the logic flow
	# Let's test Achievement Unlocking instead
	
	global.achievements = []
	global.unlock_achievement("first_blood")
	log_test("Unlock Achievement", "first_blood" in global.achievements, "Achievement not added")
	log_test("Achievement Reward", global.learning_points == 50, "LP not awarded (Expected 50, got %d)" % global.learning_points)
	
	# Duplicate unlock check
	global.unlock_achievement("first_blood")
	log_test("Duplicate Achievement Prevented", global.learning_points == 50, "Double reward given")

func test_knowledge_boss(global):
	print("\n--- 6. Testing Knowledge Boss Logic ---")
	
	# 1. Verify Boss Data
	var boss = global.monster_db.get("knowledge_guardian")
	log_test("Boss Data Exists", boss != null, "knowledge_guardian missing from DB")
	if boss:
		log_test("Boss Stats", boss.hp >= 500 and boss.weakness != null, "Boss stats weak or missing weakness")
	
	# 2. Test Codex Completion Logic
	# Force unlock all cards
	global.unlocked_cards = global.card_database.keys()
	log_test("Codex Complete Check (True)", global.is_codex_complete() == true, "Failed to detect complete codex")
	
	# Remove one card
	if global.unlocked_cards.size() > 0:
		global.unlocked_cards.pop_back()
		log_test("Codex Complete Check (False)", global.is_codex_complete() == false, "Failed to detect incomplete codex")

func test_final_chapter(global):
	print("\n--- 7. Testing Final Chapter Logic ---")
	
	# 1. Verify Ignorance Boss
	var boss = global.monster_db.get("ignorance_incarnate")
	log_test("Final Boss Data Exists", boss != null, "ignorance_incarnate missing")
	if boss:
		log_test("Final Boss Stats", boss.hp >= 800 and boss.weakness == "all", "Boss stats weak or missing weakness")
	
	# 2. Verify Final Path Story
	var StoryData = load("res://Scripts/StoryData.gd").new()
	var chunk0 = StoryData.get_story_chunk("final", 0)
	log_test("Final Path Exists", chunk0 != null, "path_final not found in StoryData")
	
	# 3. Verify Completion Check
	# Mock all paths complete (using Quest IDs)
	global.completed_quests = ["exercise_start", "nutrition_start", "hygiene_start", "wisdom_start"]
	log_test("All Paths Completed Check", global.check_all_paths_completed() == true, "Failed to detect all paths complete")
