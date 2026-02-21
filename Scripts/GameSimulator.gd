@tool
extends SceneTree

# GameSimulator.gd - Automated "Simulated Player" 🤖
# Run via command line: godot --headless --script Scripts/GameSimulator.gd
# This script simulates a full playthrough of the game to find bugs and balance issues.

var global
var total_battles = 0
var total_wins = 0
var total_losses = 0
var errors_found = []

# Mock constraints
const MAX_TURNS = 20

func _init():
	print("\n========================================")
	print("🤖 STARTING GAME SIMULATION (SimBot) 🤖")
	print("========================================")
	
	setup_simulation()
	run_simulation()
	print_report()
	
	quit(0 if errors_found.size() == 0 else 1)

func setup_simulation():
	print("[Setup] Initializing Game Environment...")
	# Load Global script manually
	var GlobalScript = load("res://Scripts/Global.gd")
	global = GlobalScript.new()
	
	# Reset state
	global.player_level = 1
	global.player_xp = 0
	global.player_gold = 100
	global.inventory = {"potion_hp": 3}
	global.player_class = "อัศวิน" # Use valid class
	global.player_name = "SimBot"
	
	# Initialize stats for class
	global.stats = {
		"อัศวิน": {"hp": 120, "max_hp": 120, "mana": 30, "max_mana": 30, "atk": 15, "def": 12}
	}
	
	print("[Setup] Player: " + global.player_name + " (" + global.player_class + ")")

func log_error(msg):
	print("❌ ERROR: ", msg)
	errors_found.append(msg)

func run_simulation():
	var paths = ["exercise", "nutrition", "hygiene", "wisdom"]
	
	for path in paths:
		print("\n--- Simulating Path: " + path.to_upper() + " ---")
		global.current_path = path
		
		# Fight 3 random battles
		for i in range(3):
			var monster_id = global.get_monster_for_path(path)
			if monster_id:
				simulate_battle(monster_id)
			else:
				log_error("No monster found for path: " + path)
		
		# Boss Battle (Simulated) - Pick the toughest in path if possible or hardcode
		var boss_id = ""
		if path == "exercise": boss_id = "couch_golem"
		elif path == "nutrition": boss_id = "junk_food_king"
		elif path == "hygiene": boss_id = "plague_lord"
		elif path == "wisdom": boss_id = "overthinking_golem"
		
		if boss_id:
			print("🚨 BOSS FIGHT: " + boss_id.to_upper())
			simulate_battle(boss_id)
		
		# Heal up
		var s = global.stats[global.player_class]
		s.hp = s.max_hp
		print("[Camp] Rested and recovered full HP.")

func simulate_battle(monster_id):
	total_battles += 1
	var monster = global.monster_db.get(monster_id)
	
	if not monster:
		log_error("Monster data missing for: " + monster_id)
		return

	print("⚔️ vs " + monster.name + " (HP: " + str(monster.hp) + ")")
	
	var enemy_hp = monster.hp
	var s = global.stats[global.player_class]
	var turns = 0
	
	while enemy_hp > 0 and s.hp > 0 and turns < MAX_TURNS:
		turns += 1
		
		# Player Attack
		var dmg = s.atk + randi() % 5
		enemy_hp -= dmg
		
		if enemy_hp <= 0:
			break
			
		# Enemy Attack
		var enemy_dmg = max(1, monster.atk - int(s["def"] * 0.5))
		s.hp -= enemy_dmg
	
	if s.hp > 0:
		total_wins += 1
		print("   WIN in " + str(turns) + " turns. HP left: " + str(s.hp))
		global.gain_xp(monster.xp)
		global.add_gold(monster.get("gold", 10))
	else:
		total_losses += 1
		print("   LOSE. " + monster.name + " was too strong.")
		# Auto revive
		s.hp = s.max_hp

func print_report():
	print("\n========================================")
	print("📊 SIMULATION REPORT")
	print("Battles: %d | Wins: %d | Losses: %d" % [total_battles, total_wins, total_losses])
	print("Final Level: %d" % global.player_level)
	print("Gold: %d" % global.player_gold)
	if errors_found.size() > 0:
		print("❌ ERRORS FOUND: ", errors_found)
	else:
		print("✅ SIMULATION PASSED")
	print("========================================")
