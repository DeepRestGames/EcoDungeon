extends CharacterBody3D


var bullet_velocity: float
var current_damage: float
var projectile_lifetime: float

@onready var collision_shape = $CollisionShape3D

func assign_values(speed, dmg, lifetime):
	bullet_velocity = speed
	current_damage = dmg
	projectile_lifetime = lifetime

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

func deal_damage(collider: EnemyBase):
	var damage_value = current_damage
	collider.take_damage(damage_value)

func destroy():
	queue_free()
