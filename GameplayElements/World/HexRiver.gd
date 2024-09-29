class_name HexRiver2D extends Line2D

@export var ENTRY_EDGE : int = 0
@export var EXIT_EDGE : int = 1

@export var ENTRY_WIDTH : float = 24.0
@export var EXIT_WIDTH : float = 24.0

#const LineJointMode = LINE_JOINT_ROUND
const RIVER_FIDELITY := 0.2
const RIVER_IN_OUT_HANDLES := 0.25
const RIVER_SKEW_HANDLES := 0.65

func _ready() -> void:
	setup()

func setup() -> void:
	calculate_river_points()
	width_curve = Curve.new()
	width_curve.add_point(Vector2(0.0,ENTRY_WIDTH))
	width_curve.add_point(Vector2(0.5,0.75*(ENTRY_WIDTH+EXIT_WIDTH)))
	width_curve.add_point(Vector2(1.0,EXIT_WIDTH))
	width = 1.0
	texture_mode = LINE_TEXTURE_STRETCH

func calculate_river_points() -> void:
	
	var RiverCurve := Curve2D.new()
	RiverCurve.add_point(HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE], HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE]*RIVER_IN_OUT_HANDLES, HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE]*-RIVER_IN_OUT_HANDLES)
	RiverCurve.add_point(HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE]*0.8, HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE]*RIVER_IN_OUT_HANDLES, HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE]*-RIVER_IN_OUT_HANDLES)
	var skew : Vector2 = (HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE]-HexLib.HEX_EDGE_CENTRES[EXIT_EDGE])*RIVER_SKEW_HANDLES
	RiverCurve.add_point(Vector2(HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE]+HexLib.HEX_EDGE_CENTRES[EXIT_EDGE]).normalized()*HexLib.HEX_HALFWIDTH*-0.5, skew, -skew)
	RiverCurve.add_point(HexLib.HEX_EDGE_CENTRES[EXIT_EDGE]*0.8, HexLib.HEX_EDGE_CENTRES[EXIT_EDGE]*-RIVER_IN_OUT_HANDLES, HexLib.HEX_EDGE_CENTRES[EXIT_EDGE]*RIVER_IN_OUT_HANDLES)
	RiverCurve.add_point(HexLib.HEX_EDGE_CENTRES[EXIT_EDGE], HexLib.HEX_EDGE_CENTRES[EXIT_EDGE]*-RIVER_IN_OUT_HANDLES, HexLib.HEX_EDGE_CENTRES[EXIT_EDGE]*RIVER_IN_OUT_HANDLES)
	
	clear_points()
	add_point(HexLib.HEX_EDGE_CENTRES[ENTRY_EDGE])
	var f : float = 0.5 + RIVER_FIDELITY
	while(f < RiverCurve.point_count-1.5):
		add_point(RiverCurve.samplef(f))
		f+=RIVER_FIDELITY
		
	add_point(HexLib.HEX_EDGE_CENTRES[EXIT_EDGE])
