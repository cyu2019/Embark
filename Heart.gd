extends TextureRect

export var num = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node("../../../../player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if player.health >= num:
		self.visible = true
	else:
		self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
