extends ItemType
class_name Sword

var base_damage = 0.0
var base_attack_speed = 0.0

var upgrade_message: String = ""
var max_level: int = 5

var damage = func():
	return base_damage

var attack_speed = func():
	return base_attack_speed

var on_hit = func(enemy: Enemy, final_damage: float):
	pass
	
var on_kill = func(enemy: Enemy):
	pass
	
