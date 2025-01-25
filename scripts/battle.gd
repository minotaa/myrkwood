extends Node2D

var max_health: float = Game.get_max_health()
var magic: float = Game.magic
var max_magic: float = Game.get_max_magic()
var attack: float = Game.get_attack()
var attack_speed: float = Game.get_attack_speed()
var defense: float = Game.get_defense()
var health_last_fight: float = Game.health
# Effective_Health = Health * (1 + Defense / 100)

var player_alive = true
var enemy_alive = true
var melt = false
var damaged_shader: ShaderMaterial = preload("res://assets/shaders/damaged.tres")

func _ready() -> void:
	Game.temp_exp_gained = 0.0
	Game.temp_gold = 0
	Game.temp_drops_gained = []
	if Game.arcade:
		Game.started_run = true
		$UI/Main/Back.visible = false
	for children in $UI/Main/ScrollContainer/HBoxContainer.get_children():
		children.queue_free()
	var consumable = preload("res://scenes/consumable.tscn")
	for item in Inventories.equipment.list:
		if item.type is Consumable:
			var consumable_object = consumable.instantiate()
			consumable_object.set_item(item.type)
			$UI/Main/ScrollContainer/HBoxContainer.add_child(consumable_object)
			
	#if Inventories.equipment.consumable != null:
		#$UI/Main/Consumable.visible = true
		#$UI/Main/Consumable.icon = Inventories.equipment.consumable.texture
		#$UI/Main/Consumable/Label.text = "x" + str(Inventories.equipment.get_item_stack(Inventories.equipment.consumable).amount)
	#else:
		#$UI/Main/Consumable.visible = false
	start_battle()
	#$UI/Main/EnemyTexture.material = null
	#$UI/Main.shake(0.5, 10.0)

#func _on_consumable_pressed(item: ItemType) -> void:
	#if Game.haptics_enabled:
		#Input.vibrate_handheld(25)
	#if Game.sounds_enabled:
		#$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/powerup.wav"))
	#Inventories.equipment.take_item(Inventories.equipment.consumable, 1)
	#Inventories.equipment.consumable.on_consume.call()
	#if Inventories.equipment.consumable.cooldown:
		#$ConsumableTimer.wait_time = Inventories.equipment.consumable.cooldown_seconds
		#$ConsumableTimer.start()
		#$UI/Main/Consumable.disabled = true
	#if Inventories.equipment.get_item_stack(Inventories.equipment.consumable) == null:
		#Inventories.equipment.consumable = null
		#$UI/Main/Consumable.visible = false
	#else:
		#$UI/Main/Consumable/Label.text = "x" + str(Inventories.equipment.get_item_stack(Inventories.equipment.consumable).amount)
	#
func start_battle() -> void:
	health_last_fight = Game.health
	player_alive = true
	melt = false
	Game.enemy = Game.live_enemy_list.pop_front()
	Game.enemy_health = Game.enemy.health
	Game.enemy_max_health = Game.enemy.health
	Game.enemy_attack = Game.enemy.attack
	Game.enemy_defense = Game.enemy.defense
	Game.enemy_attack_speed = Game.enemy.attack_speed
	enemy_alive = true
	$UI/Main/Level.text = Game.game_level.name
	$UI/Main/Panel/EnemyTexture.texture = Game.enemy.texture
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
	print("enemy: " + str(Game.enemy))
	print("your hp right now: " + str(Game.health))
	print("your hp last fight: " + str(health_last_fight))
	
func _process(delta: float) -> void:
	#print(Game.enemy_max_health)
	#print(Game.enemy_health)
	for children in $UI/Main/Panel/EnemyEffects/PanelContainer/HBoxContainer.get_children():
		children.queue_free()
	for children in $UI/Main/Effects/PanelContainer/HBoxContainer.get_children():
		children.queue_free()
	if Game.enemy.active_status_effects.is_empty() or not enemy_alive:
		$UI/Main/Panel/EnemyEffects.visible = false
	else:
		$UI/Main/Panel/EnemyEffects.visible = true
	for effect in Game.enemy.active_status_effects:
		var effect_resource = load("res://scenes/effect.tscn").instantiate()
		effect_resource.texture = effect.texture
		$UI/Main/Panel/EnemyEffects/PanelContainer/HBoxContainer.add_child(effect_resource)
	
	if Game.active_status_effects.is_empty():
		$UI/Main/Effects.visible = false
	else:
		$UI/Main/Effects.visible = true
	if not enemy_alive or melt:
		$UI/Main/Effects.visible = false
		$UI/Main/Panel/EnemyEffects.visible = false
	if not player_alive or melt:
		$UI/Main/Effects.visible = false
		$UI/Main/Panel/EnemyEffects.visible = false
	for effect in Game.active_status_effects:
		var effect_resource = load("res://scenes/effect.tscn").instantiate()
		effect_resource.texture = effect.texture
		$UI/Main/Effects/PanelContainer/HBoxContainer.add_child(effect_resource)
	$UI/Main/Panel/EnemyHealthProgressBar.max_value = Game.enemy_max_health
	$UI/Main/Panel/EnemyHealthProgressBar.value = Game.enemy_health
	$UI/Main/HealthProgressBar.max_value = max_health
	$UI/Main/HealthProgressBar.value = Game.health
	$UI/Main/MagicProgressBar.value = magic
	$UI/Main/MagicProgressBar.max_value = max_magic
	$PlayerTimer.wait_time = attack_speed
	$EnemyTimer.wait_time = Game.enemy_attack_speed
	$UI/Main/LevelText.text = str(Game.cached_enemy_list.size() - Game.live_enemy_list.size()) + "/" + str(Game.cached_enemy_list.size())
	$UI/Main/HP.text = str(roundi(Game.health)) + "/" + str(roundi(max_health))
	$UI/Main/MP.text = str(roundi(magic)) + "/" + str(roundi(max_magic))
	if melt and $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") <= 1:
		$UI/Main/Panel/EnemyTexture.material.set_shader_parameter("progress", $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") + 0.45 * delta)
	if $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") >= 1 and not player_alive:
		if not Game.arcade:
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/title.tscn")

func attack_enemy() -> void:
	if not enemy_alive:
		return
	$UI/Main.shake_enemy(0.5, 10.0)
	if Game.sounds_enabled:
		$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/hit.wav"))
	if Game.haptics_enabled:
		Input.vibrate_handheld(100)
	Game.enemy.on_damage.call()
	var damage_multiplier = 1 - (Game.enemy_defense / (Game.enemy_defense + 100))
	var damage_taken = attack * damage_multiplier
	Game.enemy_health -= damage_taken
	Inventories.equipment.weapon.on_hit.call(Game.enemy, damage_taken)
	if Game.enemy_health <= 0:
		enemy_alive = false
		melt = true
		if Game.haptics_enabled:
			Input.vibrate_handheld(500, 0.9)
		if Game.sounds_enabled:
			$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/explosion.wav"))
		Game.exp += Game.enemy.exp
		Game.temp_exp_gained += Game.enemy.exp
		Game.enemies_killed += 1
		var gold_multiplier = 1
		if Game.arcade:
			Game.temp_gold += Game.enemy.gold
			if Game.game_level.difficulty == 0:
				Game.kill_points += 3
				Game.arcade_score += 10
				Game.gold += Game.enemy.gold
			elif Game.game_level.difficulty == 1:
				Game.kill_points += 2
				Game.arcade_score += 25
				Game.gold += roundi(Game.enemy.gold * 1.5)
				gold_multiplier = 1.5
			elif Game.game_level.difficulty == 2:
				Game.kill_points += 1
				Game.arcade_score += 50
				Game.gold += roundi(Game.enemy.gold * 2)
				gold_multiplier = 2
		if not Game.arcade:
			ToastParty.show({
				"text": "You got " + str(roundi(Game.enemy.exp)) + " XP from this fight!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 24
			})
		else:
			ToastParty.show({
				"text": "You got " + str(roundi(Game.enemy.gold * gold_multiplier)) + " Gold from this fight!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 24
			})
		Inventories.equipment.weapon.on_kill.call(Game.enemy)
		await get_tree().create_timer(0.15).timeout
		if not Game.arcade:
			Game.enemy.on_die.call()
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
			Game.save_game("won")
			if Game.arcade:
				Game.generated_levels.erase(Game.game_level)
				Game.arcade_shop_items = []
				Game.shop_needs_refresh = true
				Game.arcade_score += 500
			for item in Game.temp_drops_gained:
				var item_stack = ItemStack.new(item, 1)
				Inventories.drops.add_item(item_stack)
		
			if Game.highest_completed_level <= Game.game_level.id:
				Game.highest_completed_level = Game.game_level.id + 1
				Game.gems += 1
			print("added " + str(roundi(Game.temp_exp_gained)) + " xp and " + str(Game.temp_drops_gained.size()) + " items")
			
			var exp_text = "You got:\n- +" + str(roundi(Game.temp_exp_gained)) + " XP"
			if Game.arcade:
				exp_text += "\n- " + str(Game.temp_gold) + " Gold"
			var drop_counts = {}
			for item_type in Game.temp_drops_gained:
				if drop_counts.has(item_type):
					drop_counts[item_type].amount += 1
				else:
					var stack = ItemStack.new(item_type, 1)
					drop_counts[item_type] = stack
			var drops_text = "\n"
			for stack in drop_counts.values():
				drops_text += "- x" + str(stack.amount) + " " + stack.type.name + "\n"
			$UI/Main/YouGot/Label.text = exp_text + drops_text
			$UI/Main/DoubleRewards.visible = true
			$UI/Main/YouWin.visible = true
			$UI/Main/YouGot.visible = true
			$UI/Main/Or.visible = true
			
			$UI/Main/LevelText.visible = false
			$UI/Main/ScrollContainer.visible = false
			$UI/Main/Level.visible = false
			$UI/Main/HP.visible = false
			$UI/Main/HP2.visible = false
			$UI/Main/MP.visible = false
			$UI/Main/MP2.visible = false
			$UI/Main/HealthProgressBar.visible = false
			$UI/Main/MagicProgressBar.visible = false
			$UI/Main/Panel/EnemyHealthProgressBar.visible = false
			$UI/Main/Panel/EnemyEffects.visible = false
			
			await get_tree().create_timer(2.35).timeout
			$UI/Main/RegularRewards.visible = true
		#$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/victory.mp3"))

var dead = preload("res://assets/sprites/bad.png")

func attack_player() -> void:
	if not enemy_alive:
		return
	var damage_multiplier = 1 - (defense / (defense + 100))
	var damage_taken = Game.enemy_attack * damage_multiplier
	Game.enemy.on_attack.call()
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
		$UI/Main/ScrollContainer.visible = false
		$UI/Main/HP.visible = false
		$UI/Main/HP2.visible = false
		$UI/Main/MP.visible = false
		$UI/Main/MP2.visible = false
		$UI/Main/HealthProgressBar.visible = false
		$UI/Main/MagicProgressBar.visible = false
		$UI/Main/Panel/EnemyHealthProgressBar.visible = false
		$UI/Main/Panel/EnemyEffects.visible = false
		if Game.arcade:
			$UI/Main/ArcadeFinalScore.visible = true
			$UI/Main/Revive.visible = true
		var messages = [
			"You were never found.", 
			"You went off the straight path.", 
			"Your life ended in the forest.", 
			"You died in the forest, your adventure is done.",
			"Your body was never found."
		]
		$UI/Main/GameOver.text = messages.pick_random()
		$UI/Main/GameOver.visible = true
		Game.save_game("lost")
		$UI/Main/ArcadeFinalScore.text = "Your final score is:\n" + str(Game.arcade_score)
		if Game.arcade:
			$UI/Main/Revive.text = "Watch an ad for a second chance? (10)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (9)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (8)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (7)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (6)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (5)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (4)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (3)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (2)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.text = "Watch an ad for a second chance? (1)"
			await get_tree().create_timer(1.05).timeout
			$UI/Main/Revive.visible = false
		if Game.arcade:
			Game.reset_game()
			Game.started_run = false
			Game.save_game("preventing scumming")
		if not Game.arcade:
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

func _on_effect_timer_timeout() -> void:
	Game.update_status_effects()
	Game.enemy.update_status_effects()

func _on_back_pressed() -> void:
	if not Game.arcade:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	else:
		if player_alive:
			get_tree().change_scene_to_file("res://scenes/arcade.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_double_rewards_pressed() -> void:
	Game.load_rewarded_ad("ca-app-pub-4596716586585952/4084680311")

func _on_regular_rewards_pressed() -> void:
	if not Game.arcade:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/arcade.tscn")

func _on_revive_pressed() -> void:
	Game.load_rewarded_ad("ca-app-pub-4596716586585952/9817679682")
	
