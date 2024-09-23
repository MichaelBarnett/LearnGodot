extends Sprite2D

var height_speed : float = -3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset.y = -1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if offset.y < 0:
		height_speed += 10 * delta
		offset.y += height_speed
		if offset.y > 0:
			offset.y = -1
			height_speed = -2.0
