extends Panel

signal game_start

func _ready():
	$Label.visible = false
	$icon.visible = false
	$Button.visible = false
	$Button.connect("pressed", self, "_on_button_pressed")

var ticks = 0

func _on_Timer_timeout():
	ticks+=1
	if ticks == 1:
		$Label.visible = true
	if ticks == 2:
		$icon.visible = true
	if ticks == 3:
		$Button.visible = true
		
func _on_button_pressed():
	emit_signal("game_start")