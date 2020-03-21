extends Label
var damage;

func _ready():
	set_text(str(damage))


func _on_Timer_timeout():
	queue_free()
