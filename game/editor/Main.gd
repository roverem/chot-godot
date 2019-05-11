extends Node2D

var tile_map


func _ready():
	$TileMap.connect("openPortalEditor", self, "_on_portal_editor_open")
	$PortalEditor.connect("closePortalEditor", self, "_on_portal_editor_close")
	$launch_game_button.connect("button_down", self, "_on_button_launch_game")
	
	var start_coord = MapFileLoader.get_starting_portal_coord()
	
	$start_label/start_value_x.set_text( str(start_coord.x) )
	$start_label/start_value_y.set_text( str(start_coord.y) )
	
	$start_label/start_save_button.connect("button_down", self, "_on_start_save_button")
	
	$PortalEditor.visible = false

func _on_portal_editor_open(sceneCoord, sceneRes):
	tile_map = $TileMap
	remove_child(tile_map)
	
	$launch_game_button.visible = false
	
	$PortalEditor.visible = true
	$PortalEditor.loadScene(sceneCoord, sceneRes)
	
func _on_portal_editor_close():
	$launch_game_button.visible = true
	$PortalEditor.visible = false
	$PortalEditor._removeScene()
	add_child(tile_map)
	
func _on_button_launch_game():
	print("LAUNCH GAME")
	var start_coord = MapFileLoader.get_starting_portal_coord()
	var scene_name = MapFileLoader.get_scene_name(start_coord)
	var pack = load("res://scenes/levels/" + scene_name + ".tscn")
	var scene = pack.instance()
	get_tree().get_root().add_child(scene)
	queue_free()
	
func _on_start_save_button():
	var start = {}
	start["x"] = $start_label/start_value_x.get_text()
	start["y"] = $start_label/start_value_y.get_text()
	MapFileLoader.set_starting_portal_coord(start)
	