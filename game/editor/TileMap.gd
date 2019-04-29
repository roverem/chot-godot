tool
extends TileMap

signal custom

func _ready():
	#TUTORIAL SOBRE COMO GUARDAR INFO EN FILESYSTEM
	#https://www.youtube.com/watch?v=IrUhyf-g5hU
	#TUTORIAL SOBRE COMO RECUPERAR DATA DEL FILESYSTEM
	#https://www.youtube.com/watch?v=XQptE6qrhKA
	
	#DISEÑANDO UN EDITOR DE TILES CUSTOM
	#https://steemit.com/utopian-io/@sp33dy/tutorial-godot-engine-v3-gdscript-custom-tilemap
	
	#CONTINUACION
	#https://steemit.com/cn/@sp33dy/tutorial-godot-engine-v3-gdscript-custom-tilemap-scrolling
	pass



func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_position= get_viewport().get_mouse_position()
		var map_coord= world_to_map(mouse_position)
		var clicked_grid_coord = map_to_world(map_coord)
		$Selector.set_position(clicked_grid_coord)
		var cell= get_cell(map_coord.x, map_coord.y)
		if cell != -1 and cell < tile_set.get_tiles_ids().size()-1:
			cell+= 1
		else:
			cell= 0
			
			
		print(map_coord, cell)
		#SI ESTA EN 0, LE PREGUNTO AL EDITOR, QUE VALORES VAN A IR ACA?
		#ESO LO HAGO CON UN PANEL CON VARIOS TEXTFIELDS PARA LLENAR DATA
		#QUE LEVEL? COMO SE COMUNICA CON SUS VECINOS?
		
		set_cellv(map_coord, cell)
			