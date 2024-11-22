extends Node2D

var level_object: PackedScene = preload("res://scenes/level.tscn")
var locked = preload("res://assets/sprites/locked.png")
var dead = preload("res://assets/sprites/bad.png")

func _ready() -> void:
	refresh_menu()
	
func refresh_menu() -> void:
	for children in $UI/Main/TabContainer/Levels/ScrollContainer/VBoxContainer.get_children():
		children.queue_free()
	for i in range(0, Game.highest_completed_level + 2):
		var level_button = level_object.instantiate()
		var game_level = Levels.get_by_id(i)
		if game_level == null:
			level_button.icon = dead
			level_button.disabled = true
		elif game_level.id > Game.highest_completed_level:
			level_button.icon = locked
			level_button.disabled = true
		else:
			level_button.text = game_level.name
			level_button.level = game_level
		$UI/Main/TabContainer/Levels/ScrollContainer/VBoxContainer.add_child(level_button)
	
	var meta: String = "Level: " + str(roundi(Game.get_level()))
	meta += "\nHealth: " + str(roundi(Game.get_max_health()))
	meta += "\nAttack: " + str(roundi(Game.get_attack()))
	meta += "\nDefense: " + str(roundi(Game.get_defense()))
	meta += "\nIntelligence: " + str(roundi(Game.get_max_magic()))
	$UI/Main/Meta.text = meta
	$UI/Main/ProgressBar.value = Game.get_progress()
	
	if Inventories.equipment.weapon != null:
		$UI/Main/TabContainer/Loadout/Weapon/TextureRect.texture = Inventories.equipment.weapon.texture
		$UI/Main/TabContainer/Loadout/Weapon/Name.text = Inventories.equipment.weapon.name
		$UI/Main/TabContainer/Loadout/Weapon/Description.text = Inventories.equipment.weapon.description
	
	if Inventories.equipment.armor != null:
		$UI/Main/TabContainer/Loadout/Armor/TextureRect.texture = Inventories.equipment.armor.texture
		$UI/Main/TabContainer/Loadout/Armor/Name.text = Inventories.equipment.armor.name
		$UI/Main/TabContainer/Loadout/Armor/Description.text = Inventories.equipment.armor.description
	
	var stack_resource = preload("res://scenes/item_stack.tscn")
	for children in $UI/Main/TabContainer/Drops/ScrollContainer/VBoxContainer.get_children():
		children.queue_free()
	for stack in Inventories.drops.list:
		var item = stack_resource.instantiate()
		item.stack = stack
		$UI/Main/TabContainer/Drops/ScrollContainer/VBoxContainer.add_child(item)
	
	check_craftable_items()

func check_craftable_items() -> void:
	for children in $UI/Main/TabContainer/Crafting/ScrollContainer/VBoxContainer.get_children():
		children.queue_free()
	for item in Items.items:
		if item.craftable:
			# Skip items with `only_craft_once` if already in inventory
			if item.only_craft_once:
				var already_in_inventory = false
				for inv_item in Inventories.drops.list:
					if inv_item.type.id == item.id:
						already_in_inventory = true
						break
				if already_in_inventory:
					continue
			
			# Check if `min_requirement` is fulfilled (for visibility)
			var can_view = true
			for req in item.min_requirement:
				var found = false
				for inv_item in Inventories.drops.list:
					if inv_item.type.id == req.type.id and inv_item.amount >= req.amount:
						found = true
						break
				if not found:
					can_view = false
					break
			
			# If `min_requirement` is fulfilled, evaluate further
			if can_view:
				# Check `requirement` to determine if the item can be crafted
				var can_craft = true
				for req in item.requirement:
					var found = false
					for inv_item in Inventories.drops.list:
						if inv_item.type.id == req.type.id and inv_item.amount >= req.amount:
							found = true
							break
					if not found:
						can_craft = false
						break
				
				# Add the button to the UI
				var button = load("res://scenes/crafting_item.tscn").instantiate()
				button.item = item
				button.can_craft = can_craft
				$UI/Main/TabContainer/Crafting/ScrollContainer/VBoxContainer.add_child(button)

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
	for consumable in Inventories.equipment.list:
		if consumable.type is Consumable:
			var consumable_resource = load("res://scenes/equipment.tscn").instantiate()
			consumable_resource.slot = "CONSUMABLE"
			consumable_resource.item = consumable.type
			$UI/Main/TabContainer/Loadout/Options/ScrollContainer/GridContainer.add_child(consumable_resource)

func _on_back_button_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = false
	$UI/Main/TabContainer/Loadout/Consumable.visible = true
	$UI/Main/TabContainer/Loadout/Armor.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = true 
	refresh_menu()

func _on_weapon_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = false
	$UI/Main/TabContainer/Loadout/Armor.visible = false
	$UI/Main/TabContainer/Loadout/Consumable.visible = false
	refresh_weapons()
	
func _on_armor_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = false
	$UI/Main/TabContainer/Loadout/Armor.visible = false
	$UI/Main/TabContainer/Loadout/Consumable.visible = false
	refresh_armor()

func _on_consumable_pressed() -> void:
	$UI/Main/TabContainer/Loadout/Options.visible = true
	$UI/Main/TabContainer/Loadout/Weapon.visible = false
	$UI/Main/TabContainer/Loadout/Armor.visible = false
	$UI/Main/TabContainer/Loadout/Consumable.visible = false
	refresh_consumable()
