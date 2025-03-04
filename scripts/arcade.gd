extends Node2D

var level_object = preload("res://scenes/arcade_level.tscn")

const DIFFICULTY_TIERS = {0: 0.5, 1: 1.0, 2: 1.5} 
const DIFFICULTY_NAMES = ["Easy", "Medium", "Hard"]
const SCENARIOS = [""]

func generate_level(level_tier: int) -> Level:
	var level = Level.new()
	level.id = int(Game.rng.randi_range(1, 100000))
	level.name = DIFFICULTY_NAMES[level_tier]
	level.difficulty = level_tier 

	var difficulty_multiplier = DIFFICULTY_TIERS[level_tier]
	var enemy_count = level_tier * 3 + 3  # Example: Easy = 3, Medium = 6, Hard = 9 enemies
	for i in range(enemy_count):
		var enemy = generate_enemy(difficulty_multiplier)
		if enemy:
			level.enemy_list.append(enemy)
	return level

func generate_enemy(difficulty_multiplier: float) -> Enemy:
	var eligible_enemies = filter_eligible_enemies()
	if eligible_enemies.is_empty():
		return null
		
	var base_enemy = pick_random_enemy(eligible_enemies)
	var scaled_enemy = Enemy.new()

	scaled_enemy.id = base_enemy.id
	scaled_enemy.name = base_enemy.name
	scaled_enemy.description = base_enemy.description
	scaled_enemy.texture = base_enemy.texture
	scaled_enemy.health = scale_stat(base_enemy.health, Game.kill_points, 0.09)
	scaled_enemy.defense = scale_stat(base_enemy.defense, Game.kill_points, 0.1)
	scaled_enemy.attack = scale_stat(base_enemy.attack, Game.kill_points, 0.15)
	scaled_enemy.attack_speed = base_enemy.attack_speed
	scaled_enemy.gold = base_enemy.gold
	scaled_enemy.exp = base_enemy.exp
	scaled_enemy.location = base_enemy.location
	return scaled_enemy

func filter_eligible_enemies() -> Array:
	var eligible_enemies = []
	for enemy in Enemies.enemies:
		if Game.kill_points >= enemy.kill_point_requirement:
			eligible_enemies.append(enemy)
	return eligible_enemies

func pick_random_enemy(eligible_enemies: Array) -> Enemy:
	var total_weight = 0.0
	for enemy in eligible_enemies:
		total_weight += enemy.weight
	var random_value = Game.rng.randf() * total_weight
	var current_weight = 0.0
	for enemy in eligible_enemies:
		current_weight += enemy.weight
		if random_value <= current_weight:
			return enemy
	return eligible_enemies[0]

func scale_stat(base_value: float, kill_points: int, scaling_factor: float) -> float:
	var min_scaling = 0.1
	var max_scaling = 10.0
	var scaling_adjustment = lerp(
		min_scaling,
		max_scaling,
		kill_points / (kill_points + 50.0) * scaling_factor
	)
	return round(base_value * scaling_adjustment)

func scale_exp(base_exp: float, difficulty_multiplier: float) -> float:
	return base_exp + (Game.kill_points * difficulty_multiplier * Game.rng.randf_range(0.5, 1.0))

func refresh_menu() -> void:
	print("refreshed menu")

	if Inventories.equipment.weapon != null:
		var attack = roundi(Inventories.equipment.weapon.damage.call())
		$UI/Main/TabContainer/Loadout/Weapon/TextureRect.texture = Inventories.equipment.weapon.texture
		$UI/Main/TabContainer/Loadout/Weapon/Name.text = Inventories.equipment.weapon.name
		$UI/Main/TabContainer/Loadout/Weapon/Description.text = Inventories.equipment.weapon.description.replace("{attack}", str(roundi(attack)))
	
	if Inventories.equipment.armor != null:
		$UI/Main/TabContainer/Loadout/Armor/TextureRect.texture = Inventories.equipment.armor.texture
		$UI/Main/TabContainer/Loadout/Armor/Name.text = Inventories.equipment.armor.name
		$UI/Main/TabContainer/Loadout/Armor/Description.text = Inventories.equipment.armor.description
	
		var outfit = load("res://assets/sprites/c" + str(1) + "_" + Inventories.equipment.armor.texture_id + ".png")
		$UI/Main/TextureRect.texture = outfit
	
	if Inventories.equipment.consumable != null and Inventories.equipment.get_item_stack(Inventories.equipment.consumable) == null:
		Inventories.equipment.consumable = null
	
	#if Inventories.equipment.consumable != null:
		#if Inventories.equipment.get_item_stack(Inventories.equipment.consumable).amount <= 1:
			#$UI/Main/TabContainer/Loadout/Consumable/Amount.visible = false
		#else:
			#$UI/Main/TabContainer/Loadout/Consumable/Amount.visible = true
			#$UI/Main/TabContainer/Loadout/Consumable/Amount.text = "x" + str(Inventories.equipment.get_item_stack(Inventories.equipment.consumable).amount)
		#$UI/Main/TabContainer/Loadout/Consumable/TextureRect.texture = Inventories.equipment.consumable.texture
		#$UI/Main/TabContainer/Loadout/Consumable/Name.text = Inventories.equipment.consumable.name
		#$UI/Main/TabContainer/Loadout/Consumable/Description.text = Inventories.equipment.consumable.description
	#else:
		#$UI/Main/TabContainer/Loadout/Consumable/TextureRect.texture = load("res://assets/sprites/null.png")
		#$UI/Main/TabContainer/Loadout/Consumable/Name.text = "Nothing"
		#$UI/Main/TabContainer/Loadout/Consumable/Description.text = "Nothing is better than something!"
		#$UI/Main/TabContainer/Loadout/Consumable/Amount.visible = false
	
	
	$UI/Main/TabContainer/Levels/Seed.text = str(Game.rng.seed)
	var meta: String = "Level: "
	meta += "\nHealth: " + str(roundi(Game.get_max_health()))
	meta += "\nAttack: " + str(roundi(Game.get_attack()))
	meta += "\nDefense: " + str(roundi(Game.get_defense()))
	meta += "\nIntelligence: " + str(roundi(Game.get_max_magic()))
	meta += "\nGold: " + str(roundi(Game.gold))
	meta += "\nKarma: " + str(roundi(Game.kill_points))
	$UI/Main/Meta.text = meta
	$UI/Main/Level/ProgressBar.value = Game.get_progress()
	$UI/Main/Level/Label.text = str(roundi(Game.get_level()))

	if Inventories.equipment.armor != null:
		var outfit = load("res://assets/sprites/c" + str(1) + "_" + Inventories.equipment.armor.texture_id + ".png")
		$UI/Main/TextureRect.texture = outfit

	for children in $UI/Main/TabContainer/Levels/ScrollContainer/VBoxContainer.get_children():
		children.queue_free()

	for level in Game.generated_levels:
		var level_button = level_object.instantiate()
		level_button.text = level.name
		level_button.level = level
		$UI/Main/TabContainer/Levels/ScrollContainer/VBoxContainer.add_child(level_button)
		level_button.set_difficulty(level.difficulty)
		level_button.set_enemies(level.enemy_list.size())
	
	var shop_item_resource = preload("res://scenes/shop_item.tscn")
	for children in $UI/Main/TabContainer/Shop/VBoxContainer.get_children():
		children.queue_free()
	for shop_item in Game.arcade_shop_items:
		var shop_item_object = shop_item_resource.instantiate()
		shop_item_object.set_shop_item(shop_item)
		$UI/Main/TabContainer/Shop/VBoxContainer.add_child(shop_item_object)

func _on_back_button_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = false
	#$UI/Main/TabContainer/Loadout/Consumable.visible = true
	$UI/Main/TabContainer/Loadout/Armor.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = true 
	refresh_menu()

func _on_weapon_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = false
	$UI/Main/TabContainer/Loadout/Armor.visible = false
	#$UI/Main/TabContainer/Loadout/Consumable.visible = false
	refresh_weapons()
	
func _on_armor_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = false
	$UI/Main/TabContainer/Loadout/Armor.visible = false
	#$UI/Main/TabContainer/Loadout/Consumable.visible = false
	refresh_armor()

func _on_consumable_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = false
	$UI/Main/TabContainer/Loadout/Armor.visible = false
	#$UI/Main/TabContainer/Loadout/Consumable.visible = false
	refresh_consumable()

func _on_tab_container_tab_selected(tab: int) -> void:
	refresh_menu()

var cached_equipment = Inventories.equipment.list
var cached_armor = Inventories.equipment.armor
var cached_weapon = Inventories.equipment.weapon
var cached_consumable = Inventories.equipment.consumable

func _process(delta: float) -> void:
	if Inventories.equipment.list != cached_equipment:
		cached_equipment = Inventories.equipment.list
		refresh_menu()
	if cached_armor != Inventories.equipment.armor:
		refresh_armor()
		refresh_menu()
		cached_armor = Inventories.equipment.armor
	if cached_weapon != Inventories.equipment.weapon:
		refresh_weapons()
		refresh_menu()
		cached_weapon = Inventories.equipment.weapon
	if cached_consumable != Inventories.equipment.consumable:
		refresh_consumable()
		refresh_menu()
		cached_consumable = Inventories.equipment.consumable

func refresh_weapons() -> void:
	for children in $UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.get_children():
		children.queue_free()
	for weapon in Inventories.equipment.list:
		if weapon.type is Sword:
			var weapon_resource = load("res://scenes/equipment.tscn").instantiate()
			weapon_resource.slot = "WEAPON"
			weapon_resource.item = weapon.type
			$UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.add_child(weapon_resource)

func refresh_armor() -> void:
	for children in $UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.get_children():
		children.queue_free()
	for armor in Inventories.equipment.list:
		if armor.type is Armor:
			var armor_resource = load("res://scenes/equipment.tscn").instantiate()
			armor_resource.slot = "ARMOR"
			armor_resource.item = armor.type
			$UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.add_child(armor_resource)

func refresh_consumable() -> void:
	for children in $UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.get_children():
		children.queue_free()
	var null_resource = load("res://scenes/equipment.tscn").instantiate()
	null_resource.slot = "CONSUMABLE"
	null_resource.item = null
	$UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.add_child(null_resource)
	for consumable in Inventories.equipment.list:
		if consumable.type is Consumable:
			var consumable_resource = load("res://scenes/equipment.tscn").instantiate()
			consumable_resource.slot = "CONSUMABLE"
			consumable_resource.item = consumable.type
			$UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.add_child(consumable_resource)

var shop_items = []

func populate_initial_shop_items():
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(5), 3), 15))
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(4), 1), 50, true))
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(7), 1), 80, true))
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(10), 1), 120, true))
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(11), 1), 25))
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(13), 1), 150, true))
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(14), 1), 100, true))
	shop_items.append(ShopItem.new(ItemStack.new(Items.get_item_by_id(17), 1), 500, true))
	
func _ready() -> void:
	if Game.generated_levels.is_empty():
		Game.generated_levels.append(generate_level(0))
		Game.generated_levels.append(generate_level(1))
		Game.generated_levels.append(generate_level(2))
		print("Generated arcade levels.")
	if shop_items.is_empty():
		populate_initial_shop_items()
	if not Game.started_run:
		Game.shop_needs_refresh = true
		Game.arcade_shop_items = []
	if Game.arcade_shop_items.is_empty() and Game.shop_needs_refresh:
		Game.shop_needs_refresh = false
		var available_items = shop_items.duplicate()
		var items_to_add = []

		for item in available_items:
			if !item.buy_once or not Inventories.equipment.has_item(item.item_stack.type):
				items_to_add.append(item)

		var max_items = min(3, items_to_add.size())
		for i in range(max_items):
			var random_index = Game.rng.randi_range(0, items_to_add.size() - 1)
			Game.arcade_shop_items.append(items_to_add[random_index])
			items_to_add.remove_at(random_index)

		print(Game.arcade_shop_items)
	refresh_menu()
	Game.game_loaded = true
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")
