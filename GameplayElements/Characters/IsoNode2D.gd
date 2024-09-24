class_name IsoNode2D
extends Node2D

var height : float = 0
var height_velocity : float = 0
@export var gravity : Vector2 = Vector2(748 * 0.8, 758 * 1.2) # Realistic gravity at 8 pixels / metre.
@export var can_bounce : bool = false
@export var bounce_dampen : float = 0.5
@export var elastic : bool = false
@export var elastic_height : float = 32

var elastic_strength : float = 0

func _ready() -> void:
	elastic_strength = calculate_jump_velocity_for_height(elastic_height)
	# Just override these, as this is what they always need to be.
	y_sort_enabled = false
	z_as_relative = true

func calculate_jump_velocity_for_height(height : float):
	return sqrt( 2 * abs(gravity[0]) * height)

func jump(jump_velocity : float) -> void:
	if height == 0:
		height_velocity = -abs(jump_velocity)

func _physics_process(delta: float) -> void:
	# Process the 
	if height < 0 or not height_velocity == 0:
		var grav_id : int = int(height_velocity > 0)
		height_velocity += gravity[grav_id] * delta
		height += height_velocity * delta
			
		# Check we don't go through the floor, and stop bouncing.
		if height > 0:
			height = -0
			if elastic:
				jump(elastic_strength)
			elif can_bounce:
				height_velocity *= -bounce_dampen
			else:
				height_velocity = 0

		# Apply offset to self.
		position.y = height
		z_index = -height
