extends Node

# AIConnectionTest.gd - Utility script to test the LLMService connection

func _ready():
	print("--- Starting AI Connection Test ---")
	
	# Wait one frame to ensure Autoloads are ready if calling from elsewhere
	await get_tree().process_frame
	
	if LLMService.api_key == "":
		print("WARNING: API Key is empty. Please set it in Scripts/LLMService.gd")
		return
		
	LLMService.request_completed.connect(_on_ai_success)
	LLMService.request_failed.connect(_on_ai_failure)
	
	print("Sending test request to OpenCode...")
	LLMService.generate_response("สวัสดีครับ ช่วยแนะนำตัวสั้นๆ ในฐานะผู้ช่วยในเกม RPG หน่อยครับ")

func _on_ai_success(response):
	print("✅ AI Success!")
	print("Response: ", response)
	print("--- Test Completed ---")

func _on_ai_failure(error):
	print("❌ AI Failure!")
	print("Error: ", error)
	print("--- Test Completed ---")
