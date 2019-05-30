extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dialog = ["peepee","poopoo"]
var page = 0
var cd = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	pass # Replace with function body.
func active():
	return self.visible or cd > 0
func init(d,p):
	self.visible = true
	dialog = d
	if p:
		$Portrait.texture = load(p)
	else:
		$Portrait.texture = null
	page = 0
	$MessageText.set_bbcode(dialog[page])
	$MessageText.set_visible_characters(0)


func _process(delta):
	#print(active())
	
	cd = max(0,cd - delta)
	if Input.is_action_just_pressed("ui_click_primary") and self.visible == true:
		if $MessageText.get_visible_characters() > $MessageText.get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				$MessageText.set_bbcode(dialog[page])
				$MessageText.set_visible_characters(0)
			else:
				self.visible = false
				cd = 0.5
		else:
			$MessageText.set_visible_characters($MessageText.get_total_character_count())

func _on_Timer_timeout():
	$MessageText.set_visible_characters($MessageText.get_visible_characters()+1)