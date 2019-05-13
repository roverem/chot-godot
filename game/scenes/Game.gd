extends Node2D

var current_scene
var current_coord
var starting_player_position

var current_north_portal
var current_east_portal
var current_west_portal
var current_south_portal

signal player_start(player)

func _ready():
	#start_coord
	current_coord = MapFileLoader.get_starting_portal_coord()
	starting_player_position = MapFileLoader.get_starting_player_position()
	var scene_name = MapFileLoader.get_scene_name(current_coord)
	var pack = load("res://scenes/levels/" + scene_name + ".tscn")
	current_scene = pack.instance()
	add_child(current_scene)
	
	$Portals.emit_signal("player_start", $Player) #por ahora no se usa pero lo dejo.
	$Portals.connect("player_enters", self, "_on_player_entered_portal")
	
	_setup_scene(false)
	
func _setup_scene(enter_direction):
	
	_set_portals()
	_set_player_starting_position(enter_direction)
	#current_scene
	#current_coord
	
func _on_player_entered_portal(direction):
	print("_on_player_entered", direction)
	_get_next_scene(direction)
	_setup_scene(direction)

func _get_next_scene(direction):
	if direction == "north":
		current_coord.y -= 1
	elif direction == "south":
		current_coord.y += 1
	elif direction == "west":
		current_coord.x -= 1
	elif direction == "east":
		current_coord.x += 1
	
func _set_portals():
	current_north_portal = MapFileLoader.get_portal(current_coord, "N")
	current_east_portal = MapFileLoader.get_portal(current_coord, "E")
	current_west_portal = MapFileLoader.get_portal(current_coord, "W")
	current_south_portal = MapFileLoader.get_portal(current_coord, "S")
	
	_set_portal($Portals/north_portal, current_north_portal)
	_set_portal($Portals/east_portal, current_east_portal)
	_set_portal($Portals/west_portal, current_west_portal)
	_set_portal($Portals/south_portal, current_south_portal)
	
	
func _set_portal(portal, portal_data):
	if (portal_data != null):
		portal.position.x = int(portal_data["x"])
		portal.position.y = int(portal_data["y"])
		portal.visible = true
	else:
		portal.visible = false
	
func _set_player_starting_position(direction):
	if !direction:
		$Player.position.x = int(starting_player_position.x)
		$Player.position.y = int(starting_player_position.y)
	else:
		var portal = _get_entering_portal(direction)
		$Player.position.x = int(portal.x)
		$Player.position.y = int(portal.y)


func _get_entering_portal(direction):
	if direction == "north":
		return current_south_portal
	elif direction == "south":
		return current_north_portal
	elif direction == "west":
		return current_east_portal
	elif direction == "east":
		return current_west_portal