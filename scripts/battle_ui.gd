extends Control

var shake_amount = 10
var shake_duration = 0.5
var shake_timer = 0.0
var original_position = Vector2(72, 56)

func shake_enemy(duration: float = 0.5, amount: float = 10):
	shake_duration = duration
	shake_amount = amount
	shake_timer = shake_duration
	original_position = $Panel/EnemyTexture.position

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		$Panel/EnemyTexture.position = original_position + Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
	else:
		$Panel/EnemyTexture.position = original_position
