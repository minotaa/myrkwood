extends Node2D

var level_object: PackedScene = preload("res://scenes/level.tscn")
var locked = preload("res://assets/sprites/locked.png")
var dead = preload("res://assets/sprites/bad.png")

func _ready() -> void:
	for i in range(0, Game.highest_completed_level + 2):
		var level_button = level_object.instantiate()
		var game_level = Levels.get_by_id(i)
		if game_level == null:
			level_button.icon = dead
			level_button.disabled = true
		elif game_level.id > Game.highest_completed_level:
			level_button.icon = locked
			level_button.disabled = true
		else:
			level_button.text = game_level.name
			level_button.level = game_level
		$UI/Main/TabContainer/Levels/ScrollContainer/VBoxContainer.add_child(level_button)

func _process(delta: float) -> void:
	var meta: String = "Level: " + str(Game.get_level())
	meta += "\nHealth: " + str(Game.get_max_health())
	meta += "\nAttack: " + str(Game.get_attack())
	meta += "\nDefense: " + str(Game.get_defense())
	meta += "\nIntelligence: " + str(Game.get_max_magic())
	$UI/Main/Meta.text = meta
	$UI/Main/ProgressBar.value = Game.get_progress()
