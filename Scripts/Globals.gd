extends Node


var ball_count setget set_ball_count
var diamond
var level = 1 setget set_level
var prev_time:int


func _ready() -> void:
	get_tree().set_quit_on_go_back(false)
	LocalSettings.load()
	prev_time = LocalSettings.get_setting("prev_time", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func set_ball_count(value) -> void:
	ball_count = value

func set_level(l:int) -> void:
	level = l


func time_to_string(prev_time:int, count_down_time:int) -> String:
	var t = OS.get_unix_time()
	t = t - prev_time
	t = count_down_time - t
	var h = t/60/60%60
	var m = t/60%60
	var s = t%60
	return "%02d:%02d:%02d"%[h, m, s]
