extends Node3D


# Node references
@onready var enemies_node = $"../../Enemies"
@onready var enemy_spawn_cooldown = $EnemySpawnCooldown

# Enemy waves
var enemy_waves: Array
var current_wave_id:= -1


# TODO Once main menu's level selection signal is done, move enemy_waves initialization to initialize function
func _ready():
	enemy_waves = EnemyWaveXMLParser.new()._parse_enemy_wave_xml("test_enemy_waves")

# TODO Connect this function to main menu level selection signal
#func initialize_level_enemy_waves(level_id: String):
	#enemy_waves = EnemyWaveXMLParser.new()._parse_enemy_wave_xml("test_enemy_waves")


func _on_enemy_spawn_cooldown_timeout():
	current_wave_id += 1
	
	# Repeat last wave endlessly
	if current_wave_id >= enemy_waves.size():
		current_wave_id = enemy_waves.size() - 1
	
	var current_wave = enemy_waves[current_wave_id]
	current_wave.print_wave_info()
	
	for enemy_wave_entry in current_wave.wave_enemies:
		for enemy_index in enemy_wave_entry.enemy_count:
			
			# The load method works fine here, since whenever a Resource is loaded once it stays in the cache for future use
			var enemy_scene = load(enemy_wave_entry.enemy_scene_path)
			var enemy_instance = enemy_scene.instantiate()
			
			# Randomize spawn location around player
			var enemy_location = get_node("EnemySpawnPath/EnemySpawnLocation")
			enemy_location.progress_ratio = randf()
			enemy_instance.position = enemy_location.global_transform.origin
			
			enemies_node.add_child(enemy_instance)
	
	# Start wave duration timer when enemies are instantiated
	enemy_spawn_cooldown.start(current_wave.wave_duration)
