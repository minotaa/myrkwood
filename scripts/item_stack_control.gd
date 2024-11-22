extends Control

var stack: ItemStack

func _ready() -> void:
	if not stack:
		return 
	$HBoxContainer/Label.text = "x" + str(stack.amount) + " " + stack.type.name
	$HBoxContainer/TextureRect.texture = stack.type.texture
