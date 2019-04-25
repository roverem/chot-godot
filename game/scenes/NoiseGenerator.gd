extends Node2D

const WIDTH = 500
const HEIGHT = 500

export (OpenSimplexNoise) var open_simplex_noise

func _ready():
	randomize()
	
	for x in WIDTH:
		for y in HEIGHT:
			var v = Vector2(x - WIDTH / 2, y - HEIGHT / 2)
			var t = _get_tile_index(open_simplex_noise.get_noise_2d(float(x), float(y)))
			$TileMap.set_cellv(v, t)
			
	$TileMap.update_bitmask_region()
	
	
	
func _get_tile_index(noise_sample):
		return abs(int(noise_sample * 10) / 2)