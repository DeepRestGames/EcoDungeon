extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 5.0

# Camera variables
@onready var camera = $Camera3D
@export_range(0,1000) var min_zoom: int = 5
@export_range(0,1000) var max_zoom: int = 20
@export_range(0,1000, 0.1) var zoom_speed: float = 50
@export_range(0,1000, 0.1) var zoom_speed_damp: float = 0.5
@export_range(-60, -30) var min_rotation: int = -50
@export_range(-60, -30) var max_rotation: int = -40
@export_range(0,1000, 0.1) var zoom_rotation_speed: float = 5
var current_zoom = 10
var current_rotation = -45
var zoom_direction = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _unhandled_input(event):
	if event.is_action_pressed("zoom_out"):
		zoom_direction = 1
		
	elif event.is_action_pressed("zoom_in"):
		zoom_direction = -1


func _process(delta):
	if zoom_direction != 0:
		_zoom(delta)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("spacebar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _zoom(delta: float) -> void:
	# calculate the new zoom position and clamp zoom between min and max
	var new_zoom_position_z = clamp(
		camera.position.z + zoom_speed * delta * zoom_direction,
		min_zoom,
		max_zoom
		)
	
	var new_zoom_position_y = clamp(
		camera.position.y + zoom_speed * delta * zoom_direction,
		min_zoom,
		max_zoom
		)
	
	# zoom 
	camera.position.z = new_zoom_position_z
	camera.position.y = new_zoom_position_y
	
	
	## calculate the new zoom rotation and clamp zoom between min and max
	#var new_zoom_rotation_x = clamp(
		#camera.rotation.x + zoom_rotation_speed * delta * zoom_direction,
		#min_rotation,
		#max_rotation
		#)
	#
	## zoom 
	#camera.rotation.x = new_zoom_rotation_x
	
	
	# stop scrolling
	zoom_direction *= zoom_speed_damp
	if abs(zoom_direction) <= 0.0001:
		zoom_direction = 0;
		
