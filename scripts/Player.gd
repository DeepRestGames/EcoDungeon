class_name Player
extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 5.0

# --- Camera variables ---
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
# --- Animation variables ---
# Rotation
@onready var player_model = $PlayerModel
var orientation = Transform3D()
const ROTATION_INTERPOLATE_SPEED = 8
# Animate 
enum ANIMATIONS {IDLE, WALK}
@export var current_animation := ANIMATIONS.IDLE
@onready var animation_tree = $PlayerModel/AnimationTree
const MOTION_INTERPOLATE_SPEED = 10

# --- Shooting variables ---
@onready var fire_cooldown = $FireCooldown 
@onready var shoot_from = player_model.get_node("Armature/Skeleton3D/BulletOrigin")
@onready var shoot_to = player_model.get_node("Armature/Skeleton3D/BulletOrigin/BulletTo")
@onready var bullet_instance = preload("res://scenes/Projectile.tscn")
		
# ------------------------------------
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
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("spacebar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# --- Animations ---
	# Rotation
	if direction:
		var q_from = orientation.basis.get_rotation_quaternion()
		var q_to = Transform3D().looking_at(-direction, Vector3.UP).basis.get_rotation_quaternion()
		# Interpolate current rotation with desired one.
		orientation.basis = Basis(q_from.slerp(q_to, delta * ROTATION_INTERPOLATE_SPEED))
		player_model.global_transform.basis = orientation.basis
	# Animate
	if not direction:
		_animate(ANIMATIONS.IDLE, delta)
	else:
		_animate(ANIMATIONS.WALK, delta)
		
	# --- Shooting ---
	if Input.is_action_just_pressed("shoot"):
		var shoot_origin = shoot_from.global_transform.origin
		var shoot_dir = shoot_to.global_transform.origin
		# Spawn and shoot bullet
		var bullet = bullet_instance.instantiate()
		get_parent().add_child(bullet, true)
		bullet.global_transform.origin = shoot_origin
		bullet.look_at(shoot_dir, Vector3.UP)
		bullet.add_collision_exception_with(self)
		
	move_and_slide()

func _animate(anim: int, delta := 0.0):
	current_animation = anim as ANIMATIONS

	if anim == ANIMATIONS.IDLE:
		var current_blend: float = animation_tree["parameters/Idle2Walk/blend_amount"]
		if not current_blend == 0:
			var new_blend: float = max(current_blend - delta*MOTION_INTERPOLATE_SPEED, 0)
			animation_tree["parameters/Idle2Walk/blend_amount"] = new_blend
	elif anim == ANIMATIONS.WALK:

		var current_blend: float = animation_tree["parameters/Idle2Walk/blend_amount"]
		if not current_blend == 1:
			var new_blend: float = min(current_blend + delta*MOTION_INTERPOLATE_SPEED, 1)
			animation_tree["parameters/Idle2Walk/blend_amount"] = new_blend

func _shoot():
	fire_cooldown.start()
	#sound_effect_shoot.play()


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
	
	# stop scrolling
	zoom_direction *= zoom_speed_damp
	if abs(zoom_direction) <= 0.0001:
		zoom_direction = 0;
		
