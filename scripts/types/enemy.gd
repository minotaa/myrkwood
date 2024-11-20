extends Object
class_name Enemy

var id: int = 0
var name: String
var description: String = "The enemy you're trying to look for may not exist..."
var weight: float
var texture: Texture2D

var health: float = 100.0
var defense: float = 10.0
var attack_speed: float = 1.0
var attack: float = 10.0

var exp: float = 0.0
var location: String = "forest"

func on_attack() -> void:
	pass
	
func on_die() -> void:
	pass
	
func on_damage() -> void:
	pass

func _to_string() -> String:
	return name + ": " + str(health) + " HP | " + str(defense) + " DEF | " + str(attack) + " ATK | " + str(attack_speed) + " SPD"
