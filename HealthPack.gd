extends KinematicBody2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func init(args):
	pass
func _process(delta):
	self.position.y = sin(t)*30
	
	t = (t+delta)
	while t >= (2*3.1415926):
		t -= (2*3.1415926)