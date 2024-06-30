extends Node3D


class EnemyWave:
	var wave_id: int
	var wave_duration: float
	var wave_enemies: Array[EnemyWaveEntry]
	
	func print_wave_info():
		print("--------- Wave info ---------")
		print("Wave ID: " + str(wave_id))
		print("Wave duration: " + str(wave_duration))
		for i in wave_enemies:
			print("Total of " + str(i.enemy_count) + " of enemy type: " + i.enemy_scene_path)

class EnemyWaveEntry:
	var enemy_scene_path: String
	var enemy_count: int


# TODO Suit this for multiple enemy scenes
# Enemy scenes
var enemy_follow_player_scene = preload("res://scenes/Enemies/EnemyFollowPlayer_02.tscn")

# Node references
@onready var enemies_node = $"../../Enemies"
@onready var enemy_spawn_cooldown = $EnemySpawnCooldown

# Enemy waves
var enemy_waves: Array[EnemyWave]
var current_wave_id:= -1


func _ready():
	_parse_enemy_wave_xml()
	_on_enemy_spawn_cooldown_timeout()


func _parse_enemy_wave_xml():
	var parser = XMLParser.new()
	parser.open("res://resources/enemy_waves/test_enemy_waves.xml")
	
	# Temporary variables to create wave objects
	var wave_id: int
	var wave_duration: float
	var wave_enemies: Array[EnemyWaveEntry]
	var wave_enemy_scene: String
	var wave_enemy_count: int
	
	while parser.read() != ERR_FILE_EOF:
		
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			if parser.get_node_name() == "wave":
				wave_id = parser.get_attribute_value(0).to_int()
				#print("Current wave id: " + str(wave_id))
				continue
			
			if parser.get_node_name() == "wave_duration":
				parser.read()
				if parser.get_node_type() == XMLParser.NODE_TEXT:
					wave_duration = parser.get_node_data().to_float()
					#print("Current wave duration: " + str(wave_duration))
				continue
			
			if parser.get_node_name() == "enemy_scene":
				parser.read()
				wave_enemy_scene = parser.get_node_data()
				#print("Current wave enemy scene: " + wave_enemy_scene)
				continue
			
			if parser.get_node_name() == "enemy_count":
				parser.read()
				wave_enemy_count = parser.get_node_data().to_int()
				#print("Current wave enemy count: " + str(wave_enemy_count))
				continue
		
		if parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
			if parser.get_node_name() == "enemy_wave_entry":
				var enemy_wave_entry = EnemyWaveEntry.new()
				enemy_wave_entry.enemy_scene_path = wave_enemy_scene
				enemy_wave_entry.enemy_count = wave_enemy_count
				wave_enemies.append(enemy_wave_entry)
				#print("Enemy wave entry saved!")
				
				wave_enemy_scene = ""
				wave_enemy_count = 0
				continue
			
			if parser.get_node_name() == "wave":
				var enemy_wave = EnemyWave.new()
				enemy_wave.wave_id = wave_id
				enemy_wave.wave_duration = wave_duration
				enemy_wave.wave_enemies = wave_enemies.duplicate(true)
				enemy_waves.append(enemy_wave)
				#print("Enemy wave saved!")
				
				wave_duration = 0.0
				wave_enemies.clear()
				continue


func _on_enemy_spawn_cooldown_timeout():
	current_wave_id += 1
	
	# Repeat last wave endlessly
	if current_wave_id >= enemy_waves.size():
		current_wave_id = enemy_waves.size() - 1
	
	var current_wave = enemy_waves[current_wave_id]
	current_wave.print_wave_info()
	
	# Just for debugging purposes
	if current_wave.wave_id != current_wave_id:
		print("Enemy wave ID mismatch!")

	
	for enemy_wave_entry in current_wave.wave_enemies:
		for enemy_index in enemy_wave_entry.enemy_count:
			
			# TODO Change with instantiation of actual enemy prefab
			var enemy_instance = enemy_follow_player_scene.instantiate()
			
			# Randomize spawn location around player
			var enemy_location = get_node("EnemySpawnPath/EnemySpawnLocation")
			enemy_location.progress_ratio = randf()
			enemy_instance.position = enemy_location.global_transform.origin
			
			enemies_node.add_child(enemy_instance)
	
	# Start wave duration timer when enemies are instantiated
	enemy_spawn_cooldown.start(current_wave.wave_duration)
