extends Position3D
#
export var distance = 20.0
export var height = 12.0
export var angle = 40.0
#
func _ready():
	set_as_toplevel(true)

func _physics_process(_delta):
	var target = get_parent().get_global_transform().origin
	var pos = target + Vector3(0,height,distance)
	set_translation(pos)
