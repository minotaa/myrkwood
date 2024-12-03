extends Node2D


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _process(delta: float) -> void:
	$CanvasLayer/Main/YouHave.text = "You have " + str(roundi(Game.gems)) + " gems"

#func _on_watch_ad_pressed() -> void:
	#Game.load_rewarded_ad()
	#Game.show_rewarded_ad()
