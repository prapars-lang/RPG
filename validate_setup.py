#!/usr/bin/env python3
"""
validate_setup.py - Validate the setup before testing
Run this to verify configuration is ready
"""

import os
import sys
from pathlib import Path

def check_env_file():
    """Check if .env file exists and has content"""
    home = Path.home()
    env_file = home / "AppData" / "Roaming" / "Godot" / "app_userdata" / "Educational Fantasy RPG" / ".env"
    
    print("\n📁 Checking .env file...")
    print(f"   Expected path: {env_file}")
    
    if not env_file.exists():
        print("   ❌ FAIL: .env file not found")
        return False
    
    print("   ✅ PASS: .env file exists")
    
    # Check content
    content = env_file.read_text()
    if "[llm]" not in content:
        print("   ❌ FAIL: .env missing [llm] section")
        return False
    
    if "api_key=" not in content:
        print("   ❌ FAIL: .env missing api_key")
        return False
    
    if "api_url=" not in content:
        print("   ❌ FAIL: .env missing api_url")
        return False
    
    if "model=" not in content:
        print("   ❌ FAIL: .env missing model")
        return False
    
    print("   ✅ PASS: .env has all required fields")
    return True

def check_scripts():
    """Check if required scripts exist"""
    print("\n📝 Checking scripts...")
    
    required_files = [
        "Scripts/ConfigManager.gd",
        "Scripts/LLMService.gd",
        "Scripts/Global.gd",
        "Scripts/ConfigTester.gd",
        "Scenes/ConfigTester.tscn",
        "project.godot",
    ]
    
    cwd = Path.cwd()
    all_exist = True
    
    for file in required_files:
        path = cwd / file
        if path.exists():
            print(f"   ✅ {file}")
        else:
            print(f"   ❌ {file} - NOT FOUND")
            all_exist = False
    
    return all_exist

def check_documentation():
    """Check if documentation exists"""
    print("\n📖 Checking documentation...")
    
    required_docs = [
        "README.md",
        "SETUP_GUIDE.md",
        "API_DOCUMENTATION.md",
        "TESTING_GUIDE.md",
        "QUALITY_CHECKLIST.md",
        "CONTRIBUTING.md",
    ]
    
    cwd = Path.cwd()
    all_exist = True
    
    for doc in required_docs:
        path = cwd / doc
        if path.exists():
            print(f"   ✅ {doc}")
        else:
            print(f"   ❌ {doc} - NOT FOUND")
            all_exist = False
    
    return all_exist

def main():
    print("\n" + "="*60)
    print("SETUP VALIDATION")
    print("="*60)
    
    results = {
        ".env File": check_env_file(),
        "Scripts": check_scripts(),
        "Documentation": check_documentation(),
    }
    
    print("\n" + "="*60)
    print("RESULTS")
    print("="*60)
    
    passed = sum(1 for v in results.values() if v)
    total = len(results)
    
    for check, result in results.items():
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status}: {check}")
    
    print("\n" + "="*60)
    if passed == total:
        print(f"✅ ALL CHECKS PASSED ({passed}/{total})")
        print("\nYou can now:")
        print("  1. Open Godot Editor")
        print("  2. Run ConfigTester.tscn to verify configuration")
        print("  3. Run MainMenu.tscn to test the game")
        print("  4. Follow TESTING_GUIDE.md for detailed testing steps")
        return 0
    else:
        print(f"❌ SOME CHECKS FAILED ({passed}/{total})")
        print("\nPlease fix the issues above and try again")
        return 1

if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)
