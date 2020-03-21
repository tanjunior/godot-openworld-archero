extends Spatial

export var distance = 0.0
export var height = 15.0
export var angle = -90.0
const DAMAGE = preload("res://Damage.tscn")
var player

func _ready():
	set_as_toplevel(true)
	player = get_parent()

func _physics_process(_delta):
	var target = get_parent().get_global_transform().origin
	var pos = target + Vector3(0,height,distance)
	set_translation(pos)

func _on_Player_takeDamage(d):
	var damage = DAMAGE.instance()
	damage.damage = d
	$Viewport/GUI.add_child(damage)
