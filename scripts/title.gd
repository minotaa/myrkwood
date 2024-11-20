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
	"\"awawawa\""
]

@onready var menu: PackedScene = preload("res://scenes/menu.tscn")

func _ready() -> void:
	$"UI/Main/Splash Text".text = splashes.pick_random()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(menu)
