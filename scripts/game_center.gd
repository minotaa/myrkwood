extends Node

var game_center

func _ready() -> void:
	if Engine.has_singleton("GameCenter"):
		game_center = Engine.get_singleton("GameCenter")
		print("Authenticating on GameCenter...")
		game_center.authenticate()
		print("Authenticated on GameCenter!")
	else:
		print("iOS Game Center plugin is not available on this platform.")
