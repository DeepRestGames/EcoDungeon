class_name BaseProjectile extends CharacterBody3D


var bullet_velocity: float = 20
var time_alive: float = 1.5
var hit: bool = false

@onready var collision_shape = $CollisionShape3D
@onready var projectile_attributes_component = $Components/ProjectileAttributesComponent



func _ready():
	# Initialize relevant parameters
	time_alive = projectile_attributes_component.lifetime
	bullet_velocity = projectile_attributes_component.bullet_velocity


func _physics_process(delta: float):
	# Check if collision has been signalled and exit
	if hit:
		destroy()
		return
	time_alive -= delta
	if time_alive < 0:
		hit = true
	# TODO: direction
	var collision = move_and_collide(-delta * bullet_velocity * transform.basis.z)
	if collision:
		# Get the collider that has triggered collision and perform actions
		var collider = collision.get_collider()
		if collider and collider.has_method("take_damage"):
			# Get damage component and round if needed
			deal_damage(collider)
			# TODO: remove
			print(collider.current_hp)
		collision_shape.disabled = true
		hit = true
	
func deal_damage(collider: EnemyBase):
	var damage_value = (projectile_attributes_component.current_damage)
	if projectile_attributes_component.round_float_damage:
		damage_value = round(damage_value)
	collider.take_damage(damage_value)

func destroy():
	queue_free()
	# Can add explosions and stuff
