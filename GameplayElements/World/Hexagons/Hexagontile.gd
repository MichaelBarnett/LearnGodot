extends Node2D

var format : HexEdgeFormat
var solve_requested : bool = false
var is_solved : bool = false

var sprite_texture : Texture2D = preload("res://Assets/cat_tails.png")
var rock_texture : Texture2D = preload("res://Assets/rocks.png")

func get_random_position() -> Vector2:
	var max_width = 0.5*HexLib.HEX_OFFSETS.x-16
	var max_height = 0.5*HexLib.HEX_OFFSETS.y-8
	return Vector2(
		randi_range(-max_width,max_width),
		randi_range(-max_height,max_height)
		)

func _ready() -> void:

	$Sprite2D.flip_h = bool(randi_range(0,1))
	$Sprite2D.position = get_random_position()
	
	for i in range(64):
		spawn_grass()
		
	if randi()%3==0:
		$Sprite2D.texture = rock_texture
		$Sprite2D.offset.y = -16
		$Sprite2D/Sprite2D.visible = false
		
	$HexRiver2D.ENTRY_EDGE = randi_range(0,5)
	$HexRiver2D.EXIT_EDGE = ($HexRiver2D.ENTRY_EDGE + randi_range(1,5))%6
	$HexRiver2D.setup()
	
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
	$base.visible = false
	solve()
	
func spawn_tile() -> void:
	$base.visible = true

func solve() -> void:
	solve_requested = true
	pass
