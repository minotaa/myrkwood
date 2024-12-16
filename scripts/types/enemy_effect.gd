extends Object
class_name EnemyEffect

var name: String
var duration: float = 0.0
var texture: Texture 
var id: int

var on_apply: Callable = func(enemy: Enemy, effect: EnemyEffect):
	pass
var on_expire: Callable = func(enemy: Enemy, effect: EnemyEffect):
	pass
var on_update: Callable = func(enemy: Enemy, effect: EnemyEffect):
	pass
