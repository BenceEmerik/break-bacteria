extends Node


var ball_count setget set_ball_count
var diamond
var level = 1 setget set_level


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func set_ball_count(value) -> void:
	ball_count = value

func set_level(l:int) -> void:
	level = l
