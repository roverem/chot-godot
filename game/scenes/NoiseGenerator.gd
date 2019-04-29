tool
extends TileMap

export (int) var WIDTH = 126 setget setDimension_x
export (int) var HEIGHT = 74 setget setDimension_y

export (int, 256) var noise_seed = 0 setget setSeed
export (int, 6) var noise_octaves = 4 setget setOctaves
export (float, 256) var noise_period = 35 setget setPeriod
export (float, 1) var noise_persistence = 20 setget setPersistence
export (float, 4) var noise_lacunarity = 1 setget setLacunarity


#Se puede agregar regiones al tileset 
#para que autocomplete regiones 
#(patches de tierra o agua).

#Buscar si se puede implementar
#que use ese autocomplete con procedural.


#Basicamente esto, que por lo que veo desaparecio en el editor 3.1?
#https://www.youtube.com/watch?v=F6VerW98gEc&t=317s

var open_simplex_noise = OpenSimplexNoise.new()

func setDimension_x(newValue):
	if Engine.is_editor_hint():
		WIDTH = newValue
		_draw_map()
		
func setDimension_y(newValue):
	if Engine.is_editor_hint():
		HEIGHT = newValue
		_draw_map()

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
	print()
	open_simplex_noise = OpenSimplexNoise.new()
	_draw_map()


func _draw_map():
	print("CLEARING MAP")
	clear()
	print("DRAWING MAP")
	for x in WIDTH:
		for y in HEIGHT:
			var v = Vector2(x, y)
			var t = _get_tile_index(open_simplex_noise.get_noise_2d(float(x), float(y)))
			set_cellv(v, t)
	
	noise_seed = open_simplex_noise.seed
	noise_octaves = open_simplex_noise.octaves
	noise_period = open_simplex_noise.period
	noise_persistence = open_simplex_noise.persistence
	noise_lacunarity = open_simplex_noise.lacunarity
	
	update_bitmask_region()

func _get_tile_index(noise_sample):
		return abs(int(noise_sample * 10) / 2)