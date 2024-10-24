extends Camera2D

# Variables for camera shake
var shake_amount = 10  # How much the camera should shake
var shake_duration = 0.5  # How long the shake should last
var shake_timer = 0.0
var original_position = Vector2.ZERO

# Start shaking the camera
func shake_camera(duration: float = 0.5, amount: float = 10):
	shake_duration = duration
	shake_amount = amount
	shake_timer = shake_duration
	original_position = position  # Save the original camera position

# Physics process to apply shake effect
func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		# Random offset within the shake amount
		position = original_position + Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
	else:
		# Reset the camera to its original position after the shake
		position = original_position
