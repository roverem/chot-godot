extends Node2D

var tile_map

func _ready():
	$TileMap.connect("openPortalEditor", self, "_on_portal_editor_open")
	$PortalEditor.connect("closePortalEditor", self, "_on_portal_editor_close")
	$launch_game_button.connect("button_down", self, "_on_button_launch_game")

func _on_portal_editor_open(sceneCoord, sceneRes):
	tile_map = $TileMap
	remove_child(tile_map)
	
	$PortalEditor.loadScene(sceneCoord, sceneRes)
	
func _on_portal_editor_close():
	$PortalEditor._removeScene()
	add_child(tile_map)
	
func _on_button_launch_game():
	print("LAUNCH GAME")
	var pack = preload("res://scenes/levels/Scene_A.tscn")
	var scene = pack.instance()
	get_tree().get_root().add_child(scene)
	queue_free()