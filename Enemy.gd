extends Actor
onready var nav = get_node("../../Navigation")


var begin = Vector3()
var end = Vector3()
var path = []
var draw_path = true
var m = SpatialMaterial.new()
var target = null
var ig = ImmediateGeometry.new()

func _ready():
	self.owner.call_deferred("add_child", ig)
	detectionShape.radius = 10
	max_health = 20
	health = max_health
	$HealthBar3D/Viewport/TextureProgress.max_value = max_health
	speed = 5
	print(self.name + "[health:" + str(health) + ",speed:" + str(speed) + "]")
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white

func _physics_process(_delta):
	if health <= 0:
		$FSM.change_state("dead")


func movement(delta):
	if path.size() > 1:
		var to_walk = delta * speed
		var to_watch = Vector3.ZERO
		while to_walk > 0 and path.size() >= 2:
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			to_watch = (pto - pfrom).normalized()
			var d = pfrom.distance_to(pto)
			if d <= to_walk:
				path.remove(path.size() - 1)
				to_walk -= d
#				_update_path(target)
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk / d)
				to_walk = 0

#		var atpos = path[path.size() - 1]
		var atdir = to_watch
		atdir.y = 0

		look_at(get_transform().origin+atdir, UP)
		move_and_slide(atdir * speed, UP)
#		var t = Transform()
#		t.origin = atpos
#		t = t.looking_at(atpos + atdir, UP)
#		self.set_transform(t)

		if path.size() < 2:
			path = []
	else:
		target = null


func _update_path():
	if target == null:
		return
	begin = nav.get_closest_point(self.get_translation())
	end = nav.get_closest_point(target.get_translation())
	var p = nav.get_simple_path(begin, end, true)
	path = Array(p) # Vector3 array too complex to use, convert to regular array.
	path.invert()
	
	if draw_path:
		var im = ig
		im.set_material_override(m)
		im.clear()
		im.begin(Mesh.PRIMITIVE_POINTS, null)
		im.add_vertex(begin)
		im.add_vertex(end)
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		for x in p:
			im.add_vertex(x)
		im.end()

func take_damage(value):
	health -= value
	$HealthBar3D.update(health, max_health)
	
func _on_Detection_body_entered(body):
	if body != self:
		target = body
		$FSM.change_state("aggro")

func _on_Detection_body_exited(_body):
	pass # Replace with function body.
