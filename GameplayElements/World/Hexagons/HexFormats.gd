
class_name HexEdgeFormat
extends Resource

@export var Right : HexEdge
@export var RightDown : HexEdge
@export var LeftDown : HexEdge
@export var Left : HexEdge
@export var LeftUp : HexEdge
@export var RightUp : HexEdge

enum HexEdge {
	ANY,
	CLEAR,
	WATER_IN,
	WATER_OUT,
	CLIFF_UP,
	CLIFF_DOWN,
	ERROR
}

func CompareEdges(a: HexEdge, b: HexEdge) -> bool:
	if a == HexEdge.ANY or b == HexEdge.ANY:
		return true
	else:
		return (a == b)

func CompareHexEdges(a : HexEdgeFormat, b : HexEdgeFormat) -> bool:
	return (
		CompareEdges(a.Right,b.Right) and 
		CompareEdges(a.RightDown,b.RightDown) and 
		CompareEdges(a.LeftDown,b.LeftDown) and 
		CompareEdges(a.Left,b.Left) and 
		CompareEdges(a.LeftUp,b.LeftUp) and 
		CompareEdges(a.RightUp,b.RightUp) 
	)

func validate() -> bool:
	var needs_water_in : bool = false
	var has_water_in : bool = false
	var needs_water_out : bool = false
	var has_water_out : bool = false
	
	for edge in get_edges():
		if (edge == HexEdge.WATER_IN):
			has_water_in = true
			needs_water_out = true
		if (edge == HexEdge.WATER_OUT):
			has_water_out = true
			needs_water_in = true
	
	var failure_flag : bool = false
	if needs_water_in and not has_water_in:
		failure_flag = true
	if needs_water_out and not has_water_in:
		failure_flag = true
		
	return failure_flag

func get_edges() -> Array[HexEdge]:
	return [Right, RightDown, LeftDown, Left, LeftUp, RightUp]

func i_get(i: int) -> HexEdge:
	var i_rounded := i%6
	match i_rounded:
		0:
			return Right
		1:
			return RightDown
		2:
			return LeftDown
		3:
			return Left
		4:
			return LeftUp
		5:
			return RightUp
	return HexEdge.ERROR

func i_set(i: int, input : HexEdge):
	var i_rounded := i%6
	match i_rounded:
		0:
			Right = input
		1:
			RightDown = input
		2:
			LeftDown = input
		3:
			Left = input
		4:
			LeftUp = input
		5:
			RightUp = input
