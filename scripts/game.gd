extends Node

var did_the_game_load_yet_also_big_boobs: bool = false

var health: float = 100.0
var magic: float = 100.0
var exp: float = 0.0

var inventory = []
var drops = []
var game_level: Level
var cached_enemy_list = []
var live_enemy_list = []
var highest_completed_level: int = 0

func _ready() -> void:
	pass

func get_attack_speed() -> float:
	return 1.0

func get_attack() -> float:
	return 25.0

func get_level() -> int: 
	var file = FileAccess.open("res://scripts/levels.json", FileAccess.READ)
	if not file:
		push_error("Failed to load levels.json")
		return -1
	var levels_data = JSON.parse_string(file.get_as_text())
	file.close()
	var current_level = 0
	for level in levels_data["levels"].keys():
		if int(levels_data["levels"][level]) <= exp:
			current_level = int(level)
		else:
			break
	return current_level

func get_progress() -> int:
	var file = FileAccess.open("res://scripts/levels.json", FileAccess.READ)
	if not file:
		push_error("Failed to load levels.json")
		return -1 
	var levels_data = JSON.parse_string(file.get_as_text())
	file.close()
	var current_level = 0
	for level in levels_data["levels"].keys():
		if int(levels_data["levels"][level]) <= exp:
			current_level = int(level)
		else:
			break
	var current_xp = levels_data["levels"][str(current_level)]
	var next_xp = levels_data["levels"].get(str(current_level + 1), current_xp)  # Handle max level case
	var progress = 0
	if next_xp > current_xp:
		progress = float(exp - current_xp) / float(next_xp - current_xp) * 100

	return int(clamp(progress, 0, 100))

func get_max_health() -> float:
	return 100.0

func get_max_magic() -> float:
	return 100.0

func get_defense() -> float:
	return 10.0
