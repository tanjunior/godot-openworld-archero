extends RigidBody

var speed = 15
var velocity = Vector3.ZERO
onready var timer = $Timer

func _ready():
	timer.set_wait_time(1)
	timer.start()

func _process(delta):
	transform.origin += velocity * delta
	
func start(xform):
	transform = xform
	velocity = -transform.basis.z * speed

func _on_Timer_timeout():
	queue_free()


func _on_Area_body_entered(body):
	if body is StaticBody:
		queue_free()
	elif body.get_parent().name == "Enemies":
#		print("Projectile Hit Enemy")
		body.take_damage(2)
		queue_free()
