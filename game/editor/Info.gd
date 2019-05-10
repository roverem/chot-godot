extends Node2D

var defaultPortal

func _ready():
	defaultPortal = {}
	defaultPortal["x"] = "0"
	defaultPortal["y"] = "0"
	defaultPortal["width"] = "100"
	defaultPortal["height"] = "100"
	pass # Replace with function body.

func updateInfo(active, portal):#, x, y, height, width):
	$exists_value.set_pressed(active)
	$x_value.set_text(portal["x"])
	$y_value.set_text(portal["y"])
	$width_value.set_text(portal["width"])
	$height_value.set_text(portal["height"])
	pass
	
func setDefault():
	updateInfo( false, defaultPortal )
	
	
func getInfo():
	var portal = {}
	portal["exists"] = $exists_value.is_pressed()
	portal["x"] = $x_value.get_text()
	portal["y"] = $y_value.get_text()
	portal["width"] = $width_value.get_text()
	portal["height"] = $height_value.get_text()
	return portal