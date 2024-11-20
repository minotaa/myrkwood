extends Button

var level: Level

func _on_pressed() -> void:
	if level != null:
		if level.id > Game.highest_completed_level:
			print("Something strange is going on here...")
		Game.game_level = level
		Game.cached_enemy_list = []
		Game.cached_enemy_list.append_array(level.enemy_list)
		Game.live_enemy_list = []
		Game.live_enemy_list.append_array(level.enemy_list)
		Game.health = Game.get_max_health()
		Game.magic = Game.get_max_magic()
		get_tree().change_scene_to_packed(load("res://scenes/battle.tscn"))
