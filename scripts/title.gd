extends Node2D

var splashes = [
	"Made with Godot",
	"Made by Juan",
	"Made by Minota",
	"When the night crawls",
	"Korean spicy garlic",
	"erm... what the gup?!",
	"she mirk on my wood till i slime",
	"Now with Skrunklies",
	"Absolute Cinema",
	"meow",
	"woof",
	#"\"awawawa\"" # Put the fries in the bag
]

@onready var menu: PackedScene = preload("res://scenes/menu.tscn")

func _ready() -> void:
	$"UI/Main/Splash Text".text = splashes.pick_random()
	$UI/Main/Version.text = "v" + str(ProjectSettings.get_setting("application/config/version"))
	if GameCenter.game_center != null:
		$UI/Main/GameCenter.visible = true

func _on_play_pressed() -> void:
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
	$UI/Main/Options.visible = false
	$UI/Main/Feedback.visible = true
