extends StaticBody2D

var bullet = load("res://Bullet.tscn");

export var dir = Vector2()
export var from_dir = Vector2(0,0)
func get_pos():
	return self.position
