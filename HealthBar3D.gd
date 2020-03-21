extends Sprite3D

onready var bar = $Viewport/TextureProgress
var bar_red = preload("res://assets/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/barHorizontal_yellow_mid 200.png")

func _ready():
	texture = $Viewport.get_texture()
 

func update(health, maxHealth):
	if health < maxHealth:
		show()
	bar.texture_progress = bar_green
	if health < 0.75 * maxHealth:
		bar.texture_progress = bar_yellow
	if health < 0.45 * maxHealth:
		bar.texture_progress = bar_red
	bar.value = health
