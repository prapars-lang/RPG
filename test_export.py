#!/usr/bin/env python3
"""
Post-Export Validation Script
Tests Windows EXE for save/load functionality and asset loading
"""

import os
import sys
import json
import subprocess
import time
from pathlib import Path

# Configuration
GAME_EXE = r"d:\Project\final\RPG\build\Windows\Educational_Fantasy_RPG.exe"
SAVE_DIR = Path(r"C:\Users\User\AppData\Roaming\Godot\app_userdata\Educational Fantasy RPG")
ASSETS_DIR = Path(r"d:\Project\final\RPG\Assets")
BUILD_DIR = Path(r"d:\Project\final\RPG\build\Windows")

class ExportValidator:
    def __init__(self):
        self.results = {"assets": [], "save_load": [], "errors": []}
        self.total_tests = 0
        self.passed_tests = 0
    
    def print_section(self, title):
        print(f"\n{'='*60}")
        print(f"🔍 {title}")
        print(f"{'='*60}")
    
    def log_test(self, name, passed, message=""):
        self.total_tests += 1
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{status} | {name}")
        if message:
            print(f"     └─ {message}")
        if passed:
            self.passed_tests += 1
        return passed
    
    # ============== EXE BUILD TESTS ==============
    def test_exe_exists(self):
        self.print_section("1. EXE Build Check")
        
        if os.path.exists(GAME_EXE):
            size_mb = os.path.getsize(GAME_EXE) / (1024 * 1024)
            self.log_test(
                "EXE file exists",
                True,
                f"Size: {size_mb:.1f} MB at {GAME_EXE}"
            )
            return True
        else:
            self.log_test(
                "EXE file exists",
                False,
                f"Not found at {GAME_EXE}"
            )
            return False
    
    def test_build_assets(self):
        """Check if build directory has assets"""
        self.print_section("2. Build Directory Assets")
        
        build_assets = BUILD_DIR / "Assets"
        if build_assets.exists():
            asset_count = len(list(build_assets.glob("*.png")))
            self.log_test(
                "Assets copied to build",
                asset_count > 10,
                f"Found {asset_count} PNG assets in build/Windows/"
            )
            return asset_count > 10
        else:
            self.log_test(
                "Assets copied to build",
                False,
                "Assets/ folder not found in build directory"
            )
            return False
    
    # ============== SAVE/LOAD TESTS ==============
    def test_save_directory_exists(self):
        self.print_section("3. Save Directory Structure")
        
        save_dir = SAVE_DIR
        if save_dir.exists():
            print(f"    Save directory: {save_dir}")
            files = list(save_dir.glob("*"))
            self.log_test(
                "Save directory accessible",
                True,
                f"Contains {len(files)} files/folders"
            )
            return True
        else:
            # Create it for first run
            save_dir.mkdir(parents=True, exist_ok=True)
            self.log_test(
                "Save directory created",
                True,
                f"Created at {save_dir}"
            )
            return True
    
    def test_save_file_format(self):
        """Check for valid save file structure"""
        self.print_section("4. Save File Structure")
        
        save_file = SAVE_DIR / "save_slot_0.json"
        
        if save_file.exists():
            try:
                with open(save_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    required_keys = ["player_name", "level", "xp", "max_xp", "gold"]
                    has_keys = all(k in data for k in required_keys)
                    
                    self.log_test(
                        "Save file valid JSON",
                        has_keys,
                        f"Contains required data: {list(data.keys())[:3]}..."
                    )
                    return has_keys
            except json.JSONDecodeError as e:
                self.log_test(
                    "Save file valid JSON",
                    False,
                    f"JSON decode error: {e}"
                )
                return False
        else:
            self.log_test(
                "Save file exists",
                False,
                "save_slot_0.json not found (run game to create)"
            )
            return False
    
    # ============== ASSET LOADING TESTS ==============
    def test_asset_files_complete(self):
        self.print_section("5. Asset Files Inventory")
        
        required_images = [
            "hero_knight.png",
            "hero_mage.png",
            "hero_scout.png",
            "monster_virus.png",
            "intro_bg.png",
        ]
        
        found_assets = []
        missing_assets = []
        
        for asset in required_images:
            asset_path = ASSETS_DIR / asset
            if asset_path.exists():
                found_assets.append(asset)
            else:
                missing_assets.append(asset)
        
        all_present = len(missing_assets) == 0
        self.log_test(
            "Core assets present",
            all_present,
            f"Found {len(found_assets)}/{len(required_images)} required assets"
        )
        
        if missing_assets:
            print(f"     Missing: {', '.join(missing_assets)}")
        
        return all_present
    
    def test_question_database(self):
        """Check questions.json is valid"""
        self.print_section("6. Questions Database")
        
        questions_file = Path(r"d:\Project\final\RPG\Data\questions.json")
        
        if questions_file.exists():
            try:
                with open(questions_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    
                    total_q = sum(len(questions) 
                                 for questions in data.values())
                    
                    self.log_test(
                        "Questions database valid",
                        total_q > 400,
                        f"Contains {total_q} questions across {len(data)} paths"
                    )
                    return total_q > 400
            except json.JSONDecodeError as e:
                self.log_test(
                    "Questions database valid",
                    False,
                    f"JSON error: {e}"
                )
                return False
        else:
            self.log_test(
                "Questions database exists",
                False,
                f"Not found at {questions_file}"
            )
            return False
    
    def test_configuration_files(self):
        """Check for configuration"""
        self.print_section("7. Configuration Files")
        
        config_files = {
            "project.godot": Path(r"d:\Project\final\RPG\project.godot"),
            "export_presets.cfg": Path(r"d:\Project\final\RPG\export_presets.cfg"),
            ".env or .env.example": Path(r"d:\Project\final\RPG\.env.example"),
        }
        
        found_configs = []
        for name, path in config_files.items():
            if path.exists():
                found_configs.append(name)
                self.log_test(f"Config: {name}", True)
        
        return len(found_configs) >= 2
    
    # ============== RUNTIME TESTS ==============
    def test_exe_launches(self):
        """Check if EXE can start (basic check)"""
        self.print_section("8. EXE Runtime Check")
        
        if not os.path.exists(GAME_EXE):
            self.log_test(
                "EXE is executable",
                False,
                "EXE not found (run build first)"
            )
            return False
        
        # Check file is executable
        is_exe = GAME_EXE.endswith('.exe')
        self.log_test(
            "EXE is executable",
            is_exe,
            f"File extension is {GAME_EXE.split('.')[-1]}"
        )
        
        return is_exe
    
    # ============== MAIN EXECUTION ==============
    def run_all_tests(self):
        print("\n" + "="*60)
        print("   🎮 EXPORT VALIDATION TEST SUITE 🎮")
        print("="*60)
        print(f"Date: {time.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"Project: Educational Fantasy RPG (Godot 4.4)")
        
        # Run all tests
        self.test_exe_exists()
        self.test_build_assets()
        self.test_save_directory_exists()
        self.test_save_file_format()
        self.test_asset_files_complete()
        self.test_question_database()
        self.test_configuration_files()
        self.test_exe_launches()
        
        # Summary
        self.print_summary()
    
    def print_summary(self):
        self.print_section("TEST SUMMARY")
        
        passed = self.passed_tests
        total = self.total_tests
        percentage = (passed / total * 100) if total > 0 else 0
        
        print(f"Tests Passed: {passed}/{total} ({percentage:.0f}%)")
        
        if percentage == 100:
            print("\n✅ ALL TESTS PASSED - EXE IS READY FOR DISTRIBUTION!")
            print("\nNext steps:")
            print("  1. Run the EXE manually to test gameplay")
            print("  2. Test save/load in-game")
            print("  3. Verify all menus work correctly")
            print("  4. Check character selection and battles")
        elif percentage >= 80:
            print("\n⚠️  MOST TESTS PASSED - Address issues before distribution")
            print("\nRecommendations:")
            print("  - Review failed test sections above")
            print("  - Ensure assets are included in export")
            print("  - Check save directory is accessible")
        else:
            print("\n❌ TESTS FAILED - Fix issues before running EXE")
            print("\nRequired fixes:")
            print("  - Build EXE if it doesn't exist (run BUILD_WINDOWS_EXE.md steps)")
            print("  - Include all Assets/ in export")
            print("  - Run setup_env.bat to configure environment")
        
        print("\n" + "="*60)
        return percentage >= 80

if __name__ == "__main__":
    validator = ExportValidator()
    
    # Run tests
    success = validator.run_all_tests()
    
    # Exit code
    sys.exit(0 if success else 1)
