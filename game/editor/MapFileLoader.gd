extends Node

const SAVE_PATH = "res://editor/map.cfg"

var _map_file = ConfigFile.new()

var _initData = {
	"grid_size": {
		"x": 12,
		"y": 12
		}
	}
	
func _ready():
	var err = _map_file.load(SAVE_PATH)
	if err == OK:
		if not _map_file.has_section_key("grid_size", "x"):
        	_map_file.set_value("grid_size", "x", _initData["grid_size"]["x"])
			
		if not _map_file.has_section_key("grid_size", "y"):
        	_map_file.set_value("grid_size", "y", _initData["grid_size"]["y"])
			
		_map_file.save(SAVE_PATH)
		
func _get_value(section, key):
	return _map_file.get_value(section, key)
	
func _has_section_key(section, key):
	return _map_file.has_section_key(section, key)
	
func _section_from_coord(gridCoord):
	return "grid:" + str(gridCoord.x) + "," + str(gridCoord.y)

func set_portal(gridCoord, direction, properties):
	#properties : x, y, width, height
	var section = _section_from_coord(gridCoord)
	_map_file.set_value(section, direction, properties)
	_map_file.save(SAVE_PATH)
	
func get_portal(gridCoord, direction):
	if _map_file.has_section_key( _section_from_coord(gridCoord), direction ):
		return _map_file.get_value( _section_from_coord(gridCoord), direction)
	else:
		return null
	
func has_portal_data(gridCoord):
	return _map_file.has_section_key(_section_from_coord(gridCoord), "name")
	
func get_scene_name(gridCoord):
	return _map_file.get_value( _section_from_coord(gridCoord), "name") 
	
func get_starting_portal_coord():
	var gridCoord = _map_file.get_value("start_game", "map_coord")
	return Vector2(gridCoord["x"], gridCoord["y"])
	
func get_starting_player_position():
	return _map_file.get_value("start_game", "player_coord")
	
func set_starting_portal_coord(start):
	_map_file.set_value("start_game", "map_coord", start)
	_map_file.save(SAVE_PATH)
	

func set_portals_on_room(current_grid_coord, level_name, north_door, east_door, west_door, south_door):
	var section = _section_from_coord(current_grid_coord)
	_map_file.set_value(section, "name", level_name)
	_map_file.set_value(section, "N", north_door)
	_map_file.set_value(section, "E", east_door)
	_map_file.set_value(section, "W", west_door)
	_map_file.set_value(section, "S", south_door)
	_map_file.save(SAVE_PATH)
	

func _on_tile_delete_room(current_grid_coord):
	var section = "grid:" + str(current_grid_coord.x) + "," + str(current_grid_coord.y)
	_map_file.erase_section(section)
	_map_file.save(SAVE_PATH)
	
