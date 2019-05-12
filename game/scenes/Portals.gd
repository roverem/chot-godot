extends Node2D

signal player_enters(direction)

var _player


func _ready():
	connect("player_start", self, "_on_player_start")
	
func _on_player_start(player):
	_player = player
	
func _on_body_entered(body, direction):
	print(direction)
	if body is KinematicBody2D:
		emit_signal("player_enters", direction)

func _on_north_portal_body_entered(body):
	_on_body_entered(body, "north")


func _on_south_portal_body_entered(body):
	_on_body_entered(body, "south")


func _on_east_portal_body_entered(body):
	_on_body_entered(body, "east")


func _on_west_portal_body_entered(body):
	_on_body_entered(body, "west")
