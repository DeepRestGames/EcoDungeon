extends Control

@export var player: Player
@export var player_xp: PlayerExperience
@onready var health = $Health
@onready var experience = $Experience
@onready var level_label = $LevelLabel
@onready var health_label = $Health/HealthLabel
@onready var xp_label = $Experience/XpLabel
@onready var powerup_menu = $PowerupMenu

# TODO: max HP change


func _ready():
	health.value = player.current_hp
	health.max_value = player.max_hp
	set_player_hp_label(player.current_hp, player.max_hp, player.hp_regen)
	set_xp_label(player_xp.current_xp, player_xp.xp_to_level)


func _on_player_experience_level_up(level, xp_overflow):
	level_label.text = "Level %s" % str(level)
	experience.max_value = player_xp.xp_to_level
	experience.value = xp_overflow
	
	powerup_menu.show_powerups_options()


func _on_player_experience_xp_change(xp):
	experience.value = xp
	set_xp_label(xp, player_xp.xp_to_level)


func _on_player_health_change(hp):
	health.value = hp
	set_player_hp_label(hp, player.max_hp, player.hp_regen)


func set_player_hp_label(current_value, max_value, regen):
	health_label.text = "HP: %.0f/%.0f (+%.2f /5s)" % [current_value, max_value, regen]


func set_xp_label(current_value, max_value):
	xp_label.text = "XP: %.1f/%.1f" % [current_value, max_value]
 
