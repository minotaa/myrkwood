extends Button

var item: Consumable

func set_item(consumable: Consumable) -> void:
	item = consumable
	$".".icon = item.texture

func _process(delta: float) -> void:
	if item != null and Inventories.equipment.get_item_stack(item) != null:
		$ProgressBar.value = (($Timer.time_left / $Timer.wait_time) * 100.0)
		$Label.text = "x" + str(Inventories.equipment.get_item_stack(item).amount)

func _ready() -> void:
	$Timer.stop()
	print("been added!")

func _on_pressed() -> void:
	if item != null:
		if Game.haptics_enabled:
			Input.vibrate_handheld(25)
		if Game.sounds_enabled:
			$"../../../../../AudioStreamPlayer".get_stream_playback().play_stream(load("res://assets/sounds/powerup.wav"))
		Inventories.equipment.take_item(item, 1)
		item.on_consume.call()
		if item.cooldown:
			$Timer.wait_time = item.cooldown_seconds
			$Timer.start()
			$".".disabled = true
			$ProgressBar.value = 0
		if Inventories.equipment.get_item_stack(item) == null:
			item = null
			$".".visible = false
			queue_free()
		else:
			$Label.text = "x" + str(Inventories.equipment.get_item_stack(item).amount)
		
func _on_timer_timeout() -> void:
	$".".disabled = false
	$Timer.stop()
