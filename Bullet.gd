extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var motion = Vector2(500,500)
var speed = 100
var beenBashed = false
onready var parent = get_node('..')
# Called when the node enters the scene tree for the first time.
func _ready():
	add_collision_exception_with(parent)
	pass # Replace with function body.

func get_pos():
	return self.position.rotated(parent.rotation) + parent.get_pos()

func _physics_process(delta):
	if beenBashed:
		remove_collision_exception_with(parent)
	motion = motion.normalized()*speed
	var collision_data = move_and_collide(motion*delta)
	if collision_data:
		if beenBashed and 'Enemy' in collision_data.collider.name:
			collision_data.collider.set('health',collision_data.collider.get('health')-1)
		if "Wall" in collision_data.collider.name:
			collision_data.collider.break()
		if 	"Rebound" in collision_data.collider.name:
			var dir = collision_data.collider.get("dir")
			var from_dir = collision_data.collider.get("from_dir")
			var from = get_pos()-collision_data.collider.position
			if (from_dir.x == 0 or sign(from_dir.x) == sign(from.x) ) and (from_dir.y == 0 or sign(from_dir.y) == sign(from.y) ):
					
				self.position = (collision_data.collider.position-parent.get_pos()+dir * 64).rotated(-parent.rotation)
				motion = dir
			else:
				queue_free()
		else:
			queue_free()
	