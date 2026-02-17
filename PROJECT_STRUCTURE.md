# 🌸 Project Structure - Flower Mind Map

## หลักการจัดระเบียบไฟล์ (Modular Architecture)

โปรเจคนี้ใช้ **Flower Mind Mapping** pattern เพื่อจัดระเบียบโค้ดให้เป็นโมดูลย่อย แต่ละโมดูลมีความรับผิดชอบที่ชัดเจน ลดการ coupling และง่ายต่อการบำรุงรักษา

---

## 🌺 Core Structure (หัวใจ)

```
Scripts/
│
├── 🔴 GLOBAL SYSTEMS (5 ไฟล์ - Global logic)
│   ├── Global.gd                    # Main game state, questions, XP
│   ├── ConfigManager.gd             # Configuration & API keys
│   ├── LLMService.gd                # AI dialogue integration
│   ├── StoryData.gd                 # Story content
│   └── README_GLOBAL.md             # Integration guide
│
├── 🟠 UI SYSTEMS (4 ไฟล์ - User interface)
│   ├── UIThemeManager.gd            # Colors, fonts, animations
│   ├── MainMenu.gd                  # Main menu logic
│   ├── DialogueSystem.gd            # Dialogue display
│   └── README_UI.md                 # UI architecture guide
│
├── 🟡 BATTLE SYSTEMS (3+ ไฟล์ - Combat logic)
│   ├── Battle.gd                    # Battle controller
│   ├── Battle/
│   │   ├── BattleEffectManager.gd   # Visual effects & animations
│   │   ├── BattleCalculations.gd    # Damage/XP calculations [FUTURE]
│   │   └── README_BATTLE.md         # Battle module guide
│   └── (extensions)
│
├── 🟢 QUEST SYSTEMS (2 ไฟล์ - Quest management)
│   ├── Quests/
│   │   └── QuestManager.gd          # Quest data & logic
│   └── README_QUESTS.md             # Quest system guide
│
├── 🔵 SCENE SCRIPTS (10+ ไฟล์ - Scene-specific logic)
│   ├── CharacterSelection.gd        # Character selection
│   ├── IntroStory.gd                # Intro story
│   ├── Battle.gd                    # (also listed in Battle Systems)
│   ├── StoryScene.gd                # Story progression
│   ├── Crossroads.gd                # Path selection
│   ├── Shop.gd                      # Shop logic
│   ├── SaveLoadMenu.gd              # Save/Load management
│   ├── PauseMenu.gd                 # Pause menu
│   ├── VictoryScene.gd              # Victory display
│   ├── InventoryMenu.gd             # Inventory [TODO]
│   └── (more scenes...)
│
└── 📋 CONFIG & UTILITIES
    ├── README_INTEGRATION.md        # How modules connect
    └── CORE_WORKING_GUIDELINES.md   # Development rules
```

---

## 🌻 Detailed Module Breakdown

### 🔴 GLOBAL SYSTEMS - Responsibilities

**Global.gd (800+ lines)**
- Player state (level, HP, MP, gold, class)
- Question selection & tracking (`used_questions`)
- Save/Load game data
- XP & leveling calculations
- **Future split candidates:**
  - `PlayerSystem.gd` - Player stats/progression
  - `QuestionSystem.gd` - Question selection logic
  - `SaveSystem.gd` - Save/load operations

**ConfigManager.gd**
- Load `.env` configuration
- API key management
- Settings storage

**LLMService.gd**
- OpenCode API calls
- Response generation
- Error handling

**StoryData.gd**
- Story chunks by path/chapter
- Quest activation triggers

---

### 🟠 UI SYSTEMS - Responsibilities

**UIThemeManager.gd (250+ lines)**
- Color constants (primary, accent, text, etc.)
- Font size definitions
- Button/panel/label styling methods
- Animation helpers (fade, hover, glow, etc.)

**MainMenu.gd**
- Menu button styling & interactions
- Character animation
- Scene transitions

**DialogueSystem.gd**
- Dialogue box display
- NPC name & text rendering
- Dialogue progression

---

### 🟡 BATTLE SYSTEMS - Responsibilities

**Battle.gd (Main Controller)**
- Battle state machine (START, PLAYER_TURN, QUESTION_TIME, ENEMY_TURN, WON, LOST)
- Question presentation
- Action execution (Attack, Skill, Item)
- UI updates

**BattleEffectManager.gd**
- Camera shake
- Sprite flash effects
- Damage number display
- Particle effects
- Sound effects [if added later]

**BattleCalculations.gd [FUTURE REFACTOR]**
- Damage calculations
- XP reward calculation
- Defense mechanics
- Skill effects

---

## 🔗 Integration Pattern (How modules connect)

```
┌─────────────────────────────────────┐
│         Global.gd (Central Hub)    │
│  - Player data                      │
│  - Questions & used_questions       │
│  - Save/Load state                  │
└──────────────┬──────────────────────┘
               │
       ┌───────┼───────┐
       │       │       │
       ▼       ▼       ▼
    ┌──────────────────────────┐
    │   Scene Scripts          │
    │  - MainMenu.gd           │
    │  - CharacterSelection.gd │
    │  - Battle.gd             │
    └──────────────────────────┘
       │       │       │
       ▼       ▼       ▼
    ┌──────────────────────────┐
    │   System Modules         │
    │  - UIThemeManager        │
    │  - BattleEffectManager   │
    │  - DialogueSystem        │
    └──────────────────────────┘
```

**Example: When Battle needs a question:**
```gdscript
# In Battle.gd
func show_question():
	var grade = Global.get_current_grade()
	current_question = Global.get_unique_question(grade, Global.current_path)
	# Display using BattleEffectManager & UIThemeManager
```

---

## 📊 File Size Guidelines

| File Type | Max Lines | Strategy if exceeded |
|-----------|-----------|----------------------|
| Main controller | 500 | Extract logic to helpers |
| Scene script | 300 | Use composition pattern |
| System helper | 300 | Split by concern |
| Utility/static | 200 | Keep as single file |

**ตัวอย่าง: Battle.gd (498 lines)**
- ✅ Acceptable - Main controller, complex logic
- 📋 Future: Consider extracting BattleCalculations.gd

---

## 🎯 Naming Pattern

### Folder Structure
```
Scripts/
├── [Category]/
│   ├── MainFile.gd           # Core functionality
│   ├── HelperFile.gd         # Supporting functions
│   └── README_[CATEGORY].md  # Documentation
└── [Filename].gd             # Standalone files
```

### File Naming
- **Main file:** `Battle.gd` (scene controller)
- **Helper file:** `BattleEffectManager.gd` (utility/effects)
- **Manager file:** `QuestManager.gd` (data management)
- **Service file:** `LLMService.gd` (external API)

---

## 🚀 How to Add New Features

### Small Feature (< 100 lines)
1. Add to existing scene script
2. Update that scene's README

### Medium Feature (100-300 lines)
1. Create new scene script
2. Connect to Global
3. Add README file

### Large Feature (> 300 lines)
1. Create new folder in Scripts/
2. Split into multiple files (Flower pattern)
3. Create README_[FEATURE].md
4. Add to this document

---

## 📚 Module Documentation

Each module should include:

```gdscript
# ============================================
# Module Name: [NAME]
# Purpose: [WHAT IT DOES]
# Key Functions: [PUBLIC API]
# Dependencies: [WHAT IT NEEDS]
# ============================================
extends [Parent]

"""
Example usage:
	var manager = UIThemeManager
	manager.apply_button_theme(my_button)
"""
```

---

## 🔄 Refactoring Checklist

When refactoring to Flower structure:

- [ ] Identify clear concerns (Logic, UI, Data, Effects)
- [ ] Create new file for each concern
- [ ] Update imports/preloads
- [ ] Move related functions
- [ ] Update documentation
- [ ] Test compilation
- [ ] Verify all connections work
- [ ] Add README for new module

---

## 📈 Version History

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 2026-02-15 | Initial Flower structure |
| v1.1 | - | [Future refactors] |

---

**Keep this structure clean and modular! 🌸**
