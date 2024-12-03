extends Control

var slot: String # Either "WEAPON", "CONSUMABLE" or "ARMOR"
var item: ItemType

func _on_button_pressed() -> void:
	if slot == "WEAPON":
		Inventories.equipment.weapon = item
		ToastParty.show({
			"text": "Swapped your weapon to " + item.name,
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
	elif slot == "CONSUMABLE":
		Inventories.equipment.consumable = item
		if item == null:
			ToastParty.show({
				"text": "Removed your consumable!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 24
			})
		else:
			ToastParty.show({
				"text": "Swapped your consumable to " + item.name,
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 24
			})
	elif slot == "ARMOR":
		Inventories.equipment.armor = item
		ToastParty.show({
			"text": "Swapped your armor to " + item.name,
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})

func _ready() -> void:
	if item != null:
		$Button.icon = item.texture
		if Inventories.equipment.weapon == item:
			$Button.disabled = true
		if Inventories.equipment.armor == item:
			$Button.disabled = true
		if Inventories.equipment.consumable == item:
			$Button.disabled = true
	if slot == "CONSUMABLE" and item == null:
		if Inventories.equipment.consumable == null:
			$Button.disabled = true
		$Button.icon = load("res://assets/sprites/null.png")
