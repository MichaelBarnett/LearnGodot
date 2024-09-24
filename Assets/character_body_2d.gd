extends CharacterBody2D

@export var SPEED = 64.0
@export var JUMP_HEIGHT = 32.0
var JUMP_STRENGTH = 0
var debug_mode = false
var CurrentHexagonID := Vector2i(0,0)
const HEXAGON_Y_BIAS = 0.866

func _ready() -> void:
	# Calculate the jump strength (V) = V^2 = 0 + -2 * a * d
	JUMP_STRENGTH = $IsoNode2D.calculate_jump_velocity_for_height(JUMP_HEIGHT)

func _process(delta: float) -> void:
	if  %HexManager:
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
		
	var interact := Input.is_action_just_pressed("Interact")
	if interact:
		$IsoNode2D.jump(JUMP_STRENGTH)
	
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
		velocity.x = left_right_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if up_down_axis:
		velocity.y = up_down_axis * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	velocity = velocity.limit_length(SPEED)
	velocity.y = velocity.y * HEXAGON_Y_BIAS
	
	move_and_slide()
