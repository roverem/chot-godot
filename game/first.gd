extends Node2D

var player_scene = preload("res://Player.tscn")
var player

func _ready():
	player = player_scene.instance()
	add_child(player)
	player.position.x = 100
	player.position.y = 200
	
	player.get_node("AnimatedSprite").play("walk")
	
	
func _process(delta):
	if player.position.x < 400:
		player.position += Vector2(150,0) * delta
	else:
		if player.position.x < 403:
			player.position.x = 403
			player.get_node("AnimatedSprite").play("shoot")
	