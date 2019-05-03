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
	
	
func _on_tile_set_room(current_grid_coord, level_name, north_door, east_door, west_door, south_door):
	print(current_grid_coord, level_name, north_door, east_door, west_door, south_door)
	var section = "grid:" + str(current_grid_coord.x) + "," + str(current_grid_coord.y)
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
	
	