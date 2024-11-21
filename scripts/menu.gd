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
	
	check_craftable_items()



func check_craftable_items() -> void:
	for children in $UI/Main/TabContainer/Crafting/ScrollContainer/VBoxContainer.get_children():
		children.queue_free()
	for item in Items.items:
		if item.craftable:
			var can_view = true
			var can_craft = true
			# Check min_requirement to allow viewing
			for req in item.min_requirement:
				var found = false
				for inv_item in Inventories.drops.list:
					if inv_item.type.id == req.type.id and inv_item.amount >= req.amount:
						found = true
						break
				if not found:
					can_view = false
					break
			# Check requirement to allow crafting
			for req in item.requirement:
				var found = false
				for inv_item in Inventories.drops.list:
					if inv_item.type.id == req.type.id and inv_item.amount >= req.amount:
						found = true
						break
				if not found:
					can_craft = false
					break
			if can_view:
				var button = load("res://scenes/crafting_item.tscn").instantiate()
				button.item = item
				button.can_craft = can_craft
				$UI/Main/TabContainer/Crafting/ScrollContainer/VBoxContainer.add_child(button)

func _on_tab_container_tab_selected(tab: int) -> void:
	refresh_menu()
