# Educational Fantasy RPG 🎮

A Godot 4.4-based educational fantasy RPG game designed to teach Thai youth about health, wellness, and good living habits through engaging turn-based battles with AI-powered dialogue.

## ✨ Features

### 🎭 Character System
- **4 Character Classes**: Knight, Mage, Ranger, Paladin
- **Gender Selection**: Male and Female variants  
- **Skill Trees**: Class-specific abilities and progression
- **Stat System**: HP, MP, Attack, Defense, Experience

### ⚔️ Battle System
- **Turn-Based Combat**: Strategic player vs enemy battles
- **Educational Questions**: Learning content integrated into combat
- **Difficulty Scaling**: Dynamic enemy AI based on player level
- **Special Abilities**: Class-specific skills and items

### 📚 Storyline & Quests
- **Multiple Paths**: Exercise, Nutrition, and Hygiene themed storylines
- **AI-Generated Narrative**: Dynamic dialogue using OpenCode AI
- **Quest System**: Track and complete objectives
- **Story Progression**: 100+ story chunks with branching paths

### 🛍️ Economy & Progression
- **Equipment System**: 6 equipment slots with rarity rarities (Common, Rare, Epic, Legendary, Mythic)
- **Equipment Enhancement**: Upgrade items for better stats
- **Shop System**: Purchase weapons, armor, and consumables
- **Level Up Rewards**: Stat bonuses and skill unlocks

### 💾 Save/Load
- **Game Persistence**: Save and load game progress
- **Multiple Save Slots**: Manage multiple playthroughs
- **Auto-Save**: Automatic checkpoint saving

## 🚀 Quick Start

### Prerequisites
- Godot Engine 4.4 or higher
- OpenCode AI API key (free tier available)

### Setup (5 minutes)
1. **Get API Key**: Sign up at [OpenCode AI](https://opencode.ai/) and generate an API key
2. **Configure**: Copy `.env.example` to your Godot user data folder as `.env`
3. **Edit**: Add your API key to the `.env` file
4. **Run**: Press F5 in Godot to start playing!

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions.

## 🎮 How to Play

1. **Character Selection**: Choose your class and gender
2. **Story Mode**: Follow the narrative through different themes
3. **Battle**: Answer educational questions to gain advantages
4. **Progression**: Level up, collect equipment, complete quests
5. **Victory**: Defeat all story bosses and reach the ending

## 🏗️ Project Structure

```
RPG/
├── Scripts/              # GDScript game logic
│   ├── ConfigManager.gd    # Configuration & API key management
│   ├── Global.gd           # Global game state
│   ├── LLMService.gd       # AI dialogue service
│   ├── Battle/             # Combat system
│   ├── Inventory/          # Item management
│   ├── Quests/             # Quest system
│   └── Paths/              # Story paths
├── Scenes/              # Godot scene files (.tscn)
├── Data/                # Game data (questions, quests)
├── Assets/              # Images, fonts, themes
├── project.godot        # Godot project configuration
├── SETUP_GUIDE.md       # Installation & configuration
├── .env.example         # Environment config template
└── .gitignore           # Git ignore rules
```

## 🔧 Configuration

### API Configuration
The game uses **ConfigManager** for secure API key management:

```gdscript
# Automatically loads from:
# 1. user://.env file (recommended for development)
# 2. OPENCODE_API_KEY environment variable (recommended for production)
```

See [.env.example](.env.example) for configuration options.

## 📊 Game Data

### Questions Database (`Data/questions.json`)
- 5500+ educational questions in Thai
- Topics: Body health, Hygiene, Nutrition, Exercise
- Used in battles to determine combat bonuses

### Story Chunks
- Located in `StoryData.gd`
- Supports 3 main paths with branching narratives
- AI generates dialogue variations for immersion

## 🛡️ Security

✅ **API Key Protection**:
- Never hardcoded in source files
- Loaded from environment variables or `.env` file
- `.env` is excluded from git (see `.gitignore`)
- Only `.env.example` is tracked (without credentials)

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Missing API Key" error | Create `.env` file with valid API key |
| Scenes won't load | Ensure all `.tscn` files exist in Scenes/ |
| Dialogue not appearing | Check API key validity and network connection |
| Questions not loading | Verify `questions.json` is in Data/ folder |

## 📈 Development

### Code Style
- Follow Godot GDScript conventions
- Use Thai language for game content (characters, dialogue, UI)
- Keep functions small and focused
- Document complex logic with comments

### Adding Features
1. Create scripts in appropriate subfolder (Scripts/Quests/, Scripts/Battle/, etc.)
2. Use signals for event communication
3. Update `Global.gd` if adding persistent data
4. Test in-game before committing

### Testing
- Run F5 to launch the game
- Check Output console for errors
- Verify all scenes load without errors
- Test save/load functionality

## 🎓 Educational Content

The game focuses on teaching Thai youth:
- **Hygiene**: Proper handwashing, dental care, cleanliness
- **Nutrition**: Healthy diet, balanced meals, avoiding junk food  
- **Exercise**: Physical activity, benefits of movement
- **Body Knowledge**: Understanding organs and body systems

Questions are presented during battles to reinforce learning while maintaining engagement.

## 📝 License

[Your License Here]

## 👥 Contributors

- Game Design & Development: [Your Name]
- AI Integration: OpenCode AI Platform
- Educational Content: [Content Creator]

## 🙏 Acknowledgments

- **Godot Foundation**: For the amazing game engine
- **OpenCode AI**: For Thai language AI capabilities
- **Community**: For support and feedback

---

**Current Version**: 1.0.0  
**Last Updated**: February 15, 2026  
**Engine**: Godot 4.4  
**Language**: Thai (ไทย) & English

🌟 Star this project if you find it useful!
