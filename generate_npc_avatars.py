#!/usr/bin/env python3
"""
NPC Character Avatar Generator
Creates simple placeholder avatars for each NPC
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_npc_avatar(npc_name: str, npc_type: str, color: tuple, output_path: str):
    """
    Create a simple avatar for an NPC
    
    Args:
        npc_name: Display name
        npc_type: NPC type (MERCHANT, GUIDE, etc.)
        color: RGB color tuple
        output_path: Where to save the image
    """
    
    # Create image (200x200 px, square avatar)
    img = Image.new('RGBA', (200, 200), color=(0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw background circle/square
    padding = 10
    draw.rectangle([padding, padding, 200-padding, 200-padding], fill=color, outline="white", width=3)
    
    # Draw type icon area (top-left)
    type_colors = {
        "ELDER": "#8B7355",      # Brown
        "MERCHANT": "#FFD700",   # Gold
        "GUIDE": "#87CEEB",      # Sky Blue
        "HEALER": "#90EE90",     # Light Green
        "RIVAL": "#FF6347",      # Tomato Red
        "SCHOLAR": "#4169E1",    # Royal Blue
        "STORYTELLER": "#DDA0DD", # Plum
        "QUEST_GIVER": "#FF8C00", # Dark Orange
    }
    
    # Draw simple face (circle head)
    head_pos = [50, 40, 150, 140]
    draw.ellipse(head_pos, fill="#FFD9B3", outline="#8B4513", width=2)
    
    # Draw eyes
    eye_color = "#000000"
    eye_left = [75, 80]
    eye_right = [125, 80]
    eye_size = 5
    draw.ellipse([eye_left[0]-eye_size, eye_left[1]-eye_size, 
                  eye_left[0]+eye_size, eye_left[1]+eye_size], fill=eye_color)
    draw.ellipse([eye_right[0]-eye_size, eye_right[1]-eye_size, 
                  eye_right[0]+eye_size, eye_right[1]+eye_size], fill=eye_color)
    
    # Draw mouth (simple smile)
    mouth_color = "#FF69B4"
    draw.arc([80, 100, 120, 125], 0, 180, fill=mouth_color, width=2)
    
    # Draw type symbol (at bottom)
    draw.rectangle([10, 160, 40, 190], fill=type_colors.get(npc_type, "#CCCCCC"), outline="white", width=2)
    
    # Save image
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, "PNG")
    print(f"✓ Created: {output_path}")

def main():
    """Generate all NPC avatars"""
    
    print("\n" + "=" * 70)
    print("🎨 NPC AVATAR GENERATOR")
    print("=" * 70)
    
    base_path = "d:/Project/final/RPG/Assets"
    
    # NPC data: (NPC ID, NPC Type, Color RGB)
    npcs = [
        ("npc_elder", "ELDER", (139, 69, 19)),           # Brown
        ("npc_merchant", "MERCHANT", (255, 215, 0)),     # Gold
        ("npc_guide", "GUIDE", (135, 206, 235)),         # Sky Blue
        ("npc_healer", "HEALER", (144, 238, 144)),       # Light Green
        ("npc_rival", "RIVAL", (255, 99, 71)),           # Tomato
        ("npc_scholar", "SCHOLAR", (65, 105, 225)),      # Royal Blue
        ("npc_storyteller", "STORYTELLER", (221, 160, 221)), # Plum
        ("npc_potion_merchant", "MERCHANT", (255, 140, 0)), # Dark Orange
        ("npc_questmaster", "QUEST_GIVER", (255, 140, 0)), # Orange
        ("npc_guardian", "GUIDE", (34, 139, 34)),        # Forest Green
    ]
    
    print("\n🎨 CREATING NPC AVATARS:")
    print("-" * 70)
    
    for npc_id, npc_type, color in npcs:
        output = f"{base_path}/{npc_id}.png"
        create_npc_avatar(npc_id, npc_type, color, output)
    
    print("\n" + "=" * 70)
    print("✅ NPC AVATARS CREATED SUCCESSFULLY!")
    print("=" * 70)
    print(f"\nLocation: {base_path}/")
    print(f"Total avatars: {len(npcs)}")
    print("\n📝 Each avatar is:")
    print("  • 200x200 pixels")
    print("  • PNG format with transparency")
    print("  • Simple face design")
    print("  • Type symbol at bottom")
    print("  • Color-coded by NPC type")
    print("\n💡 NEXT STEPS:")
    print("  1. Godot will auto-import these images")
    print("  2. Reference in NPCManager.gd sprite field")
    print("  3. Display in NPCDialogUI.gd")
    print("  4. Later replace with custom art if desired")
    print("\n" + "=" * 70 + "\n")

if __name__ == "__main__":
    try:
        main()
    except ImportError:
        print("\n❌ Pillow library not found!")
        print("Install with: pip install Pillow")
        print("\nAlternatively, create placeholder PNG files manually")
