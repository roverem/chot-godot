extends Node2D

signal player_enters(direction)

var _player
var _entering_direction
var _exiting_direction

func _ready():
	connect("player_start", self, "_on_player_start")
	
func _on_player_start(player):
	_player = player
	
func _on_body_exited(body, direction):
	if direction == _exiting_direction:
		_exiting_direction = null
	
func _on_body_entered(body, direction):
	
	if body is KinematicBody2D and _exiting_direction == null and direction != _exiting_direction:
		emit_signal("player_enters", direction)
		_entering_direction = direction
		_exiting_direction = _get_opposite_direction(direction)
		
func _get_opposite_direction(direction):
	if direction == "north":
		return "south"
	if direction == "east":
		return "west"
	if direction == "west":
		return "east"
	if direction == "south":
		return "north"

func _on_north_portal_body_entered(body):
	_on_body_entered(body, "north")

func _on_south_portal_body_entered(body):
	_on_body_entered(body, "south")

func _on_east_portal_body_entered(body):
	_on_body_entered(body, "east")

func _on_west_portal_body_entered(body):
	_on_body_entered(body, "west")

func _on_north_portal_body_exited(body):
	_on_body_exited(body, "north")

func _on_south_portal_body_exited(body):
	_on_body_exited(body, "south")

func _on_east_portal_body_exited(body):
	_on_body_exited(body, "east")

func _on_west_portal_body_exited(body):
	_on_body_exited(body, "west")
