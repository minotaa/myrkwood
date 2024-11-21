extends Node

var enemies = []

func get_by_id(id: int) -> Enemy:
	for enemy in enemies:
		if enemy.id == id:
			return enemy
	return null

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
	baubles.health = 50.0
	baubles.attack_speed = 1.35
	baubles.attack = 8.0
	baubles.defense = 3.0
	baubles.exp = 5.0
	baubles.texture = load("res://assets/sprites/baubles.png")
	baubles.on_die = func ():
		Game.temp_drops_gained.append(Items.get_item_by_id(3))
	enemies.append(baubles)
	
	var slime = Enemy.new()
	slime.id = 1
	slime.name = "Slime"
	slime.description = "A viscous, sticky blob of a hungry being that would rather just eat you."
	slime.weight = 30.0
	slime.health = 75.0
	slime.attack_speed = 1.0
	slime.attack = 20.0
	slime.defense = 1.0
	slime.exp = 15.0
	slime.texture = load("res://assets/sprites/slime.png")
	slime.on_die = func ():
		Game.temp_drops_gained.append(Items.get_item_by_id(2))
	enemies.append(slime)
	print("enemies added")
