extends Node2D

export (PackedScene) var map_A
export (PackedScene) var map_B

signal map_button_A_pressed
signal map_button_B_pressed

var backgrounds

func _ready():
	backgrounds = [map_A, map_B]
	
	#DEBERIA LLEGAR ESTE DATO DEL MAIN
	
	var i = randi() % backgrounds.size()
	var b = backgrounds[i].instance()
	add_child(b)
	
	b.get_node("Button_A").connect("pressed", self, "_on_button_A_pressed")
	b.get_node("Button_B").connect("pressed", self, "_on_button_B_pressed")
	
	
func _on_button_A_pressed():
	emit_signal("map_button_A_pressed")
	
func _on_button_B_pressed():
	emit_signal("map_button_B_pressed")