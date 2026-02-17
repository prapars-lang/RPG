# 🎭 NPC System Implementation

## Overview

Complete **NPC System** with 10 diverse NPCs:

### **NPC Types Included:**

1. **Elder (ท่านอาจารย์สติ)** - Wisdom source
   - Gives life advice and spiritual quests
   - Location: Library of Memories
   - High relationship bonus (+5)

2. **Merchant - Potion (พ่อค้าโชค)** - Item seller
   - Sells potions, antidotes, supplies
   - Location: Shop
   - Normal discount

3. **Guide (ไกด์ทางสำนัก)** - Navigation helper
   - Provides hints and directions
   - Location: Crossroads
   - Moderate relationship bonus

4. **Healer (หมอแล่งจิต)** - Health support
   - Heals players with discount
   - Location: Healing Temple
   - 20% healing discount
   - Highest relationship bonus (+6)

5. **Rival (ศต(อ)สิขร)** - Antagonist/Competitor
   - Provides challenges/battles
   - Location: Arena
   - Low relationship bonus

6. **Scholar (อักษร)** - Knowledge keeper
   - Teaches skills and lore
   - Location: Library of Memories
   - Moderate relationship bonus

7. **Storyteller (กาลหัวใจ)** - Lore narrator
   - Tells stories and history
   - Location: Campfire
   - Unlocks world lore

8. **Potion Merchant (ยา'สั้น)** - Alchemist
   - Sells specialized potions
   - Location: Shop
   - Potion specialist

9. **Quest Master (นายใหญ่เทพ)** - Job creator
   - Gives various quests
   - Location: Guild Hall
   - Multiple quest sources

10. **Guardian Spirit (วิญญาณผู้รักษา)** - Nature protector
    - Provides environmental quests
    - Location: The Sleepy Forest
    - Highest relationship bonus (+7)

---

## System Architecture

### **NPCManager.gd (AutoLoad)**
```
Core NPC management system
├── NPC Database (10 NPCs)
├── Reputation System (-100 to +100)
├── Visited Tracking
├── Quest Management
├── Merchant Functions
└── Location System
```

### **NPCDialogUI.gd**
```
NPC Interaction UI
├── NPC Info Display
├── Dialog Management
├── Reputation Display
├── Action Buttons (Interact, Close)
└── Theme Integration
```

---

## NPC Reputation System

### Reputation Levels:
```
[  -100 to -75 ]  → "enemy"      (Red)
[   -75 to -25 ]  → "hostile"    (Dark Red)
[   -25 to +25 ]  → "suspicious" (Yellow)
[   +25 to +50 ]  → "neutral"    (Gray)
[   +50 to +75 ]  → "friendly"   (Green)
[   +75 to +100]  → "devoted"    (Bright Green)
```

### Relationship Effects:
- **Friendly NPCs**: Better prices, more dialog options
- **Hostile NPCs**: Higher prices, limited interaction
- **Neutral NPCs**: Standard pricing and interaction

---

## Usage Examples

### Basic NPC Interaction
```gdscript
# Show NPC dialog
NPCDialogUI.show_npc_dialog("elder_wisdom")

# Check reputation
var rep = NPCManager.get_reputation("merchant_fortune")
print("Reputation: %d" % rep)

# Modify reputation
NPCManager.add_reputation("elder_wisdom", 10)

# Check if NPC is friendly
if NPCManager.is_friendly("healer_compassion"):
    print("NPC likes you!")
```

### Merchant Functions
```gdscript
# Get merchant items
if NPCManager.is_merchant("merchant_fortune"):
    var items = NPCManager.get_merchant_items("merchant_fortune")
    
    # Get discount price
    var discount = NPCManager.get_merchant_discount("merchant_fortune")
    var final_price = item_cost * discount
```

### Location System
```gdscript
# Get NPCs at specific location
var shop_npcs = NPCManager.get_npc_by_location("Shop")

# Get NPCs by type
var merchants = NPCManager.get_npc_by_type(NPCManager.NPCType.MERCHANT)

# Get all locations
var all_locations = NPCManager.get_all_locations()
```

### Quest Management
```gdscript
# Get quests from NPC
var quests = NPCManager.get_available_quests("quest_master")

# Complete quest
NPCManager.complete_quest_for_npc("elder_wisdom", "focus_meditation")
```

---

## Integration Points

### Current Integration:
- ✅ NPCManager created and registered as AutoLoad
- ✅ NPCDialogUI script ready for scene
- ✅ Reputation system implemented
- ✅ Merchant discount system
- ✅ Location tracking

### Next Integration:
- 📋 Create NPCDialog.tscn scene
- 📋 Create NPC Gallery/List UI
- 📋 Integrate into Story scenes
- 📋 Connect with Merchant shop
- 📋 Connect with Quest system
- 📋 Add NPC sprites/visuals

---

## NPC Statistics

| NPC | Type | Location | Quests | Rep Bonus |
|-----|------|----------|--------|-----------|
| Elder | ELDER | Library | 2 | +5 |
| Merchant | MERCHANT | Shop | 0 | +3 |
| Guide | GUIDE | Crossroads | 0 | +4 |
| Healer | HEALER | Temple | 0 | +6 |
| Rival | RIVAL | Arena | 0 | +2 |
| Scholar | SCHOLAR | Library | 0 | +5 |
| Storyteller | STORYTELLER | Campfire | 0 | +4 |
| Potion Merchant | MERCHANT | Shop | 0 | +3 |
| Quest Master | QUEST_GIVER | Guild | 3+ | +4 |
| Guardian | GUIDE | Forest | 2+ | +7 |

---

## File Structure

```
Scripts/
├── NPCManager.gd           (350+ lines) ✅ Created
├── NPCDialogUI.gd          (200+ lines) ✅ Created
└── ... (existing)

Scenes/
├── NPCDialog.tscn          (📋 TODO - create scene)
├── NPCGallery.tscn         (📋 TODO - show all NPCs)
└── ... (existing)
```

---

## Next Development Steps

### Phase 1: Create UI Scenes
```
1. Create NPCDialog.tscn scene
2. Create NPC info display
3. Create dialog text box
4. Create button layout
5. Test interaction flow
```

### Phase 2: Create NPC Gallery
```
1. Create NPCGallery.tscn
2. Show all 10 NPCs with info
3. View NPC status/reputation
4. Quick interaction access
```

### Phase 3: Integration
```
1. Add NPC spawning to story scenes
2. Integrate with merchant shops
3. Connect with quest system
4. Add reputation rewards
5. Test full flow
```

### Phase 4: Polish
```
1. Add NPC sprites/visuals
2. Create unique dialog trees
3. Add sound effects
4. Balance reputation gains
5. Test all 10 NPCs
```

---

## Debug Commands

```gdscript
# In any script:

# Print all NPC info
NPCManager.print_npc_status()

# Get NPC count
var total = NPCManager.get_npc_count()

# Test dialog UI
NPCDialogUI.test_npc_dialog()

# Check NPC relationships
var all_rep = NPCManager.npc_reputation
```

---

## Summary

✅ **Complete NPC Database**: 10 diverse NPCs  
✅ **Reputation System**: -100 to +100 scale  
✅ **Core Functions**: Interaction, dialog, quests  
✅ **Merchant Support**: Pricing, items, discounts  
✅ **Location Tracking**: Scene-based NPC placement  
✅ **Dialog UI**: Basic interaction framework  

📋 **Pending**: Scene creation, NPC visuals, full integration  

**Status**: Ready for scene creation and visual implementation

