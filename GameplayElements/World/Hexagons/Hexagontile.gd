extends Node2D

var side_key = "000000"
var solve_requested : bool = false
var is_solved : bool = false

var SolvingEffects : PackedScene = preload("res://Assets/HexagonSolveEffect.tscn")
var AnimatingEffects : PackedScene = preload("res://Assets/HexagonSummonEffect.tscn")

var current_effect
var sprite_texture : Texture2D = preload("res://Assets/cat_tails.png")
var rock_texture : Texture2D = preload("res://Assets/rocks.png")

var spawn_progress : float = 0.0
var my_material : ShaderMaterial
var noise_texture : Texture2D = preload("res://Assets/noise128.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn_x = randi_range(24,-24)
	var spawn_y = randi_range(24,-24)
	$Sprite2D.flip_h = bool(randi_range(0,1))
	$Sprite2D.position = Vector2(spawn_x, spawn_y)
	
	var shader_code = preload("res://Shaders/spawn-effect.gdshader")

	my_material = ShaderMaterial.new()
	my_material.shader = shader_code
	my_material.set_shader_parameter("noise_texture", noise_texture)
	$Sprite2D.material = my_material
	$Base.material = my_material
	$Sprite2D/Sprite2D.material = my_material
	
	for i in range(8):
		spawn_grass()
		
	if randi()%3==0:
		$Sprite2D.texture = rock_texture
		$Sprite2D.offset.y = -16
		$Sprite2D/Sprite2D.visible = false
	
func _process(delta: float) -> void:
	spawn_progress = move_toward(spawn_progress, 1.0, 0.01)
	if is_instance_valid(my_material):
		my_material.set_shader_parameter("spawn_progress", spawn_progress)
		if (spawn_progress > 0.99 and spawn_progress != 1.0):
			spawn_progress = 1.0
			$ParticleRoot.queue_free()
			$Sprite2D.material = null
			$Base.material = null
			$Sprite2D/Sprite2D.material = null
	

func spawn_grass():
	var sprite_instance := Sprite2D.new()
	sprite_instance.texture = sprite_texture
	sprite_instance.y_sort_enabled = true
	sprite_instance.z_as_relative = false
	sprite_instance.z_index = 10
	sprite_instance.position = Vector2(randi_range(-32,32),randi_range(-24,24))
	sprite_instance.offset.y = -4
	sprite_instance.material = my_material
	add_child(sprite_instance)
	
func start_solving() -> void:
	current_effect = SolvingEffects.instantiate()
	add_child(current_effect)
	$base.visible = false
	solve()
	
func spawn_tile() -> void:
	if current_effect:
		current_effect.queue_free()
	current_effect = AnimatingEffects.instantiate()
	add_child(current_effect)
	$base.visible = true

func solve() -> void:
	solve_requested = true
	pass
