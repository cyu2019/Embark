extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var moveTo = Vector2()
export var speed = 0
var target = Vector2()
var initial = Vector2()
var sig = 1
var theta = 0
export var stoptime = 1
var time = stoptime

# Called when the node enters the scene tree for the first time.
func _ready():
	initial = self.position
	target = initial + moveTo
	theta = get_angle_to(target)
	pass # Replace with function body.

func _process(delta):
	if time < stoptime:
		time += delta
	else:
		self.position += speed * sig * delta * moveTo.normalized()
		if initial.distance_to(self.position) > initial.distance_to(target):
			sig = -1
			time = 0
		if target.distance_to(self.position) > initial.distance_to(target):
			sig = 1
			time = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
