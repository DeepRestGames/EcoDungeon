extends Area3D


var bullet_velocity: float
var current_damage: float
var lifetime_override: float
var enemy_to_follow: EnemyBase
var explosion_range: float 
var explosion_damage: float 
var piercing_amount: int
var pierced_so_far: int = 0
var enemies_pierced = []

@onready var collision_shape = $CollisionShape3D
@onready var life_time: Timer = $Lifetime


func initialize(speed, dmg, lifetime, enemy, expl_range, expl_damage, pierce):
	bullet_velocity = speed
	current_damage = dmg
	enemy_to_follow = enemy
	lifetime_override = lifetime
	explosion_range = expl_range
	explosion_damage = expl_damage
	piercing_amount = pierce
	


func _ready():
	life_time.wait_time = lifetime_override
	life_time.start()



func _physics_process(delta):
	if life_time.is_stopped():
		destroy()
	else:
		global_translate(-delta * bullet_velocity * transform.basis.z)

		var enemies_in_range: Array[Node3D] = get_overlapping_bodies()
		if len(enemies_in_range) > 0 :
			# Get the collider that has triggered collision and perform actions
			var collider = enemies_in_range.pop_front()
			if collider is EnemyBase:
				# Get damage component and round if needed
				deal_damage(collider)
			else:
				destroy()
		else:
	 		# TODO: less homing?
			if enemy_to_follow != null:
				look_at(enemy_to_follow.global_position, Vector3.UP)


func deal_damage(collider: EnemyBase):
	if collider.get_instance_id() not in enemies_pierced:
		collider.take_damage(current_damage)
		enemies_pierced += [collider.get_instance_id()]
		if piercing_amount > 0:
			pierced_so_far +=1
	if pierced_so_far > piercing_amount:
		destroy()


func destroy():
	queue_free()
