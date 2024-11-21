extends Node

var did_the_game_load_yet_also_big_boobs: bool = false

var health: float = 100.0
var magic: float = 100.0

var exp: float = 0.0
var temp_exp_gained: float = 0.0
var temp_drops_gained = []

var equipment = []
var drops = []
var game_level: Level
var cached_enemy_list = []
var live_enemy_list = []
var highest_completed_level: int = 0

func load_game():
	if did_the_game_load_yet_also_big_boobs == true:
		return
	if not FileAccess.file_exists("user://game.april"):
		return
	var save_file = FileAccess.open("user://game.april", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var data = json.get_data()
		if data.has("exp"):
			exp = data["exp"]
		if data.has("highest_completed_level"):
			highest_completed_level = data["highest_completed_level"]
		if data.has("equipment"):
			Inventories.equipment.set_list_from_save(data["equipment"])
		if data.has("drops"):
			Inventories.drops.set_list_from_save(data["drops"])
		if data.has("equipped_weapon"):
			Inventories.equipment.weapon = Items.get_item_by_id(data["equipped_weapon"])
	
	print("Loaded the game.")
	did_the_game_load_yet_also_big_boobs = true
	
func get_game_save_data() -> Dictionary:
	return {
		"highest_completed_level": highest_completed_level,
		"exp": exp,
		"equipment": Inventories.equipment.to_list(),
		"drops": Inventories.drops.to_list(),
		"equipped_weapon": Inventories.equipment.weapon.id
	}
	
func save_game(_data: Dictionary, reason: String):
	var save_file = FileAccess.open("user://game.april", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(get_game_save_data()))
	print("Saved the game. " + "(" + reason + ")")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		save_game(get_game_save_data(), "went to background")

func _ready() -> void:
	load_game()

func get_attack_speed() -> float:
	var attack_speed = 1.0
	return attack_speed

func get_attack() -> float:
	var attack = 20.0
	return attack
	
func get_max_health() -> float:
	var max_health = 100.0
	max_health += 10 * get_level()
	return max_health

func get_max_magic() -> float:
	var max_magic = 100.0
	max_magic += 1 * get_level()
	return max_magic

func get_defense() -> float:
	var defense = 10.0
	defense += 3 * get_level()
	return defense

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
