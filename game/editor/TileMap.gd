extends TileMap

var WIDTH
var HEIGHT
var current_grid_coord
var direction_indicator= load("res://editor/DirectionIndicator.tscn")

signal openPortalEditor(sceneCoord, sceneName, sceneToEdit)

func _ready():
	
	WIDTH = MapFileLoader._get_value("grid_size", "x")
	HEIGHT = MapFileLoader._get_value("grid_size", "y")
	
	#Inicializar todos los tiles que tengan data
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var section = "grid:" + str(x) + "," + str(y)
			if (MapFileLoader._has_section_key(section, "name")):
				set_cellv(Vector2(x,y), 0)
				_set_direction_tile( Vector2(x,y), 
					MapFileLoader.get_portal(Vector2(x,y), "N") != null, #MapFileLoader._get_value(section, "N") ),
					MapFileLoader.get_portal(Vector2(x,y), "S") != null, #MapFileLoader._get_value(section, "S") ),
					MapFileLoader.get_portal(Vector2(x,y), "E") != null, #MapFileLoader._get_value(section, "E") ),
					MapFileLoader.get_portal(Vector2(x,y), "W") != null) #MapFileLoader._get_value(section, "W") ))
	
	$Properties/save_button.connect("button_down", self, "_on_save_button")
	$Properties/delete_button.connect("button_down", self, "_on_delete_button")
	$Properties/edit_portals_button.connect("button_down", self, "_on_edit_portals_button")
	$launch_game_button.connect("button_down", self, "_on_button_launch_game")
	
#	$Properties/North_Door.set_text( "False" )
#	$Properties/East_Door.set_text( "False" )
#	$Properties/West_Door.set_text( "False" )
#	$Properties/South_Door.set_text( "False" ) 
	
	$Properties/error_message.visible = false;
	
	#CARGAR LA INFO DEL 0,0
	_load_panel_info(Vector2(0,0))
	
	#TUTORIAL SOBRE COMO GUARDAR INFO EN FILESYSTEM
	#https://www.youtube.com/watch?v=IrUhyf-g5hU
	#TUTORIAL SOBRE COMO RECUPERAR DATA DEL FILESYSTEM
	#https://www.youtube.com/watch?v=XQptE6qrhKA
	
	#DISEÑANDO UN EDITOR DE TILES CUSTOM
	#https://steemit.com/utopian-io/@sp33dy/tutorial-godot-engine-v3-gdscript-custom-tilemap
	#CONTINUACION
	#https://steemit.com/cn/@sp33dy/tutorial-godot-engine-v3-gdscript-custom-tilemap-scrolling


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
		
		print("_input", current_grid_coord)
		
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
	print("_load_panel_info: ", coord)
	var section = "grid:" + str(coord.x) + "," + str(coord.y)

	if (not MapFileLoader._has_section_key(section, "name")):
		$Properties/Level_Name.set_text( "Default" )
		$Properties/edit_portals_button.set_disabled(true)
		return
	
	$Properties/Level_Name.set_text( MapFileLoader._get_value(section, "name") )
	#set_portal_direction($Properties/North_Door, bool(MapFileLoader._get_value(section, "N") ) ) 

	$Properties/edit_portals_button.set_disabled(false)
	
	
func _on_delete_button():
	set_cellv(Vector2(current_grid_coord.x, current_grid_coord.y), -1)
	$Properties/Level_Name.set_text( "Default" )
	delete_direction_tile(Vector2(current_grid_coord.x, current_grid_coord.y))
	
	MapFileLoader._on_tile_delete_room(current_grid_coord)

func _get_portal_values(direction):
	if ( !$Properties.get_node(direction + "_label").get_node("Info").get_node("exists_value").is_pressed() ):
		return null
		
	var portal = {}
	portal["x"] = $Properties.get_node(direction + "_label").get_node("Info").get_node("x_value").get_text()
	portal["y"] = $Properties.get_node(direction + "_label").get_node("Info").get_node("y_value").get_text()
	portal["width"] = $Properties.get_node(direction + "_label").get_node("Info").get_node("width_value").get_text()
	portal["height"] = $Properties.get_node(direction + "_label").get_node("Info").get_node("height_value").get_text()
	return portal

func _on_save_button():
	
	#REIMPLEMENTAR EL SAVE BUTTON.
	#ANTES VA A SER NECESARIO GUARDAR EL ESTADO TEMPORAL DE LA EDICION
	set_cellv(Vector2(current_grid_coord.x, current_grid_coord.y), 0)
	
	var level_name = $Properties/Level_Name.get_text()
	var north_portal = _get_portal_values("north")
	var east_portal = _get_portal_values("east")
	var west_portal = _get_portal_values("west")
	var south_portal = _get_portal_values("south")
	
	_set_direction_tile(Vector2(current_grid_coord.x, current_grid_coord.y),
						north_portal != null,
						south_portal != null,
						east_portal != null,
						west_portal != null)
	
	print("saving on: ", current_grid_coord)
	MapFileLoader._on_tile_set_room(current_grid_coord, level_name, north_portal, east_portal, west_portal, south_portal)
	
func _on_button_launch_game():
	print("LAUNCH GAME")
	var pack = preload("res://scenes/MapEditor.tscn")
	var scene = pack.instance()
	get_tree().get_root().add_child(scene)
	get_parent().queue_free()
	

func _on_edit_portals_button():
	var sceneCoord = "grid:" + str(current_grid_coord.x) + "," + str(current_grid_coord.y)
	var sceneName = $Properties/Level_Name.get_text()
	var sceneRes = load("res://scenes/levels/" + sceneName + ".tscn")
	if not sceneRes:
		$Properties/error_message.visible = true;
	else:
		emit_signal("openPortalEditor", sceneCoord, sceneName, sceneRes)
		
		
		