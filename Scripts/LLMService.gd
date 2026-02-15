extends Node

# LLMService.gd - Singleton to handle requests to OpenCode AI (Thai LLM platform)

signal request_completed(response_text: String)
signal request_failed(error_message: String)

var api_key: String = "sk-G0tmEjZjb6Tpl9bjKStb723GFuvWgzzSapCN4W4QxiWj2u53pFqLUPtroe7OTQPr" # Set your OpenCode API Key here
var api_url: String = "https://api.opencode.ai/v1/chat/completions" # Confirming URL
var model_name: String = "typhoon-v1.5x-70b-instruct"

@onready var http_request = HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

func generate_response(prompt: String, system_prompt: String = "You are a helpful assistant in an educational RPG game."):
	if api_key == "":
		push_error("OpenCode API Key is missing. Please set it in LLMService.gd")
		request_failed.emit("Missing API Key")
		return

	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]

	var body = {
		"model": model_name,
		"messages": [
			{"role": "system", "content": system_prompt},
			{"role": "user", "content": prompt}
		],
		"temperature": 0.7
	}

	var json_body = JSON.stringify(body)
	var error = http_request.request(api_url, headers, HTTPClient.METHOD_POST, json_body)

	if error != OK:
		push_error("An error occurred in the HTTP request.")
		request_failed.emit("HTTP Request Error")

func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		var response_text = body.get_string_from_utf8()
		push_error("API Request failed with code: %d. Response: %s" % [response_code, response_text])
		request_failed.emit("API Error: %d" % response_code)
		return

	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result == OK:
		var response = json.get_data()
		if response.has("choices") and response["choices"].size() > 0:
			var message = response["choices"][0]["message"]["content"]
			request_completed.emit(message)
		else:
			request_failed.emit("Unexpected API response format")
	else:
		request_failed.emit("JSON Parse Error")
