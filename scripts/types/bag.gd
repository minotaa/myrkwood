extends Object
class_name Bag

var list = []

func total_size() -> int:
	var size = 0
	for item in list:
		size += item.amount
	return size

func get_item(index: int) -> ItemStack:
	return list[index]

func add_item(item: ItemStack) -> void:
	for i in list: # Checks for existing items.
		if i.type.id == item.type.id:
			var prev = list[list.find(i)]
			prev.amount += item.amount
			return
	list.append(item)

func has_item(item: ItemType) -> bool:
	for i in list:
		if i.type.id == item.type:
			return true
	return false

func take_item(item: ItemType) -> void:
	for i in list:
		if i.type.id == item.type:
			i.amount -= 1

func set_list_from_save(_list: Array):
	for value in _list:
		var item = ItemStack.new()
		item.amount = value.amount
		item.type = Items.get_item_by_id(value.id)
		list.append(item)

func to_list() -> Array:
	var _list = []
	for value in list:
		_list.append({
			"id": (((value as ItemStack).type) as ItemType).id,
			"amount": (value as ItemStack).amount
		})
	return _list

func remove_item(item: ItemStack) -> void:
	list.erase(item)
