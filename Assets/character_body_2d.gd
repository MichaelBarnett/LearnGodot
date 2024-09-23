extends CharacterBody2D


@export var SPEED = 10000.0
var debug_mode = false
var CurrentHexagonID := Vector2i(0,0)
const HEXAGON_Y_BIAS = 0.866

func _process(delta: float) -> void:
	CurrentHexagonID = %HexManager.get_nearest_hexagon_id(Vector2(position.x, position.y))
	%HexManager.get_or_create_hexagon(CurrentHexagonID)
	
func update_debug_text(delta : float) -> void:
	$debug_label.text = (" FPS: " +  str(Engine.get_frames_per_second()) + "/" + str(Engine.max_fps) + "\n" + 
			" ms : " + str(delta*1000.0)
	)
	
func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	var left_right_axis := Input.get_axis("MoveLeft", "MoveRight")
	var up_down_axis := Input.get_axis("MoveUp", "MoveDown")
	
	var escape := Input.is_action_just_pressed("Quit")
	if escape:
		get_tree().quit()
	
	var debug_pressed := Input.is_action_just_pressed("Debug")
	if debug_pressed:
		if debug_mode == true:
			debug_mode = false
			print("`Deactivated debug mode!")
			$debug_label.visible = false
		else:
			debug_mode = true
			print("Activated debug mode!")
			$debug_label.visible = true

	if debug_mode:
		update_debug_text(delta)

	if left_right_axis:
		velocity.x = left_right_axis * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	if up_down_axis:
		velocity.y = up_down_axis * SPEED * delta
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	velocity = velocity.limit_length(SPEED * delta)
	velocity.y = velocity.y * HEXAGON_Y_BIAS
	
	move_and_slide()
