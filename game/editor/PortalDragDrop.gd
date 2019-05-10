extends Area2D

var drag_mouse = false

export(String) var label_name = "none"

func _ready():
	$Label.set_text(label_name)
	connect("input_event", self, "_on_Area2D_input_event")

func _process(delta):
	if (drag_mouse):
		set_position(get_viewport().get_mouse_position())

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		drag_mouse = event.is_pressed()
		

	