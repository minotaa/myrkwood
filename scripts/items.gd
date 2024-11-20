extends Node

var items = []

func get_item_by_id(id: int) -> ItemType:
	for item in items:
		if item.id == id:
			return item
	return null
	
func _ready() -> void:
	pass
