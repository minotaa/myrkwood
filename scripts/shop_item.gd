extends Object
class_name ShopItem

var item_stack: ItemStack = null
var name: String
var gold: int = 0
var kill_point_req: int = 0
var buy_once: bool = false

func _init(stack: ItemStack, cost: int, once: bool = false, display_name: String = "",karma_req: int = 0) -> void:
	item_stack = stack
	gold = cost
	if display_name == "":
		name = stack.type.name
	buy_once = once
	kill_point_req = karma_req 

var on_buy: Callable = func(): 
	pass
