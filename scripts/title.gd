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

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(menu)

func _on_feedback_pressed() -> void:
	OS.shell_open("https://discord.gg/zhz3nnCDDg")
