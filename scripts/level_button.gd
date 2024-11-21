extends Button

var item: ItemType

func _on_pressed() -> void:
	if item != null:
		print("Something strange is going on here...")

func refresh() -> void:
	$"../TextureRect".texture = item.texture
	
