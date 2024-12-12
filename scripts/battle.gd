extends Node2D

var max_health: float = Game.get_max_health()
var magic: float = Game.magic
var max_magic: float = Game.get_max_magic()
var attack: float = Game.get_attack()
var defense: float = Game.get_defense()

var enemy_max_health: float = 100.0
var enemy_health: float = 100.0
var enemy_attack: float = 10.0
var enemy_defense: float = 10.0

var enemy_attack_speed: float = 1.0
var attack_speed: float = Game.get_attack_speed()
# Effective_Health = Health * (1 + Defense / 100)

var enemy: Enemy

var health_last_fight: float = Game.health

var player_alive = true
var enemy_alive = true
var melt = false
var damaged_shader: ShaderMaterial = preload("res://assets/shaders/damaged.tres")

func _ready() -> void:
	Game.temp_exp_gained = 0.0
	Game.temp_drops_gained = []
	if Inventories.equipment.consumable != null:
		$UI/Main/Consumable.visible = true
		$UI/Main/Consumable.icon = Inventories.equipment.consumable.texture
		$UI/Main/Consumable/Label.text = "x" + str(Inventories.equipment.get_item_stack(Inventories.equipment.consumable).amount)
	else:
		$UI/Main/Consumable.visible = false
	start_battle()
	#$UI/Main/EnemyTexture.material = null
	#$UI/Main.shake(0.5, 10.0)

func _on_consumable_pressed() -> void:
	if Game.haptics_enabled:
		Input.vibrate_handheld(25)
	if Game.sounds_enabled:
		$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/powerup.wav"))
	Inventories.equipment.take_item(Inventories.equipment.consumable, 1)
	Inventories.equipment.consumable.on_consume.call()
	if Inventories.equipment.consumable.cooldown:
		$ConsumableTimer.wait_time = Inventories.equipment.consumable.cooldown_seconds
		$ConsumableTimer.start()
		$UI/Main/Consumable.disabled = true
	if Inventories.equipment.get_item_stack(Inventories.equipment.consumable) == null:
		Inventories.equipment.consumable = null
		$UI/Main/Consumable.visible = false
	else:
		$UI/Main/Consumable/Label.text = "x" + str(Inventories.equipment.get_item_stack(Inventories.equipment.consumable).amount)
	
func start_battle() -> void:
	player_alive = true
	melt = false
	enemy_alive = true
	enemy = Game.live_enemy_list.pop_front()
	enemy_health = enemy.health
	enemy_max_health = enemy.health
	enemy_attack = enemy.attack
	enemy_defense = enemy.defense
	enemy_attack_speed = enemy.attack_speed
	$UI/Main/Level.text = Game.game_level.name
	$UI/Main/Panel/EnemyTexture.texture = enemy.texture
	$UI/Main/Panel/EnemyTexture.material.set_shader_parameter("progress", 0.0)
	$PlayerTimer.stop()
	$PlayerTimer.start()
	$MagicTimer.stop()
	$MagicTimer.start()
	$EnemyTimer.stop()
	$EnemyTimer.start()
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.play()
	print("battle started:")
	print("enemy: " + str(enemy))
	print("your hp right now: " + str(Game.health))
	
func _process(delta: float) -> void:
	for children in $UI/Main/Panel/EnemyEffects/PanelContainer/HBoxContainer.get_children():
		children.queue_free()
	if enemy.active_status_effects.is_empty():
		$UI/Main/Panel/EnemyEffects.visible = false
	else:
		$UI/Main/Panel/EnemyEffects.visible = true
	for effect in enemy.active_status_effects:
		var effect_resource = load("res://scenes/effect.tscn").instantiate()
		effect_resource.texture = effect.texture
		$UI/Main/Panel/EnemyEffects/PanelContainer/HBoxContainer.add_child(effect_resource)
	$UI/Main/Consumable/ProgressBar.value = (($ConsumableTimer.time_left / $ConsumableTimer.wait_time) * 100.0)
	$UI/Main/Panel/EnemyHealthProgressBar.max_value = enemy_max_health
	$UI/Main/Panel/EnemyHealthProgressBar.value = enemy_health
	$UI/Main/HealthProgressBar.max_value = max_health
	$UI/Main/HealthProgressBar.value = Game.health
	$UI/Main/MagicProgressBar.value = magic
	$UI/Main/MagicProgressBar.max_value = max_magic
	$PlayerTimer.wait_time = attack_speed
	$EnemyTimer.wait_time = enemy_attack_speed
	$UI/Main/LevelText.text = str(Game.cached_enemy_list.size() - Game.live_enemy_list.size()) + "/" + str(Game.cached_enemy_list.size())
	$UI/Main/HP.text = str(roundi(Game.health)) + "/" + str(roundi(max_health))
	$UI/Main/MP.text = str(roundi(magic)) + "/" + str(roundi(max_magic))
	if melt and $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") <= 1:
		$UI/Main/Panel/EnemyTexture.material.set_shader_parameter("progress", $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") + 0.45 * delta)
	if $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") >= 1 and not player_alive:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
func attack_enemy() -> void:
	if not enemy_alive:
		return
	$UI/Main.shake_enemy(0.5, 10.0)
	if Game.sounds_enabled:
		$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/hit.wav"))
	if Game.haptics_enabled:
		Input.vibrate_handheld(100)
	var damage_multiplier = 1 - (enemy_defense / (enemy_defense + 100))
	var damage_taken = attack * damage_multiplier
	enemy_health -= damage_taken
	Inventories.equipment.weapon.on_hit.call(enemy, damage_taken)
	if enemy_health <= 0:
		health_last_fight = Game.health
		enemy_alive = false
		melt = true
		if Game.haptics_enabled:
			Input.vibrate_handheld(500, 0.9)
		if Game.sounds_enabled:
			$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/explosion.wav"))
		Game.exp += enemy.exp
		Game.temp_exp_gained += enemy.exp
		ToastParty.show({
			"text": "You got " + str(roundi(enemy.exp)) + " XP from this fight!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})
		Game.enemies_killed += 1
		Inventories.equipment.weapon.on_kill.call(enemy)
		await get_tree().create_timer(0.15).timeout
		enemy.on_die.call()
		print(Game.temp_drops_gained)
		await get_tree().create_timer(2.0).timeout
		print("you won!")
		if not Game.live_enemy_list.is_empty():
			start_battle()
		else:
			if Game.sounds_enabled:
				$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/pickup.wav"))
			if Game.haptics_enabled:
				Input.vibrate_handheld(500, 1.0)
			Game.save_game(Game.get_game_save_data(), "won")
			for item in Game.temp_drops_gained:
				var item_stack = ItemStack.new()
				item_stack.amount = 1
				item_stack.type = item
				Inventories.drops.add_item(item_stack)
		
			if Game.highest_completed_level <= Game.game_level.id:
				Game.highest_completed_level = Game.game_level.id + 1
				Game.gems += 1
			print("added " + str(roundi(Game.temp_exp_gained)) + " xp and " + str(Game.temp_drops_gained.size()) + " items")
			
			var exp_text = "You got:\n- +" + str(roundi(Game.temp_exp_gained)) + " XP"
			var drop_counts = {}
			for item_type in Game.temp_drops_gained:
				if drop_counts.has(item_type):
					drop_counts[item_type].amount += 1
				else:
					var stack = ItemStack.new()
					stack.type = item_type
					stack.amount = 1
					drop_counts[item_type] = stack
			var drops_text = "\n"
			for stack in drop_counts.values():
				drops_text += "- x" + str(stack.amount) + " " + stack.type.name + "\n"
			$UI/Main/YouGot/Label.text = exp_text + drops_text
			$UI/Main/DoubleRewards.visible = true
			$UI/Main/YouWin.visible = true
			$UI/Main/YouGot.visible = true
			$UI/Main/Or.visible = true
			$UI/Main/RegularRewards.visible = true
			
			$UI/Main/LevelText.visible = false
			$UI/Main/Consumable.visible = false
			$UI/Main/Level.visible = false
			$UI/Main/HP.visible = false
			$UI/Main/HP2.visible = false
			$UI/Main/MP.visible = false
			$UI/Main/MP2.visible = false
			$UI/Main/HealthProgressBar.visible = false
			$UI/Main/MagicProgressBar.visible = false
			$UI/Main/Panel/EnemyHealthProgressBar.visible = false
			$UI/Main/Panel/EnemyEffects.visible = false
			
			#await get_tree().create_timer(3.25).timeout
			#get_tree().change_scene_to_file("res://scenes/menu.tscn")
		#$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/victory.mp3"))

var dead = preload("res://assets/sprites/bad.png")

func attack_player() -> void:
	if not enemy_alive:
		return
	var damage_multiplier = 1 - (defense / (defense + 100))
	var damage_taken = enemy_attack * damage_multiplier
	Game.health -= damage_taken
	if Game.health <= 0:
		if Game.sounds_enabled:
			$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/explosion2.wav"))
		if Game.haptics_enabled:
			Input.vibrate_handheld(300)
		enemy_alive = false
		$UI/Main/Panel/EnemyTexture.texture = dead
		$UI/Main/LevelText.visible = false
		$UI/Main/Level.visible = false
		$UI/Main/Consumable.visible = false
		$UI/Main/HP.visible = false
		$UI/Main/HP2.visible = false
		$UI/Main/MP.visible = false
		$UI/Main/MP2.visible = false
		$UI/Main/HealthProgressBar.visible = false
		$UI/Main/MagicProgressBar.visible = false
		$UI/Main/EnemyHealthProgressBar.visible = false
		$UI/Main/EnemyEffects.visible = false
		var messages = [
			"You were never found.", 
			"You went off the straight path.", 
			"Your life ended in the forest.", 
			"You died in the forest, your adventure is done.",
			"Your body was never found."
		]
		$UI/Main/GameOver.text = messages.pick_random()
		$UI/Main/GameOver.visible = true
		Game.save_game(Game.get_game_save_data(), "lost")
		await get_tree().create_timer(3.25).timeout
		melt = true
		player_alive = false
		if Game.sounds_enabled:
			$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/tone.wav"))
		if Game.haptics_enabled:
			Input.vibrate_handheld(300, 0.9)

func _on_player_timer_timeout() -> void:
	attack_enemy()

func _on_enemy_timer_timeout() -> void:
	attack_player()

func _on_misc_timer_timeout() -> void:
	magic = min(magic + 5, max_magic)

func _on_consumable_timer_timeout() -> void:
	$UI/Main/Consumable.disabled = false
	$ConsumableTimer.stop()

func _on_effect_timer_timeout() -> void:
	Game.update_status_effects()
	enemy.update_status_effects()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_double_rewards_pressed() -> void:
	Game.load_rewarded_ad("ca-app-pub-4596716586585952/4084680311")

func _on_regular_rewards_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
