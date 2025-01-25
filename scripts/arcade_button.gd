extends Button

var level: Level
@onready var texture_rect = $TextureRect

func _on_pressed() -> void:
	if level != null:
		if level.id > Game.highest_completed_level:
			print("Something strange is going on here...")
		Game.game_level = level
		Game.generated_levels = []
		Game.cached_enemy_list = []
		Game.cached_enemy_list.append_array(level.enemy_list)
		Game.live_enemy_list = []
		Game.live_enemy_list.append_array(level.enemy_list)
		Game.health = Game.get_max_health()
		Game.magic = Game.get_max_magic()
		get_tree().change_scene_to_packed(load("res://scenes/battle.tscn"))

func set_difficulty(difficulty: int):
	for children in $HBoxContainer.get_children():
		children.queue_free()
	for i in range(0, difficulty + 1):
		await get_tree().create_timer(0.15).timeout
		var star = texture_rect.duplicate()
		star.visible = true
		$HBoxContainer.add_child(star)

func set_enemies(enemies: int):
	$Label.text = str(enemies) + " enemies"
