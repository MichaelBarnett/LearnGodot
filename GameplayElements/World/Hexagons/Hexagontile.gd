class_name HexagonTerrain extends Node2D

var format : HexEdgeFormat
var solve_requested : bool = false
var is_solved : bool = false

var sprite_texture : Texture2D = preload("res://Assets/cat_tails.png")
var rock_texture : Texture2D = preload("res://Assets/rocks.png")

@onready var timer := Timer.new()

func get_random_position() -> Vector2:
	var max_width = 0.5*HexLib.HEX_OFFSETS.x-4
	var max_height = 0.5*HexLib.HEX_OFFSETS.y-4
	return Vector2(
		randi_range(-max_width,max_width),
		randi_range(-max_height,max_height)
		)

func _ready() -> void:

	$Sprite2D.flip_h = bool(randi_range(0,1))
	$Sprite2D.position = get_random_position()
	
	#add_child(timer)
	#timer.wait_time = randf_range(5.0,15.0)
	#timer.one_shot = true
	#timer.connect("timeout",despawn)
	#timer.start()
	
	start_solving()
	
func despawn():
	var new_effect := SpawnHexagonEffectManager.new()
	new_effect.REVERSE = true
	add_child(new_effect)
	
func spawn_grass():
	var sprite_instance := Sprite2D.new()
	sprite_instance.texture = sprite_texture
	sprite_instance.y_sort_enabled = true
	sprite_instance.z_as_relative = false
	sprite_instance.z_index = 10
	sprite_instance.position = get_random_position()
	sprite_instance.offset.y = -4
	add_child(sprite_instance)
	
func start_solving() -> void:
	#$base.visible = false
	solve()
	
func spawn_tile() -> void:
	#$base.visible = true
	add_child(SpawnHexagonEffectManager.new())

func solve() -> void:

	print("Solving format: ", format.get_edges())
	
	$DebugTexts/Right.text = str(format.Right)
	$DebugTexts/RightDown.text = str(format.RightDown)
	$DebugTexts/LeftDown.text = str(format.LeftDown)
	$DebugTexts/Left.text = str(format.Left)
	$DebugTexts/LeftUp.text = str(format.LeftUp)
	$DebugTexts/RightUp.text = str(format.RightUp)
	$DebugTexts/Coords.text = str(HexLib.pixel_to_axial(position))
	
	solve_requested = true
	
	var has_river : bool = false
	var river_start : int = 0
	var river_end : int = 0
	
	for i in range(6):
		if format.i_get(i) == HexEdgeFormat.HexEdge.WATER_IN:
			has_river = true
			river_start = i
		if format.i_get(i) == HexEdgeFormat.HexEdge.WATER_OUT:
			has_river = true
			river_end = i
	
	if has_river:
		print("This format has a river, from ", river_start, " to ", river_end)
		var my_river := HexRiver2D.new()
		add_child(my_river)
		my_river.ENTRY_EDGE = river_start
		my_river.EXIT_EDGE = river_end
		my_river.z_index = 5
		my_river.setup()
		
		$Sprite2D.texture = rock_texture
		$Sprite2D.offset.y = -16
		$Sprite2D/Sprite2D.visible = false
		
	if not has_river:
		for i in range(64):
			spawn_grass()

	spawn_tile()
