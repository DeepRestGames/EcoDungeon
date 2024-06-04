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
			var enemy = collision.get_collider() as EnemyBase
			if enemy:
				enemy.take_damage(BULLET_DAMAGE)
			destroy()


func destroy():
	queue_free()
