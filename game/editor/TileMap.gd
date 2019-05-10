extends TileMap

var WIDTH
var HEIGHT
var current_grid_coord = Vector2(3,3)
var direction_indicator= load("res://editor/DirectionIndicator.tscn")

signal openPortalEditor(sceneCoord, sceneToEdit)

func _ready():
	
	WIDTH = MapFileLoader._get_value("grid_size", "x")
	HEIGHT = MapFileLoader._get_value("grid_size", "y")
	
	#Inicializar todos los tiles que tengan data
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var coord = Vector2(x,y)
			if (MapFileLoader.has_portal_data(coord)):
				set_cellv(coord, 0)
				_set_direction_tile( coord, 
					MapFileLoader.get_portal(coord, "N") != null, 
					MapFileLoader.get_portal(coord, "S") != null, 
					MapFileLoader.get_portal(coord, "E") != null, 
					MapFileLoader.get_portal(coord, "W") != null) 
	
	$Properties/save_button.connect("button_down", self, "_on_save_button")
	$Properties/delete_button.connect("button_down", self, "_on_delete_button")
	$Properties/edit_portals_button.connect("button_down", self, "_on_edit_portals_button")
	
	
	$Properties/error_message.visible = false;
	
	var cursor_pos = map_to_world(current_grid_coord)
	$Selector.set_position(cursor_pos)
	
	_load_panel_info(current_grid_coord)

func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_position= get_viewport().get_mouse_position()
		var old_current_grid= current_grid_coord
		current_grid_coord= world_to_map(mouse_position)
		
		$Properties/error_message.visible = false;
		
		if (current_grid_coord.x > WIDTH or current_grid_coord.y > HEIGHT):
			current_grid_coord= old_current_grid
			return
		
		var cursor_pos = map_to_world(current_grid_coord)
		$Selector.set_position(cursor_pos)
		
		_load_panel_info(current_grid_coord)
	
	
func _set_direction_tile(v, n, s, e, w):
	var node_name = str(v.x) + "," + str(v.y)
	var c
	if $Directions.has_node(node_name):
		c= $Directions.get_node(node_name)
	else:
		c= direction_indicator.instance()
		$Directions.add_child(c)
	
	c.set_name(str(v.x) + "," + str(v.y))
	c.set_position(Vector2(v.x*64,v.y*64))
	c.set_directions(n, s, e, w)
	
func delete_direction_tile(v):
	var node_name = str(v.x) + "," + str(v.y)
	if $Directions.has_node(node_name):
		$Directions.get_node(node_name).queue_free()

func _load_panel_info(coord):
	$Properties/coord_value.set_text( str(coord) )
	
	if (not MapFileLoader.has_portal_data(coord)):
		$Properties/Level_Name.set_text( "Default" )
		$Properties/edit_portals_button.set_disabled(true)
	else:
		$Properties/Level_Name.set_text( MapFileLoader.get_scene_name(coord) )
		$Properties/edit_portals_button.set_disabled(false)
	
	var north_portal = MapFileLoader.get_portal( coord, "N" )
	var east_portal = MapFileLoader.get_portal( coord, "E" )
	var west_portal = MapFileLoader.get_portal( coord, "W" )
	var south_portal = MapFileLoader.get_portal( coord, "S" )
	
	_set_portal_values( "north", north_portal )
	_set_portal_values( "east", east_portal)
	_set_portal_values( "south", south_portal)
	_set_portal_values( "west", west_portal)
	
	
func _set_portal_values(direction, portal):
	#
	if (portal != null):
		$Properties.get_node(direction + "_label").get_node("Info").updateInfo(true, portal)
	else:
		$Properties.get_node(direction + "_label").get_node("Info").setDefault()

func _get_portal_values(direction):
	if ( !$Properties.get_node(direction + "_label").get_node("Info").get_node("exists_value").is_pressed() ):
		return null
		
	var portal = {}
	var portal_info = $Properties.get_node(direction + "_label").get_node("Info").getInfo()
	portal["x"] = portal_info["x"]
	portal["y"] = portal_info["y"]
	portal["width"] = portal_info["width"]
	portal["height"] = portal_info["height"]
	return portal
	
func _on_delete_button():
	set_cellv(Vector2(current_grid_coord.x, current_grid_coord.y), -1)
	delete_direction_tile(Vector2(current_grid_coord.x, current_grid_coord.y))
	
	MapFileLoader._on_tile_delete_room(current_grid_coord)
	
	_load_panel_info(current_grid_coord)

func _on_save_button():
	
	set_cellv(current_grid_coord, 0)
	
	var level_name = $Properties/Level_Name.get_text()
	var north_portal = _get_portal_values("north")
	var east_portal = _get_portal_values("east")
	var west_portal = _get_portal_values("west")
	var south_portal = _get_portal_values("south")
	
	_set_direction_tile(current_grid_coord,
						north_portal != null,
						south_portal != null,
						east_portal != null,
						west_portal != null)
	
	print("saving on: ", current_grid_coord)
	MapFileLoader.set_portals_on_room(current_grid_coord, level_name, north_portal, east_portal, west_portal, south_portal)
	

func _on_edit_portals_button():
	var sceneName = $Properties/Level_Name.get_text()
	var sceneRes = load("res://scenes/levels/" + sceneName + ".tscn")
	if not sceneRes:
		$Properties/error_message.visible = true;
	else:
		emit_signal("openPortalEditor", current_grid_coord, sceneRes)