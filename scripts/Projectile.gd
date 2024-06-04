extends CharacterBody3D

const BULLET_VELOCITY = 20
const BULLET_DAMAGE = 2

var time_alive = 1.5

@onready var collision_shape = $CollisionShape3D


func _physics_process(delta):
	time_alive -= delta
	if time_alive < 0:
		destroy()
	else:
		var collision = move_and_collide(-delta * BULLET_VELOCITY * transform.basis.z)
		if collision:
			# Get the collider that has triggered collision and perform actions
			var collider = collision.get_collider()
			if collider is EnemyBase:
				# Get damage component and round if needed
				deal_damage(collider)
			destroy()

func deal_damage(collider: EnemyBase):
	var damage_value = BULLET_DAMAGE
	collider.take_damage(damage_value)

func destroy():
	queue_free()
