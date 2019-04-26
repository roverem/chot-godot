tool
extends Node2D

const WIDTH = 500
const HEIGHT = 500

export (int) var noise_seed = 0 setget setSeed
export (int) var noise_octaves = 1 setget setOctaves
export (float) var noise_period = 1 setget setPeriod
export (float) var noise_persistence = 1 setget setPersistence
export (float) var noise_lacunarity = 1 setget setLacunarity

var open_simplex_noise = OpenSimplexNoise.new()


func setSeed(newSeed):
	if Engine.is_editor_hint():
		noise_seed = newSeed
		if (open_simplex_noise):
			 open_simplex_noise.set_seed(newSeed)
		_draw_map()

func setOctaves(newOctave):
	if Engine.is_editor_hint():
		noise_octaves = newOctave
		if (open_simplex_noise):
			open_simplex_noise.set_octaves(noise_octaves)
		_draw_map()

func setPeriod(newPeriod):
	if Engine.is_editor_hint():
		noise_period = newPeriod
		if (open_simplex_noise):
			open_simplex_noise.set_period(noise_period)
		_draw_map()
		
func setPersistence(newPersistence):
	if Engine.is_editor_hint():
		noise_persistence = newPersistence
		if (open_simplex_noise):
			open_simplex_noise.set_persistence(noise_persistence)
		_draw_map()

func setLacunarity(newLacunarity):
	if Engine.is_editor_hint():
		noise_lacunarity = newLacunarity
		if (open_simplex_noise):
			open_simplex_noise.set_lacunarity(noise_lacunarity)
		_draw_map()
		
		

func _ready():
	randomize()
	print("_READY")
	open_simplex_noise = OpenSimplexNoise.new()
	_draw_map()


func _draw_map():
	print("DRAWING MAP")
	for x in WIDTH:
		for y in HEIGHT:
			var v = Vector2(x - WIDTH / 2, y - HEIGHT / 2)
			var t = _get_tile_index(open_simplex_noise.get_noise_2d(float(x), float(y)))
			$TileMap.set_cellv(v, t)
			
	$TileMap.update_bitmask_region()

func _get_tile_index(noise_sample):
		return abs(int(noise_sample * 10) / 2)