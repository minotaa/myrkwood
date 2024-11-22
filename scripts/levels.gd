extends Node

var levels = []

func get_by_id(id: int) -> Level:
	for level in levels:
		if level.id == id:
			return level
	return null

func _ready() -> void:
	var zero = Level.new()
	zero.enemy_list = [
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(1)
	]
	zero.id = 0
	zero.name = "Departure"
	levels.append(zero)

	var one = Level.new()
	one.enemy_list = [
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(1)
	]
	one.id = 1
	one.name = "Borax"
	levels.append(one)
