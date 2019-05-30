extends Character

const UP = Vector2(0,-1)

const JUMP = -500
const GRAVITY = 20
const SPEED = 50

const DECAYTIME = 3


var landed = false
func _ready():
	maxhealth = 3
	health = 3
	pass


var timeOffScreen = 0

func get_pos():
	return self.position + get_node("..").position

func _process(delta):
	"""
	if timeOffScreen > DECAYTIME:
		queue_free()
	if $VisibilityNotifier2D.is_on_screen():
		timeOffScreen = 0
	else:
		timeOffScreen += delta
	"""
	pass
	
func _physics_process(delta):
	var pos = get_pos()
	motion.y += GRAVITY
	var target = sign(get_node("../../../player").position.x-pos.x)*SPEED
	motion.x = lerp(motion.x,target,0.05)
	if is_on_floor():
		if not landed:
			landed = true
			$Sprite.frame = 0
		if $Sprite.frame >= 2:
			motion.y = JUMP
	else:
		landed = false
	motion = move_and_slide(motion,UP)
	self.modulate.b = float(health)/maxhealth
	self.modulate.g = float(health)/maxhealth
	if (health == 0):
		queue_free()
	