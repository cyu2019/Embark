extends Shrine

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func not_upgraded():
	dialog_box.init(["Another large gap, eh? No enemies to possess, no platforms to jump across...","...","Well, you know what to do. Let's ask the spirits for help again!"],"res://Sprites/cat_portrait.png")

func already_upgraded():
	dialog_box.init(["Hold [LEFT CLICK] to shoot out a rope and grapple along sufaces! Use [RIGHT ARROW] and [LEFT ARROW] to influence your momentum on the rope!"],"res://Sprites/cat_portrait.png")

func upgrade():
	dialog_box.init(["You learned rope swing!","Hold [LEFT CLICK] to shoot out a rope and grapple along sufaces! Use [RIGHT ARROW] and [LEFT ARROW] to influence your momentum on the rope!"],"res://Sprites/cat_portrait.png")
	player.canRope = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
