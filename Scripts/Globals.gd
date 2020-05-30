extends Node

var level:int = 1
var prev_time:int
var colors =  [
	Color.red, Color.blue, Color.orange, Color.yellow, Color.yellowgreen, Color.aqua, Color.green,
	Color.purple, Color.brown, Color.darkslategray, Color.coral, Color.fuchsia, Color.dodgerblue,
	Color.firebrick, Color.chocolate, Color.lawngreen, Color.olive, Color.limegreen, Color.snow,
	
]
var reload_level:int

func _ready() -> void:
	get_tree().set_quit_on_go_back(false)
	prev_time = LocalSettings.get_setting("prev_time", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func time_to_string(prev_time:int, count_down_time:int) -> String:
	var t = OS.get_unix_time()
	t = t - prev_time
	t = count_down_time - t
	var h = t/60/60%60
	var m = t/60%60
	var s = t%60
	return "%02d:%02d:%02d"%[h, m, s]
