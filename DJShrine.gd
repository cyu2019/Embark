extends Shrine

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func not_upgraded():
	dialog_box.init(["Hmm... This jump looks a little too long for us to jump across.","Maybe we can ask the spirit of this shrine to help!","Let's look for some coins in a nearby area to see if we can make an offering."],"res://Sprites/cat_portrait.png")

func already_upgraded():
	dialog_box.init(["Remember, press **[SPACE]** while airborne to do a jump in midair!"],"res://Sprites/cat_portrait.png")

func upgrade():
	dialog_box.init(["You learned double jump! This lets you kick off the air and soar through the skies!","Press **[SPACE]** while airborne to do a jump in midair!"],"res://Sprites/cat_portrait.png")
	player.maxAirJumps = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
