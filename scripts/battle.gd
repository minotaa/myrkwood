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

var player_alive = true
var enemy_alive = true
var melt = false
var damaged_shader: ShaderMaterial = preload("res://assets/shaders/damaged.tres")

func _ready() -> void:
	Game.temp_exp_gained = 0.0
	Game.temp_drops_gained = []
	start_battle()
	#$UI/Main/EnemyTexture.material = null
	#$UI/Main.shake(0.5, 10.0)
	
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
	$AudioStreamPlayer.play()
	print("battle started:")
	print("enemy: " + str(enemy))
	print("your hp right now: " + str(Game.health))
	
func _process(delta: float) -> void:
	
	$UI/Main/EnemyHealthProgressBar.max_value = enemy_max_health
	$UI/Main/EnemyHealthProgressBar.value = enemy_health
	$UI/Main/HealthProgressBar.max_value = max_health
	$UI/Main/HealthProgressBar.value = Game.health
	$UI/Main/MagicProgressBar.value = magic
	$UI/Main/MagicProgressBar.max_value = max_magic
	$PlayerTimer.wait_time = attack_speed
	$EnemyTimer.wait_time = enemy_attack_speed
	$UI/Main/LevelText.text = str(Game.cached_enemy_list.size() - Game.live_enemy_list.size()) + "/" + str(Game.cached_enemy_list.size())
	$UI/Main/HP.text = str(round(Game.health)) + "/" + str(round(max_health))
	$UI/Main/MP.text = str(round(magic)) + "/" + str(round(max_magic))
	if melt and $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") <= 1:
		$UI/Main/Panel/EnemyTexture.material.set_shader_parameter("progress", $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") + 0.45 * delta)
	if $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") >= 1 and not player_alive:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
func attack_enemy() -> void:
	if not enemy_alive:
		return
	$UI/Main.shake_enemy(0.5, 10.0)
	var damage_multiplier = 1 - (enemy_defense / (enemy_defense + 100))
	var damage_taken = attack * damage_multiplier
	enemy_health -= damage_taken
	if enemy_health <= 0:
		enemy_alive = false
		melt = true
		$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/explosion.wav"))
		Game.exp += enemy.exp
		Game.temp_exp_gained += enemy.exp
		await get_tree().create_timer(2.15).timeout
		print("you won!")
		if not Game.live_enemy_list.is_empty():
			start_battle()
		else:
			if Game.highest_completed_level < Game.game_level.id:
				Game.highest_completed_level = Game.game_level.id + 1
			$UI/Main/YouWin.text = "YOU WIN!\n\nYou gained +" + str(round(Game.temp_exp_gained)) + " XP\nYou also gained +69 items."
			$UI/Main/YouWin.visible = true
			$UI/Main/LevelText.visible = false
			$UI/Main/Level.visible = false
			$UI/Main/HP.visible = false
			$UI/Main/HP2.visible = false
			$UI/Main/MP.visible = false
			$UI/Main/MP2.visible = false
			$UI/Main/HealthProgressBar.visible = false
			$UI/Main/MagicProgressBar.visible = false
			$UI/Main/EnemyHealthProgressBar.visible = false
			await get_tree().create_timer(3.25).timeout
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
		#$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/victory.mp3"))

var dead = preload("res://assets/sprites/bad.png")

func attack_player() -> void:
	if not enemy_alive:
		return
	var damage_multiplier = 1 - (defense / (defense + 100))
	var damage_taken = enemy_attack * damage_multiplier
	Game.health -= damage_taken
	if Game.health <= 0:
		enemy_alive = false
		$UI/Main/Panel/EnemyTexture.texture = dead
		$UI/Main/LevelText.visible = false
		$UI/Main/Level.visible = false
		$UI/Main/HP.visible = false
		$UI/Main/HP2.visible = false
		$UI/Main/MP.visible = false
		$UI/Main/MP2.visible = false
		$UI/Main/HealthProgressBar.visible = false
		$UI/Main/MagicProgressBar.visible = false
		$UI/Main/EnemyHealthProgressBar.visible = false
		var messages = [
			"You were never found.", 
			"You went off the straight path.", 
			"Your life ended in the forest.", 
			"You died in the forest, your adventure is done.",
			"Your body was never found."
		]
		$UI/Main/GameOver.text = messages.pick_random()
		$UI/Main/GameOver.visible = true
		await get_tree().create_timer(3.25).timeout
		melt = true
		player_alive = false
		
func _on_player_timer_timeout() -> void:
	attack_enemy()

func _on_enemy_timer_timeout() -> void:
	attack_player()

func _on_misc_timer_timeout() -> void:
	magic = min(magic + 5, max_magic)
