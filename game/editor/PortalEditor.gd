extends Node2D

signal closePortalEditor

var currentScene
var sceneCoord
var drag_mouse = false

func _ready():
	
	$close_button.connect("button_down", self, "_on_close_button")
	$close_button.visible = false
	
	$save_button.connect("button_down", self, "_on_save_button")
	$save_button.visible = false
	
	$Portals/north_portal.visible = false
	$Portals/south_portal.visible = false
	$Portals/east_portal.visible = false
	$Portals/west_portal.visible = false
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_N:
			_toggle_portal("north")
		if event.pressed and event.scancode == KEY_S:
			_toggle_portal("south")
		if event.pressed and event.scancode == KEY_W:
			_toggle_portal("west")
		if event.pressed and event.scancode == KEY_E:
			_toggle_portal("east")
			
			
func _toggle_portal(direction):
	$Portals.get_node(direction + "_portal").visible = !_is_portal_active(direction)
	
func _is_portal_active(direction):
	return $Portals.get_node(direction + "_portal").visible

func _on_close_button():
	emit_signal("closePortalEditor")
	
func _on_save_button():
	print("_on_save_button")
	#REVISAR EL ESTADO DE LOS PORTALES PARA GUARDARLOS (SI PRENDIDOS O NO)
	print( _is_portal_active("north") )
	print( _is_portal_active("south") )
	print( _is_portal_active("east") )
	print( _is_portal_active("west") )
	
					#placeholder. Esto puede dar errores, hay que meterle el nombre a mano igual que el nombre de la escena.
	var level_name = currentScene.get_name()
	var north_portal = _get_portal_values("north")
	var east_portal = _get_portal_values("east")
	var west_portal = _get_portal_values("west")
	var south_portal = _get_portal_values("south")
#
#	print("saving on: ", current_grid_coord)
	MapFileLoader.set_portals_on_room(sceneCoord, level_name, north_portal, east_portal, west_portal, south_portal)
	
	
func _get_portal_values(direction):
	if ( !$Portals.get_node(direction + "_portal").visible ):
		return null
		
	var portal = {}
	var portal_info = $Portals.get_node(direction + "_portal")
	portal["x"] = str(portal_info.position.x)
	portal["y"] = str(portal_info.position.y)
	portal["width"] = "100" #portal_info["width"]
	portal["height"] = "100" #portal_info["height"]
	return portal
	
func loadScene(_sceneCoord, sceneRes):
	sceneCoord = _sceneCoord
	
	var north_portal_data = MapFileLoader.get_portal( sceneCoord, "N" )
	var east_portal_data = MapFileLoader.get_portal( sceneCoord, "E" )
	var west_portal_data = MapFileLoader.get_portal( sceneCoord, "W" )
	var south_portal_data = MapFileLoader.get_portal( sceneCoord, "S" )
	
	_set_portal($Portals/north_portal, north_portal_data)
	_set_portal($Portals/south_portal, south_portal_data)
	_set_portal($Portals/east_portal, east_portal_data)
	_set_portal($Portals/west_portal, west_portal_data)
	
	$close_button.visible = true
	$save_button.visible = true
	
	currentScene = sceneRes.instance()
	add_child(currentScene)

func _set_portal(portal, portal_data):
	if (portal_data != null):
		portal.position.x = int(portal_data["x"])
		portal.position.y = int(portal_data["y"])
		portal.visible = true
	else:
		portal.visible = false

func _removeScene():
	
	_set_portal($Portals/north_portal, null)
	_set_portal($Portals/south_portal, null)
	_set_portal($Portals/east_portal, null)
	_set_portal($Portals/west_portal, null)
	
	#APAGAR LOS LISTENERS PARA DIBUJAR PORTALES
	
	$close_button.visible = true
	remove_child(currentScene)
	
	
func _draw():
	pass