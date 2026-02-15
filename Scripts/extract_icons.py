"""
Extract individual item icons from RPG Maker MZ IconSet.png
IconSet.png is a grid of 32x32 pixel icons, 16 columns wide.
Each icon is identified by its index (row * 16 + col).
"""
from PIL import Image
import os

ICON_SIZE = 32
COLS = 16
INPUT = r"C:\Users\theka\Downloads\RPG\Assets\img\system\IconSet.png"
OUTPUT_DIR = r"C:\Users\theka\Downloads\RPG\Assets\items"

os.makedirs(OUTPUT_DIR, exist_ok=True)

# Map of icon_index -> filename
# These are the standard RPG Maker MZ icon positions
ICONS_TO_EXTRACT = {
    # === Weapons ===
    96: "sword_iron",        # Iron Sword
    97: "sword_steel",       # Steel Sword  
    98: "sword_mythril",     # Mythril Sword
    99: "axe_battle",        # Battle Axe
    100: "spear_iron",       # Iron Spear
    101: "bow_short",        # Short Bow
    102: "bow_long",         # Long Bow
    103: "staff_oak",        # Oak Staff
    104: "staff_mystic",     # Mystic Staff
    105: "dagger_iron",      # Iron Dagger
    106: "dagger_assassin",  # Assassin Dagger
    107: "whip",             # Whip
    108: "claw",             # Claw
    109: "gun_flintlock",    # Flintlock
    110: "sword_flame",      # Flame Sword
    111: "sword_ice",        # Ice Sword
    
    # === Shields ===
    128: "shield_wooden",    # Wooden Shield
    129: "shield_iron",      # Iron Shield
    130: "shield_mythril",   # Mythril Shield
    131: "shield_tower",     # Tower Shield
    
    # === Head Armor ===
    132: "helm_leather",     # Leather Helm
    133: "helm_iron",        # Iron Helm
    134: "helm_knight",      # Knight Helm
    135: "hat_wizard",       # Wizard Hat
    136: "crown_golden",     # Golden Crown  
    137: "bandana",          # Bandana
    
    # === Body Armor ===
    138: "armor_leather",    # Leather Armor
    139: "armor_chainmail",  # Chainmail
    140: "armor_plate",      # Plate Armor
    141: "robe_silk",        # Silk Robe
    142: "robe_mystic",      # Mystic Robe
    143: "cloak_shadow",     # Shadow Cloak
    
    # === Gloves ===
    144: "gloves_leather",   # Leather Gloves
    145: "gloves_iron",      # Iron Gauntlets
    146: "gloves_mythril",   # Mythril Gauntlets
    
    # === Boots ===
    147: "boots_leather",    # Leather Boots
    148: "boots_iron",       # Iron Boots
    149: "boots_speed",      # Speed Boots
    
    # === Accessories ===
    150: "ring_power",       # Power Ring
    151: "ring_guard",       # Guard Ring
    152: "ring_magic",       # Magic Ring
    153: "necklace_hp",      # HP Necklace
    154: "necklace_mp",      # MP Necklace
    155: "amulet_luck",      # Luck Amulet
    156: "belt_strength",    # Strength Belt
    157: "cape_wind",        # Wind Cape
    
    # === Consumables (extra) ===
    176: "potion_hp",        # HP Potion
    177: "potion_mp",        # MP Potion
    178: "potion_hp_large",  # Large HP Potion
    179: "potion_mp_large",  # Large MP Potion
    
    # === Orbs / Gems ===  
    160: "orb_fire",         # Fire Orb
    161: "orb_ice",          # Ice Orb
    162: "orb_thunder",      # Thunder Orb
    163: "orb_earth",        # Earth Orb
    164: "orb_light",        # Light Orb
    165: "orb_dark",         # Dark Orb
}

img = Image.open(INPUT)
print(f"IconSet.png size: {img.size}")
print(f"Grid: {img.width // ICON_SIZE} cols x {img.height // ICON_SIZE} rows")
print(f"Total possible icons: {(img.width // ICON_SIZE) * (img.height // ICON_SIZE)}")

extracted = 0
for idx, name in ICONS_TO_EXTRACT.items():
    row = idx // COLS
    col = idx % COLS
    
    x = col * ICON_SIZE
    y = row * ICON_SIZE
    
    if x + ICON_SIZE > img.width or y + ICON_SIZE > img.height:
        print(f"  SKIP {name} (idx {idx}): out of bounds")
        continue
    
    icon = img.crop((x, y, x + ICON_SIZE, y + ICON_SIZE))
    
    # Scale up to 64x64 for better visibility in Godot
    icon = icon.resize((64, 64), Image.NEAREST)
    
    output_path = os.path.join(OUTPUT_DIR, f"{name}.png")
    icon.save(output_path)
    extracted += 1
    print(f"  Extracted: {name}.png (idx {idx})")

print(f"\nDone! Extracted {extracted} icons to {OUTPUT_DIR}")
