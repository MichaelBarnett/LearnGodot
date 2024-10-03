class_name HexagonManager
extends Node2D

const cube_direction_vectors = [
	Vector3i(+1, 0, -1), Vector3i(0, +1, -1), Vector3i(-1, +1, 0), 
	Vector3i(-1, 0, 1), Vector3i(0, -1, 1), Vector3i(+1, -1, 0), 
]

const axial_direction_vectors = [
	Vector2i(+1, 0), Vector2i(0, +1), Vector2i(-1, +1), 
	Vector2i(-1, 0), Vector2i(0, -1), Vector2i(+1, -1), 
]

const HEX_SIZE : Vector2 = Vector2(64, 48)
const HEX_ASPECT_RATIO : float = HEX_SIZE.y / HEX_SIZE.x
const HEX_HALFWIDTH : float = HEX_SIZE.x / 2

# Preload the HexagonTile scene
var HexagonTileScene = preload("res://GameplayElements/World/Hexagons/HexagonTile.tscn")

var placed_hexagons : Dictionary = {}
var stored_hexagons : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _create_hexagon(coord : Vector2i) -> bool:
	#TODO: Update so that a scene isn't used, and HexTiles / aka terrains are chill.
	if (placed_hexagons.has(str(coord))):
		return false
	var hex_tile := HexagonTileScene.instantiate()
	hex_tile.position = HexLib.axial_to_pixel(coord)
	var format := get_required_hexagon_format(coord)
	collapse_hexagon_format(format)
	hex_tile.format = format
	add_child(hex_tile)
	placed_hexagons[str(coord)] = hex_tile
	
	var check = placed_hexagons.get(str(Vector2(coord.x, coord.y)))
	if check != hex_tile:
		print("Boooooooo")
	return true

func get_or_create_hexagon(coord : Vector2i):
	""" 
	Check a tile for an existing hexagon, 
	or create a new one if none exists. 
	"""
	var hex_tile = placed_hexagons.get(str(coord))
	if hex_tile:
		return hex_tile
	_create_hexagon(coord)
	return null
	
func wake_hexagon(coord : Vector2i) -> void:
	""" 
	Awaken a target hexagon, it will solve its 
	generation in a background process. 
	"""
	pass
	
func reveal_hexagon(coord : Vector2i) -> void:
	""" 
	Reveal the target hexagon, and play its spawn animation. 
	"""
	pass

func store_hexagon(coord : Vector2i) -> void:
	pass

func get_nearest_hexagon_id(coord : Vector2) -> Vector2i:
	return HexLib.round_axial(HexLib.pixel_to_axial(coord))
	
func get_required_hexagon_format(coord : Vector2i) -> HexEdgeFormat:
	var neighbour_coords = HexLib.get_axiali_neighbours(coord)
	var out : HexEdgeFormat = HexEdgeFormat.new()
	for i in range(6):
		#print("Checking Neighbour ", neighbour_coords[i])
		var hex_tile = placed_hexagons.get(str(neighbour_coords[i]))
		print(hex_tile)
		out.i_set(i, HexEdgeFormat.HexEdge.ANY)
		if is_instance_valid(hex_tile):
			#print("Neighbour ", neighbour_coords[i], " has the format: " , hex_tile.format.get_edges())
			out.i_set(i, hex_tile.format.i_get(i+3))
			#print("TILE LOGIC: Adjacent is ", hex_tile.format.i_get(i+3), " so I am that too! " )
			
		# We need to flip the direction of the water.
		if out.i_get(i) == HexEdgeFormat.HexEdge.WATER_IN:
			out.i_set(i, HexEdgeFormat.HexEdge.WATER_OUT)
			continue
		if out.i_get(i) == HexEdgeFormat.HexEdge.WATER_OUT:
			out.i_set(i, HexEdgeFormat.HexEdge.WATER_IN)
			continue
	
	return out
	
func collapse_hexagon_format(input : HexEdgeFormat):
	""" Insert spawn logic. """
	
	var unassigned : Array[int] = []
	var add_water : int = 0
	
	for i : int in range(6):
		if input.i_get(i) == HexEdgeFormat.HexEdge.ANY:
			unassigned.append(i)
		if input.i_get(i) == HexEdgeFormat.HexEdge.WATER_IN:
			add_water+=1
		if input.i_get(i) == HexEdgeFormat.HexEdge.WATER_OUT:
			add_water-=1
			#input.i_set(i, HexEdgeFormat.HexEdge.CLEAR)
	
	if unassigned.size() >= 2 and add_water == 0:
		# We could add a river! Maybe do that.
		if randi()%20 == 0:
			print("Generating river!: ", unassigned.size())
			var river_begin : int = randi_range(0,unassigned.size()-1)
			input.i_set(unassigned[river_begin], HexEdgeFormat.HexEdge.WATER_IN)
			print("River Starts at ", unassigned[river_begin], "(Edges: ", unassigned.size(), ")")
			unassigned.remove_at(river_begin)
			print("Remaining Edges = ", unassigned.size())
			var river_end : int = randi_range(0,unassigned.size()-1)
			input.i_set(unassigned[river_end], HexEdgeFormat.HexEdge.WATER_OUT)
			print("River Ends at ", unassigned[river_end], "(Edges: ", unassigned.size(), ")")
			unassigned.remove_at(river_end)
			print("Remaining Edges = ", unassigned.size())

	if add_water > 0 and unassigned.size() > 0:
		var river_end : int = randi_range(0,unassigned.size()-1)
		input.i_set(unassigned[river_end], HexEdgeFormat.HexEdge.WATER_OUT)
		print("Add River Finish at ", unassigned[river_end], "(Edges: ", unassigned.size(), ")")
		unassigned.remove_at(river_end)
		add_water -= 1
		
	if add_water < 0 and unassigned.size() > 0:
		var river_begin : int = randi_range(0,unassigned.size()-1)
		input.i_set(unassigned[river_begin], HexEdgeFormat.HexEdge.WATER_IN)
		print("Add River Start at ", unassigned[river_begin], "(Edges: ", unassigned.size(), ")")
		unassigned.remove_at(river_begin)
		add_water += 1
		
	# Add some cliffs, rarely?
	
	for i : int in unassigned:
		if randi()%10 == 0:
			input.i_set(i, HexEdgeFormat.HexEdge.CLIFF_UP if randi()%2 == 0 else HexEdgeFormat.HexEdge.CLIFF_DOWN)
			continue
		input.i_set(i, HexEdgeFormat.HexEdge.CLEAR)
		
	print("Created format: ", input.get_edges())
