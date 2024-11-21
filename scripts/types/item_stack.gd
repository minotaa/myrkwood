extends Object
class_name ItemStack

var amount: int = 0
var type: ItemType
var data = {}

func _to_string() -> String:
	return "x" + str(amount) + " " + type.name 
