extends Node

# QuestManager.gd - Logic for quest state management
# Part of the Quest & Story System

const QuestData = preload("res://Scripts/Quests/QuestData.gd")

static func activate_quest(quest_id: String):
	if not Global.active_quests.has(quest_id) and not Global.completed_quests.has(quest_id):
		Global.active_quests.append(quest_id)
		print("Quest Activated: ", quest_id)

static func complete_quest(quest_id: String):
	if Global.active_quests.has(quest_id):
		Global.active_quests.erase(quest_id)
		if not Global.completed_quests.has(quest_id):
			Global.completed_quests.append(quest_id)
			
			# Grant Rewards
			var data = QuestData.get_quest(quest_id)
			if not data.is_empty():
				Global.player_xp += data.xp_reward
				Global.player_gold += data.gold_reward
				print("Quest Completed: ", data.title, " | Rewards: ", data.xp_reward, " XP, ", data.gold_reward, " Gold")
				
				# Trigger Level Up check if needed (handled in XP setter usually, or call manually)
				if Global.has_method("check_level_up"):
					Global.check_level_up()

static func is_quest_active(quest_id: String) -> bool:
	return Global.active_quests.has(quest_id)

static func is_quest_completed(quest_id: String) -> bool:
	return Global.completed_quests.has(quest_id)
