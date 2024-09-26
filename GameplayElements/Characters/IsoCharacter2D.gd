class_name IsoCharacter2D
extends StaticBody2D

var _velocity : Vector2 = Vector2(0.0, 0.0)
var _acceleration : Vector2 = Vector2(0.0, 0.0)
var _is_running : bool = false
@export var max_speed : float = 32.0
@export var min_speed : float = 16.0
var _current_max_speed : float = 0.0
@export var max_stamina : float = 100.0
@export var stamina : float = max_stamina

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func add_acceleration(input : Vector2) -> void:
	_acceleration += input

func _physics_process(delta: float) -> void:
	
	# Increment Velocity based on inputs.
	_velocity += _acceleration * delta
	
	var target_max_speed : float = max_speed if _is_running else min_speed
	var delta_target_speed : float = target_max_speed - _current_max_speed
	var max_target_delta = min(abs(delta_target_speed), 1.0)
	_current_max_speed += max_target_delta * sign(delta_target_speed) * delta

	_velocity.limit_length(_current_max_speed)

	#if abs(_running_modifer):
		#stamina += _velocity.length_squared() * _running_modifer

	move_and_collide(_velocity)
