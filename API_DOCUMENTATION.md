# API Documentation

## Core Systems

### ConfigManager
**Location**: `Scripts/ConfigManager.gd`

Manages application configuration and environment variables.

#### Methods

##### `load_config() -> void`
Loads configuration from `.env` file in user data directory.

```gdscript
ConfigManager.load_config()
```

##### `get_value(section: String, key: String, default: String = "") -> String`
Gets configuration value with fallback to default.

```gdscript
var api_url = ConfigManager.get_value("llm", "api_url", "https://api.opencode.ai/v1/chat/completions")
```

##### `set_value(section: String, key: String, value: String) -> void`
Sets configuration value.

```gdscript
ConfigManager.set_value("llm", "api_key", "sk-your-key")
```

##### `save_config() -> void`
Saves configuration to file.

```gdscript
ConfigManager.save_config()
```

#### Convenience Methods

##### `get_llm_api_key() -> String`
Gets LLM API Key from environment or .env file.

```gdscript
var api_key = ConfigManager.get_llm_api_key()
if api_key.is_empty():
	print("API key not configured!")
```

##### `get_llm_api_url() -> String`
Gets LLM API URL. Returns default if not configured.

```gdscript
var url = ConfigManager.get_llm_api_url()
```

##### `get_llm_model() -> String`
Gets LLM Model name. Returns default if not configured.

```gdscript
var model = ConfigManager.get_llm_model()
```

---

### LLMService
**Location**: `Scripts/LLMService.gd`

Handles API requests to OpenCode AI for dialogue generation.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `api_key` | String | OpenCode API key (loaded from ConfigManager) |
| `api_url` | String | API endpoint URL |
| `model_name` | String | Model identifier |

#### Signals

##### `request_completed(response_text: String)`
Emitted when API returns successful response.

```gdscript
LLMService.request_completed.connect(_on_ai_response)

func _on_ai_response(response: String):
	print("AI said: ", response)
```

##### `request_failed(error_message: String)`
Emitted when API request fails.

```gdscript
LLMService.request_failed.connect(_on_ai_failed)

func _on_ai_failed(error: String):
	print("AI error: ", error)
```

#### Methods

##### `generate_response(prompt: String, system_prompt: String = "...") -> void`
Sends a request to OpenCode AI and emits signal when complete.

```gdscript
var prompt = "ช่วยสร้างคำศัพท์เกี่ยวกับสุขภาพ"
var system = "You are a helpful Thai language teacher."

LLMService.generate_response(prompt, system)
```

**Parameters:**
- `prompt`: User message/question
- `system_prompt`: System instruction for AI behavior

**Signals emmitted:**
- `request_completed(response)` - on success
- `request_failed(error)` - on failure

#### Example Usage

```gdscript
extends Node

func _ready():
	LLMService.request_completed.connect(_on_response)
	LLMService.request_failed.connect(_on_error)

func ask_ai():
	var prompt = "ให้คำเสนอแนะเกี่ยวกับการกินอาหารเพื่อสุขภาพ"
	LLMService.generate_response(prompt)

func _on_response(text: String):
	print("Response: ", text)

func _on_error(error: String):
	print("Failed: ", error)
```

---

### Global
**Location**: `Scripts/Global.gd`

Singleton containing all persistent game state.

#### Player Data

```gdscript
Global.player_name: String          # Player name
Global.player_gender: String        # "เด็กชาย" or "เด็กหญิง"
Global.player_class: String         # "อัศวิน", "จอมเวทย์", etc.
Global.player_level: int            # Current level
Global.player_xp: int              # Current experience points
Global.player_gold: int            # Currency amount
Global.current_mana: int           # Current mana points
Global.current_path: String        # "exercise", "nutrition", "hygiene"
```

#### Game State

```gdscript
Global.story_progress: int         # Current story chunk
Global.is_story_mode: bool         # True if in story battle
Global.active_quests: Array        # Active quest IDs
Global.completed_quests: Array     # Completed quest IDs
Global.used_questions: Array       # Questions asked this session
Global.current_scene: String       # Current scene path
```

#### Inventory & Equipment

```gdscript
Global.inventory: Dictionary       # {"potion": 2, ...}
Global.equipped_items: Dictionary  # {"weapon": "sword_iron", ...}
Global.enhancement_levels: Dictionary  # {"weapon": 0, ...}
```

#### Methods

##### `add_xp(amount: int) -> void`
Add experience points and handle level ups.

```gdscript
Global.add_xp(100)
```

##### `level_up() -> void`
Increase player level and stats.

```gdscript
Global.level_up()
```

##### `get_stat(stat_name: String) -> int`
Get current stat value.

```gdscript
var hp = Global.get_stat("hp")
var atk = Global.get_stat("atk")
```

##### `has_save_file() -> bool`
Check if save file exists.

```gdscript
if Global.has_save_file():
	continue_btn.disabled = false
```

##### `save_game(filename: String) -> bool`
Save game state to file.

```gdscript
var success = Global.save_game("save_1.sav")
```

##### `load_game(filename: String) -> bool`
Load game state from file.

```gdscript
if Global.load_game("save_1.sav"):
	get_tree().change_scene_to_file("res://Scenes/Crossroads.tscn")
```

---

### Battle System
**Location**: `Scripts/Battle.gd`

Main battle controller and state machine.

#### Signals

```gdscript
signal battle_ended(result: String)  # "won" or "lost"
signal state_changed(new_state)
signal question_asked(question: Dictionary)
```

#### Properties

```gdscript
var current_state: int              # Current BattleState
var player_hp: int
var player_max_hp: int
var player_mp: int
var player_max_mp: int
var enemy_hp: int
var enemy_max_hp: int
var player_atk: int
var player_def: int
```

#### Methods

##### `start_battle(enemy_id: String) -> void`
Initialize and start a battle.

```gdscript
Battle.start_battle("enemy_virus_1")
```

##### `player_attack() -> void`
Execute player attack action.

```gdscript
Battle.player_attack()
```

##### `use_item(item_id: String) -> void`
Use an item during battle.

```gdscript
Battle.use_item("potion")
```

---

### DialogueSystem
**Location**: `Scripts/DialogueSystem.gd`

Manages dialogue display and AI integration.

#### Signals

```gdscript
signal dialogue_completed
signal character_change(character_name: String)
```

#### Methods

##### `show_dialogue(speaker: String, text: String) -> void`
Display dialogue text.

```gdscript
DialogueSystem.show_dialogue("Guide", "ยินดีต้อนรับเข้าสู่เกม!")
```

##### `show_ai_dialogue(prompt: String, speaker: String = "AI") -> void`
Request AI-generated dialogue.

```gdscript
DialogueSystem.show_ai_dialogue(
	"ให้คำแนะนำเกี่ยวกับการออกกำลังกาย",
	"Health Guide"
)
```

---

### Quest System
**Location**: `Scripts/Quests/QuestManager.gd`

Manages quest creation, tracking, and completion.

#### Methods

##### `create_quest(quest_data: Dictionary) -> String`
Create new quest. Returns quest ID.

```gdscript
var quest = {
	"title": "สุขภาพดี",
	"description": "ออกกำลังกาย 30 นาที",
	"reward_xp": 100,
	"reward_gold": 50
}
var quest_id = QuestManager.create_quest(quest)
```

##### `complete_quest(quest_id: String) -> void`
Mark quest as completed.

```gdscript
QuestManager.complete_quest(quest_id)
```

##### `get_quest(quest_id: String) -> Dictionary`
Get quest data by ID.

```gdscript
var quest = QuestManager.get_quest(quest_id)
print(quest.title)
```

---

## Data Structures

### Question Dictionary
```gdscript
{
	"q": "เราควรแปรงฟันอย่างน้อยวันละกี่ครั้ง?",
	"a": "2 ครั้ง",
	"options": ["1 ครั้ง", "2 ครั้ง", "3 ครั้ง", "ไม่ต้องแปรง"],
	"topic": "hygiene"
}
```

### Enemy Dictionary
```gdscript
{
	"id": "virus_1",
	"name": "Virus Monster",
	"hp": 50,
	"atk": 10,
	"def": 5,
	"level": 1,
	"xp_reward": 50,
	"image": "res://Assets/monster_virus.png"
}
```

### Item Dictionary
```gdscript
{
	"id": "potion_health",
	"name": "Health Potion",
	"type": "consumable",
	"rarity": "common",
	"effect": "heal",
	"value": 50,
	"cost": 100
}
```

## Error Handling

### Common Errors

#### "Missing API Key"
**Cause**: API key not configured
**Solution**: 
1. Run `python3 setup_env.py`
2. Check `.env` file exists in Godot user data
3. Verify API key format (starts with `sk-`)

#### "API Request Failed (401)"
**Cause**: Invalid or expired API key
**Solution**:
1. Generate new key from OpenCode dashboard
2. Update `.env` file
3. Restart game

#### "Scene not found"
**Cause**: Missing `.tscn` file
**Solution**: Ensure all files in `Scenes/` directory exist

## Performance Considerations

### API Requests
- LLMService requests are async and non-blocking
- Use signals to handle responses
- Best to cache frequently used responses

### Battle Calculations
- Avoid recalculating stats every frame
- Cache player stats in Battle.gd
- Update UI only when values change

### Memory Management
- Clear dialogue history periodically
- Unload unused scenes
- Profile with Godot Profiler

## Testing

### Unit Test Example
```gdscript
# In your test script
extends Node

func test_quest_creation():
	var quest = QuestManager.create_quest({
		"title": "Test Quest",
		"reward_xp": 100
	})
	assert(quest != "", "Quest ID should not be empty")
	assert(Global.active_quests.has(quest), "Quest should be active")
```

### Integration Test Example
```gdscript
func test_battle_flow():
	# Start battle
	Battle.start_battle("test_enemy")
	await get_tree().create_timer(0.5)
	
	# Verify battle started
	assert(Battle.current_state == Battle.BattleState.PLAYER_TURN)
	
	# Test action
	Battle.player_attack()
	await get_tree().create_timer(0.5)
	
	# Verify enemy took damage
	assert(Battle.enemy_hp < 50, "Enemy should take damage")
```

---

**Last Updated**: February 15, 2026  
**Godot Version**: 4.4+  
**Language**: Thai & English
