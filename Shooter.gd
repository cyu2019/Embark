extends StaticBody2D

var bullet = load("res://Bullet.tscn");

export var dir = Vector2()
export var speed = 0

func get_pos():
	return self.position

func _on_ShotTimer_timeout():
	#if $VisibilityEnabler2D.is_on_screen():
	var b = bullet.instance()
	b.position = Vector2(32,32)
	b.motion = dir
	b.speed = speed
	add_child(b)
