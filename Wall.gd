extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func break():
	$CollisionShape2D.disabled = true
	$Sprite.play("break")
	get_node("../../player/Camera2D").shake(0.5,20,10)

func _process(delta):
	if $Sprite.frame == 5:
		
		queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
