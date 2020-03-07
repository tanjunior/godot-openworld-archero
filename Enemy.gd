extends Actor


func _ready():
#	detectionShape.radius = detectionRadius
	health = 20
	speed = 8
	print(self.name + "[health:" + str(health) + ",speed:" + str(speed) + "]")

func _physics_process(delta):
	pass

func _on_Detection_body_entered(body):
	pass
