tool
extends TileMap

signal custom

var WIDTH
var HEIGHT
var current_grid_coord


func _ready():
	
	WIDTH = MapFileLoader._map_file.get_value("grid_size", "x")
	HEIGHT = MapFileLoader._map_file.get_value("grid_size", "y")
	
	#Inicializar todos los tiles que tengan data
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var section = "grid:" + str(x) + "," + str(y)
			if (MapFileLoader._map_file.has_section_key(section, "name")):
				set_cellv(Vector2(x,y), 0)
	
	$Properties/save_button.connect("button_down", self, "_on_save_button")
	
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
		
		if (current_grid_coord.x > WIDTH or current_grid_coord.y > HEIGHT):
			current_grid_coord= old_current_grid
			return
		
		var cursor_pos = map_to_world(current_grid_coord)
		$Selector.set_position(cursor_pos)
		
		print("_input", current_grid_coord)
		
		_load_panel_info(current_grid_coord)
		
		#var cell= get_cell(current_grid_coord.x, current_grid_coord.y)
		#if cell != -1 and cell < tile_set.get_tiles_ids().size()-1:
		#	cell+= 1
		#else:
		#	cell= 0


func _load_panel_info(coord):
	print("_load_panel_info: ", coord)
	var section = "grid:" + str(coord.x) + "," + str(coord.y)

	if (not MapFileLoader._map_file.has_section_key(section, "name")):
		$Properties/Level_Name.set_text( "" )
		$Properties/North_Door.set_text( "" )
		$Properties/East_Door.set_text( "" )
		$Properties/West_Door.set_text( "" )
		$Properties/South_Door.set_text( "" )
		return
	
	$Properties/Level_Name.set_text( MapFileLoader._map_file.get_value(section, "name") )
	$Properties/North_Door.set_text( str( MapFileLoader._map_file.get_value(section, "N") ) )
	$Properties/East_Door.set_text( str( MapFileLoader._map_file.get_value(section, "E") ) )
	$Properties/West_Door.set_text( str( MapFileLoader._map_file.get_value(section, "W") ) )
	$Properties/South_Door.set_text( str( MapFileLoader._map_file.get_value(section, "S") ) )
	

func _on_save_button():
	set_cellv(Vector2(current_grid_coord.x, current_grid_coord.y), 0)
	
	var level_name = $Properties/Level_Name.get_text()
	var north_door = $Properties/North_Door.get_text()
	var east_door = $Properties/East_Door.get_text()
	var west_door =$Properties/West_Door.get_text()
	var south_door = $Properties/South_Door.get_text()
	
	print("saving on: ", current_grid_coord)
	MapFileLoader._on_tile_set_room(current_grid_coord, level_name, north_door, east_door, west_door, south_door)