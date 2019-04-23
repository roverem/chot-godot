extends Node

export (PackedScene) var Coso

func _ready():
	var m = Coso.instance()
	add_child(m)