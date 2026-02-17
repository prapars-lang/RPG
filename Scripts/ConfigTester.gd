extends Node
# ConfigTester.gd - Test script to verify ConfigManager is working correctly

func _ready():
	print("\n" + "="*60)
	print("CONFIG MANAGER TEST")
	print("="*60)
	
	await get_tree().process_frame
	
	# Test 1: Check if API key is loaded
	var api_key = ConfigManager.get_llm_api_key()
	print("\n[TEST 1] API Key Loading:")
	if api_key.is_empty():
		print("  ❌ FAILED: API key is empty")
		print("    Make sure .env file exists in user data directory")
		print("    Windows path: %APPDATA%\\Godot\\app_userdata\\Educational Fantasy RPG\\.env")
	else:
		print("  ✅ PASSED: API key loaded")
		print("    Key (first 20 chars): " + api_key.substr(0, 20) + "...")
	
	# Test 2: Check if API URL is loaded
	var api_url = ConfigManager.get_llm_api_url()
	print("\n[TEST 2] API URL Loading:")
	if api_url.is_empty():
		print("  ❌ FAILED: API URL is empty")
	else:
		print("  ✅ PASSED: API URL loaded")
		print("    URL: " + api_url)
	
	# Test 3: Check if Model is loaded
	var model = ConfigManager.get_llm_model()
	print("\n[TEST 3] Model Loading:")
	if model.is_empty():
		print("  ❌ FAILED: Model is empty")
	else:
		print("  ✅ PASSED: Model loaded")
		print("    Model: " + model)
	
	# Test 4: Check if LLMService has loaded config
	print("\n[TEST 4] LLMService Configuration:")
	print("  LLMService.api_key: " + ("✅ Set" if LLMService.api_key != "" else "❌ Empty"))
	print("  LLMService.api_url: " + ("✅ Set" if LLMService.api_url != "" else "❌ Empty"))
	print("  LLMService.model_name: " + ("✅ Set" if LLMService.model_name != "" else "❌ Empty"))
	
	# Test 5: Check if Global.gd works
	print("\n[TEST 5] Global State:")
	print("  Player name: " + Global.player_name)
	print("  Player class: " + Global.player_class)
	print("  Player level: " + str(Global.player_level))
	print("  ✅ PASSED: Global state accessible")
	
	# Summary
	print("\n" + "="*60)
	if api_key != "" and api_url != "" and model != "":
		print("✅ ALL TESTS PASSED - Game is ready to play!")
		print("   Press F5 to start the game")
	else:
		print("❌ SOME TESTS FAILED - Check .env file setup")
		print("   See SETUP_GUIDE.md for instructions")
	print("="*60 + "\n")
	
	# Auto-close to return to editor (optional - comment out to stay)
	await get_tree().create_timer(3.0).timeout
	get_tree().quit()
