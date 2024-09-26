extends CharacterBody2D

@export var SPEED = 96.0
@export var JUMP_HEIGHT = 12.0
var JUMP_STRENGTH : float = 0
var debug_mode = false
var CurrentHexagonID := Vector2i(0,0)
const HEXAGON_Y_BIAS = 0.866

@onready var jump_component = $YRoot/Jumper

func _ready() -> void:
	# Calculate the jump strength (V) = V^2 = 0 + -2 * a * d
	JUMP_STRENGTH = jump_component.calculate_jump_velocity_for_height(JUMP_HEIGHT)

func _process(delta: float) -> void:
	if  %HexManager:
		CurrentHexagonID = %HexManager.get_nearest_hexagon_id(Vector2(position.x, position.y))
		var close_ring
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
		jump_component.jump(JUMP_STRENGTH)
	
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
		if left_right_axis > 0:
			$YRoot/Jumper/AnimatedSprite2D.flip_h = false
		if left_right_axis < 0:
			$YRoot/Jumper/AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if up_down_axis:
		velocity.y = up_down_axis * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	velocity = velocity.limit_length(SPEED)
	velocity.y = velocity.y * HexLib.HEX_ASPECT_RATIO
	
	move_and_slide()
