extends Node

var enemies = []

func get_random_enemy(bonus_weight: float, location: String) -> Enemy:
	var list = []
	var total_weight = 0
	for enemy in enemies:
		if enemy.location == location:
			list.append(enemy)
	for enemy in list:
		total_weight += enemy.weight 
	var random_value = randi() % floori(total_weight)
	var current_weight = 0 + bonus_weight
	var shuffled_list = list
	shuffled_list.shuffle()
	for enemy in shuffled_list:
		current_weight += enemy.weight
		if random_value < current_weight:
			return enemy
	return null
			
func _ready() -> void:
	var baubles = Enemy.new()
	baubles.id = 0
	baubles.name = "Baubles"
	baubles.description = "Colorful Christmas ornamental balls, they've sprouted wings and now want to wreak havoc."
	baubles.weight = 20.0
	baubles.health = 80.0
	baubles.attack_speed = 0.5
	baubles.attack = 8.0
	baubles.defense = 3.0
	baubles.texture = load("res://assets/sprites/baubles.png")
	enemies.append(baubles)

	print(get_random_enemy(0.0, "forest"))
