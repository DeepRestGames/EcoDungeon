class_name SaveFileXMLParser


# Class representing a single save file
class SaveFile:
	var save_file_id: String
	var current_game: CurrentGameState
	var unlockables: Unlockables
	
	func print_save_file_info():
		print("--------- Save file info ---------")
		print(save_file_id)
		


# Class representing the state of the game from where to continue from
class CurrentGameState:
	var enemy_scene_path: String
	var enemy_count: int


# Class representing all the unlockables that were unlocked in a save file
class Unlockables:
	# --------------------------------------------------------------------------------------------------
    # CONTINUE FROM HERE
    # --------------------------------------------------------------------------------------------------


func _parse_enemy_wave_xml(level_id: String) -> Array[EnemyWave]:
	var enemy_waves: Array[EnemyWave] = []
	
	var parser = XMLParser.new()
	parser.open("res://resources/enemy_waves/" + level_id + ".xml")
	
	# Temporary variables to create wave objects
	var wave_id: String
	var wave_duration: float
	var wave_enemies: Array[EnemyWaveEntry] = []
	var wave_enemy_scene: String
	var wave_enemy_count: int
	
	while parser.read() != ERR_FILE_EOF:
		
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			if parser.get_node_name() == "wave":
				wave_id = parser.get_attribute_value(0)
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
	
	return enemy_waves







# class_name EnemyWaveXMLParser
# 
# 
# # Class representing a single enemy wave
# class EnemyWave:
# 	var wave_id: String
# 	var wave_duration: float
# 	var wave_enemies: Array[EnemyWaveEntry]
# 	
# 	func print_wave_info():
# 		print("--------- Wave info ---------")
# 		print(wave_id)
# 		print("Wave duration: " + str(wave_duration))
# 		for i in wave_enemies:
# 			print("Total of " + str(i.enemy_count) + " of enemy type: " + i.enemy_scene_path)
# 
# 
# # Class representing a set of enemies to be spawned during a single wave
# class EnemyWaveEntry:
# 	var enemy_scene_path: String
# 	var enemy_count: int
# 
# 
# func _parse_enemy_wave_xml(level_id: String) -> Array[EnemyWave]:
# 	var enemy_waves: Array[EnemyWave] = []
# 	
# 	var parser = XMLParser.new()
# 	parser.open("res://resources/enemy_waves/" + level_id + ".xml")
# 	
# 	# Temporary variables to create wave objects
# 	var wave_id: String
# 	var wave_duration: float
# 	var wave_enemies: Array[EnemyWaveEntry] = []
# 	var wave_enemy_scene: String
# 	var wave_enemy_count: int
# 	
# 	while parser.read() != ERR_FILE_EOF:
# 		
# 		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
# 			if parser.get_node_name() == "wave":
# 				wave_id = parser.get_attribute_value(0)
# 				#print("Current wave id: " + str(wave_id))
# 				continue
# 			
# 			if parser.get_node_name() == "wave_duration":
# 				parser.read()
# 				if parser.get_node_type() == XMLParser.NODE_TEXT:
# 					wave_duration = parser.get_node_data().to_float()
# 					#print("Current wave duration: " + str(wave_duration))
# 				continue
# 			
# 			if parser.get_node_name() == "enemy_scene":
# 				parser.read()
# 				wave_enemy_scene = parser.get_node_data()
# 				#print("Current wave enemy scene: " + wave_enemy_scene)
# 				continue
# 			
# 			if parser.get_node_name() == "enemy_count":
# 				parser.read()
# 				wave_enemy_count = parser.get_node_data().to_int()
# 				#print("Current wave enemy count: " + str(wave_enemy_count))
# 				continue
# 		
# 		if parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
# 			if parser.get_node_name() == "enemy_wave_entry":
# 				var enemy_wave_entry = EnemyWaveEntry.new()
# 				enemy_wave_entry.enemy_scene_path = wave_enemy_scene
# 				enemy_wave_entry.enemy_count = wave_enemy_count
# 				wave_enemies.append(enemy_wave_entry)
# 				#print("Enemy wave entry saved!")
# 				
# 				wave_enemy_scene = ""
# 				wave_enemy_count = 0
# 				continue
# 			
# 			if parser.get_node_name() == "wave":
# 				var enemy_wave = EnemyWave.new()
# 				enemy_wave.wave_id = wave_id
# 				enemy_wave.wave_duration = wave_duration
# 				enemy_wave.wave_enemies = wave_enemies.duplicate(true)
# 				enemy_waves.append(enemy_wave)
# 				#print("Enemy wave saved!")
# 				
# 				wave_duration = 0.0
# 				wave_enemies.clear()
# 				continue
# 	
# 	return enemy_waves
