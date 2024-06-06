extends CharacterBody3D


var bullet_velocity: float
var current_damage: float
var projectile_lifetime: float
var enemy_to_follow: EnemyBase

@onready var collision_shape = $CollisionShape3D

func assign_values(speed, dmg, lifetime, enemy):
	bullet_velocity = speed
	current_damage = dmg
	projectile_lifetime = lifetime
	enemy_to_follow = enemy

func _physics_process(delta):
	projectile_lifetime -= delta
	if projectile_lifetime < 0:
		destroy()
	else:
		var collision = move_and_collide(-delta * bullet_velocity * transform.basis.z)

		if collision:
			# Get the collider that has triggered collision and perform actions
			var collider = collision.get_collider()
			if collider is EnemyBase:
				# Get damage component and round if needed
				deal_damage(collider)
			destroy()
		else:
	 		# TODO: less homing?
			if enemy_to_follow != null:
				look_at(enemy_to_follow.global_position, Vector3.UP)

func deal_damage(collider: EnemyBase):
	var damage_value = current_damage
	collider.take_damage(damage_value)

func destroy():
	queue_free()
