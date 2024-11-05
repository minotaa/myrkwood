extends Node2D

var steps: int = randi_range(24, 64)
var battle_scene: PackedScene = preload("res://scenes/battle.tscn")

func _ready() -> void:
	$Player.position.x = Game.journey_x

func _on_timer_timeout() -> void:
	steps -= 1
	print("steps left: " + str(steps))
	if steps <= 0:
		Game.journey_x = $Player.position.x
		steps = randi_range(24, 64)
		get_tree().change_scene_to_packed(battle_scene)
		print("Random encounter: Found a battle!")

func _process(delta: float) -> void:
	$UI/Main/HealthProgressBar.value = Game.health
	$UI/Main/HealthProgressBar.max_value = Game.get_max_health()
	$UI/Main/HP.text = str(roundi(Game.health)) + "/" + str(roundi(Game.get_max_health()))
