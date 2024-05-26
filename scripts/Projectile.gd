extends CharacterBody3D

const BULLET_VELOCITY = 20

var time_alive = 1.5
var hit = false

@onready var collision_shape = $CollisionShape3D




func _physics_process(delta):
	if hit:
		# TODO: re-enable once it seems ok
		queue_free()
		return
	time_alive -= delta
	if time_alive < 0:
		hit = true
	# TODO: will need collion masks and layers to determine impact
	var collision = move_and_collide(-delta * BULLET_VELOCITY * transform.basis.x)
	if collision:
		collision_shape.disabled = true
		hit = true
	print(hit)


#func explode():
	#animation_player.play("explode")

func destroy():
	queue_free()
