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
	if (placed_hexagons.has(coord)):
		return false
	var hex_tile := HexagonTileScene.instantiate()
	hex_tile.position = HexLib.axial_to_pixel(coord)
	add_child(hex_tile)
	placed_hexagons[coord] = hex_tile

	return true

func get_or_create_hexagon(coord : Vector2i) -> PackedScene:
	""" 
	Check a tile for an existing hexagon, 
	or create a new one if none exists. 
	"""
	var hex_tile = placed_hexagons.find_key(coord)
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
	var neighbour_coords = HexLib.get_ring(coord, 1)
	var OutputHexEdgeFormat : HexEdgeFormat
	var out : HexEdgeFormat
	for i in range(6):
		var hex_tile = placed_hexagons.find_key(neighbour_coords[i])
		if hex_tile:
			out.i_set(i, hex_tile.format.i_get(i+3))
		else:
			out.i_set(i, HexEdgeFormat.HexEdge.ANY)
	return out
	
func collapse_hexagon_format(input : HexEdgeFormat) -> HexEdgeFormat:
	""" Insert spawn logic. """
	for i : int in range(6):
		if input.i_get(i) == HexEdgeFormat.HexEdge.ANY:
			input.i_set(i, HexEdgeFormat.HexEdge.CLEAR)
	return input
