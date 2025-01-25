extends Node2D

var splashes = [
	"Made with Godot",
	"Made by Juan",
	"Made by Minota",
	"When the night crawls",
	"Korean spicy garlic",
	"erm... what the gup?!",
	"she mirk on my wood till i slime",
	"also known as Mirkwood",
	"formerly known as Mirkwood",
	"Now with Skrunklies",
	"Absolute Cinema",
	"meow",
	"woof",
	#"\"awawawa\"" # Put the fries in the bag
]

@onready var menu: PackedScene = preload("res://scenes/menu.tscn")
@onready var arcade_menu: PackedScene = preload("res://scenes/arcade.tscn")

func _ready() -> void:
	$"UI/Main/Splash Text".text = splashes.pick_random()
	$UI/Main/Version.text = "v" + str(ProjectSettings.get_setting("application/config/version"))
	if GameCenter.game_center != null:
		$UI/Main/GameCenter.visible = true

func _on_play_pressed() -> void:
	if Game.game_loaded and Game.arcade:
		Game.save_game("switched modes")
	Game.arcade = false
	Game.load_game()
	get_tree().change_scene_to_packed(menu)

func _on_feedback_pressed() -> void:
	OS.shell_open("https://discord.gg/zhz3nnCDDg")

func _on_options_pressed() -> void:
	$UI/Main/Title.visible = false
	$"UI/Main/Splash Text".visible = false
	$UI/Main/Version.visible = false
	$UI/Main/Play.visible = false
	$UI/Main/Options2.visible = false
	$UI/Main/Feedback.visible = false
	$UI/Main/GameCenter.visible = false
	$UI/Main/Options.visible = true
	$UI/Main/Options/Sounds.button_pressed = Game.sounds_enabled
	$UI/Main/Options/Haptics_Vibrations.button_pressed = Game.haptics_enabled
	
func _on_game_center_pressed() -> void:
	if GameCenter.game_center != null:
		GameCenter.game_center.show_game_center({ "view": "leaderboards" })

func _on_back_pressed() -> void:
	if GameCenter.game_center != null:
		$UI/Main/GameCenter.visible = true
	$UI/Main/Title.visible = true
	$"UI/Main/Splash Text".visible = true
	$UI/Main/Version.visible = true
	$UI/Main/Play.visible = true
	$UI/Main/Options2.visible = true
	$UI/Main/Arcade.visible = true
	$UI/Main/Options.visible = false
	$UI/Main/NewRun.visible = false
	$UI/Main/Feedback.visible = true

func _on_sounds_pressed() -> void:
	Game.sounds_enabled = $UI/Main/Options/Sounds.button_pressed
	Game.haptics_enabled = $UI/Main/Options/Haptics_Vibrations.button_pressed
	Game.save_settings()

func _on_haptics_vibrations_pressed() -> void:
	Game.sounds_enabled = $UI/Main/Options/Sounds.button_pressed
	Game.haptics_enabled = $UI/Main/Options/Haptics_Vibrations.button_pressed
	Game.save_settings()

func _on_arcade_pressed() -> void:
	var found_run = false
	if not FileAccess.file_exists("user://arcade.april"):
		found_run = false
	else:
		var save_file = FileAccess.open("user://arcade.april", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
			var data = json.get_data()
			if data.has("started_run"):
				if data["started_run"]:
					found_run = true
	if not found_run:
		$UI/Main/Title.visible = false
		$"UI/Main/Splash Text".visible = false
		$UI/Main/Version.visible = false
		$UI/Main/Play.visible = false
		$UI/Main/Options2.visible = false
		$UI/Main/Feedback.visible = false
		$UI/Main/Arcade.visible = false
		$UI/Main/GameCenter.visible = false
		$UI/Main/NewRun.visible = true
	else:
		if Game.game_loaded and not Game.arcade:
			Game.save_game("switched modes")
		Game.arcade = true
		Game.load_game()
		Game.rng.seed = Game.seed 
		get_tree().change_scene_to_packed(arcade_menu)

func _on_endless_back_pressed() -> void:
	if GameCenter.game_center != null:
		$UI/Main/GameCenter.visible = true
	$UI/Main/Title.visible = true
	$"UI/Main/Splash Text".visible = true
	$UI/Main/Version.visible = true
	$UI/Main/Play.visible = true
	$UI/Main/Options2.visible = true
	$UI/Main/Arcade.visible = true
	$UI/Main/Options.visible = false
	$UI/Main/NewRun.visible = false
	$UI/Main/Feedback.visible = true

func _on_start_pressed() -> void:
	if Game.game_loaded and not Game.arcade:
		Game.save_game("switched modes")
	Game.arcade = true
	print($UI/Main/NewRun/Panel/LineEdit.text)
	if $UI/Main/NewRun/Panel/LineEdit.text == "":
		print("no seed")
		Game.rng.randomize()
		Game.seed = Game.rng.seed
		print(Game.seed)
	else:
		print("set seed")
		Game.rng.seed = Game.seed
		print(Game.rng.seed)
	Game.load_game()
	get_tree().change_scene_to_packed(arcade_menu)

func _on_line_edit_text_changed(new_text: String) -> void:
	Game.seed = hash(new_text) 
	print("changed seed: " + str(Game.seed))
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	Game.seed = hash(new_text)
	print(Game.rng.seed)
