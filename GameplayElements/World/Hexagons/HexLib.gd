class_name HexLib

const CUBE_DIRECTION_VECTORS = [
	Vector3i(+1, 0, -1), Vector3i(0, +1, -1), Vector3i(-1, +1, 0), 
	Vector3i(-1, 0, 1), Vector3i(0, -1, 1), Vector3i(+1, -1, 0), 
]

const AXIAL_DIRECTION_VECTORS = [
	Vector2i(+1, 0), Vector2i(0, +1), Vector2i(-1, +1), 
	Vector2i(-1, 0), Vector2i(0, -1), Vector2i(+1, -1), 
]

const HEX_SIZE : Vector2 = Vector2(64, 64)
const HEX_OFFSETS : Vector2 = Vector2(HEX_SIZE.x, HEX_SIZE.y * 3/4)
const HEX_ASPECT_RATIO : float = 2.0 / sqrt(3)
const HEX_HALFWIDTH : float = HEX_OFFSETS.x / 2

static func axial_to_pixel(coord : Vector2) -> Vector2:
	return Vector2((coord.x * HEX_OFFSETS.x) + coord.y * HEX_HALFWIDTH, 
					coord.y * HEX_OFFSETS.y)

static func pixel_to_axial(coord : Vector2) -> Vector2:
	var r = coord.y / HEX_OFFSETS.y
	var q = (coord.x - (r * HEX_HALFWIDTH)) / HEX_OFFSETS.x
	return Vector2(q,r)
	
static func get_nearest_hexagon_axiali(coord : Vector2) -> Vector2i:
	var CubeCoords = round_axial_to_cubei(pixel_to_axial(coord))
	return cube_to_axial(CubeCoords)

static func round_cube(coord : Vector3) -> Vector3i:
	var q = round(coord.x)
	var r = round(coord.y)
	var s = round(coord.z)
	var q_diff = abs(q - coord.x)
	var r_diff = abs(r - coord.y)
	var s_diff = abs(s - coord.z)
	if q_diff > r_diff and q_diff > s_diff:
		q = -r-s
	elif r_diff > s_diff:
		r = -q-s
	else:
		s = -q-r
	return Vector3(q, r, s)
	
static func get_cubei_neighbours(coord : Vector3i) -> Array[Vector3i]:
	return [coord + CUBE_DIRECTION_VECTORS[0],
			coord + CUBE_DIRECTION_VECTORS[1],
			coord + CUBE_DIRECTION_VECTORS[2],
			coord + CUBE_DIRECTION_VECTORS[3],
			coord + CUBE_DIRECTION_VECTORS[4],
			coord + CUBE_DIRECTION_VECTORS[5]]

static func get_axiali_neighbours(coord : Vector2i) -> Array[Vector2i]:
	return [coord + AXIAL_DIRECTION_VECTORS[0],
			coord + AXIAL_DIRECTION_VECTORS[1],
			coord + AXIAL_DIRECTION_VECTORS[2],
			coord + AXIAL_DIRECTION_VECTORS[3],
			coord + AXIAL_DIRECTION_VECTORS[4],
			coord + AXIAL_DIRECTION_VECTORS[5]]
			
static func get_ring(coord : Vector2i, radius : int = 1) -> Array[Vector2i]:
	var Output : Array[Vector2i] = []
	var coord_increment : Vector2i = coord
	coord_increment += AXIAL_DIRECTION_VECTORS[4] * 4
	Output.append(coord_increment)
	for dir in AXIAL_DIRECTION_VECTORS:
		for i in range(radius):
			coord_increment += dir
			Output.append(coord_increment)

	return Output

static func round_axial_to_cubei(coord : Vector2) -> Vector3i:
	""" Returns the cubic coordinate of the nearest hexagon, given a position in 2D space. """
	var coords_cube := axial_to_cube(coord)
	return round_cube(coords_cube)

static func round_axial(coord : Vector2) -> Vector2i:
	""" Returns the cubic coordinate of the nearest hexagon, given a position in 2D space. """
	var coords_cube := axial_to_cube(coord)
	return cubei_to_axiali(round_cube(coords_cube))

static func cubei_to_axiali(Cube : Vector3i) -> Vector2i:
	return Vector2i(Cube.x,Cube.y)

static func axiali_to_cubei(Axial : Vector2i) -> Vector3i:
	return Vector3i(Axial.x, Axial.y, -Axial.x-Axial.y)

static func cube_to_axial(Cube : Vector3) -> Vector2:
	return Vector2(Cube.x,Cube.y)

static func axial_to_cube(Axial : Vector2) -> Vector3:
	return Vector3(Axial.x, Axial.y, -Axial.x-Axial.y)
