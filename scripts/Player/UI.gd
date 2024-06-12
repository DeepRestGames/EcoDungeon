extends Control

@export var player: Player
@export var player_xp: PlayerExperience
@onready var health = $Health
@onready var experience = $Experience
@onready var level_label = $LevelLabel
@onready var health_label = $Health/HealthLabel
@onready var xp_label = $Experience/XpLabel
@onready var power_up_menu = $PowerUpMenu

# TODO: max HP change

# Powerups
signal new_powerup(powerup)

var powerup_damage: WeaponPowerup = preload("res://resources/powerups/PowerupDamage.tres")
var powerup_cooldown: WeaponPowerup = preload("res://resources/powerups/PowerupCooldown.tres")
var powerup_range: WeaponPowerup = preload("res://resources/powerups/PowerupRange.tres")
var powerup_shotgun: WeaponPowerup = preload("res://resources/powerups/PowerupShotgun.tres")


func _ready():
	health.value = player.current_hp
	health.max_value = player.max_hp
	set_player_hp_label(player.current_hp, player.max_hp)
	set_xp_label(player_xp.current_xp, player_xp.xp_to_level)
	power_up_menu.hide()
	

func _on_player_experience_level_up(level, xp_overflow):
	level_label.text = "Level %s" % str(level)
	experience.max_value = player_xp.xp_to_level
	experience.value = xp_overflow
	pause_and_show_options()
	
	

func pause_and_show_options():
	get_tree().paused = true
	power_up_menu.show()


func _on_player_experience_xp_change(xp):
	experience.value = xp
	set_xp_label(xp, player_xp.xp_to_level)
	

func _on_player_health_change(hp):
	health.value = hp
	set_player_hp_label(hp, player.max_hp)
	
func set_player_hp_label(current_value, max_value):
	health_label.text = "HP: %s/%s" % [str(current_value), str(max_value)]
	
func set_xp_label(current_value, max_value):
	xp_label.text = "XP: %s/%s" % [str(current_value), str(max_value)]
 


func _on_power_up_menu_id_pressed(id):
	match id:
		# Fire - Shotgun
		0:
			new_powerup.emit(powerup_shotgun)
		# Water - Cooldown
		1:
			new_powerup.emit(powerup_cooldown)
		# Earth - Damage
		2:
			new_powerup.emit(powerup_damage)
		# Wind - Range
		3:
			new_powerup.emit(powerup_range)

	get_tree().paused = false
