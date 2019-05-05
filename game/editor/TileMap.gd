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
					bool(MapFileLoader._get_value(section, "N") ),
					bool(MapFileLoader._get_value(section, "S") ),
					bool(MapFileLoader._get_value(section, "E") ),
					bool(MapFileLoader._get_value(section, "W") ))
	
	$Properties/save_button.connect("button_down", self, "_on_save_button")
	$Properties/delete_button.connect("button_down", self, "_on_delete_button")
	$Properties/edit_portals_button.connect("button_down", self, "_on_edit_portals_button")
	$launch_game_button.connect("button_down", self, "_on_button_launch_game")
	
	$Properties/North_Door.set_text( "False" )
	$Properties/East_Door.set_text( "False" )
	$Properties/West_Door.set_text( "False" )
	$Properties/South_Door.set_text( "False" ) 
	
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
	

func set_portal_direction(node, pressed):
	node.set_text(str(pressed))
	node.set_pressed(pressed)
	
func refresh_directions():
	set_portal_direction($Properties/North_Door, false ) 
	set_portal_direction($Properties/East_Door, false )
	set_portal_direction($Properties/West_Door, false )
	set_portal_direction($Properties/South_Door, false )

func _load_panel_info(coord):
	print("_load_panel_info: ", coord)
	var section = "grid:" + str(coord.x) + "," + str(coord.y)

	if (not MapFileLoader._has_section_key(section, "name")):
		$Properties/Level_Name.set_text( "Default" )
		$Properties/edit_portals_button.set_disabled(true)
		refresh_directions()
		return
	
	$Properties/Level_Name.set_text( MapFileLoader._get_value(section, "name") )
	set_portal_direction($Properties/North_Door, bool(MapFileLoader._get_value(section, "N") ) ) 
	set_portal_direction($Properties/East_Door, bool(MapFileLoader._get_value(section, "E") ) )
	set_portal_direction($Properties/West_Door, bool(MapFileLoader._get_value(section, "W") ) )
	set_portal_direction($Properties/South_Door, bool(MapFileLoader._get_value(section, "S") ) )
	$Properties/edit_portals_button.set_disabled(false)
	
	
func _on_delete_button():
	set_cellv(Vector2(current_grid_coord.x, current_grid_coord.y), -1)
	$Properties/Level_Name.set_text( "Default" )
	refresh_directions()
	delete_direction_tile(Vector2(current_grid_coord.x, current_grid_coord.y))
	
	MapFileLoader._on_tile_delete_room(current_grid_coord)

func _on_save_button():
	
	#REIMPLEMENTAR EL SAVE BUTTON.
	#ANTES VA A SER NECESARIO GUARDAR EL ESTADO TEMPORAL DE LA EDICION
	set_cellv(Vector2(current_grid_coord.x, current_grid_coord.y), 0)
	
	var level_name = $Properties/Level_Name.get_text()
	var north_door = $Properties/North_Door.is_pressed()
	var east_door = $Properties/East_Door.is_pressed()
	var west_door =$Properties/West_Door.is_pressed()
	var south_door = $Properties/South_Door.is_pressed()
	
	_set_direction_tile(Vector2(current_grid_coord.x, current_grid_coord.y),
						$Properties/North_Door.is_pressed(),
						$Properties/South_Door.is_pressed(),
						$Properties/East_Door.is_pressed(),
						$Properties/West_Door.is_pressed())
	
	print("saving on: ", current_grid_coord)
	MapFileLoader._on_tile_set_room(current_grid_coord, level_name, north_door, east_door, west_door, south_door)
	
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
		
		
		