extends SubViewportContainer

@onready var my_player = $SubViewport/WorldBase/PlayerCharacter
@onready var my_camera = $SubViewport/WorldBase/Camera2D
@onready var subview = $SubViewport
@onready var resolution = $"../Label"
@export var CAMERA_SPEED : float = 10.0
@export var CAMERA_AHEAD_SCALE : float = 0.25

const SCALE : int = 3
const DESIRED_VERTICAL_PIXEL_RESOLUTION : int = 1080 / SCALE
var  OUTCOME_HORIZONTAL_PIXEL_RESOLUTION : int = 1920 / SCALE
var screen_ratio : float = float(OUTCOME_HORIZONTAL_PIXEL_RESOLUTION) / float(DESIRED_VERTICAL_PIXEL_RESOLUTION)
var _debug_text : String = ""
var offset : Vector2 = Vector2(0.0,0.0)
var current_camera_position : Vector2 = Vector2(0.0,0.0)
var debug_mode = false

func _ready() -> void:
	update_screen()

func update_screen() -> void:
	stretch = false
	var window_size = get_viewport_rect().size
	screen_ratio = window_size.x / window_size.y
	OUTCOME_HORIZONTAL_PIXEL_RESOLUTION = int(screen_ratio * DESIRED_VERTICAL_PIXEL_RESOLUTION)
	size.x = OUTCOME_HORIZONTAL_PIXEL_RESOLUTION + 2
	size.y = DESIRED_VERTICAL_PIXEL_RESOLUTION + 2
	subview.size.x = OUTCOME_HORIZONTAL_PIXEL_RESOLUTION + 2
	subview.size.y = DESIRED_VERTICAL_PIXEL_RESOLUTION + 2
	position.x = -SCALE
	position.y = -SCALE
	scale.x = SCALE
	scale.y = SCALE
	_debug_text = str(window_size) + " " + str(Vector2(OUTCOME_HORIZONTAL_PIXEL_RESOLUTION, DESIRED_VERTICAL_PIXEL_RESOLUTION)) + " " + str(screen_ratio)

func _process(delta : float) -> void:
	my_camera.global_position = lerp(my_camera.global_position, my_player.global_position+my_player.velocity*CAMERA_AHEAD_SCALE, delta*CAMERA_SPEED)
	var actual_camera_position : Vector2 = my_camera.global_position
	var stabilisation_offset : Vector2 = Vector2(
		actual_camera_position.round().x - actual_camera_position.x, 
		actual_camera_position.round().y - actual_camera_position.y
		)
	material.set_shader_parameter("camera_offset", stabilisation_offset)
	resolution.text = _debug_text + " - CAMOFFSET: " + str(offset) + " Player: " + str(my_camera.global_position)

	var debug_pressed := Input.is_action_just_pressed("Debug")
	if debug_pressed:
		if debug_mode == true:
			debug_mode = false
			print("`Deactivated debug mode!")
			resolution.visible = false
		else:
			debug_mode = true
			print("Activated debug mode!")
			resolution.visible = true

	if debug_mode:
		update_debug_text(delta)

func update_debug_text(delta : float) -> void:
	resolution.text = " FPS: " + str(Engine.get_frames_per_second()) + "\n" + " ms : " + str(delta*1000.0) + "\n" + " Player xy : " + str(my_player.position)

func _on_resized() -> void:
	update_screen()
