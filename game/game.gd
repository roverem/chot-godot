extends Node2D

var intro_scene = preload("res://intro.tscn")
var first_scene = preload("res://first.tscn")

var intro_node 
var first_node

func _ready():
	intro_node = intro_scene.instance()
	add_child(intro_node)
	
	intro_node.get_node("Intro Panel").connect("game_start", self, "_on_game_start")


func _on_game_start():
	intro_node.queue_free()
	
	first_node = first_scene.instance()
	add_child(first_node)