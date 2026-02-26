extends Node

# --- Profile Management System ---
# Handles a separate JSON database of all players who have used the device.

const PROFILES_PATH = "user://profiles.json"

var profiles: Dictionary = {}
var active_profile_name: String = ""

func _ready():
	load_profiles()

func load_profiles():
	if FileAccess.file_exists(PROFILES_PATH):
		var file = FileAccess.open(PROFILES_PATH, FileAccess.READ)
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			profiles = json.data
			print("[ProfileManager] Loaded ", profiles.size(), " profiles.")
		else:
			print("[ProfileManager] Error parsing profiles.json")
	else:
		profiles = {}
		print("[ProfileManager] No profile database found. Starting fresh.")

func save_profiles():
	var file = FileAccess.open(PROFILES_PATH, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(profiles))
		print("[ProfileManager] Database saved.")
	else:
		push_error("[ProfileManager] Failed to save profiles.json")

func create_profile(player_name: String) -> bool:
	if profiles.has(player_name):
		return false # Name already exists
	
	# Create a new entry in the 'small DB'
	profiles[player_name] = {
		"name": player_name,
		"created_at": Time.get_datetime_string_from_system(),
		"last_played": Time.get_datetime_string_from_system(),
		"total_lp": 0,
		"max_level": 1,
		"chapters_completed": 0,
		"save_slot": -1 # Not yet associated with a slot
	}
	save_profiles()
	return true

func update_profile_stats(player_name: String, lp: int, level: int, chapter: int):
	if profiles.has(player_name):
		var p = profiles[player_name]
		p.total_lp = max(p.total_lp, lp)
		p.max_level = max(p.max_level, level)
		p.chapters_completed = max(p.chapters_completed, chapter)
		p.last_played = Time.get_datetime_string_from_system()
		save_profiles()

func get_profile_list() -> Array:
	return profiles.values()

func set_active_profile(player_name: String):
	active_profile_name = player_name
	# When profile is selected, we update Global data
	Global.player_name = player_name
	print("[ProfileManager] Active profile set to: ", player_name)

func delete_profile(player_name: String):
	if profiles.has(player_name):
		profiles.erase(player_name)
		save_profiles()
