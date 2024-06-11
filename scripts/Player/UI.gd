extends Control

@export var player: Player
@onready var health = $Health
@onready var experience = $Experience
@onready var level_label = $LevelLabel


func _ready():
	health.max_value = player.max_hp



func _on_player_experience_level_up(level):
	level_label.text = "Level %s" % str(level)


func _on_player_experience_xp_change(xp):
	experience.value = xp


func _on_player_health_change(hp):
	health.value = hp
