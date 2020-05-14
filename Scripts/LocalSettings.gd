extends Node


var sound:bool = true
var music:bool = true

var settings_file:File = File.new()
var file_path:String = "user://save.bin"

var settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !settings_file.file_exists(file_path):
		settings_file.open(file_path, File.WRITE)
		var d = {"coins": 0,
				"current_level": 1,
				"challenge_checkpoints": 1,
				"best_challenge_level": 0,
				"buyed_balls": ["antikor"],
				"selected_ball": "antikor",
				"total_balls": 30,
				"prev_time": 0,
				"last_completed_level": 0,
				"completed_levels": {
#					1: {
#						"score": 0}
#						}
				},
#				"challenge": {
#					"checkpoint": 1
#				}
		}
		settings_file.store_string(JSON.print(d))
		settings_file.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func load() -> void:
	settings_file.open(file_path, File.READ)
	settings =  parse_json(settings_file.get_as_text())
	settings_file.close()

func save() -> void:
	settings_file.open(file_path, File.WRITE)
	settings_file.store_string(JSON.print(settings))
	settings_file.close()

func set_setting(key:String, value) -> void:
	settings[key] = value

func get_setting(key:String, default):
#	print(settings[key])
	if !settings.has(key):
		return default
	else:
		return settings[key]
