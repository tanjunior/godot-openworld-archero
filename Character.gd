extends Actor
class_name Characters

var keyboard_mode = true
var is_moving = false
var has_target = false
var target:KinematicBody = null
var targetList:Array
var distanceList:Array

func _ready():
	speed = 10
	detectionShape.radius = 12
	
func _physics_process(delta):
	is_moving = false
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
	else:
		pass

	velocity = velocity.normalized() * speed
	move_and_slide(velocity, UP)
	_dir = Vector3(velocity.x,0,velocity.z)
	if(_dir != Vector3(0,0,0)):
		is_moving = true
		look_at(get_transform().origin+_dir, UP)

func analog_force_change(inForce):
	velocity.y = 0
	velocity.x = inForce.x
	velocity.z = -inForce.y #changing 2D joystick Y-AXIS(UP/DOWN) movement to 3D Z-AXIS(FORWARD/BACKWARD)

func find_closest_target():
	if targetList.empty():
		return

	distanceList = []
	for b in targetList:
		var distance = self.translation.distance_squared_to(b.translation)
		distanceList.append(distance)
		var closest = distanceList.find(distanceList.min())
		target = targetList[closest]

func _on_Detection_body_entered(body):
	if !targetList.has(body):
		targetList.append(body)
		
	if !targetList.empty():
		has_target = true

func _on_Detection_body_exited(body):
	var i = targetList.find(body)
	targetList.remove(i)
	distanceList.remove(i)
	
	if targetList.empty():
		has_target = false
