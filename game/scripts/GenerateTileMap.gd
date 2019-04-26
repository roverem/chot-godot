tool
extends EditorScript

var tilemap
var tileset

func _run():
	tilemap = TileMap.new()
	tileset = TileSet.new()
	for i in range(5):
		tileset.create_tile(i)
		var n = str(i)
		var file_name = "res://assets/tile noise/" + n + ".png"
		tileset.tile_set_texture( i, load(file_name))
	
	tilemap.tile_set = tileset
	tilemap.name = "TileMap"
	
	tilemap.connect("ready", self, "_on_noise_ready")
	tilemap.set_script(preload("res://scenes/NoiseGenerator.gd"))
	
	tilemap.cell_size = Vector2(8, 8)
	
	get_scene().add_child(tilemap)
	tilemap.set_owner(get_scene())
	
	var sprite = Sprite.new()
	sprite.texture = preload("res://icon.png")
	sprite.name = "icon"
	get_scene().add_child(sprite)
	sprite.set_owner(get_scene())

func _on_noise_ready():
	pass