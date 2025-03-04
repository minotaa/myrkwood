extends Node

var items = []

func get_item_by_id(id: int) -> ItemType:
	for item in items:
		if item.id == id:
			return item
	return null

func _init() -> void:
	var wooden_sword = Sword.new()
	wooden_sword.id = 0 
	wooden_sword.description = "+{attack} DMG, ol' reliable."
	wooden_sword.name = "Wooden Sword"
	wooden_sword.upgrade_message = "Increases damage by 10, increases XP earned by 10% per monster killed."
	wooden_sword.max_level = 20
	wooden_sword.damage = func():
		return 5 + (Game.get_current_weapon_level() * 10)
	wooden_sword.on_kill = func(enemy: Enemy):
		var bonus_multiplier = 0.1 * Game.get_current_weapon_level()  # 10% bonus per level
		var total_exp = enemy.exp + (enemy.exp * bonus_multiplier)
		Game.temp_exp_gained += total_exp
		Game.exp += total_exp
	var atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(0.0, 0.0, 16.0, 16.0)
	wooden_sword.texture = atlas
	wooden_sword.base_damage = 5
	items.append(wooden_sword)
	
	var hoodie = Armor.new()
	hoodie.id = 1
	hoodie.name = "T-Shirt"
	hoodie.texture_id = "normal"
	hoodie.description = "Doesn't give any benefits but looks nice!"
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(16.0, 0.0, 16.0, 16.0)
	hoodie.texture = atlas
	hoodie.defense = 0.0
	hoodie.health = 0.0
	items.append(hoodie)
	
	var goop = ItemType.new()
	goop.id = 2
	goop.name = "Goop"
	goop.description = "A ball of goop dropped from a slime has regenerative properties."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(32.0, 0.0, 16.0, 16.0)
	goop.texture = atlas
	items.append(goop)
	
	var glass_shard = ItemType.new()
	glass_shard.id = 3
	glass_shard.name = "Glass Shard"
	glass_shard.description = "A triangular shard of glass dropped from an ornament. "
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(80.0, 0.0, 16.0, 16.0)
	glass_shard.texture = atlas
	items.append(glass_shard)
	
	var glass_knife = Sword.new()
	glass_knife.id = 4
	glass_knife.name = "Glass Knife"
	glass_knife.description = "+{attack} DMG, a sharp tempered glass knife, has a 20% chance to apply Bleeding"
	glass_knife.upgrade_message = "Increases damage by 3, and increases bleed effect by 0.5s"
	glass_knife.max_level = 5
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(64.0, 0.0, 16.0, 16.0)
	glass_knife.texture = atlas
	glass_knife.damage = func():
		return 20.0 + (Game.get_current_weapon_level() * 3)
	glass_knife.base_damage = 20.0
	glass_knife.base_attack_speed = -0.125
	glass_knife.on_hit = func(enemy: Enemy, final_damage: float):
		var found = false
		for effect in enemy.active_status_effects:
			if effect.id == 0:
				found = true
		if randf() <= 0.2:
			if not found:
				var bleed = EnemyEffect.new()
				bleed.duration = 2.5 + (Game.get_current_weapon_level() * 0.5)
				bleed.id = 0
				bleed.name = "Bleeding"
				bleed.texture = load("res://assets/sprites/bleed.png")
				bleed.on_update = func(enemy: Enemy, effect: EnemyEffect):
					Game.enemy_health -= 5.0
					print(enemy.name + " bled a little bit")
				enemy.apply_status_effect(bleed)
	glass_knife.craftable = true
	var min_requirement = ItemStack.new(get_item_by_id(3), 1)
	glass_knife.min_requirement = [min_requirement]
	var requirement = ItemStack.new(get_item_by_id(3), 5)
	glass_knife.requirement = [requirement]
	glass_knife.only_craft_once = true
	items.append(glass_knife)
	
	var small_healing_potion = Consumable.new()
	small_healing_potion.id = 5
	small_healing_potion.name = "Small Healing Potion"
	small_healing_potion.description = "Heals +25 HP, 5 second cooldown."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(96.0, 0.0, 16.0, 16.0)
	small_healing_potion.texture = atlas
	small_healing_potion.cooldown = true
	small_healing_potion.cooldown_seconds = 5
	small_healing_potion.infinite = false
	small_healing_potion.craftable = true
	min_requirement = ItemStack.new(get_item_by_id(2), 1)
	small_healing_potion.min_requirement = [min_requirement]
	requirement = ItemStack.new(get_item_by_id(2), 5)
	small_healing_potion.requirement = [requirement]
	small_healing_potion.on_consume = func():
		Game.health = min(Game.health + 25, Game.get_max_health())
	items.append(small_healing_potion)
	
	var frogspawn = ItemType.new()
	frogspawn.id = 6
	frogspawn.name = "Frogspawn"
	frogspawn.description = "A frog egg, it's soft, squishy, springy jelly, almost like gelatin."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(128.0, 0.0, 16.0, 16.0)
	frogspawn.texture = atlas
	items.append(frogspawn)
	
	var froggy_armor = Armor.new()
	froggy_armor.id = 7
	froggy_armor.name = "Froggy Armor"
	froggy_armor.description = "+100 HP, +45 DEF"
	froggy_armor.texture_id = "froggy"
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(112.0, 0.0, 16.0, 16.0)
	froggy_armor.texture = atlas
	froggy_armor.defense = 45.0
	froggy_armor.health = 100.0
	froggy_armor.craftable = true
	froggy_armor.only_craft_once = true
	min_requirement = ItemStack.new(get_item_by_id(6), 1)
	froggy_armor.min_requirement = [min_requirement]
	requirement = ItemStack.new(get_item_by_id(6), 15)
	froggy_armor.requirement = [requirement]
	items.append(froggy_armor)

	var blade_of_grass = ItemType.new()
	blade_of_grass.id = 8
	blade_of_grass.name = "Blade of Grass"
	blade_of_grass.description = "Substitutes as an instrument if you're skilled enough."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(160.0, 0.0, 16.0, 16.0)
	blade_of_grass.texture = atlas
	items.append(blade_of_grass)
	
	var flytrap_leaves = ItemType.new()
	flytrap_leaves.id = 9 
	flytrap_leaves.name = "Flytrap Leaves"
	flytrap_leaves.description = "Heavy clump of leaves grown from a flytrap."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(176.0, 0.0, 16.0, 16.0)
	flytrap_leaves.texture = atlas
	items.append(flytrap_leaves)
	
	var axe_of_the_dionaea = Sword.new()
	axe_of_the_dionaea.id = 10
	axe_of_the_dionaea.name = "Axe of the Dionaea"
	axe_of_the_dionaea.description = "+{attack} DMG, a sluggish powerful axe made from the felled Minos Fly Trap."
	axe_of_the_dionaea.base_damage = 100
	axe_of_the_dionaea.base_attack_speed = 1.5
	axe_of_the_dionaea.attack_speed = func():
		return 1.5 - (0.1 * Game.get_current_weapon_level())
	axe_of_the_dionaea.damage = func():
		return 100 + (2 * Game.get_current_weapon_level())
	axe_of_the_dionaea.upgrade_message = "Increases damage by 2, increases attack speed by 0.1."
	axe_of_the_dionaea.max_level = 5
	
	var flytrap_req = ItemStack.new(get_item_by_id(9), 3)
	var blade_of_grass_min_req = ItemStack.new(get_item_by_id(8), 1)
	var blade_of_grass_req = ItemStack.new(get_item_by_id(8), 5)
	
	axe_of_the_dionaea.craftable = true
	axe_of_the_dionaea.only_craft_once = true
	axe_of_the_dionaea.min_requirement = [blade_of_grass_min_req]
	axe_of_the_dionaea.requirement = [blade_of_grass_req, flytrap_req]
	
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(144.0, 0.0, 16.0, 16.0)
	axe_of_the_dionaea.texture = atlas
	items.append(axe_of_the_dionaea)
	
	var medium_healing_potion = Consumable.new()
	medium_healing_potion.id = 11
	medium_healing_potion.name = "Medium Healing Potion"
	medium_healing_potion.description = "Heals +100 HP, 4.5 second cooldown."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(48.0, 0.0, 16.0, 16.0)
	medium_healing_potion.texture = atlas
	medium_healing_potion.cooldown = true
	medium_healing_potion.cooldown_seconds = 4.5
	medium_healing_potion.infinite = false
	medium_healing_potion.craftable = true
	
	var potion_req = ItemStack.new(get_item_by_id(5), 1)
	medium_healing_potion.min_requirement = [blade_of_grass_min_req]
	medium_healing_potion.requirement = [potion_req, blade_of_grass_min_req]
	medium_healing_potion.on_consume = func():
		Game.health = min(Game.health + 100, Game.get_max_health())
	items.append(medium_healing_potion)
	
	var poison_gland = ItemType.new()
	poison_gland.id = 12
	poison_gland.name = "Poison Orb"
	poison_gland.description = "A poisonous gland, dropped from a felled poisonous monster."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(224.0, 0.0, 16.0, 16.0)
	poison_gland.texture = atlas
	items.append(poison_gland)
	
	var venomous_axe = Sword.new()
	venomous_axe.id = 13
	venomous_axe.name = "Venomous Axe"
	venomous_axe.description = "+{attack} DMG, an upgraded axe that can cause poison on swing."
	venomous_axe.base_damage = 150
	venomous_axe.base_attack_speed = 1.2
	venomous_axe.upgrade_message = "Increases duration of Poison by 1s, poison chance by 5%."
	venomous_axe.max_level = 5
	venomous_axe.craftable = true
	venomous_axe.only_craft_once = true
	venomous_axe.min_requirement = [ItemStack.new(get_item_by_id(12), 1)]
	venomous_axe.requirement = [
		ItemStack.new(get_item_by_id(12), 3), 
		ItemStack.new(get_item_by_id(10), 1), 
		ItemStack.new(get_item_by_id(6), 100)
	]
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(208.0, 0.0, 16.0, 16.0)
	venomous_axe.texture = atlas
	venomous_axe.on_hit = func(enemy: Enemy, final_damage: float):
		var found = false
		for effect in enemy.active_status_effects:
			if effect.id == 1:
				found = true
		var chance = 0.35 + (Game.get_current_weapon_level() * 0.05)
		if randf() <= chance:
			if not found:
				var poison = EnemyEffect.new()
				poison.duration = 5.0 + (Game.get_current_weapon_level())
				poison.id = 1
				poison.name = "Poison"
				poison.texture = load("res://assets/sprites/poison.png")
				poison.on_update = func(enemy: Enemy, effect: EnemyEffect):
					if int(effect.duration) % 2 == 0:
						var damage = (Game.enemy_max_health * 0.1)
						Game.enemy_health -= damage
						print(enemy.name + " was poisoned a bit (" + str(damage) + ")") 
				enemy.apply_status_effect(poison)
	items.append(venomous_axe)
	
	var bullfrog_armor = Armor.new()
	bullfrog_armor.id = 14
	bullfrog_armor.name = "Bullfrog Armor"
	bullfrog_armor.description = "+200 HP, +75 DEF; Enhanced version of the Froggy Armor."
	bullfrog_armor.texture_id = "bullfrog"
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(192.0, 0.0, 16.0, 16.0)
	bullfrog_armor.texture = atlas
	bullfrog_armor.defense = 75.0
	bullfrog_armor.health = 200.0
	bullfrog_armor.craftable = true
	bullfrog_armor.only_craft_once = true
	bullfrog_armor.min_requirement = [ItemStack.new(get_item_by_id(12), 1)]
	bullfrog_armor.requirement = [ItemStack.new(get_item_by_id(12), 5), ItemStack.new(get_item_by_id(7), 1),  ItemStack.new(get_item_by_id(6), 100)]
	items.append(bullfrog_armor)
	
	var pincers = ItemType.new()
	pincers.id = 15
	pincers.name = "Pincers"
	pincers.description = "Pincers straight from a crab."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(240.0, 0.0, 16.0, 16.0)
	pincers.texture = atlas
	items.append(pincers)
	
	var tempered_exoskeleton = ItemType.new()
	tempered_exoskeleton.id = 16 
	tempered_exoskeleton.name = "Tempered Exoskeleton"
	tempered_exoskeleton.description = "Revitalized crustacean exoskeleton."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(32.0, 16.0, 16.0, 16.0)
	tempered_exoskeleton.texture = atlas
	tempered_exoskeleton.craftable = true
	tempered_exoskeleton.min_requirement = [ItemStack.new(get_item_by_id(15), 1)]
	tempered_exoskeleton.requirement = [ItemStack.new(get_item_by_id(15), 5), ItemStack.new(get_item_by_id(3), 5)]
	items.append(tempered_exoskeleton)
	
	var crabby_armor = Armor.new()
	crabby_armor.id = 17
	crabby_armor.name = "Carapace Armor"
	crabby_armor.description = "+300 HP, +200 DEF"
	crabby_armor.texture_id = "crabby"
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(64.0, 16.0, 16.0, 16.0)
	crabby_armor.texture = atlas
	crabby_armor.defense = 200.0
	crabby_armor.health = 300.0
	crabby_armor.craftable = true
	crabby_armor.only_craft_once = true
	crabby_armor.min_requirement = [ItemStack.new(get_item_by_id(16), 1)]
	crabby_armor.requirement = [ItemStack.new(get_item_by_id(16), 15)]
	items.append(crabby_armor)
	
	
	print("items added")
