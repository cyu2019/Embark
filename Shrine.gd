extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Shrine
onready var dialog_box = get_node("../../CanvasLayer/Control/Dialog")
var player = null
var upgraded = false
var coinsLeft = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../player")
	pass # Replace with function body.

func not_upgraded():
	pass

func already_upgraded():
	pass

func upgrade():
	pass

func _process(delta):
	var player_on = false
	for b in get_overlapping_bodies():
		if b == player:
			player_on = true
			self.modulate.a = 0.8
			if Input.is_action_just_pressed("ui_action") and not dialog_box.active():
				if coinsLeft == 0 and upgraded == false:
					print("upgraded")
					# play cutscene or something
					upgrade()
					upgraded = true
				elif upgraded == true:
					already_upgraded()
				else:
					not_upgraded()
	if not player_on:
		self.modulate.a = 1			
					
					
					# play dialogue about this shrine maybe being able to help
	