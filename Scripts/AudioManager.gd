extends Node

# Audio Manager for Educational Fantasy RPG
# Handles all music, sound effects, and audio settings
# Autoload: Initialized as singleton

# Audio Buses
const MASTER_BUS = "Master"
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

# Default volumes (in dB)
const DEFAULT_MUSIC_VOLUME = 0.0  # Music volume increased for better web audibility
const DEFAULT_SFX_VOLUME = 0.0

# BGM Configuration
var current_bgm: AudioStreamPlayer = null
var current_bgm_key: String = ""
var bgm_fade_tween: Tween = null
var is_music_playing: bool = false

# SFX Configuration
var sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS = 8  # Pool of simultaneous SFX

# Audio File Paths
var bgm_paths = {
	"main_menu": "res://Audio/bgm_menu.ogg",
	"menu": "res://Audio/bgm_menu.ogg",
	"battle": "res://Audio/bgm_battle.ogg",
	"story": "res://Audio/bgm_story.ogg",
	"forest": "res://Audio/bgm_forest.ogg",
	"boss": "res://Audio/bgm_boss.ogg",
	"victory": "res://Audio/bgm_victory.ogg",
}

var sfx_paths = {
	"button_click": "res://Audio/sfx_button.ogg",
	"button_hover": "res://Audio/sfx_hover.ogg",
	"attack": "res://Audio/sfx_attack.ogg",
	"hit": "res://Audio/sfx_hit.ogg",
	"heal": "res://Audio/sfx_heal.ogg",
	"levelup": "res://Audio/sfx_levelup.ogg",
	"victory": "res://Audio/sfx_victory.ogg",
	"defeat": "res://Audio/sfx_defeat.ogg",
	"menu_open": "res://Audio/sfx_menu_open.ogg",
	"menu_close": "res://Audio/sfx_menu_close.ogg",
	"typing": "res://Audio/sfx_typing.ogg",
}

# Mute states
var music_muted: bool = false
var sfx_muted: bool = false

func _ready():
	"""Initialize audio manager"""
	# Create audio buses if they don't exist
	_setup_audio_buses()
	
	# Force-start audio context on input (Browser Workaround)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Create SFX player pool
	_create_sfx_pool()
	
	# Load saved audio settings from config
	_load_audio_settings()
	
	print("[AudioManager] Initialized successfully!")
	print("  - Music Bus Volume: %.1f dB" % get_music_volume())
	print("  - SFX Bus Volume: %.1f dB" % get_sfx_volume())
	print("  - BGM Paths: %d loaded" % bgm_paths.size())
	print("  - SFX Paths: %d loaded" % sfx_paths.size())

func _input(event):
	# Web Audio Context Fix: Resume simple audio context on first click
	if event is InputEventMouseButton and event.pressed:
		if is_music_playing and current_bgm != null and not current_bgm.playing:
			current_bgm.play()

func _setup_audio_buses():
	"""Create master, music, and sfx audio buses"""
	var audio_bus_layout = AudioServer.get_bus_count()
	
	# Check if buses already exist
	if AudioServer.get_bus_index(MUSIC_BUS) == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, MUSIC_BUS)
		AudioServer.set_bus_send(AudioServer.get_bus_count() - 1, MASTER_BUS)
	
	if AudioServer.get_bus_index(SFX_BUS) == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, SFX_BUS)
		AudioServer.set_bus_send(AudioServer.get_bus_count() - 1, MASTER_BUS)
	
	# Set default volumes
	set_music_volume(DEFAULT_MUSIC_VOLUME)
	set_sfx_volume(DEFAULT_SFX_VOLUME)

func _create_sfx_pool():
	"""Create a pool of AudioStreamPlayer nodes for sound effects"""
	sfx_players.clear()
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		sfx_players.append(player)

func _load_audio_settings():
	"""Load audio settings from config if available"""
	# This can be extended to load from a config file
	# For now, use defaults
	pass

# ============== BACKGROUND MUSIC ==============

func play_bgm(bgm_key: String, fade_in_duration: float = 1.0) -> void:
	"""Play background music with optional fade-in"""
	if bgm_key not in bgm_paths:
		push_error("BGM key not found: %s" % bgm_key)
		return
	
	var bgm_path = bgm_paths[bgm_key]
	
	# Load the audio file
	var audio_stream = load(bgm_path)
	if audio_stream == null:
		push_error("Failed to load BGM: %s" % bgm_path)
		return
	
	# Stop current BGM if playing
	if current_bgm != null:
		stop_bgm(fade_in_duration)
	
	# Create new BGM player
	current_bgm = AudioStreamPlayer.new()
	current_bgm.stream = audio_stream
	current_bgm.bus = MUSIC_BUS
	current_bgm.volume_db = -80.0  # Start silent
	add_child(current_bgm)
	current_bgm.play()
	is_music_playing = true
	current_bgm_key = bgm_key
	
	# Fade in
	_fade_music(0.0, get_music_volume(), fade_in_duration)

func stop_bgm(fade_out_duration: float = 1.0) -> void:
	"""Stop background music with optional fade-out"""
	if current_bgm == null:
		return
	
	_fade_music(get_music_volume(), -80.0, fade_out_duration)
	await get_tree().create_timer(fade_out_duration).timeout
	
	if current_bgm != null:
		current_bgm.stop()
		current_bgm.queue_free()
		current_bgm = null
		is_music_playing = false

func pause_bgm() -> void:
	"""Pause current background music"""
	if current_bgm != null:
		current_bgm.stream_paused = true

func resume_bgm() -> void:
	"""Resume paused background music"""
	if current_bgm != null:
		current_bgm.stream_paused = false

func _fade_music(from_db: float, to_db: float, duration: float) -> void:
	"""Fade music from one volume to another"""
	if bgm_fade_tween != null:
		bgm_fade_tween.kill()
	
	if current_bgm == null:
		return
	
	bgm_fade_tween = create_tween()
	bgm_fade_tween.tween_property(current_bgm, "volume_db", to_db, duration)

# ============== SOUND EFFECTS ==============

func play_sfx(sfx_key: String, volume_offset: float = 0.0) -> void:
	"""Play a sound effect from the library"""
	if sfx_key not in sfx_paths:
		push_error("SFX key not found: %s" % sfx_key)
		return
	
	var sfx_path = sfx_paths[sfx_key]
	var audio_stream = load(sfx_path)
	
	if audio_stream == null:
		push_error("Failed to load SFX: %s" % sfx_path)
		return
	
	# Find an available player
	var available_player = null
	for player in sfx_players:
		if not player.playing:
			available_player = player
			break
	
	if available_player == null:
		# If no players available, use the first one (oldest sound gets cut off)
		available_player = sfx_players[0]
	
	# Play the SFX
	available_player.stream = audio_stream
	available_player.volume_db = get_sfx_volume() + volume_offset
	available_player.play()

func play_sfx_at_position(sfx_key: String, position: Vector2, volume_offset: float = 0.0) -> void:
	"""Play a spatial sound effect (future enhancement)"""
	# For now, just play regular SFX
	# Can be extended for 3D audio positioning
	play_sfx(sfx_key, volume_offset)

# ============== VOLUME CONTROL ==============

func set_music_volume(volume_db: float) -> void:
	"""Set music bus volume (in dB)"""
	var music_bus_idx = AudioServer.get_bus_index(MUSIC_BUS)
	if music_bus_idx != -1:
		AudioServer.set_bus_volume_db(music_bus_idx, volume_db)

func set_sfx_volume(volume_db: float) -> void:
	"""Set SFX bus volume (in dB)"""
	var sfx_bus_idx = AudioServer.get_bus_index(SFX_BUS)
	if sfx_bus_idx != -1:
		AudioServer.set_bus_volume_db(sfx_bus_idx, volume_db)

func set_master_volume(volume_db: float) -> void:
	"""Set master bus volume (in dB)"""
	var master_bus_idx = AudioServer.get_bus_index(MASTER_BUS)
	if master_bus_idx != -1:
		AudioServer.set_bus_volume_db(master_bus_idx, volume_db)

func get_music_volume() -> float:
	"""Get current music volume in dB"""
	var music_bus_idx = AudioServer.get_bus_index(MUSIC_BUS)
	if music_bus_idx != -1:
		return AudioServer.get_bus_volume_db(music_bus_idx)
	return DEFAULT_MUSIC_VOLUME

func get_sfx_volume() -> float:
	"""Get current SFX volume in dB"""
	var sfx_bus_idx = AudioServer.get_bus_index(SFX_BUS)
	if sfx_bus_idx != -1:
		return AudioServer.get_bus_volume_db(sfx_bus_idx)
	return DEFAULT_SFX_VOLUME

# ============== MUTE TOGGLE ==============

func toggle_music_mute() -> bool:
	"""Toggle music mute state"""
	var music_bus_idx = AudioServer.get_bus_index(MUSIC_BUS)
	if music_bus_idx != -1:
		music_muted = !music_muted
		AudioServer.set_bus_mute(music_bus_idx, music_muted)
	return music_muted

func toggle_sfx_mute() -> bool:
	"""Toggle SFX mute state"""
	var sfx_bus_idx = AudioServer.get_bus_index(SFX_BUS)
	if sfx_bus_idx != -1:
		sfx_muted = !sfx_muted
		AudioServer.set_bus_mute(sfx_bus_idx, sfx_muted)
	return sfx_muted

func toggle_master_mute() -> bool:
	"""Toggle master mute state"""
	var master_bus_idx = AudioServer.get_bus_index(MASTER_BUS)
	if master_bus_idx != -1:
		var is_muted = AudioServer.is_bus_mute(master_bus_idx)
		AudioServer.set_bus_mute(master_bus_idx, !is_muted)
		return !is_muted
	return false

func set_music_mute(muted: bool) -> void:
	"""Set music mute state"""
	var music_bus_idx = AudioServer.get_bus_index(MUSIC_BUS)
	if music_bus_idx != -1:
		music_muted = muted
		AudioServer.set_bus_mute(music_bus_idx, muted)

func set_sfx_mute(muted: bool) -> void:
	"""Set SFX mute state"""
	var sfx_bus_idx = AudioServer.get_bus_index(SFX_BUS)
	if sfx_bus_idx != -1:
		sfx_muted = muted
		AudioServer.set_bus_mute(sfx_bus_idx, muted)

# ============== CONVERSION HELPERS ==============

func linear_to_db(linear: float) -> float:
	"""Convert linear volume (0.0-1.0) to decibels"""
	if linear <= 0:
		return -80.0
	return 20.0 * log(linear) / log(10.0)

func db_to_linear(db: float) -> float:
	"""Convert decibels to linear volume (0.0-1.0)"""
	return pow(10.0, db / 20.0)

# ============== UTILITY ==============

func stop_all_sfx() -> void:
	"""Stop all currently playing sound effects"""
	for player in sfx_players:
		if player.playing:
			player.stop()

func add_bgm_path(key: String, path: String) -> void:
	"""Add a new BGM path dynamically"""
	bgm_paths[key] = path

func add_sfx_path(key: String, path: String) -> void:
	"""Add a new SFX path dynamically"""
	sfx_paths[key] = path

func is_bgm_playing() -> bool:
	"""Check if background music is currently playing"""
	return is_music_playing and current_bgm != null and current_bgm.playing

# Debug/Testing
func print_audio_status() -> void:
	"""Print current audio system status"""
	print("\n=== AUDIO SYSTEM STATUS ===")
	print("Music Volume: %.1f dB" % get_music_volume())
	print("SFX Volume: %.1f dB" % get_sfx_volume())
	print("Music Muted: %s" % music_muted)
	print("SFX Muted: %s" % sfx_muted)
	print("BGM Playing: %s" % is_bgm_playing())
	print("SFX Playing: %d/%d" % [sfx_players.filter(func(p): return p.playing).size(), MAX_SFX_PLAYERS])
	print("===========================\n")
