#class_name HexagonManager
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
	hex_tile.position = hex_to_pixel(coord)
	add_child(hex_tile)
	placed_hexagons[coord] = hex_tile

	return true

func get_or_create_hexagon(coord : Vector2i):
	var hex_tile = placed_hexagons.find_key(coord)
	if hex_tile:
		return hex_tile
	_create_hexagon(coord)
	pass

func hex_to_pixel(coord : Vector2) -> Vector2:
	return Vector2((coord.x * HEX_SIZE.x) + coord.y * HEX_HALFWIDTH, 
					coord.y * HEX_SIZE.y)

func pixel_to_hex(coord : Vector2) -> Vector2:
	var r = coord.y / HEX_SIZE.y
	var q = (coord.x - (r * HEX_HALFWIDTH)) / HEX_SIZE.x
	return Vector2(q,r)
	
func get_nearest_hexagon_id(coord : Vector2) -> Vector2i:
	var CubeCoords = round_axial(pixel_to_hex(coord))
	return cube_to_axial(CubeCoords)

func round_axial(coord : Vector2) -> Vector3i:
	""" Returns the cubic coordinate of the nearest hexagon, given a position in 2D space. """
	var coords_cube_f := axial_to_cube_f(coord)
	var q = round(coords_cube_f.x)
	var r = round(coords_cube_f.y)
	var s = round(coords_cube_f.z)

	var q_diff = abs(q - coords_cube_f.x)
	var r_diff = abs(r - coords_cube_f.y)
	var s_diff = abs(s - coords_cube_f.z)

	if q_diff > r_diff and q_diff > s_diff:
		q = -r-s
	elif r_diff > s_diff:
		r = -q-s
	else:
		s = -q-r

	return Vector3i(q,r,s)

func cube_to_axial(Cube : Vector3i) -> Vector2i:
	return Vector2i(Cube.x,Cube.y)

func axial_to_cube(Axial : Vector2i) -> Vector3i:
	return Vector3i(Axial.x, Axial.y, -Axial.x-Axial.y)

func cube_to_axial_f(Cube : Vector3) -> Vector2:
	return Vector2(Cube.x,Cube.y)

func axial_to_cube_f(Axial : Vector2) -> Vector3:
	return Vector3(Axial.x, Axial.y, -Axial.x-Axial.y)
