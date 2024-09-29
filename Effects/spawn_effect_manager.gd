class_name SpawnHexagonEffectManager extends Node2D

var spawn_progress : float = 0.0
var spawn_material : ShaderMaterial
var noise_texture : Texture2D = preload("res://Assets/noise128.png")
var shader_code = preload("res://Shaders/spawn-effect.gdshader")

var visual_children : Array[Node2D] = []
var visual_children_materials : Array[ShaderMaterial] = []
var visual_children_materials_original : Array[Material] = []
var visual_children_spawn_progress : Array[float] = []

var total_time_to_spawn : float = 1000
var SPAWN_SPEED : float = 1.0
var SPAWN_STAGGER : float = 0.5
var removal : bool = true

func _ready() -> void:
	call_deferred("setup")

func setup() -> void:
	gather_visual_children()
	setup_visual_children()

func spawn_sort(a : Node2D, b : Node2D):
	if (a.z_index == b.z_index):
		return (a.position.y < b.position.y)
	return (a.z_index < b.z_index)

func gather_visual_children() -> void:
	var parent := get_parent()
	visual_children.clear()
	if is_instance_valid(parent):
		visual_children.append_array(recursively_append_children(parent))
	visual_children.sort_custom(spawn_sort)
	#print("Found ", str(visual_children.size()), " children! ")

func recursively_append_children(input_node : Node) -> Array[Node2D]:
	var output_array : Array[Node2D] = []
	if is_instance_valid(input_node):
		if (
			input_node.is_class("Sprite2D") or 
			input_node.is_class("AnimatedSprite2D") or 
			input_node.is_class("Line2D")
			) :
			output_array.append(input_node)
		for child in input_node.get_children():
			output_array.append_array(recursively_append_children(child))
	return output_array

func setup_visual_children() -> void:
	total_time_to_spawn = 1.0 + ((visual_children.size() + 1) * SPAWN_STAGGER)
	visual_children_materials.clear()
	visual_children_spawn_progress.clear()
	for i in range(visual_children.size()):
		var my_material = ShaderMaterial.new()
		my_material.shader = shader_code
		my_material.set_shader_parameter("noise_texture", noise_texture)
		var spawn_position : float = float(i+1) / float(visual_children.size())
		visual_children_spawn_progress.append(
			-1 * ((total_time_to_spawn - 1) * spawn_position) * SPAWN_STAGGER * randf_range(-SPAWN_STAGGER, SPAWN_STAGGER)
			)
		visual_children_materials.append(my_material)
		visual_children_materials_original.append(visual_children[i].material)
		visual_children[i].material = my_material
		visual_children[i].visible = true
	pass

func _process(delta: float) -> void:
	process_visual_children(delta)
	total_time_to_spawn -= delta * SPAWN_SPEED
	if total_time_to_spawn <= 0.0:
		release_visual_children()

func process_visual_children(delta : float) -> void:
	for i in range(visual_children.size()):
		visual_children_spawn_progress[i] += delta * SPAWN_SPEED
		var spawn_progress : float = clampf(visual_children_spawn_progress[i], 0.0, 1.0)
		visual_children[i].material.set_shader_parameter("spawn_progress", spawn_progress)

func release_visual_children() -> void:
	for i in range(visual_children.size()):
		visual_children[i].material = visual_children_materials_original[i]
	queue_free()
	
