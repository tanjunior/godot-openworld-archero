extends Actor
class_name Characters

var keyboard_mode = true
var is_moving = false
var has_target = false
var target:KinematicBody = null
var targetList:Array

func _ready():
	max_health = 20
	health = max_health
	speed = 10
	detectionShape.radius = 12
	$HealthBar3D/Viewport/TextureProgress.max_value = max_health
	
func _physics_process(_delta):
	if health <= 0:
		queue_free()
#		set_physics_process(false)
	is_moving = false
	
	if Input.is_action_pressed("Kill"):
		queue_free()
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
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, UP)
	if get_slide_count() != 0:
		var collider = get_slide_collision(get_slide_count() -1).collider
		if collider is KinematicBody:
			print("hit by: " + collider.name)
			health -= 2
			$HealthBar3D.update(health, max_health)
			
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

	var closestDist = -1
	for b in targetList:
			var distance = self.translation.distance_squared_to(b.translation)
			if distance < closestDist or closestDist < 0:
			  closestDist = distance
			  target = b

func _on_Detection_body_entered(body):
	if !targetList.has(body):
		targetList.append(body)
		
	if !targetList.empty():
		has_target = true

func _on_Detection_body_exited(body):
	var i = targetList.find(body)
	targetList.remove(i)
	
	if targetList.empty():
		has_target = false
		target = null
