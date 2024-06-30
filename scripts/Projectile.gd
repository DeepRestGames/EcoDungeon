extends Area3D


var bullet_velocity: float
var current_damage: float
var lifetime_override: float
var enemy_to_follow: EnemyBase
# Explosion
var explosion_area: float 
var explosion_damage_percentage: float 
# Pierce
var piercing_amount: int
var pierced_so_far: int = 0
var enemies_pierced = []
# DOT
var dot_damage: float
var dot_duration: float = 5.0
var dot_tick_frequency: float = 1.0

@onready var collision_shape = $CollisionShape3D
@onready var life_time: Timer = $Lifetime
@onready var explosion_radius = $ExplosionRadius
@onready var explosion_collider = $ExplosionRadius/ExplosionCollider
@onready var explosion_range_debug = $ExplosionRadius/ExplosionRangeDEBUG


func initialize(speed, dmg, lifetime, enemy, expl_range, expl_damage, pierce, dot_dmg, dot_dur, dot_fr):
	bullet_velocity = speed
	current_damage = dmg
	enemy_to_follow = enemy
	lifetime_override = lifetime
	explosion_area = expl_range
	explosion_damage_percentage = expl_damage
	piercing_amount = pierce
	dot_damage = dot_dmg
	# Only replace if specified
	dot_duration = dot_dur if dot_dur > 0 else dot_duration
	dot_tick_frequency = dot_fr if dot_fr > 0 else dot_tick_frequency
	


func _ready():
	life_time.wait_time = lifetime_override
	life_time.start()
	explosion_collider.shape.radius = explosion_area
	# DEBUG: view explosion area
	#explosion_range_debug.mesh.top_radius = explosion_area + 0.01
	#explosion_range_debug.mesh._radius = explosion_area + 0.01



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
		if explosion_area > 0:
			# Pass the collider if you want to skip him taking damage
			explode() # collider)
		collider.take_damage(current_damage, collider.NORMAL_DMG_COLOR)
		if dot_damage > 0:
			collider.gain_dot(dot_damage, dot_duration, dot_tick_frequency)
		enemies_pierced += [collider.get_instance_id()]
		if piercing_amount > 0:
			pierced_so_far +=1
	if pierced_so_far > piercing_amount or piercing_amount == 0:
		destroy()

# Uncomment if you want hit enemy to not take damage
func explode(): # enemy_hit):
	var enemies_in_explosion_range: Array = explosion_radius.get_overlapping_bodies()#
	# These should all be enemies because of mask
	for enemy in enemies_in_explosion_range:
		# Uncomment if you don't want target to take explosion damage
		#if enemy_hit.get_instance_id() == enemy.get_instance_id():
			#continue
		enemy.take_damage((explosion_damage_percentage/100) * current_damage, enemy.EXPLOSION_DMG_COLOR)

func destroy():
	queue_free()
