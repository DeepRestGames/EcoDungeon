extends Node3D


@onready var enemies_node = $"../../Enemies"

var enemy_scene = preload("res://scenes/Enemies/EnemyFollowPlayer_02.tscn")


func _on_enemy_spawn_cooldown_timeout():
	var enemy_instance = enemy_scene.instantiate()
	
	var enemy_location = get_node("EnemySpawnPath/EnemySpawnLocation")
	enemy_location.progress_ratio = randf()
	enemy_instance.position = enemy_location.position
	
	enemies_node.add_child(enemy_instance)
