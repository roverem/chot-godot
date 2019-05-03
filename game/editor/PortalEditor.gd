extends Node2D


func _ready():
	pass # Replace with function body.

func _loadScene(sceneRes):
	var scene = sceneRes.instance()
	add_child(scene)