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

const GROUNDSPEED = 400
const ACCELERATION = 200
const DECELERATION = 10
const GRAVITY = 25
const JUMP = -500
const SELF_PUSH_ON_ROPE = 5
const BASH_FORCE = 1000

var rope_point = Vector2(0,0)
var rope_dist = -1
var bash_target = null

var maxAirJumps = 1
var airJumps = maxAirJumps
func _physics_process(delta):
	
	# get space state of world for ray tracing
	var space_state = get_world_2d().direct_space_state
	
	#acceleration of gravity
	motion.y += GRAVITY
	
	#checking if on floor with raycast
	var onFloor = $FloorCast.is_colliding()
	var onLeftWall = $LeftWallCast.is_colliding()
	var onRightWall = $RightWallCast.is_colliding()
	
	if motion.x > 0:
		$Sprite.flip_h = false
		$CatSprite.flip_h = false
	elif motion.x < 0:
		$Sprite.flip_h = true
		$CatSprite.flip_h = true
	
	#refresh double jumps if you're on the ground
	if onFloor or onRightWall or onLeftWall:
		airJumps = maxAirJumps
	else:
		#jumping/landing animations
		if motion.y < 0:
			$Sprite.play("Jumping")
		elif motion. y > 0:
			$Sprite.play("Falling")
	
	#check if colliding with a block on spirit whip use
	if Input.is_action_just_pressed("ui_click_primary"):
		var mouse_pos_scaled = 1.5*(get_global_mouse_position()-self.position)*1.1+self.position
		var result = space_state.intersect_ray(self.position, mouse_pos_scaled,[self])
		if result:
			rope_point = result.position
			rope_dist = result.position.distance_to(self.position)
			$WhipLine.visible = true
			#resest double jumps
			# -- MAY CHANGE THIS LATER -- #
			airJumps = maxAirJumps
		else:
			$WhipLine.visible = false
			rope_dist = -1
	
	#if mouse is held down and rope physics are active
	#disables regular controls during rope physics mode (couldn't think of a better way lol)
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and rope_dist > -1:
		
		# some keyboard controls so you can affect your movement
		var push = 0
		if Input.is_action_pressed("ui_right"):
			push = SELF_PUSH_ON_ROPE
		elif Input.is_action_pressed("ui_left"):
			push = -SELF_PUSH_ON_ROPE
		
		
		$WhipLine.set_point_position(1,rope_point-self.position)
		
		
		var dir = (rope_point - self.position)/self.position.distance_to(rope_point)
		var angle = Vector2(0,1).angle_to(-dir)
		var mag = GRAVITY*sin(angle)
		var force_dir = dir.rotated(3.1415926/2)
		
		motion = force_dir*(motion.dot(force_dir)+mag+push)
	
		if self.position.distance_to(rope_point) > rope_dist+30:
			$WhipLine.default_color = "#ff7777"
		if self.position.distance_to(rope_point) > rope_dist+40:
			rope_dist = -1
			
		#print(motion)
		#print(angle)
			
	else:
		# put away rope 
		$WhipLine.visible = false
		$WhipLine.default_color = "#667fff"
		
		# ground keyboard controls
		if Input.is_action_pressed("ui_right"):
			if onRightWall and motion.y > 0:
				motion.y = lerp(motion.y,GRAVITY,0.3)
			if motion.x > GROUNDSPEED:
				motion.x -= DECELERATION
			else:
				motion.x += ACCELERATION
				motion.x = min(motion.x,GROUNDSPEED)
			if onFloor:
				$Sprite.play("Run")
		elif Input.is_action_pressed("ui_left"):
			if onLeftWall and motion.y > 0:
				motion.y =lerp(motion.y,GRAVITY,0.3)
			if motion.x < -GROUNDSPEED:
				motion.x += DECELERATION
				
			else:
				motion.x -= ACCELERATION
				motion.x = max(motion.x,-GROUNDSPEED)
			if onFloor:
				$Sprite.play("Run")
		else:
			if onFloor:
				$Sprite.play("Idle")
				motion.x = lerp(motion.x, 0, 0.3)
			else:
				motion.x = lerp(motion.x, 0, 0.05)
		if Input.is_action_just_pressed("ui_jump"):
			if onFloor or onLeftWall or onRightWall:
				motion.y = JUMP
			elif airJumps > 0:
				motion.y = JUMP
				airJumps -= 1
	
	#bash target detecting
	if Input.is_action_just_pressed("ui_click_secondary"):
		var bodies = $BashArea.get_overlapping_bodies()
		if len(bodies) > 0:
			bash_target	= bodies[0]
			airJumps = maxAirJumps
		else:
			bash_target = null
	#bash directing + some animation stuff
	if Input.is_mouse_button_pressed(BUTTON_RIGHT) and bash_target:
		var dir_not_normal = get_global_mouse_position()-bash_target.position
		var dir = dir_not_normal / dir_not_normal.distance_to(Vector2(0,0))
		motion = Vector2(0,0)
		self.position.x = lerp(self.position.x,bash_target.position.x,0.1)
		self.position.y = lerp(self.position.y,bash_target.position.y,0.1)
		$BashLine.visible = true
		$Sprite.modulate.a = lerp($Sprite.modulate.a,0,0.1) 
		
		$BashLine.set_point_position(0, bash_target.position - self.position + dir*50) 
		$BashLine.set_point_position(1, bash_target.position - self.position)
	else:
		$Sprite.modulate.a = 1 
		$BashLine.visible=false
	#bash shoot
	if Input.is_action_just_released("ui_click_secondary") and bash_target:
		var dir_not_normal = get_global_mouse_position()-bash_target.position
		var dir = dir_not_normal / dir_not_normal.distance_to(Vector2(0,0))
		motion = dir * BASH_FORCE
		bash_target = null
				
	
	motion = move_and_slide(motion,UP)
	$CatSprite.position -= motion*delta
	$CatSprite.position -= $CatSprite.position.normalized() * $CatSprite.position.distance_to(Vector2(0,0)) * 0.05 
	
	