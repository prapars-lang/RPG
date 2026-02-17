# Contributing to Educational Fantasy RPG

Thank you for your interest in contributing to this educational game project! 🎮

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions.

## How to Contribute

### 1. **Reporting Bugs** 🐛
If you find a bug:
1. Check if it's already reported
2. Create a clear description with steps to reproduce
3. Include screenshots or videos if possible
4. List your environment (OS, Godot version, etc.)

### 2. **Suggesting Features** 💡
Great ideas are welcome:
1. Check existing issues to avoid duplicates
2. Clearly describe the feature and why it would help
3. Provide examples or mockups if applicable
4. Consider the educational value and user experience

### 3. **Writing Code** 💻

#### Setup Development Environment
1. Clone the repository
2. Install Godot 4.4+
3. Run `python3 setup_env.py` to set up API key
4. Open project in Godot
5. Press F5 to run

#### Code Guidelines
- **Language**: Use Thai for game content (characters, dialogue, UI text)
- **English for**: Code comments, function names, documentation
- **Style**: Follow Godot GDScript conventions
- **Quality**: Test your changes before submitting
- **Documentation**: Comment complex logic
- **No Abbreviated Code**: Write complete, legible code

#### Project Structure
```
Scripts/
├── Core/           # Central systems
│   ├── ConfigManager.gd    # Configuration
│   ├── Global.gd           # Global state
│   └── LLMService.gd       # AI service
├── Scenes/         # Scene-specific logic
├── Systems/        # Game systems
│   ├── Battle/
│   ├── Inventory/
│   ├── Quests/
│   └── Paths/
└── Utils/          # Utilities and helpers
```

#### Creating a New Script
```gdscript
# Follow this template:
extends Node
# Brief description of what this script does

signal event_name(parameter)

@export var some_setting = 10

func _ready():
	# Initialize
	pass

func _process(delta):
	# Update each frame
	pass

func public_function():
	# Public methods at top
	pass

func _private_function():
	# Private methods below
	pass
```

### 4. **Improving Documentation** 📖
Documentation improvements are valuable:
- Fix typos or unclear explanations
- Add examples or use cases
- Improve README or SETUP_GUIDE
- Translate documentation to other languages
- Add API documentation comments

### 5. **Educational Content** 📚
Help create better learning content:
- Suggest new questions in `Data/questions.json`
- Improve story chunks in `StoryData.gd`
- Balance difficulty progression
- Ensure content accuracy
- Make content engaging and age-appropriate

## Pull Request Process

1. **Fork** the repository
2. **Create a branch** with a descriptive name:
   ```bash
   git checkout -b feature/add-new-quest-system
   git checkout -b fix/dialogue-text-bug
   ```

3. **Commit** with clear messages:
   ```bash
   git commit -m "Add new quest system for daily objectives"
   git commit -m "Fix: API key not loading from .env file"
   ```

4. **Push** to your fork:
   ```bash
   git push origin feature/add-new-quest-system
   ```

5. **Create Pull Request** with:
   - Clear title and description
   - Reference any related issues (#123)
   - Screenshots/videos for visual changes
   - Testing notes
   - Any breaking changes noted

## Development Workflow

### Adding a Feature

1. **Plan**: Discuss major features in issues first
2. **Create Branch**: `git checkout -b feature/feature-name`
3. **Implement**: Write code following guidelines
4. **Test**: Play through affected areas
5. **Document**: Update relevant docs
6. **Commit**: Clear, logical commits
7. **Push & PR**: Submit for review

### Example Feature: New Equipment Type

```gdscript
# Location: Scripts/Inventory/EquipmentTypes.gd
extends Node

# Define new equipment type
const EQUIPMENT_RINGS = "rings"

# Add to Global.gd equipped_items:
equipped_items = {
	"weapon": null,
	"head": null,
	"body": null,
	"hands": null,
	"feet": null,
	"accessory": null,
	"ring_1": null,      # NEW
	"ring_2": null,      # NEW
}

# Update UI to show new slots
# Update save/load system
# Add items to shop
# Test thoroughly
```

### Testing Checklist
- [ ] Game starts without errors
- [ ] All scenes load properly
- [ ] New feature works as intended
- [ ] No regressions in existing features
- [ ] Save/load preserves new data
- [ ] UI is clear and functional
- [ ] AI responses are appropriate
- [ ] No console errors

## Git Workflow Tips

```bash
# Keep your fork updated
git remote add upstream https://github.com/original/repo.git
git fetch upstream
git checkout main
git merge upstream/main

# Check what you changed
git diff

# Before pushing
git log --oneline -5  # Review last 5 commits
git status            # Check staging area

# If you need to amend last commit
git commit --amend --no-edit
git push --force-with-lease  # Use with care!
```

## Commit Message Guidelines

```
# Good commit message format:
# <type>: <subject> (50 chars max)
#
# <body> (72 chars per line)
#
# <footer>

# Types: feat, fix, docs, style, refactor, test, chore
# Example:
feat: Add daily quest system with rewards
- Players can now accept one daily quest per day
- Rewards scale with player level
- Quests reset at midnight

Fixes #123, #456
```

## Documentation Standards

### GDScript Comments
```gdscript
# Explain WHY, not just WHAT
func calculate_damage(attacker_atk: int, defender_def: int) -> int:
	# Base damage is attacker's attack minus 10% of defender's defense
	# This creates a consistent formula while allowing defense to scale
	var base = attacker_atk - (defender_def * 0.1)
	# Ensure minimum damage of 1
	return max(1, int(base))
```

### Dialog Comments
```gdscript
# ✅ Good - Explains the non-obvious logic
# Player level affects enemy HP scaling with diminishing returns
# Formula: enemy_hp = base_hp * (1 + player_level * 0.05)

# ❌ Poor - Doesn't add value
# Add the level to hp
```

## Performance Considerations

- Avoid heavy loops in `_process()` or `_physics_process()`
- Cache frequently used values
- Use object pooling for frequently created objects
- Profile with Godot's profiler before optimizing
- Test on lower-end devices

## Accessibility

Help make the game accessible to all:
- Readable fonts and colors
- Clear UI labels
- Colorblind-friendly palettes
- Keyboard navigation support
- Text descriptions for images
- Adjustable difficulty

## Questions?

- Check [SETUP_GUIDE.md](SETUP_GUIDE.md) for setup help
- Review [README.md](README.md) for overview
- Look at existing code for examples
- Create a discussion issue to ask questions

## Recognition

Contributors will be listed in:
- CONTRIBUTORS.md file
- In-game credits (if applicable)
- GitHub repository contributors page

Thank you for helping make educational gaming better! 🌟
