extends Character

const UP = Vector2(0,-1)

const DECAYTIME = 3

func _ready():
	maxhealth = 3
	health = 3
	pass

var timeOffScreen = 0

var bullet = load("res://Bullet.tscn");

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
	motion = move_and_slide(motion)
	
	motion.x = max(0,motion.x-200*delta)
	motion.y = max(0,motion.y-200*delta)
	
	if motion.x == 0:
		self.position.x = lerp(self.position.x,0,0.03)
		self.position.y = lerp(self.position.y,0,0.03)
	
	self.modulate.b = float(health)/maxhealth
	self.modulate.g = float(health)/maxhealth
	if (health == 0):
		queue_free()

func _on_ShotTimer_timeout():
	if $VisibilityEnabler2D.is_on_screen():
		var target = get_node("../../../player").position - get_pos()
		var b = bullet.instance()
		b.motion = target.normalized()
		b.speed = 200
		add_child(b)
