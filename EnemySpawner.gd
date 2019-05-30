extends Position2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var enemy
export var args = []
var baby = null
var seen = false
# Called when the node enters the scene tree for the first time.

func _process(delta):
	if not seen and $VisibilityNotifier2D.is_on_screen():
		seen = true
		if not baby or not baby.get_ref():
			baby = weakref(enemy.instance())
			baby.get_ref().init(args)
			add_child(baby.get_ref())
	if not $VisibilityNotifier2D.is_on_screen():
		seen = false