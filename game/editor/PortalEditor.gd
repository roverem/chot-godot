extends Node2D

signal closePortalEditor

var currentScene

func _ready():
	$close_button.connect("button_down", self, "_on_close_button")
	$close_button.visible = false
	
func _on_close_button():
	emit_signal("closePortalEditor")
	

func _loadScene(sceneCoord, sceneName, sceneRes):
	#CARGAR LOS NODOS QUE YA ESTEN LISTOS EN ESTA ESCENA
	print(sceneCoord, sceneName)
	var northPortalExist =  MapFileLoader._get_value(sceneCoord, "N") 
	var southPortalExist =  MapFileLoader._get_value(sceneCoord, "S") 
	var eastPortalExist =  MapFileLoader._get_value(sceneCoord, "E") 
	var westPortalExist =  MapFileLoader._get_value(sceneCoord, "W") 
	
	#PREPARAR LOS LISTENERS PARA DIBUJAR PORTALES
	if (northPortalExist):
		#DRAW SQUARE AT POS
		pass
	
	$close_button.visible = true
	currentScene = sceneRes.instance()
	add_child(currentScene)
	
func _removeScene():
	#APAGAR LOS LISTENERS PARA DIBUJAR PORTALES
	
	$close_button.visible = true
	remove_child(currentScene)
	
	
func _draw():
	pass