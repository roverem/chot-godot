extends Node

export (PackedScene) var Intro
export (PackedScene) var Map
export (PackedScene) var Level

var intro_scene
var map_scene
var level_scene

func _ready():
	intro_scene = Intro.instance()
	add_child(intro_scene)
	
	intro_scene.get_node("Intro Panel").connect("game_start", self, "_on_game_start")


func _on_game_start():
	intro_scene.queue_free()
	
	map_scene = Map.instance()
	add_child(map_scene)
	
	map_scene.connect("map_button_A_pressed", self, "_on_map_button_A_pressed")
	map_scene.connect("map_button_B_pressed", self, "_on_map_button_B_pressed")
	
	
	
func _on_map_button_A_pressed():
	map_scene.queue_free()
	
	level_scene = Level.instance()
	add_child(level_scene)

	level_scene.connect("game_start_2", self, "_on_game_start_2")
	
	
func _on_map_button_B_pressed():
	map_scene.queue_free()
	
	level_scene = Level.instance()
	add_child(level_scene)
	
	level_scene.connect("game_start_2", self, "_on_game_start_2")
	
	
	
func _on_game_start_2():
	level_scene.queue_free()
	
	map_scene = Map.instance()
	add_child(map_scene)
	
	map_scene.connect("map_button_A_pressed", self, "_on_map_button_A_pressed")
	map_scene.connect("map_button_B_pressed", self, "_on_map_button_B_pressed")