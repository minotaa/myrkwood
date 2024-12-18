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
	baubles.location = "forest"
	baubles.texture = load("res://assets/sprites/baubles.png")
	baubles.on_die = func ():
		ToastParty.show({
			"text": "You also got a Glass Shard!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
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
	slime.location = "forest"
	slime.texture = load("res://assets/sprites/slime.png")
	slime.on_die = func ():
		var amount = randi_range(1, 5)
		ToastParty.show({
			"text": "You also got x" + str(amount) + " Goop!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		for i in amount:
			Game.temp_drops_gained.append(Items.get_item_by_id(2))
	enemies.append(slime)
	
	var tadpole = Enemy.new()
	tadpole.id = 2
	tadpole.name = "Tadpole"
	tadpole.description = "Bigger than it looks."
	tadpole.weight = 50.0
	tadpole.health = 125.0
	tadpole.attack_speed = 1.25
	tadpole.attack = 35.0
	tadpole.defense = 1.5
	tadpole.exp = 45.0
	tadpole.location = "forest"
	tadpole.on_die = func ():
		var amount = randi_range(1, 3)
		ToastParty.show({
			"text": "You also got x" + str(amount) + " Frogspawn!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		for i in amount:
			Game.temp_drops_gained.append(Items.get_item_by_id(6))
	tadpole.texture = load("res://assets/sprites/tadpole.png")
	enemies.append(tadpole)
	
	var fungal_tadpole = Enemy.new()
	fungal_tadpole.id = 3
	fungal_tadpole.name = "Fungal Tadpole"
	fungal_tadpole.description = "Do you know the Zombie-ant fungus? Yeah, that."
	fungal_tadpole.weight = 10.0
	fungal_tadpole.health = 350.0
	fungal_tadpole.attack_speed = 2.15
	fungal_tadpole.attack = 50.0
	fungal_tadpole.defense = 5.0
	fungal_tadpole.exp = 100.0
	fungal_tadpole.location = "forest"
	fungal_tadpole.texture = load("res://assets/sprites/tadpole_fungus.png")
	fungal_tadpole.on_die = func():
		pass
	enemies.append(fungal_tadpole)
	
	var minos_fly_trap = Enemy.new()
	minos_fly_trap.id = 4
	minos_fly_trap.name = "Minos Fly Trap"
	minos_fly_trap.description = "The protector of the swamp."
	minos_fly_trap.weight = 0.005
	minos_fly_trap.health = 1250.0
	minos_fly_trap.attack_speed = 4.5
	minos_fly_trap.attack = 75.0
	minos_fly_trap.defense = 0.0
	minos_fly_trap.exp = 500.0
	minos_fly_trap.location = "forest"
	minos_fly_trap.texture = load("res://assets/sprites/minos_fly_trap.png")
	minos_fly_trap.on_die = func():
		var amount = randi_range(1, 2)
		ToastParty.show({
			"text": "You also got x" + str(amount) + " Blades of Grass!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		for i in amount:
			Game.temp_drops_gained.append(Items.get_item_by_id(8))
		if randf() <= 0.2:
			ToastParty.show({
				"text": "RARE DROP! You also got a Flytrap Leaf!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 24
			})
			Game.temp_drops_gained.append(Items.get_item_by_id(9))
	enemies.append(minos_fly_trap)
	
	var minos_shroom = Enemy.new()
	minos_shroom.id = 5
	minos_shroom.name = "Minos Shroom"
	minos_shroom.description = "Protector of the protector, kind of silly if you think about it."
	minos_shroom.weight = 100.0
	minos_shroom.health = 250.0
	minos_shroom.attack_speed = 4.0
	minos_shroom.attack = 30.0
	minos_shroom.defense = 0.0
	minos_shroom.exp = 0.0
	minos_shroom.location = "forest"
	minos_shroom.texture = load("res://assets/sprites/mino_shroom.png")
	minos_shroom.on_die = func():
		pass
	enemies.append(minos_shroom)
	
	var frog = Enemy.new()
	frog.id = 6
	frog.name = "Frog"
	frog.description = "Grown up version of the tadpole, surprisingly pretty chill."
	frog.weight = 75.0
	frog.health = 400.0
	frog.attack_speed = 2.25
	frog.attack = 30.0
	frog.defense = 10.0
	frog.exp = 200.0
	frog.location = "sea"
	frog.texture = load("res://assets/sprites/frog.png")
	frog.on_die = func():
		var amount = randi_range(3, 6)
		ToastParty.show({
			"text": "You also got x" + str(amount) + " Frogspawn!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		for i in amount:
			Game.temp_drops_gained.append(Items.get_item_by_id(6))
		await get_tree().create_timer(0.1).timeout
		amount = randi_range(3, 6)
		ToastParty.show({
			"text": "You also got x" + str(amount) + " Blades of Grass!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		for i in amount:
			Game.temp_drops_gained.append(Items.get_item_by_id(8))
	enemies.append(frog)
		
	var warm_frog = Enemy.new()
	warm_frog.id = 7
	warm_frog.name = "Warm Frog"
	warm_frog.description = "A frog that comes from warmer climate lands, also is poisonous for some reason."
	warm_frog.weight = 50.0
	warm_frog.health = 400.0
	warm_frog.attack_speed = 2.0
	warm_frog.attack = 28.9
	warm_frog.defense = 0.0
	warm_frog.exp = 250.0
	warm_frog.location = "sea"
	warm_frog.texture = load("res://assets/sprites/warm_frog.png")
	warm_frog.on_die = func():
		if randf() <= 0.2:
			ToastParty.show({
				"text": "RARE DROP! You also got a Poison Orb!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 24
			})
			Game.temp_drops_gained.append(Items.get_item_by_id(12))
	warm_frog.on_attack = func():
		var found = false
		for effect in Game.active_status_effects:
			if effect.id == 1:
				found = true
		if not found:
			if randf() <= 0.3:
				var poison = Effect.new()
				poison.duration = 8.0
				poison.id = 1
				poison.name = "Poison"
				poison.texture = load("res://assets/sprites/poison.png")
				poison.on_update = func(effect: Effect):
					if int(effect.duration) % 2 == 0:
						var damage = (Game.get_max_health() * 0.1)
						Game.health -= damage
						print("You were poisoned a bit (" + str(damage) + ")") 
				Game.apply_status_effect(poison)
	enemies.append(warm_frog)
	
	var poison_slime = Enemy.new()
	poison_slime.id = 8
	poison_slime.name = "Poison Slime"
	poison_slime.description = "The jungle has made this slime adept for survival with its poisonous membrane."
	poison_slime.weight = 75.0
	poison_slime.health = 175.0
	poison_slime.attack_speed = 1.0
	poison_slime.attack = 20.0
	poison_slime.defense = 1.0
	poison_slime.exp = 100.0
	poison_slime.location = "sea"
	poison_slime.texture = load("res://assets/sprites/poison_slime.png")
	poison_slime.on_die = func ():
		var amount = randi_range(5, 12)
		ToastParty.show({
			"text": "You also got x" + str(amount) + " Goop!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		for i in amount:
			Game.temp_drops_gained.append(Items.get_item_by_id(2))
		if randf() <= 0.2:
			ToastParty.show({
				"text": "RARE DROP! You also got a Poison Orb!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 24
			})
			Game.temp_drops_gained.append(Items.get_item_by_id(12))
	poison_slime.on_attack = func():
		var found = false
		for effect in Game.active_status_effects:
			if effect.id == 1:
				found = true
		if not found:
			var poison = Effect.new()
			poison.duration = 5.0
			poison.id = 1
			poison.name = "Poison"
			poison.texture = load("res://assets/sprites/poison.png")
			poison.on_update = func(effect: Effect):
				#if int(effect.duration) % 2 == 0:
				var damage = (Game.get_max_health() * 0.1)
				Game.health -= damage
				print("You were poisoned a bit (" + str(damage) + ")") 
			Game.apply_status_effect(poison)
	enemies.append(poison_slime)
	print("enemies added")
