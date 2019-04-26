tool
extends Node

export (bool) var doCleanScene = false setget cleanScene


func cleanScene(newValue):
	if Engine.is_editor_hint():
		for i in range(0, get_child_count()):
				get_child(i).queue_free()
				
		doCleanScene = false
		
