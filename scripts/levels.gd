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
	
	var two = Level.new()
	two.enemy_list = [
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0)
	]
	two.id = 2
	two.name = "Christmas Tree"
	levels.append(two)
	
	var three = Level.new()
	three.enemy_list = [
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(2)
	]
	three.id = 3
	three.name = "Amphibia"
	levels.append(three)

	var four = Level.new()
	four.enemy_list = [
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(3)
	]
	four.id = 4
	four.name = "Anura"
	levels.append(four)
	
	var five = Level.new()
	five.enemy_list = [
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(3),
		Enemies.get_by_id(5)
	]
	five.id = 5
	five.name = "Mycology 101"
	levels.append(five)
	
	var six = Level.new()
	six.enemy_list = [
		Enemies.get_by_id(5),
		Enemies.get_by_id(5),
		Enemies.get_by_id(5),
		Enemies.get_by_id(5),
		Enemies.get_by_id(5),
		Enemies.get_by_id(4)
	]
	six.id = 6
	six.name = "The Swamp Guardian"
	levels.append(six)
	
	var seven = Level.new()
	seven.enemy_list = [
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(0),
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(1),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(3),
		Enemies.get_by_id(5),
		Enemies.get_by_id(5),
		Enemies.get_by_id(5),
		Enemies.get_by_id(5),
		Enemies.get_by_id(4),
	]
	seven.id = 7
	seven.name = "The Black Lagoon"
	levels.append(seven)

	var eight = Level.new()
	eight.id = 8
	eight.name = "Heket"
	eight.enemy_list = [
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(2),
		Enemies.get_by_id(3),
		Enemies.get_by_id(6),
		Enemies.get_by_id(6),
		Enemies.get_by_id(6),
		Enemies.get_by_id(6),
	]
	levels.append(eight)
	
	var nine = Level.new()
	nine.id = 9
	nine.name = "The Apothecary"
	nine.enemy_list = [
		Enemies.get_by_id(6),
		Enemies.get_by_id(6),
		Enemies.get_by_id(6),
		Enemies.get_by_id(8),
		Enemies.get_by_id(8),
		Enemies.get_by_id(8),
		Enemies.get_by_id(7),
		Enemies.get_by_id(7),
		Enemies.get_by_id(7),
	]
	levels.append(nine)
