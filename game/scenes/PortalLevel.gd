extends Area2D

export(String) var label_name = "none"

func _ready():
	$Label.set_text(label_name)
