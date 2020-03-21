extends Characters

onready var label = get_node("../Panel/Label")
const PROJECTILE = preload("res://Projectile.tscn")
var current_time = 0

func _ready():
	print(self.name + "[health:" + str(health) + ",speed:" + str(speed) + "]")

func _physics_process(delta):
	label.set_text("velocity:" + str(velocity) + "\ndir:" + str(_dir) + "\ntarget:" + str(target))
	if !is_moving and has_target:
		attack(delta)

func attack(deltaTime):
	find_closest_target()
	current_time += deltaTime
	if (current_time < 1/attackRate):
		return

	current_time = 0
	look_at(target.get_global_transform().origin, Vector3(0,1,0))
	var projectile = PROJECTILE.instance()
	projectile.start(self.global_transform)
	get_parent().add_child(projectile)

func _on_InputToggle_toggled(button_pressed):
	if button_pressed:
		keyboard_mode = true
	else:
		keyboard_mode = false

func _on_CameraFollowToggle_toggled(button_pressed):
	var cameraToggle = get_node("../Panel/CameraFollowToggle")
	var i_camera = get_node("../InterpolatedCamera")
	var camera = get_node("../Camera")
	if button_pressed:
		cameraToggle.set_text("FOLLOW CAMERA")
		i_camera.current = true
	else:
		cameraToggle.set_text("STATIC CAMERA")
		camera.current = true
