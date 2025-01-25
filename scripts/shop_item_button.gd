extends Control

var shop_item_ref: ShopItem 

func set_shop_item(shop_item: ShopItem) -> void:
	shop_item_ref = shop_item
	if shop_item.gold > Game.gold:
		$Button.disabled = true
	$Cost.text = str(shop_item.gold)
	$TextureRect.texture = shop_item.item_stack.type.texture
	$Item.text = shop_item.name
	var attack = 0.0
	if shop_item.item_stack.type is Sword:
		attack = roundi(shop_item.item_stack.type.damage.call())
	$Desc.text = shop_item.item_stack.type.description.replace("{attack}", str(roundi(attack)))

func _on_button_pressed() -> void:
	if shop_item_ref != null:
		var item_stack = ItemStack.new(shop_item_ref.item_stack.type, shop_item_ref.item_stack.amount)
		Inventories.equipment.add_item(item_stack)
		
		Game.gold -= shop_item_ref.gold
		
		ToastParty.show({
			"text": "You bought x" + str(shop_item_ref.item_stack.amount) + " " + shop_item_ref.name + " from the shop!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 20
		})
		
		if shop_item_ref.buy_once:
			Game.arcade_shop_items.erase(shop_item_ref)
			queue_free()
			
		$"../../../../../../".refresh_menu()
