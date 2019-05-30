extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dialog = ["peepee peepee peepee peepee peepee","poopoo"]
var page = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init():
	set_bbcode(dialog[page])
	set_visible_characters(0)

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
	