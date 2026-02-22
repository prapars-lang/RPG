#!/usr/bin/env python3
"""
.env File Verification Helper
Checks if .env file exists in correct Godot user data directory
and provides instructions if missing.
"""

import os
import sys
from pathlib import Path

def get_godot_userdata_path():
    """Get the Godot user data directory path based on OS"""
    if sys.platform == "win32":
        # Windows: %APPDATA%\Godot\app_userdata\Educational Fantasy RPG\
        appdata = os.environ.get("APPDATA", "")
        if appdata:
            return Path(appdata) / "Godot" / "app_userdata" / "Educational Fantasy RPG"
    elif sys.platform == "darwin":
        # macOS: ~/Library/Application Support/Godot/app_userdata/Educational Fantasy RPG/
        return Path.home() / "Library" / "Application Support" / "Godot" / "app_userdata" / "Educational Fantasy RPG"
    elif sys.platform == "linux":
        # Linux: ~/.local/share/godot/app_userdata/Educational Fantasy RPG/
        return Path.home() / ".local" / "share" / "godot" / "app_userdata" / "Educational Fantasy RPG"
    
    return None

def check_env_file():
    """Check if .env file exists and provide instructions if not"""
    print("\n" + "="*60)
    print("🔍 GODOT .ENV FILE VERIFICATION")
    print("="*60)
    
    godot_path = get_godot_userdata_path()
    
    if not godot_path:
        print("\n❌ ERROR: Could not determine Godot user data path")
        print("   Platform: " + sys.platform)
        return False
    
    print("\n📂 Expected .env location:")
    print("   " + str(godot_path / ".env"))
    
    # Check if directory exists
    if not godot_path.exists():
        print(f"\n⚠️  Directory doesn't exist yet:")
        print(f"   {godot_path}")
        print("\n💡 SOLUTION:")
        print("   1. Open Godot 4.4")
        print("   2. Open project: d:\\Project\\final\\RPG\\")
        print("   3. Run ConfigTester.tscn to create directory")
        print("   Then create .env file in that directory")
        return False
    
    # Check if .env file exists
    env_file = godot_path / ".env"
    
    if env_file.exists():
        print(f"\n✅ .env file EXISTS")
        print(f"   Location: {env_file}")
        
        # Check file content
        try:
            with open(env_file, 'r') as f:
                content = f.read()
            
            print(f"\n📋 File size: {len(content)} bytes")
            
            # Check for required keys
            has_api_key = "api_key" in content
            has_api_url = "api_url" in content
            has_model = "model_name" in content
            
            print("\n✓ File contains:")
            print(f"  {'✅' if has_api_key else '❌'} api_key")
            print(f"  {'✅' if has_api_url else '❌'} api_url")
            print(f"  {'✅' if has_model else '❌'} model_name")
            
            if has_api_key and has_api_url and has_model:
                print("\n✅ .env file is READY for testing!")
                return True
            else:
                print("\n⚠️  .env file incomplete - missing required keys")
                print("\n📝 Required format:")
                print("""
[llm]
api_key = YOUR_OPENCODE_API_KEY_HERE
api_url = https://api.opencode.ai/v1/chat/completions
model_name = gpt-4-turbo
                """)
                return False
        
        except Exception as e:
            print(f"\n❌ ERROR reading .env file: {e}")
            return False
    
    else:
        print(f"\n❌ .env file DOES NOT EXIST")
        print(f"   Expected: {env_file}")
        
        # Check if .env.example exists in project
        env_example = Path("d:\\Project\\final\\RPG\\.env.example")
        if env_example.exists():
            print(f"\n✅ Found .env.example in project")
            print("\n📋 INSTRUCTIONS:")
            print(f"   1. Create folder: {godot_path}")
            print(f"   2. Copy .env.example to: {env_file}")
            print(f"   3. Edit the .env file with your OpenCode API key:")
            print(f"""
            [llm]
            api_key = YOUR_API_KEY_HERE
            api_url = https://api.opencode.ai/v1/chat/completions
            model_name = gpt-4-turbo
            """)
        return False

def main():
    """Main entry point"""
    is_ready = check_env_file()
    
    print("\n" + "="*60)
    if is_ready:
        print("✅ SYSTEM READY FOR TESTING")
        print("   Run: ConfigTester.tscn in Godot Editor (F5)")
    else:
        print("❌ SYSTEM NOT READY")
        print("   Fix .env configuration first")
    print("="*60 + "\n")
    
    return 0 if is_ready else 1

if __name__ == "__main__":
    sys.exit(main())
