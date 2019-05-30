extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

var background
export(Texture) var texture

func _ready():
	background = get_node("../../Background/ParallaxLayer/Sprite")

var entered = false
var transitioning = false
var fade_done = false



func _process(delta):
	if transitioning and entered:
		#print(fade_done)
		if fade_done:
			background.modulate.a = min(1,background.modulate.a + 0.05)
			#print("fading in")
		elif background.modulate.a == 0:
			fade_done = true
			background.texture = texture
			#print("switched")
		elif background.modulate.a == 1 and fade_done:
			transitioning = false
			#print("done")
		else:
			#print("fading out")
			background.modulate.a = max(0,background.modulate.a - 0.05)
	var player_in = false
	for i in get_overlapping_areas():
		if "HurtBox" == i.name:
			player_in = true
	
	if player_in and not entered:
		transitioning = true
		fade_done = false
	if player_in:
		entered = true
	else:
		entered = false
	