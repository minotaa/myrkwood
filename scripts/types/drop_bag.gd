extends Bag
class_name DropBag

func is_full() -> bool:
	return total_size() >= get_max_capacity()

func get_max_capacity() -> int:
	var max_capacity = 25
	return max_capacity
