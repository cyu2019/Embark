extends Character

const UP = Vector2(0,-1)

export var dir = Vector2(1,-1)
export var speed = 1000

func _ready():
	maxhealth = 3
	health = 3
	pass

func init(args):
	dir = args[0]
	speed = args[1]
	$Sprite.flip_h = dir.x < 0

var timeOffScreen = 0

var bullet = load("res://Rock.tscn");

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
	self.modulate.b = float(health)/maxhealth
	self.modulate.g = float(health)/maxhealth
	if (health == 0):
		queue_free()
	if $Sprite.frame == 4:
		var b = bullet.instance()
		b.position = Vector2(0,-32)
		b.speed = speed
		b.dir = dir
		add_child(b)
	
	if $Sprite.frame == 7:
		$Sprite.play("Idle")

func _on_ShotTimer_timeout():
	if $VisibilityEnabler2D.is_on_screen():
		$Sprite.play("Throwing")
