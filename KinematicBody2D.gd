extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

var motion = Vector2()
const UP = Vector2(0,-1)

const GROUNDSPEED = 300
const GRAVITY = 25
const JUMP = -500

var rope_point = Vector2(0,0)

var maxAirJumps = 1
var airJumps = maxAirJumps
func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	
	motion.y += GRAVITY
	var onFloor = $FloorCast.is_colliding()
	
	
		
	"""
	if motion.y < 0:
		$Sprite.play("Jumping")
	elif motion. y > 0:
		$Sprite.play("Falling")
	"""
	
	if onFloor:
		airJumps = maxAirJumps	
	#print(onFloor)
	if Input.is_action_just_pressed("ui_jump"):
		if onFloor:
			motion.y = JUMP
		elif airJumps > 0:
			motion.y = JUMP
			airJumps -= 1
	
	if Input.is_action_just_pressed("ui_click_primary"):
		var result = space_state.intersect_ray(self.position, get_viewport().get_mouse_position(),[self])
		if result:
			rope_point = result.position
			$Line2D.visible = true
		else:
			$Line2D.visible = false
		motion = Vector2(0,0)
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		
		$Line2D.set_point_position(1,rope_point-self.position)
		var dir = (rope_point - self.position)/self.position.distance_to(rope_point)
		var angle = Vector2(0,1).angle_to(-dir)
		var mag = GRAVITY*sin(angle)
		var sig = sign(motion.x)
		print(dir.rotated(3.1415926/2))
		motion = dir.rotated(3.1415926/2)*(sig*sqrt(motion.x*motion.x+motion.y*motion.y)+mag)
		print(motion)
		print(angle)
			
	else:
		$Line2D.visible = false
		if Input.is_action_pressed("ui_right"):
			motion.x = max(GROUNDSPEED,motion.x)
			$Sprite.flip_h = false
			if onFloor:
				$Sprite.play("Run")
		elif Input.is_action_pressed("ui_left"):
			motion.x = -max(abs(motion.x),GROUNDSPEED)
			$Sprite.flip_h = true
			if onFloor:
				$Sprite.play("Run")
		else:
			if onFloor:
				$Sprite.play("Idle")
			motion.x = 0
	
	motion = move_and_slide(motion,UP)
	
	