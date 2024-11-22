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
	$Button.disabled = !can_craft

func _on_button_pressed() -> void:
	if item != null:
		var item_stack = ItemStack.new()
		item_stack.type = item
		item_stack.amount = 1
		Inventories.equipment.add_item(item_stack)
		ToastParty.show({
			"text": "You crafted a " + item.name + "!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		if item.only_craft_once:
			queue_free()
