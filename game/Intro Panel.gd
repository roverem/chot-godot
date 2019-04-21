extends Panel

var ticks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	ticks+=1
	if ticks == 1:
		$Label.visible = true
	if ticks == 2:
		$icon.visible = true
	if ticks == 3:
		$Button.visible = true
