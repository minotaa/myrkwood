extends Node2D

var health: float = 100.0
var max_health: float = Game.get_max_health()
var magic: float = 100.0
var max_magic: float = Game.get_max_magic()
var attack: float = 25.0
var defense: float = Game.get_defense()

var enemy_max_health: float = 100.0
var enemy_health: float = 100.0
var enemy_attack: float = 10.0
var enemy_defense: float = 10.0

var enemy_attack_speed: float = 1.0
var attack_speed: float = 1.0
# Effective_Health = Health * (1 + Defense / 100)

var enemy_alive = true
var melt = false
var damaged_shader: ShaderMaterial = preload("res://assets/shaders/damaged.tres")

func _ready() -> void:
	$AudioStreamPlayer.play()
	#$UI/Main/EnemyTexture.material = null
	#$UI/Main.shake(0.5, 10.0)
	
func _process(delta: float) -> void:
	$UI/Main/EnemyHealthProgressBar.max_value = enemy_max_health
	$UI/Main/EnemyHealthProgressBar.value = enemy_health
	$UI/Main/HealthProgressBar.max_value = max_health
	$UI/Main/HealthProgressBar.value = health
	$UI/Main/MagicProgressBar.value = magic
	$UI/Main/MagicProgressBar.max_value = max_magic
	$PlayerTimer.wait_time = attack_speed
	$EnemyTimer.wait_time = enemy_attack_speed
	$UI/Main/HP.text = str(round(health)) + "/" + str(round(max_health))
	$UI/Main/MP.text = str(round(magic)) + "/" + str(round(max_magic))
	if melt and $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") < 1:
		$UI/Main/Panel/EnemyTexture.material.set_shader_parameter("progress", $UI/Main/Panel/EnemyTexture.material.get_shader_parameter("progress") + 0.45 * delta)
	
func attack_enemy() -> void:
	if not enemy_alive:
		return
	$UI/Main.shake_enemy(0.5, 10.0)
	var damage_multiplier = 1 - (enemy_defense / (enemy_defense + 100))
	var damage_taken = attack * damage_multiplier
	enemy_health -= damage_taken
	if enemy_health <= 0:
		pass
		enemy_alive = false
		melt = true
		$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/explosion.wav"))
		#$AudioStreamPlayer.get_stream_playback().play_stream(load("res://assets/sounds/victory.mp3"))
		
func attack_player() -> void:
	if not enemy_alive:
		return
	var damage_multiplier = 1 - (defense / (defense + 100))
	var damage_taken = enemy_attack * damage_multiplier
	health -= damage_taken
	if health <= 0:
		pass

func _on_player_timer_timeout() -> void:
	attack_enemy()

func _on_enemy_timer_timeout() -> void:
	attack_player()

func _on_misc_timer_timeout() -> void:
	magic = min(magic + 5, max_magic)
