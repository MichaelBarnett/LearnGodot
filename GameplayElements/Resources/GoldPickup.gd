extends Sprite2D

var height : float = 12.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var jump_strength : float = get_parent().calculate_jump_velocity_for_height(height)
	get_parent().jump(jump_strength)
