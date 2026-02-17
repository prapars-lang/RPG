# Setup Guide - Educational Fantasy RPG

## Game Overview
Educational Fantasy RPG is a Godot 4.4-based educational game where players learn health and wellness topics through turn-based battles with AI-powered dialogue.

## System Requirements
- Godot Engine 4.4 or higher
- OpenCode AI API key (for dialogue generation)
- 2GB available disk space

## Installation & Setup

### 1. Configure API Key
The game uses OpenCode AI's Typhoon model for dialogue. You need to set up your API key:

#### Option A: Using Environment File (Recommended for Development)
1. Copy `.env.example` to the Godot user data directory:
   - **Windows**: `%APPDATA%\Godot\app_userdata\<your_project_name>\.env`
   - **macOS**: `~/Library/Application Support/Godot/app_userdata/<your_project_name>/.env`
   - **Linux**: `~/.local/share/godot/app_userdata/<your_project_name>/.env`

2. Edit the `.env` file and replace `sk-your-api-key-here` with your actual OpenCode API key

3. Save the file

#### Option B: Using Environment Variable (Recommended for Production)
Set the `OPENCODE_API_KEY` environment variable:
- **Windows (PowerShell)**: `$env:OPENCODE_API_KEY="your-api-key"`
- **macOS/Linux**: `export OPENCODE_API_KEY="your-api-key"`

### 2. Get Your OpenCode API Key
1. Visit [OpenCode AI Platform](https://opencode.ai/)
2. Create an account or sign in
3. Generate an API key from your dashboard
4. Copy the API key starting with `sk-`

### 3. Run the Game
1. Open the project in Godot Engine 4.4+
2. Click "Play" (F5) to run the game
3. The game will automatically load your configuration on startup

## Project Structure

```
Scripts/
├── ConfigManager.gd          # ✨ NEW: Manages API keys and config
├── Global.gd                 # Global game state and player data
├── LLMService.gd            # AI dialogue service (Updated)
├── Battle.gd                # Turn-based battle system
├── CharacterSelection.gd     # Character creation
├── DialogueSystem.gd         # Dialogue UI and management
├── StoryData.gd             # Story content
├── StoryScene.gd            # Story progression
├── MainMenu.gd              # Main menu UI
├── Battle/
│   └── BattleEffectManager.gd
├── Inventory/
│   ├── InventoryMenu.gd
│   ├── ItemGrid.gd
│   ├── ItemUsage.gd
│   └── StatusUI.gd
├── Paths/
│   ├── PathCard.gd
│   └── PathData.gd
└── Quests/
    ├── QuestManager.gd
    ├── QuestLog.gd
    └── QuestData.gd

Data/
└── questions.json           # Educational content questions

Assets/
├── img/                      # Character and UI images
├── items/                    # Item sprites
├── *.png.import             # Godot import files
└── MainTheme.tres           # UI theme

Scenes/
├── MainMenu.tscn            # Game start
├── CharacterSelection.tscn   # Character creation
├── IntroStory.tscn          # Story introduction
├── Crossroads.tscn          # Path selection
├── Battle.tscn              # Battle scene
├── StoryScene.tscn          # Story progression
├── Shop.tscn                # Equipment shop
├── InventoryMenu.tscn       # Inventory management
├── QuestLog.tscn            # Quest tracking
├── LevelUpUI.tscn           # Level up display
├── VictoryScene.tscn        # Battle victory
├── PauseMenu.tscn           # Pause menu
├── Credits.tscn             # Credits
├── DialogueSystem.tscn       # AI Dialogue system
└── OptionsMenu.tscn         # Game settings
```

## Game Features

### Character System
- 4 Classes × 2 Genders = 8 unique character combinations
- Classes: Knight (อัศวิน), Mage (จอมเวทย์), Ranger (นักล่า), Paladin (ผู้พิทักษ์)

### Battle System
- Turn-based combat
- Educational questions integrate into battles
- Answer correctly to deal more damage or reduce enemy damage
- Experience points and leveling system

### Equipment & Inventory
- 6 equipment slots (weapon, head, body, hands, feet, accessory)
- Equipment enhancement and rarity system
- Item shop for upgrades

### Story Mode
- Multiple narrative paths (Exercise, Nutrition, Hygiene)
- AI-generated responses for immersive storytelling
- Quest system for additional objectives

## Security Notes

⚠️ **Important**: Never commit your `.env` file with real API keys to version control!

The following files are automatically excluded from git:
- `.env` - Your actual configuration
- `.env.local` - Local overrides
- `.env.*.local` - Environment-specific config
- Any files matching pattern in `.gitignore`

Only `.env.example` is tracked (without real credentials).

## Troubleshooting

### "Missing API Key" Error
- Ensure you've created the `.env` file in the correct location
- Check that the API key is correct (starts with `sk-`)
- Verify the file format matches `.env.example`

### API Request Failed (Code 401)
- Your API key may be invalid or expired
- Generate a new key from OpenCode AI dashboard
- Ensure there are no extra spaces in your API key

### Game Won't Start
- Make sure Godot 4.4+ is installed
- Check the Output console for error messages
- Verify all scene files exist in Scenes/

## Development

### Code Standards
- All code must be complete and not abbreviated
- Modular architecture: split large files into smaller components
- Use meaningful variable and function names in Thai language for game content

### Running Tests
- Use Godot's built-in GDScript unit testing
- Check the Output console for any push_error messages

## Credits
- Game Engine: Godot 4.4
- AI Platform: OpenCode AI (Typhoon Model)
- Language: Thai (ไทย)
- Genre: Educational RPG

## License
[Add your license information here]

---

**Last Updated**: February 15, 2026
