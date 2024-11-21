extends Node

var items = []

func get_item_by_id(id: int) -> ItemType:
	for item in items:
		if item.id == id:
			if item is Sword:
				return (item as Sword)
			return item
	return null
	
func _ready() -> void:
	var wooden_sword = Sword.new()
	wooden_sword.id = 0 
	wooden_sword.description = "+5 damage"
	wooden_sword.name = "Wooden Sword"
	var atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/sprites/items.png")
	atlas.region = Rect2(0.0, 0.0, 16.0, 16.0)
	wooden_sword.texture = atlas
	wooden_sword.damage = 5
	wooden_sword.type = "WEAPON"
	items.append(wooden_sword)
