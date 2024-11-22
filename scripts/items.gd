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
	wooden_sword.description = "+5 damage, ol' reliable."
	wooden_sword.name = "Wooden Sword"
	var atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(0.0, 0.0, 16.0, 16.0)
	wooden_sword.texture = atlas
	wooden_sword.damage = 5
	items.append(wooden_sword)
	
	var hoodie = Armor.new()
	hoodie.id = 1
	hoodie.name = "T-Shirt"
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
	glass_knife.description = "+10 damage, a sharp tempered glass knife."
	atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(64.0, 0.0, 16.0, 16.0)
	glass_knife.texture = atlas
	glass_knife.damage = 10.0
	glass_knife.craftable = true
	var min_requirement = ItemStack.new()
	min_requirement.amount = 1
	min_requirement.type = get_item_by_id(3)
	glass_knife.min_requirement = [min_requirement]
	var requirement = ItemStack.new()
	requirement.amount = 5
	requirement.type = get_item_by_id(3)
	glass_knife.requirement = [requirement]
	glass_knife.only_craft_once = true
	items.append(glass_knife)
	
	print("items added")
