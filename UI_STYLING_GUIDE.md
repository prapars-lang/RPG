# 🎨 UI Styling Guide & Premium Theme

## Visual Design System

### Color Palette

```
Primary Colors:
  - Green (Nature): #66FF99 (RGB: 102, 255, 153)
  - Dark Green: #336644 (RGB: 51, 102, 68)
  - Gold (Accent): #FFD900 (RGB: 255, 217, 0)
  - Text (Light): #F2F2F2 (RGB: 242, 242, 242)
  - Dark BG: #0D0D19 (RGB: 13, 13, 25)
  - Error Red: #FF3333 (RGB: 255, 51, 51)
```

### Usage Guidelines

| Color | Use Case |
|-------|----------|
| Green | Primary actions, highlights |
| Dark Green | Button backgrounds, containers |
| Gold | Hover states, important info |
| Light Text | Body text, labels |
| Dark BG | Backgrounds, overlays |
| Red | Errors, warnings |

---

## Button Styling

### States

#### Normal State
```
Background:   Dark green (0.15, 0.25, 0.2, 0.75)
Border:       Green (0.4, 1.0, 0.6, 0.6)
Border Width: 2.5 pixels
Corner Radius: 15 pixels
Shadow:       Dark (8px)
```

#### Hover State
```
Background:   Lighter green (0.25, 0.35, 0.3, 0.95)
Border:       Gold (#FFD900)
Border Width: 3 pixels
Shadow:       Green glow (15px)
Scale:        1.08x (108% of original)
```

#### Pressed State
```
Background:   Bright green (0.35, 0.5, 0.4, 1.0)
Border:       Gold (#FFD900)
Border Width: 3 pixels
Shadow:       Green glow (12px)
```

### Text Properties
- **Font Color**: Light (#F2F2F2)
- **Font Color (Hover)**: Gold (#FFD900)
- **Font Size**: 28px (menu), 24px (secondary), 18px (small)
- **Font Family**: Use the project theme font

---

## Animation Standards

### Button Interactions
- **Hover Scale**: 1.05 → 1.08 (105-108% of size)
- **Duration**: 150ms for smooth response
- **Easing**: TRANS_BACK with EASE_OUT

### Scene Transitions
- **Fade Out**: 500ms
- **Fade In**: 800ms
- **Type**: COLOR (BLACK) to prevent jarring shifts

### Title Animations
- **Float Up/Down**: 15px movement
- **Duration**: 2.5 seconds (loop)
- **Easing**: TRANS_SINE (smooth wave)

### Character Animations
- **Fade In Delay**: Staggered 0.2s between characters
- **Fade In Duration**: 1.2 seconds
- **Float Offset**: 8-20px random
- **Float Duration**: 3-4 seconds random

---

## UI Layout Principles

### Spacing
- **Container Padding**: 40px
- **Button Gap**: 20px vertical
- **Text to Button**: 30px

### Alignment
- Buttons: Center aligned horizontally
- Text: Center aligned for titles
- Characters: Left and Right edges

### Z-Order
```
1. Background (TextureRect)
2. Particles (optional)
3. Overlay (ColorRect for dimming)
4. CharacterTeam (sprites)
5. MainContainer (UI elements)
```

---

## Typography

### Title Text
- **Size**: 72px
- **Color**: Gold (#FFD900)
- **Weight**: Bold
- **Effect**: Slight glow/shadow

### Subtitle Text
- **Size**: 20px
- **Color**: Light (#F2F2F2)
- **Weight**: Normal
- **Effect**: Subtle glow animation

### Button Text
- **Size**: 28px
- **Color**: Light (#F2F2F2) / Gold on hover
- **Weight**: Medium

### Body Text
- **Size**: 16-18px
- **Color**: Light (#F2F2F2)
- **Weight**: Normal

---

## Glassmorphism Effect

### Properties
- **Backdrop Blur**: Simulated with semi-transparent overlays
- **Transparency**: 0.75-0.95 alpha
- **Border Glow**: Primary color border with shadow

### Implementation
```gdscript
var style = StyleBoxFlat.new()
style.bg_color = Color(0.15, 0.25, 0.2, 0.75)        # Semi-transparent
style.border_color = Color(0.4, 1.0, 0.6, 0.6)       # Glowing border
style.shadow_color = Color(0.0, 0.0, 0.0, 0.4)       # Soft shadow
style.shadow_size = 8                                 # Shadow strength
```

---

## Visual Effects

### Particle Effects
- **Location**: Bottom center (for spawn point)
- **Amount**: 20 particles
- **Lifetime**: 10 seconds
- **Color**: Green (#66FF99) with transparency
- **Direction**: Upward (0, -1)
- **Spread**: 90 degrees

### Shadow & Glow
- **Button Shadow**: 8-15px blur
- **Color**: Either dark shadow or primary glow
- **Intensity**: Increases on hover

### Overlay
- **Color**: Black
- **Alpha**: 0.35 (keeps background visible)
- **Purpose**: Improve text readability

---

## Responsive Considerations

### Screen Sizes
- **1280x720** (Current): Optimal
- **1920x1080**: Scale 1.5x
- **800x600**: Scale 0.8x

### Scaling Strategy
```
Button Size ∝ Screen Width
Font Size ∝ Screen Height
Spacing ∝ Min(Width, Height)
```

---

## Consistency Checklist

All UI Scenes should follow:

- [ ] Use color palette defined above
- [ ] Buttons have rounded corners (15px minimum)
- [ ] Buttons have glow/shadow effects
- [ ] Hover effects provide clear feedback
- [ ] Text is readable (high contrast)
- [ ] Animations are smooth (60 FPS)
- [ ] Spacing follows grid system
- [ ] Icons match button colors
- [ ] Transitions are 0.5s fade
- [ ] All text properly aligned

---

## Scene Application

### MainMenu.tscn ✅
- Status: Updated with premium styling
- Buttons: Golden glow on hover
- Animation: Smooth floating characters
- Colors: Green theme with gold accents

### Character Selection
- Apply same button styling
- Add character preview glow
- Animate character selection

### Battle UI
- Health bars: Green gradient
- Text: Gold for important info
- Buttons: Same dark green style
- Animation: Smooth HP/MP changes

### Inventory Menu
- Item slots: Dark green containers
- Hover: Gold border + glow
- Selected: Bright with animation
- Text: Light color for readability

### Shop
- Item cards: Dark green with border
- Currency: Gold text
- Prices: Red if can't afford, green if can
- Buttons: Consistent styling

### Pause Menu
- Background: Semi-transparent black
- Buttons: Same green styling
- Resume button: Gold to highlight
- Exit: Red variant

---

## Code Template for Button Styling

```gdscript
func _create_premium_button() -> Button:
	var btn = Button.new()
	
	# Normal state
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.15, 0.25, 0.2, 0.75)
	style_normal.corner_radius_top_left = 15
	style_normal.border_width_left = 2.5
	style_normal.border_color = Color(0.4, 1.0, 0.6, 0.6)
	style_normal.shadow_size = 8
	
	# Hover state
	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(0.25, 0.35, 0.3, 0.95)
	style_hover.border_color = Color(1.0, 0.8, 0.3, 1.0)
	style_hover.shadow_size = 15
	
	btn.add_theme_stylebox_override("normal", style_normal)
	btn.add_theme_stylebox_override("hover", style_hover)
	btn.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95))
	btn.add_theme_font_size_override("font_size", 28)
	
	return btn
```

---

## Animation Template

```gdscript
func _animate_hover(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.08, 1.08), 0.15)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _fade_transition():
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	add_child(overlay)
	
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.5)
```

---

## Next Steps

1. **MainMenu**: ✅ Updated with premium styling
2. **Other Scenes**: Apply same design system
3. **Testing**: Verify on different resolutions
4. **Refinement**: Adjust colors/timing as needed
5. **Documentation**: Update theme whenever changed

---

**Last Updated**: February 15, 2026  
**Theme Version**: 1.0 (Premium)  
**Engine**: Godot 4.4
