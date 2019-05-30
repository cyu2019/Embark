extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var shrine = null
var player = null
var t = 0
onready var default_y = self.position.y
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../../player")
	shrine = get_node("..")
	shrine.coinsLeft += 1

func _process(delta):
	self.position.y = default_y+20*sin(t)
	t = (t+2*delta)
	while t >= (2*3.1415926):
		t -= (2*3.1415926)
	for b in get_overlapping_bodies():
		if b == player:
			shrine.coinsLeft -= 1
			queue_free()