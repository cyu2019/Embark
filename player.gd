extends Character

"""
bugs
can attack while bashing (fixed)
if bash target dies, crash. (shouldn't happen in regular play though)
if claw cannot reach target, will never return 
dj refresh even if no wallslide (fixed) 
make grappling hook raytracing more precise (find normalized vector to mouse then go specific length)
make attack less precise, just go to enemy nearest mouse within specified area
put in 1 million pixesl
make fps 3000
"""

func _ready():
	maxhealth = 5
	health = 5
	pass
var jumping = false

var curSave = 1
#var motion = Vector2()
const UP = Vector2(0,-1)

const GROUNDSPEED = 400
const ACCELERATION = 200
const AIR_ACCELERATION = 10
const GRAVITY = 25
const JUMP = -600
const SELF_PUSH_ON_ROPE = 5
const BASH_FORCE = 1000
const BLINK = 0.08


var rope_point = Vector2(0,0)
var rope_length = 0
var rope_dist = -1
var bash_target = null
var sliding = false
onready var BASH_ARROW_INITIAL = $BashArrow.rotation

var blinktime = BLINK

var attack_target = null
var bash_timer = 0

export var maxAirJumps = 0
export var canRope = false
export var canBash = false

var airJumps = maxAirJumps



func _physics_process(delta):

	# get space state of world for ray tracing
	var space_state = get_world_2d().direct_space_state

	bash_timer = max (0, bash_timer - delta)

	#acceleration of gravity
	motion.y += GRAVITY

	#checking if on floor with raycast
	"""
	var b = $FloorArea.get_overlapping_bodies()
	for i in range(len(b)):
		if b[i] == self:
			b.remove(i)
			break
	"""
	var onFloor = is_on_floor() #len(b) > 0 #is_on_floor() or $FloorCast.is_colliding()
	var onLeftWall = $LeftWallCast.is_colliding()
	var onRightWall = $RightWallCast.is_colliding()
	
	if $Sprite.animation != "dying":
		#refresh double jumps if you're on the ground
		if onFloor:
			airJumps = maxAirJumps
			jumping = false
		#jumping/landing animations
		if not onFloor:
			if motion.y < 0:
				$Sprite.play("Jumping")
			elif motion. y > 0:
				$Sprite.play("Falling")
			if motion.x > 0:
				$Sprite.flip_h = false
			elif motion.x < 0:
				$Sprite.flip_h = true
	
		if Input.is_action_just_pressed("ui_attack"):
			for b in $AttackArea.get_overlapping_bodies():
				if (b.name == "Enemy") and not bash_target and not attack_target:
					rope_dist = -1
					attack_target = b
					$CatSprite.play("attack")
					$CatSprite.frame = 0
					$CatSprite.position.x += sign(b.position.x-self.position.x)*100
					$ClawSprite.position = Vector2(0,0)
					break
	
		#check if colliding with a block on spirit whip use or hitting enemy
		if Input.is_action_just_pressed("ui_click_primary"):
			var mouse_pos_scaled = 1.5*(get_global_mouse_position()-self.position)*1.1+self.position
			var result = space_state.intersect_ray(self.position, mouse_pos_scaled,[self,get_node("./HurtBox")])
			
			if result and canRope and not 'Enemy' in result.collider.name:
					rope_point = result.position
					rope_dist = result.position.distance_to(self.position)
					#$WhipLine.set_point_position(1,Vector2(0,0))
					#resest double jumps
					# -- MAY CHANGE THIS LATER -- #
					airJumps = maxAirJumps
			else:
				$WhipLine.visible = false
				rope_dist = -1
		#if mouse is held down and rope physics are active
		#disables regular controls during rope physics mode (couldn't think of a better way lol)
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and rope_dist > -1 and not bash_target:
			#print("rp")
			#print(rope_point)
			# some keyboard controls so you can affect your movement
			var push = 0
			if Input.is_action_pressed("ui_right"):
				push = SELF_PUSH_ON_ROPE
			elif Input.is_action_pressed("ui_left"):
				push = -SELF_PUSH_ON_ROPE
			
			
			$WhipLine.visible = true
	
			rope_length = lerp(rope_length,rope_point.distance_to(self.position),0.5)
			var rope = (rope_point-self.position).normalized()*rope_length
	
			$WhipLine.set_point_position(1,rope)
	
	
			var dir = (rope_point - self.position).normalized()
			var angle = Vector2(0,1).angle_to(-dir)
			var mag = GRAVITY*sin(angle)
			var force_dir = dir.rotated(3.1415926/2)
			#print("pos")
			#print(self.position)
	
			motion = force_dir*(motion.dot(force_dir)+mag+push)
	
			if self.position.distance_to(rope_point) > rope_dist+30:
				$WhipLine.default_color = "#ff7777"
			if self.position.distance_to(rope_point) > rope_dist+40:
				rope_dist = -1
	
			
			if Input.is_action_pressed("ui_jump") and airJumps > 0:
				airJumps -= 1
				rope_dist = -1
				motion.y = JUMP
				$Sprite.frame = 0
			#print(motion)
			#print(angle)
		else:
			# put away rope
			if attack_target and $CatSprite.frame > 2:
				$ClawSprite.modulate.a = lerp($ClawSprite.modulate.a,1,0.5)
				var dir = (attack_target.get_pos()-self.position)
				$ClawSprite.position.x = lerp($ClawSprite.position.x,dir.x,0.3)
				$ClawSprite.position.y = lerp($ClawSprite.position.y,dir.y,0.3)
				#var claw = (attack_target.position-self.position).normalized()*rope_length
				if (($ClawSprite.position+self.position).distance_to(attack_target.get_pos()) <= 30):
					attack_target.motion = 100*(attack_target.get_pos() - self.position).normalized()
					attack_target.set("health",attack_target.get("health")-1)
					attack_target = null
					$CatSprite.play("default")
				#old attack animation code
				"""
				$WhipLine.visible = true
				rope_length = lerp(rope_length,attack_target.position.distance_to(self.position),0.5)
				var rope = (attack_target.position-self.position).normalized()*rope_length
				$WhipLine.set_point_position(1,rope)
				if (rope_length/attack_target.position.distance_to(self.position) >= 0.99):
					attack_target.motion = 100*(attack_target.position - self.position).normalized()
					attack_target.set("health",attack_target.get("health")-1)
					attack_target = null
					$CatSprite.play("default")
				"""
			elif $ClawSprite.position.distance_to(Vector2(0,0)) > 0:
				$ClawSprite.position.x = lerp($ClawSprite.position.x,0,0.3)
				$ClawSprite.position.y = lerp($ClawSprite.position.y,0,0.3)
				$ClawSprite.modulate.a = lerp($ClawSprite.modulate.a,0,0.1)
			else:
				$ClawSprite.modulate.a = 0
			
			if rope_length > 0:
				rope_length = lerp(rope_length,0,0.5)-0.01
				var rope = $WhipLine.get_point_position(1).normalized()*rope_length
				$WhipLine.set_point_position(1,rope)
			else:
				$WhipLine.visible = false
				$WhipLine.default_color = "#667fff"
	
			# ground keyboard controls
			if Input.is_action_pressed("ui_right"):
				if onRightWall:
					if motion.y > 0:
						motion.y = lerp(motion.y,GRAVITY,0.3)
						$Sprite.play("Slide")
						$Sprite.flip_h = false
					sliding = true
					airJumps = maxAirJumps
					
				if onFloor:
					motion.x += ACCELERATION
					motion.x = min(motion.x,GROUNDSPEED)
					$Sprite.flip_h = false
					$Sprite.play("Run")
				else:
					if motion.x > GROUNDSPEED:
						motion.x -= AIR_ACCELERATION
					else:
						motion.x += ACCELERATION
						motion.x = min(motion.x,GROUNDSPEED)
						
			elif Input.is_action_pressed("ui_left"):
				if onLeftWall:
					if motion.y > 0:
						motion.y =lerp(motion.y,GRAVITY,0.3)
						$Sprite.play("Slide")
						$Sprite.flip_h = true
					sliding = true
					airJumps = maxAirJumps
				if onFloor:
					$Sprite.play("Run")
					motion.x -= ACCELERATION
					$Sprite.flip_h = true
					motion.x = max(motion.x,-GROUNDSPEED)
				else:
					if motion.x < -GROUNDSPEED-20:
						motion.x += AIR_ACCELERATION
					else:
						motion.x -= ACCELERATION
						motion.x = max(motion.x,-GROUNDSPEED)
			else:
				sliding = false
				if onFloor:
					if Input.is_action_pressed("ui_down"):
						$Sprite.play("Sleep")
					elif Input.is_action_just_pressed("ui_action") or ($Sprite.animation == "Bark" and $Sprite.frame < 5):
						$Sprite.play("Bark")
						#print($Sprite.frame)
					else:
						$Sprite.play("Idle")
					
					motion.x = lerp(motion.x, 0, 0.3)
					if abs(motion.x) < 100:
						motion.y = 0
				else:
					motion.x = lerp(motion.x, 0, 0.05)
				#print(is_on_floor())
			if Input.is_action_just_pressed("ui_jump"):
				if onFloor:
					motion.y = JUMP
				elif (onLeftWall or onRightWall):
					motion.y = JUMP/1.1
				elif airJumps > 0:
					motion.y = JUMP
					airJumps -= 1
				jumping = true
		#print(airJumps)
		#bash target detecting
		if Input.is_action_just_pressed("ui_click_secondary") and canBash:
			var bodies = $BashArea.get_overlapping_bodies()
			if len(bodies) > 0:
				if bash_timer == 0:
					bash_target	= weakref(bodies[0])
					airJumps = maxAirJumps
		#print(onRightWall)
		#bash directing + some animation stuff
		if Input.is_mouse_button_pressed(BUTTON_RIGHT) and bash_target and bash_target.get_ref():
			var bt = bash_target.get_ref()
			var dir = (get_global_mouse_position()-bt.get_pos()).normalized()
			motion = Vector2(0,0)
			$CollisionShape2D.disabled = true
			if self.position.distance_to(bt.get_pos()) > 20:
				self.position.x = lerp(self.position.x,bt.get_pos().x,0.4)
				self.position.y = lerp(self.position.y,bt.get_pos().y,0.4)
			else:
				self.position = bt.get_pos()
			#$BashLine.visible = true
			$BashArrow.visible = true
			$Sprite.modulate.a = lerp($Sprite.modulate.a,0,0.1)
			$BashArrow.rotation = BASH_ARROW_INITIAL + dir.angle()
			#$BashLine.set_point_position(0, bt.get_pos() - self.position + dir*50)
			#$BashLine.set_point_position(1, bt.get_pos() - self.position)
		else:
			$Sprite.modulate.a = 1
			#$BashLine.visible=false
			$BashArrow.visible = false
		#bash shoot
		
		if Input.is_action_just_released("ui_click_secondary") and bash_target and bash_target.get_ref():
			$InvincibilityTimer.start()
			var bt = bash_target.get_ref()
			if bt.get("beenBashed") != null:
				bt.beenBashed = true
			var dir = (get_global_mouse_position()-bt.get_pos()).normalized()
			motion = dir * BASH_FORCE
			if bt.get("motion"):
				bt.set("motion",-motion)
			bash_target = null
			$CollisionShape2D.disabled = false
			bash_timer = 0.25	
		if bash_target and not bash_target.get_ref():
			bash_target = null
			$CollisionShape2D.disabled = false
		
		var snap = Vector2.DOWN*60
		if jumping:
			snap = Vector2.ZERO
		#print(snap)
		motion = move_and_slide_with_snap(motion,snap,Vector2.UP,false,4,0.802851456)
	
	
	
		if len($HurtBox.get_overlapping_bodies()) > 0 and not bash_target and $InvincibilityTimer.time_left <= 0:
			#print("a")
			var harmful = true
			for b in $HurtBox.get_overlapping_bodies():
				if "Bullet" in b.name:
					b.queue_free()
				if "HealthPack" in b.name:
					print("aaaa")
					b.queue_free()
					health = maxhealth
					harmful = false
			if harmful:
				rope_dist = -1
				health -= 1
				$InvincibilityTimer.start()
				$Camera2D.shake(0.15,20,50)
				blinktime = 0
		
		if $InvincibilityTimer.time_left > 0:
			if blinktime > BLINK:
				if self.modulate.a < 1:
					self.modulate.a = 1
				else:
					self.modulate.a = 0.5
				blinktime = 0
			else:
				blinktime += delta
		else:
			self.modulate.a = 1
	
		self.modulate.b = health/float(maxhealth)
		self.modulate.g = health/float(maxhealth)
		if health <= 0:
			$Sprite.play("dying")
			self.modulate.b = 1
			self.modulate.g = 1

		$CatSprite.position -= motion*delta
		$CatSprite.position -= $CatSprite.position.normalized() * $CatSprite.position.distance_to(Vector2(0,0)) * 0.3
		#$CatSprite.rotation = - motion.x * 0.005 / 2 / 3.14159
	
	if attack_target:
		$CatSprite.flip_h = attack_target.get_pos() < self.position
		$LampSprite.flip_h = attack_target.get_pos() < self.position
		$ClawSprite.flip_h = attack_target.get_pos() < self.position
	else:
		$CatSprite.flip_h = $Sprite.flip_h
		$LampSprite.flip_h = $Sprite.flip_h
		
	if $Sprite.animation == "dying" and $Sprite.frame == 6:
		health = maxhealth
		self.position = get_node("../SavePoints/"+str(curSave)).position
		$Sprite.play("Idle")
		
	
	if Input.is_key_pressed(KEY_H):
		health = maxhealth
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

