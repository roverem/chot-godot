extends Node2D

var player_scene = preload("res://Player.tscn")
var player

func _ready():
	player = player_scene.instance()
	add_child(player)
	player.position.x = 200
	player.position.y = 200