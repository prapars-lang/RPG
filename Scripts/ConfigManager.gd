extends Node
# ConfigManager.gd - Manages application configuration and environment variables

var config = ConfigFile.new()
var config_path = "user://.env"

func _ready():
	load_config()

func load_config():
	"""Load configuration from .env file in user data directory"""
	var error = config.load(config_path)
	
	if error != OK:
		push_warning("Config file not found at %s. Using default values." % config_path)
		return
	
	print("Configuration loaded from: ", config_path)

func get_value(section: String, key: String, default: String = "") -> String:
	"""Get configuration value with fallback to default"""
	if config.has_section_key(section, key):
		return config.get_value(section, key)
	return default

func set_value(section: String, key: String, value: String) -> void:
	"""Set configuration value"""
	config.set_value(section, key, value)

func save_config() -> void:
	"""Save configuration to file"""
	var error = config.save(config_path)
	if error == OK:
		print("Configuration saved to: ", config_path)
	else:
		push_error("Failed to save configuration. Error code: ", error)

# Convenience methods for common settings
func get_llm_api_key() -> String:
	"""Get LLM API Key from environment"""
	# First try to get from .env file
	var api_key = get_value("llm", "api_key", "")
	
	# If not found in .env, try to use environment variable
	if api_key.is_empty():
		api_key = OS.get_environment("OPENCODE_API_KEY")
	
	return api_key

func get_llm_api_url() -> String:
	"""Get LLM API URL"""
	return get_value("llm", "api_url", "https://api.opencode.ai/v1/chat/completions")

func get_llm_model() -> String:
	"""Get LLM Model name"""
	return get_value("llm", "model", "typhoon-v1.5x-70b-instruct")
