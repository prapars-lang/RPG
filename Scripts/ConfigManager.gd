extends Node
# ConfigManager.gd - Manages application configuration and environment variables

var config = ConfigFile.new()
var config_path = "user://.env"
var _config_loaded: bool = false

func _ready():
	load_config()

func load_config():
	"""Load configuration from .env file in user data directory"""
	# Step 1: Check if file exists at all
	if not FileAccess.file_exists(config_path):
		return
	
	# Step 2: Read raw content and validate INI format before parsing
	# ConfigFile.load() prints internal errors we can't suppress,
	# so we check the format ourselves first.
	var file = FileAccess.open(config_path, FileAccess.READ)
	if file == null:
		return
	
	var content = file.get_as_text().strip_edges()
	file.close()
	
	# ConfigFile expects INI format starting with [section]
	# If it doesn't start with '[', it's not valid INI (e.g. raw API key)
	if content.is_empty() or not content.begins_with("["):
		# Silently skip — this is likely a raw .env file, not INI format
		return
	
	# Step 3: Now safe to parse
	var error = config.load(config_path)
	if error != OK:
		return
	
	_config_loaded = true

func get_value(section: String, key: String, default_val: String = "") -> String:
	"""Get configuration value with fallback to default"""
	if config.has_section_key(section, key):
		return config.get_value(section, key)
	return default_val

func set_value(section: String, key: String, value: String) -> void:
	"""Set configuration value"""
	config.set_value(section, key, value)

func save_config() -> void:
	"""Save configuration to file"""
	var error = config.save(config_path)
	if error != OK:
		push_warning("Failed to save configuration.")

# Convenience methods for common settings
func get_llm_api_key() -> String:
	"""Get LLM API Key from environment"""
	var api_key = get_value("llm", "api_key", "")
	if api_key.is_empty():
		api_key = OS.get_environment("OPENCODE_API_KEY")
	return api_key

func get_llm_api_url() -> String:
	"""Get LLM API URL"""
	return get_value("llm", "api_url", "https://api.opencode.ai/v1/chat/completions")

func get_llm_model() -> String:
	"""Get LLM Model name"""
	return get_value("llm", "model", "typhoon-v1.5x-70b-instruct")
