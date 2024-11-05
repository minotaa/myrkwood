extends CharacterBody2D

const SPEED = 20.0
const JUMP_VELOCITY = -400.0

var touching = false

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		touching = true
	elif event is InputEventScreenTouch and event.is_pressed():
		touching = true
	else:
		touching = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = 1 * SPEED
	
	if touching:
		velocity.x = 2.75 * SPEED
	$AnimatedSprite2D.play("wg", min(1, 0.5 + velocity.length_squared()))
	move_and_slide()
