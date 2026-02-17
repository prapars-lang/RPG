# 🎨 UI Development Guide - Using UIThemeManager

## Overview

`UIThemeManager.gd` provides a centralized system for applying consistent, professional UI styling across all scenes in the game.

## Setup

### Step 1: Make UIThemeManager Available
No special setup needed - it's a static class, available everywhere:

```gdscript
# From any script:
UIThemeManager.apply_button_theme(my_button)
```

## Usage Examples

### ✅ Example 1: Style a Single Button

```gdscript
extends Control

func _ready():
	var btn = $MyButton
	UIThemeManager.apply_button_theme(btn, UIThemeManager.FONT_SIZE_TITLE)
```

### ✅ Example 2: Style Multiple Buttons

```gdscript
func style_all_buttons():
	for btn in $MenuContainer.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn)
			btn.mouse_entered.connect(_on_btn_hover.bind(btn))
			btn.mouse_exited.connect(_on_btn_exit.bind(btn))

func _on_btn_hover(btn: Button):
	UIThemeManager.animate_button_hover(btn)

func _on_btn_exit(btn: Button):
	UIThemeManager.animate_button_exit(btn)
```

### ✅ Example 3: Style Labels

```gdscript
func _ready():
	# Title styling
	var title = $Title
	UIThemeManager.apply_title_theme(title)
	
	# Subtitle styling
	var subtitle = $Subtitle
	UIThemeManager.apply_subtitle_theme(subtitle)
	
	# Body text styling
	var description = $Description
	UIThemeManager.apply_text_theme(description, UIThemeManager.FONT_SIZE_SMALL)
	
	# Add glow animation
	UIThemeManager.animate_glow(subtitle)
```

### ✅ Example 4: Animate Button on Click

```gdscript
@onready var play_btn = $PlayButton

func _ready():
	UIThemeManager.apply_button_theme(play_btn)
	play_btn.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	UIThemeManager.play_transition_fade()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
```

### ✅ Example 5: Create Custom Panel

```gdscript
func create_info_panel() -> PanelContainer:
	var panel = PanelContainer.new()
	UIThemeManager.apply_panel_theme(panel)
	
	var label = Label.new()
	UIThemeManager.apply_text_theme(label)
	label.text = "Game Info"
	panel.add_child(label)
	
	return panel
```

---

## Color Constants

### Primary Colors
```gdscript
UIThemeManager.COLOR_PRIMARY           # Green (#66FF99)
UIThemeManager.COLOR_PRIMARY_DARK      # Dark Green (#336644)
UIThemeManager.COLOR_PRIMARY_DARKER    # Very Dark Green
UIThemeManager.COLOR_ACCENT            # Gold (#FFD900)
```

### Text Colors
```gdscript
UIThemeManager.COLOR_TEXT              # Light text (#F2F2F2)
UIThemeManager.COLOR_TEXT_DARK         # Dark text (#333333)
```

### Status Colors
```gdscript
UIThemeManager.COLOR_ERROR             # Red
UIThemeManager.COLOR_SUCCESS           # Green
UIThemeManager.COLOR_WARNING           # Orange
```

### Background
```gdscript
UIThemeManager.COLOR_DARK_BG           # Dark background
```

---

## Font Sizes

```gdscript
UIThemeManager.FONT_SIZE_HUGE    # 72px - Main titles
UIThemeManager.FONT_SIZE_LARGE   # 48px - Section titles
UIThemeManager.FONT_SIZE_BIG     # 36px - Subtitles
UIThemeManager.FONT_SIZE_TITLE   # 28px - Menu buttons
UIThemeManager.FONT_SIZE_NORMAL  # 24px - Body text
UIThemeManager.FONT_SIZE_SMALL   # 18px - Secondary text
UIThemeManager.FONT_SIZE_TINY    # 14px - Help text
```

### Usage
```gdscript
# Apply text with specific size
UIThemeManager.apply_text_theme(label, UIThemeManager.FONT_SIZE_SMALL)

# Title with huge font
UIThemeManager.apply_title_theme(title_label)  # Uses FONT_SIZE_HUGE
```

---

## Animation Durations

```gdscript
UIThemeManager.ANIM_DURATION_QUICK      # 0.1 sec - Instant feedback
UIThemeManager.ANIM_DURATION_SHORT      # 0.15 sec - Button hover
UIThemeManager.ANIM_DURATION_NORMAL     # 0.3 sec - Transitions
UIThemeManager.ANIM_DURATION_LONG       # 0.5 sec - Scene fade
UIThemeManager.ANIM_DURATION_VERY_LONG  # 1.0 sec - Slow animations
```

---

## Animation Methods

### Button Animations

```gdscript
# On hover
UIThemeManager.animate_button_hover(btn)           # Scale to 1.08x
UIThemeManager.animate_button_hover(btn, 1.15)    # Custom scale

# On exit hover
UIThemeManager.animate_button_exit(btn)
```

### Node Animations

```gdscript
# Fade in
UIThemeManager.animate_fade_in(node)
UIThemeManager.animate_fade_in(node, 1.5)  # 1.5 sec duration

# Fade out
UIThemeManager.animate_fade_out(node)
UIThemeManager.animate_fade_out(node, 2.0)  # 2.0 sec duration

# Floating (up/down movement)
UIThemeManager.animate_floating(node)
UIThemeManager.animate_floating(node, 20.0, 3.0)  # 20px, 3sec

# Label glow
UIThemeManager.animate_glow(label)
```

### Scene Transitions

```gdscript
# Fade to black before changing scene
UIThemeManager.play_transition_fade()
await get_tree().create_timer(0.5).timeout
get_tree().change_scene_to_file("res://Scenes/Next.tscn")
```

---

## Real-World Scene Examples

### CharacterSelection.tscn Style Guide

```gdscript
extends Control

func _ready():
	# Style the title
	var title = $Title
	UIThemeManager.apply_title_theme(title)
	UIThemeManager.animate_glow(title)
	
	# Style class selection buttons
	for btn in $ClassButtons.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn)
			btn.mouse_entered.connect(func(): UIThemeManager.animate_button_hover(btn))
			btn.mouse_exited.connect(func(): UIThemeManager.animate_button_exit(btn))
	
	# Style confirm button (highlight)
	var confirm_btn = $ConfirmButton
	UIThemeManager.apply_button_theme(confirm_btn, UIThemeManager.FONT_SIZE_LARGE)
```

### Battle.tscn Style Guide

```gdscript
extends Node2D

func _ready():
	# Enemy name
	var enemy_label = $EnemyName
	UIThemeManager.apply_text_theme(enemy_label, UIThemeManager.FONT_SIZE_BIG)
	
	# Battle log
	var log = $BattleLog
	UIThemeManager.apply_text_theme(log, UIThemeManager.FONT_SIZE_SMALL)
	
	# Action buttons
	for btn in $ActionButtons.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn, UIThemeManager.FONT_SIZE_NORMAL)
```

### Shop.tscn Style Guide

```gdscript
extends Control

func _ready():
	# Gold display
	var gold_label = $GoldDisplay
	gold_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)
	UIThemeManager.apply_text_theme(gold_label, UIThemeManager.FONT_SIZE_NORMAL)
	
	# Item prices (affordable/not affordable)
	for item_card in $ItemGrid.get_children():
		var price_label = item_card.get_node("PriceLabel")
		if Global.player_gold >= int(price_label.text):
			price_label.add_theme_color_override("font_color", UIThemeManager.COLOR_SUCCESS)
		else:
			price_label.add_theme_color_override("font_color", UIThemeManager.COLOR_ERROR)
	
	# Buy buttons
	for btn in $BuyButtons.get_children():
		if btn is Button:
			UIThemeManager.apply_button_theme(btn)
```

---

## Style Creation Methods

### Create Custom Button Style

```gdscript
func create_danger_button() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = UIThemeManager.COLOR_ERROR
	style.border_width_left = 2
	style.border_color = Color.WHITE
	return style
```

### Apply Custom Style

```gdscript
var btn = Button.new()
var danger_style = create_danger_button()
btn.add_theme_stylebox_override("normal", danger_style)
```

---

## Best Practices

### ✅ DO:

```gdscript
# ✅ Use UIThemeManager for consistency
UIThemeManager.apply_button_theme(btn)

# ✅ Use color constants
label.add_theme_color_override("font_color", UIThemeManager.COLOR_ACCENT)

# ✅ Use font size constants
UIThemeManager.apply_text_theme(label, UIThemeManager.FONT_SIZE_NORMAL)

# ✅ Keep animations under 1 second for UI
UIThemeManager.animate_fade_in(node)
```

### ❌ DON'T:

```gdscript
# ❌ Hardcode colors
label.add_theme_color_override("font_color", Color(1, 0.8, 0.3))

# ❌ Use different button styles per scene
my_custom_button_style = StyleBoxFlat.new()  # No!

# ❌ Create slow animations
tween.tween_property(btn, "scale", Vector2(2, 2), 5.0)  # Too slow!

# ❌ Duplicate styling code
# Instead: Use UIThemeManager everywhere
```

---

## Troubleshooting

### Buttons Don't Look Right

**Problem**: Buttons missing rounded corners or glow
**Solution**: 
```gdscript
# Make sure you're using the theme manager
UIThemeManager.apply_button_theme(btn)
# Don't override with custom styles after
```

### Text Too Small/Big

**Problem**: Text scaling issues
**Solution**:
```gdscript
# Use the correct font size constant
UIThemeManager.apply_text_theme(label, UIThemeManager.FONT_SIZE_NORMAL)
```

### Colors Don't Match

**Problem**: Colors look different than expected
**Solution**:
```gdscript
# Always use color constants
btn.add_theme_color_override("font_color", UIThemeManager.COLOR_TEXT)
# Not: Color(0.95, 0.95, 0.95)
```

### Animations Jittery

**Problem**: Animations stuttering or looking choppy
**Solution**:
```gdscript
# Use durations from UIThemeManager
UIThemeManager.animate_button_hover(btn)  # Smooth durations built-in
# Not: tween.tween_property(..., 0.001)  # Too fast
```

---

## Extending UIThemeManager

### Add Custom Theme Method

```gdscript
# In UIThemeManager.gd, add:

static func apply_danger_button_theme(btn: Button) -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = COLOR_ERROR
	style.border_color = COLOR_TEXT
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_color_override("font_color", COLOR_TEXT)
```

### Add Custom Color

```gdscript
# In UIThemeManager.gd, add:
const COLOR_CUSTOM = Color(0.5, 0.7, 0.9, 1.0)

# Then use anywhere:
UIThemeManager.COLOR_CUSTOM
```

---

## Quick Reference Cheatsheet

```gdscript
# 🎨 Colors
UIThemeManager.COLOR_PRIMARY
UIThemeManager.COLOR_ACCENT
UIThemeManager.COLOR_TEXT

# 🔤 Font Sizes
UIThemeManager.FONT_SIZE_HUGE
UIThemeManager.FONT_SIZE_TITLE
UIThemeManager.FONT_SIZE_NORMAL

# 🎛️ Apply Theme
UIThemeManager.apply_button_theme(btn)
UIThemeManager.apply_title_theme(label)
UIThemeManager.apply_text_theme(label)

# ✨ Animate
UIThemeManager.animate_button_hover(btn)
UIThemeManager.animate_fade_in(node)
UIThemeManager.animate_floating(node)

# 🎬 Transitions
UIThemeManager.play_transition_fade()
```

---

**Remember**: Consistency is key! Always use UIThemeManager instead of creating custom styles per scene.

**Last Updated**: February 15, 2026  
**Theme System**: Premium Edition 1.0
