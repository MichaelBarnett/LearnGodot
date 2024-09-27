extends Node2D

var side_key = "000000"
var solve_requested : bool = false
var is_solved : bool = false

var SolvingEffects : PackedScene = preload("res://Assets/HexagonSolveEffect.tscn")
var AnimatingEffects : PackedScene = preload("res://Assets/HexagonSummonEffect.tscn")

var current_effect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn_x = randi_range(24,-24)
	var spawn_y = randi_range(24,-24)
	$Sprite2D.flip_h = bool(randi_range(0,1))
	$Sprite2D.position = Vector2(spawn_x, spawn_y)
	pass # Replace with function body.
	
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
