extends Node2D

var tile_map

func _ready():
	$TileMap.connect("openPortalEditor", self, "_on_portal_editor_open")
	$PortalEditor.connect("closePortalEditor", self, "_on_portal_editor_close")

func _on_portal_editor_open(sceneCoord, sceneRes):
	tile_map = $TileMap
	remove_child(tile_map)
	
	$PortalEditor.loadScene(sceneCoord, sceneRes)
	
func _on_portal_editor_close():
	$PortalEditor._removeScene()
	add_child(tile_map)