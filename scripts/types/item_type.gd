extends Object
class_name ItemType

var name: String
var id: int
var description: String
var rarity: String = "COMMON" # COMMON, UNCOMMON, RARE, EPIC, LEGENDARY
var texture: Texture

var craftable: bool = false
var requirement = []
var min_requirement = [] # To view it in crafting.

func _to_string() -> String:
	return name + " (" + str(id) + ")"
