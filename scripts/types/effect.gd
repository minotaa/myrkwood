extends Object
class_name Effect

var name: String
var duration: float = 0.0
var texture: Texture 
var id: int

var on_apply: Callable = func():
	pass
var on_expire: Callable = func():
	pass
var on_update: Callable = func():
	pass
