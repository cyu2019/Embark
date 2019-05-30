extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var beenBashed = false
var dir = Vector2(500,500)
var speed = 100
var motion = Vector2(0,0)
const GRAVITY = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	add_collision_exception_with(get_node(".."))
	motion = dir*speed
	pass # Replace with function body.

func get_pos():
	return self.position + get_node("..").get_pos()

func _physics_process(delta):
	if beenBashed:
		remove_collision_exception_with(get_node(".."))
	rotate( 0.05 )
	motion.y += GRAVITY
	var collision_data = move_and_collide(motion*delta)
	if collision_data:
		if collision_data.collider.name == "Enemy" and beenBashed:
			collision_data.collider.set('health',collision_data.collider.get('health')-1)
		if collision_data.collider.name == "Wall":
			collision_data.collider.break() 
		queue_free()
	