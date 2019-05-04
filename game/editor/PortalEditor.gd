extends Node2D

signal closePortalEditor

var currentScene

func _ready():
	$close_button.connect("button_down", self, "_on_close_button")
	$close_button.visible = false
	
func _on_close_button():
	emit_signal("closePortalEditor")


func _loadScene(sceneRes):
	#CARGAR LOS NODOS QUE YA ESTEN LISTOS EN ESTA ESCENA
	
	#PREPARAR LOS LISTENERS PARA DIBUJAR PORTALES
	
	$close_button.visible = true
	currentScene = sceneRes.instance()
	add_child(currentScene)
	
func _removeScene():
	#APAGAR LOS LISTENERS PARA DIBUJAR PORTALES
	
	$close_button.visible = true
	remove_child(currentScene)
	
	
func _draw():
	pass