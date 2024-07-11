extends Control

enum state { MAIN_MENU, IN_GAME, PLAYER_PAUSE, POWERUP_PAUSE }
var current_state = state.IN_GAME
@onready var pause_menu = $PauseMenu
@onready var power_ups = $PauseMenu/PowerUps

@onready var base_weapon = $"../BaseWeapon"
@onready var player = $".."
@onready var pickup_area_collider = $"../PlayerExperience/PickupArea/PickupAreaCollider"


func _on_weapon_powerup_system_powered_up(weapon):
	# REFRESH
	
	var description: String = ""
	description += "MAX HP: " + str(player.max_hp) + "\n"
	description += "HP REGEN: " + str(player.hp_regen) + "\n"
	description += "MOVE SPEED: " + str(player.move_speed) + "\n"
	description += "PICKUP AREA: " + str(pickup_area_collider.shape.radius) + "\n\n"
	
	description += "PROJ LIFETIME: " + str(weapon.projectile_lifetime) + "\n"
	description += "PROJ SPD: " + str(weapon.projectile_velocity) + "\n"
	description += "RANGE: " + str(weapon.weapon_range) + "\n"
	description += "PROJ NUMBER: " + str(weapon.current_projectiles_number) + "\n"
	description += "HOMING: " + str(weapon.homing_projectiles) + "\n"
	description += "PIERCE: " + str(weapon.projectile_lifetime) + "\n\n"
	
	description += "DMG: " + str(weapon.current_damage) + "\n"
	description += "ATK SPD: " + str(weapon.fire_cooldown)  + "\n"
	description += "CRIT CHANCE: " + str(weapon.crit_chance) + "\n"
	description += "CRIT DMG: " + str(weapon.crit_damage) + "\n\n"

	description += "EXPL RAD: " + str(weapon.explosion_range) + "\n"
	description += "EXPL DMG: " + str(weapon.explosion_damage) + "\n\n"

	description += "DOT DMG: " + str(weapon.dot_dmg) + "\n"
	description += "DOT DUR: " + str(weapon.dot_duration) + "\n"
	description += "DOT FREQ: " + str(weapon.dot_frequency)
	
	power_ups.text = description



func _ready():
	pause_menu.hide()
	_on_weapon_powerup_system_powered_up(base_weapon)

func _process(_delta):
	 	# Handle pause.
	if Input.is_action_just_pressed("pause"):
		if current_state == state.IN_GAME:
			get_tree().paused = true
			current_state = state.PLAYER_PAUSE
			pause_menu.show()
		elif current_state == state.PLAYER_PAUSE:
			get_tree().paused = false
			current_state = state.IN_GAME
			pause_menu.hide()


func _on_power_up_menu_is_in_powerup_state(flag):
	# Change states when in powerup
	if flag:
		current_state = state.POWERUP_PAUSE
	else:
		current_state = state.IN_GAME


func _on_pause_menu_unpause():
	get_tree().paused = false
	current_state = state.IN_GAME
	pause_menu.hide()


