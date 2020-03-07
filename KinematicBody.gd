extends KinematicBody

export (int) var speed = 10

var velocity = Vector3.ZERO
var keyboard_mode = false

var _dir = Vector3.ZERO

onready var label = get_node("../Panel/Label")

func _ready():
	pass

	
func _physics_process(delta):
	label.set_text("velocity:" + str(velocity) + "\ndir:" + str(_dir))
	if keyboard_mode:
		velocity = Vector3.ZERO
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_up"):
			velocity.z -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.z += 1
		velocity = velocity.normalized()

	move_and_slide(velocity*speed, Vector3.UP)
	_dir = Vector3(velocity.x,0,velocity.z)
	if(_dir != Vector3(0,0,0)):
		look_at(get_transform().origin+_dir, Vector3.UP)

func analog_force_change(inForce):
	print(inForce)
	velocity.x = inForce.x
	velocity.z = -inForce.y #changing 2D joystick Y-AXIS(UP/DOWN) movement to 3D Z-AXIS(FORWARD/BACKWARD)

func _on_InputToggle_toggled(button_pressed):
	var inputToggle = get_node("../Panel/InputToggle")
	if button_pressed:
		keyboard_mode = true
	else:
		keyboard_mode = false


func _on_CameraFollowToggle_toggled(button_pressed):
	var cameraToggle = get_node("../Panel/CameraFollowToggle")
	var i_camera = get_node("../InterpolatedCamera")
	var camera = get_node("../Camera")
	if button_pressed:
		cameraToggle.set_text("STATIC CAMERA")
		camera.current = true
	else:
		cameraToggle.set_text("FOLLOW CAMERA")
		i_camera.current = true
