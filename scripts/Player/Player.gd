class_name Player
extends CharacterBody3D

# ------------------------------------------
# ------------ Camera variables ------------
# ------------------------------------------
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

# -------------------------------------------
# ---------------- ANIMATION ----------------
# -------------------------------------------
@onready var player_model = $PlayerModel
# Rotation and interpolation for facing
var orientation = Transform3D()
const ROTATION_INTERPOLATE_SPEED = 8
# Animation for various states
enum ANIMATIONS {IDLE, WALK}
@export var current_animation := ANIMATIONS.IDLE
@onready var animation_tree = $PlayerModel/AnimationTree
const MOTION_INTERPOLATE_SPEED = 10

# --------------------------------------------
# ---------------- STATISTICS ----------------
# --------------------------------------------
# Damage number variables
@onready var damage_number_3d_template = preload("res://scenes/weapons/DamageNumber3D.tscn")
@export var dmg_label_height: float = 10
@export var dmg_label_spread: float = 10
# Health variables
@export var max_hp: int = 5
var current_hp: int = max_hp:
	set(value):
		current_hp = clamp(value, 0, max_hp)

# --- Experience / level up ---
@onready var player_experience = $PlayerExperience

# Invincibility frames variables
@onready var invincibility_frames_timer = $InvincibilityFramesTimer

# ---------------------------------------------
# ---------------- ENVIRONMENT ----------------
# ---------------------------------------------
var SPEED: float = 10.0
const JUMP_VELOCITY: float = 5.0 # TODO: should probably remove jump
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var bullet_origin = $BulletOrigin

# ****************************************************************************
# ****************************************************************************
# ****************************************************************************

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

func take_damage(damage: int):
	# Prevent damage if a hit was just taken
	if invincibility_frames_timer.is_stopped():
		show_damage(damage)
		current_hp -= damage
		invincibility_frames_timer.start()
	if current_hp <= 0:
		death()

func show_damage(damage: float):
	# TODO/NOTE: this is identical in enemy_base
	var damage_floating_label = damage_number_3d_template.instantiate()
	var pos = global_position
	var level_root =  get_tree().get_root()
	level_root.add_child(damage_floating_label, true)
	damage_floating_label.set_values_and_animate(str(damage), pos, dmg_label_height, dmg_label_spread, Color(255,0,0,255))


func death():
	queue_free()
