extends Object
class_name Enemy

var id: int = 0
var name: String
var description: String = "The enemy you're trying to look for may not exist..."
var weight: float
var kill_point_requirement: int
var gold: int = 0
var texture: Texture2D

var health: float = 100.0
var defense: float = 10.0
var attack_speed: float = 1.0
var attack: float = 10.0
var active_status_effects: Array[EnemyEffect] = []

var exp: float = 0.0
var location: String = "forest"

func apply_status_effect(effect: EnemyEffect) -> void:
	effect.on_apply.call(self, effect)
	active_status_effects.append(effect)

func update_status_effects() -> void:
	for effect in active_status_effects:
		if effect.on_update:
			effect.on_update.call(self, effect)
		effect.duration -= 1.0
		if effect.duration <= 0:
			effect.on_expire.call(self, effect)
			active_status_effects.erase(effect)

var on_attack: Callable = func():
	pass

var on_die: Callable = func():
	pass
	
var on_damage: Callable = func():
	pass

func _to_string() -> String:
	return name + ": " + str(health) + " HP | " + str(defense) + " DEF | " + str(attack) + " ATK | " + str(attack_speed) + " SPD"
