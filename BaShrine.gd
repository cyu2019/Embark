extends Shrine

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func not_upgraded():
	dialog_box.init(["My, what a large gap! I don't think we'd even be able to cross with 5 jumps!","Perhaps the guardian of this shrine will teach us how to cross this chasm.","Let's look for some coins nearby to see if we can make an offering."],"res://Sprites/cat_portrait.png")

func already_upgraded():
	dialog_box.init(["Hold [RIGHT CLICK] when near enemies or projectiles to possess them! Let go of [RIGHT CLICK] to launch yourself towards your mouse, and the target of your possession in the opposite direction!","Use possession to take control of smaller objects to get into small gaps or launch projectiles to break walls!"],"res://Sprites/cat_portrait.png")

func upgrade():
	dialog_box.init(["You learned possession!","Hold [RIGHT CLICK] when near enemies or projectiles to possess them! Let go of [RIGHT CLICK] to launch yourself towards your mouse, and the target of your possession in the opposite direction!","Use possession to take control of smaller objects to get into small gaps or launch projectiles to break walls!"],"res://Sprites/cat_portrait.png")
	player.canBash = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
