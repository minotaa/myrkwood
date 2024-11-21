extends Control

var item: ItemType
var can_craft: bool = false

func _on_pressed() -> void:
	if item != null:
		print("Something strange is going on here...")

func format_list(items: Array) -> String:
	if items.size() == 0:
		return ""
	if items.size() == 1:
		return str(items[0])
	if items.size() == 2:
		return str(items[0]) + " and " + str(items[1])
	return ", ".join(items.slice(0, items.size() - 1)) + ", and " + str(items[items.size() - 1])

func _process(delta: float) -> void:
	$TextureRect.texture = item.texture
	$Name.text = item.name
	$Requirements.text = format_list(item.requirement)
	$Button.disabled = can_craft
		
